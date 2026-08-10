#!/usr/bin/env python3
"""Generate /opt/portswigger/TRACKER.md and labs.json from labs.tsv.

Source of truth: the official PortSwigger Web Security Academy "All labs" page
(https://portswigger.net/web-security/all-labs), 274 labs across 31 categories.

Idempotent: re-running preserves any statuses already recorded in labs.json.
"""
import json
import os
import sys
from collections import OrderedDict

ROOT = "/opt/portswigger"
TSV = os.path.join(ROOT, "labs.tsv")
JSON_PATH = os.path.join(ROOT, "labs.json")
TRACKER = os.path.join(ROOT, "TRACKER.md")
BASE = "https://portswigger.net/web-security/"

STATUS_ICON = {"pendiente": "[ ]", "en-progreso": "[~]", "hecho": "[x]"}
VALID = set(STATUS_ICON)


def load_rows(path):
    rows = []
    with open(path, encoding="utf-8") as fh:
        for lineno, line in enumerate(fh, 1):
            line = line.rstrip("\n")
            if not line.strip():
                continue
            parts = line.split("|")
            if len(parts) != 5:
                sys.exit("FATAL: %s:%d expected 5 fields, got %d" % (path, lineno, len(parts)))
            rows.append(parts)
    return rows


def build(rows, previous):
    """Assign stable ids (<cat>-NN) and carry over prior statuses."""
    prev_status = {lab["id"]: lab.get("status", "pendiente") for lab in previous}
    counters = {}
    labs = []
    for cat, cat_name, difficulty, title, path in rows:
        counters[cat] = counters.get(cat, 0) + 1
        lab_id = "%s-%02d" % (cat, counters[cat])
        status = prev_status.get(lab_id, "pendiente")
        if status not in VALID:
            status = "pendiente"
        labs.append(OrderedDict([
            ("id", lab_id),
            ("category", cat),
            ("category_name", cat_name),
            ("num", counters[cat]),
            ("difficulty", difficulty),
            ("title", title),
            ("url", BASE + path),
            ("status", status),
            ("notes", ""),
        ]))
    return labs


def render(labs):
    by_cat = OrderedDict()
    for lab in labs:
        by_cat.setdefault(lab["category"], []).append(lab)

    done = sum(1 for l in labs if l["status"] == "hecho")
    wip = sum(1 for l in labs if l["status"] == "en-progreso")
    pend = len(labs) - done - wip

    out = []
    add = out.append
    add("# PortSwigger Web Security Academy - TRACKER")
    add("")
    add("Fuente oficial: <https://portswigger.net/web-security/all-labs>")
    add("")
    add("**Total labs: %d** | hecho: %d | en-progreso: %d | pendiente: %d"
        % (len(labs), done, wip, pend))
    add("")
    add("Estados validos: `pendiente` `en-progreso` `hecho`")
    add("")
    add("Cambiar estado (NO editar a mano, regenera este fichero):")
    add("")
    add("```bash")
    add("/opt/portswigger/start-lab.sh status sqli 1 hecho")
    add("/opt/portswigger/start-lab.sh sqli 1        # abrir/preparar el lab")
    add("/opt/portswigger/start-lab.sh list sqli     # listar una categoria")
    add("```")
    add("")
    add("## Indice de categorias")
    add("")
    add("| Categoria | Slug | Labs | Hecho | Pendiente |")
    add("|---|---|---:|---:|---:|")
    for cat, items in by_cat.items():
        d = sum(1 for i in items if i["status"] == "hecho")
        add("| %s | `%s` | %d | %d | %d |"
            % (items[0]["category_name"], cat, len(items), d, len(items) - d))
    add("")
    add("---")
    add("")

    for cat, items in by_cat.items():
        d = sum(1 for i in items if i["status"] == "hecho")
        add("## %s (`%s`) - %d labs [%d/%d hechos]"
            % (items[0]["category_name"], cat, len(items), d, len(items)))
        add("")
        add("| # | ID | Nivel | Lab | Estado | Link |")
        add("|---:|---|---|---|---|---|")
        for lab in items:
            add("| %d | `%s` | %s | %s %s | `%s` | [abrir](%s) |"
                % (lab["num"], lab["id"], lab["difficulty"],
                   STATUS_ICON[lab["status"]], lab["title"].replace("|", "\\|"),
                   lab["status"], lab["url"]))
        add("")

    add("---")
    add("")
    add("Generado por `generate_tracker.py`. Estado persistido en `labs.json`.")
    add("")
    return "\n".join(out)


def main():
    if not os.path.exists(TSV):
        sys.exit("FATAL: missing %s" % TSV)
    previous = []
    if os.path.exists(JSON_PATH):
        try:
            with open(JSON_PATH, encoding="utf-8") as fh:
                previous = json.load(fh)
        except (ValueError, OSError) as exc:
            print("WARN: could not read existing labs.json (%s); starting fresh" % exc)

    rows = load_rows(TSV)
    labs = build(rows, previous)

    with open(JSON_PATH, "w", encoding="utf-8") as fh:
        json.dump(labs, fh, indent=2, ensure_ascii=False)
    with open(TRACKER, "w", encoding="utf-8") as fh:
        fh.write(render(labs))

    print("OK labs=%d categories=%d" % (labs and len(labs) or 0,
                                        len({l["category"] for l in labs})))
    return 0


if __name__ == "__main__":
    sys.exit(main())
