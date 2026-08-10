#!/usr/bin/env bash
# start-lab.sh - PortSwigger Web Security Academy lab launcher / tracker driver
#
# The Web Security Academy labs are NOT self-hostable: PortSwigger publishes no
# lab Docker image (verified against the portswigger/ Docker Hub namespace, which
# contains only Burp Enterprise images). Each lab is a per-account cloud instance
# spawned on demand from https://portswigger.net/web-security. This script therefore
# prepares the LOCAL side of the engagement: workspace, notes skeleton, Burp,
# lab URL and tracker state.
#
# Usage:
#   start-lab.sh <categoria> <numero>          Preparar y abrir un lab
#   start-lab.sh list [categoria]              Listar labs (todos o de una categoria)
#   start-lab.sh status <cat> <num> <estado>   estado: pendiente|en-progreso|hecho
#   start-lab.sh publish <cat> <num>           Generar writeup desde NOTES.md -> out/
#   start-lab.sh search <texto>                Buscar labs por titulo
#   start-lab.sh progress                      Resumen de progreso
#   start-lab.sh cats                          Listar categorias disponibles
#   start-lab.sh burp                          Arrancar Burp Suite Community
#   start-lab.sh regen                         Regenerar TRACKER.md desde labs.json
set -euo pipefail

ROOT="/opt/portswigger"
LABS_JSON="${ROOT}/labs.json"
GEN="${ROOT}/generate_tracker.py"
BURP_JAR="/opt/burp/burpsuite_community.jar"
PY="${PY:-python3}"

die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

usage() { sed -n '11,20p' "$0" | sed 's/^#\{1,\} \{0,1\}//'; }

command -v "$PY" >/dev/null 2>&1 || die "python3 no encontrado"
[[ -f "$LABS_JSON" ]] || die "no existe $LABS_JSON (ejecuta: python3 $GEN)"

# ---- lookups -----------------------------------------------------------------

lab_lookup() { # <categoria> <numero> -> TSV record or empty
  "$PY" - "$LABS_JSON" "$1" "$2" <<'PYEOF'
import json, sys
labs = json.load(open(sys.argv[1], encoding="utf-8"))
cat = sys.argv[2]
try:
    num = int(sys.argv[3])
except ValueError:
    sys.exit(2)
for l in labs:
    if l["category"] == cat and l["num"] == num:
        print("\t".join([l["id"], l["difficulty"], l["title"], l["url"],
                         l["status"], l["category_name"]]))
        break
PYEOF
}

cmd_cats() {
  "$PY" - "$LABS_JSON" <<'PYEOF'
import json, sys, collections
labs = json.load(open(sys.argv[1], encoding="utf-8"))
per = collections.OrderedDict()
for l in labs:
    per.setdefault(l["category"], [l["category_name"], 0])[1] += 1
for cat, (name, n) in per.items():
    print("%-22s %-45s %d labs" % (cat, name, n))
PYEOF
}

cmd_list() {
  "$PY" - "$LABS_JSON" "${1:-}" <<'PYEOF'
import json, sys
path = sys.argv[1]
labs = json.load(open(path, encoding="utf-8"))
want = sys.argv[2] if len(sys.argv) > 2 else ""
if want:
    sel = [l for l in labs if l["category"] == want]
    if not sel:
        print("categoria desconocida:", want)
        print("disponibles:", ", ".join(sorted({l["category"] for l in labs})))
        sys.exit(1)
    labs = sel
icon = {"pendiente": " ", "en-progreso": "~", "hecho": "x"}
cur = None
for l in labs:
    if l["category"] != cur:
        cur = l["category"]
        print("\n== %s (%s) ==" % (l["category_name"], cur))
    print("  [%s] %-3d %-13s %s" % (icon[l["status"]], l["num"],
                                    l["difficulty"].lower(), l["title"]))
PYEOF
}

cmd_search() {
  [[ $# -ge 1 ]] || die "search necesita un texto"
  "$PY" - "$LABS_JSON" "$*" <<'PYEOF'
import json, sys
labs = json.load(open(sys.argv[1], encoding="utf-8"))
q = sys.argv[2].lower()
hits = [l for l in labs if q in l["title"].lower() or q in l["category"].lower()]
for l in hits:
    print("%-22s %-3d %-13s %s" % (l["category"], l["num"],
                                   l["difficulty"].lower(), l["title"]))
print("\n%d resultado(s)" % len(hits))
PYEOF
}

cmd_progress() {
  "$PY" - "$LABS_JSON" <<'PYEOF'
import json, sys, collections
labs = json.load(open(sys.argv[1], encoding="utf-8"))
c = collections.Counter(l["status"] for l in labs)
total = len(labs)
print("Total: %d | hecho: %d | en-progreso: %d | pendiente: %d (%.1f%% completado)"
      % (total, c["hecho"], c["en-progreso"], c["pendiente"], 100.0 * c["hecho"] / total))
per = collections.defaultdict(lambda: [0, 0])
for l in labs:
    per[l["category"]][1] += 1
    if l["status"] == "hecho":
        per[l["category"]][0] += 1
for cat in sorted(per):
    d, t = per[cat]
    filled = int(round(20.0 * d / t))
    print("  %-22s [%s] %2d/%-3d" % (cat, "#" * filled + "." * (20 - filled), d, t))
PYEOF
}

cmd_status() {
  [[ $# -eq 3 ]] || die "uso: start-lab.sh status <categoria> <numero> <pendiente|en-progreso|hecho>"
  case "$3" in
    pendiente|en-progreso|hecho) ;;
    *) die "estado invalido: $3 (usa pendiente|en-progreso|hecho)" ;;
  esac
  "$PY" - "$LABS_JSON" "$1" "$2" "$3" <<'PYEOF'
import json, sys
path, cat, new = sys.argv[1], sys.argv[2], sys.argv[4]
try:
    num = int(sys.argv[3])
except ValueError:
    sys.exit("numero invalido: %s" % sys.argv[3])
labs = json.load(open(path, encoding="utf-8"))
for l in labs:
    if l["category"] == cat and l["num"] == num:
        old = l["status"]
        l["status"] = new
        with open(path, "w", encoding="utf-8") as fh:
            json.dump(labs, fh, indent=2, ensure_ascii=False)
        print("%s: %s -> %s  (%s)" % (l["id"], old, new, l["title"]))
        break
else:
    sys.exit("no existe el lab %s-%s" % (cat, num))
PYEOF
  "$PY" "$GEN" >/dev/null || die "fallo regenerando TRACKER.md"
  echo "TRACKER.md regenerado."
}

cmd_publish() {
  [[ $# -eq 2 ]] || die "uso: start-lab.sh publish <categoria> <numero>"
  "$PY" - "$LABS_JSON" "$1" "$2" <<'PYEOF'
import json, sys, os, re, datetime
path, cat, num = sys.argv[1], sys.argv[2], sys.argv[3]
labs = json.load(open(path, encoding="utf-8"))
lab = None
for l in labs:
    if l["category"] == cat and l["num"] == int(num):
        lab = l
        break
if not lab:
    sys.exit("no existe el lab %s-%s" % (cat, num))
root = os.path.dirname(path)
workdir = os.path.join(root, cat, lab["id"])
notes_path = os.path.join(workdir, "NOTES.md")
if not os.path.exists(notes_path):
    sys.exit("no existe %s - abre el lab primero: start-lab.sh %s %s" % (notes_path, cat, num))
notes = open(notes_path, encoding="utf-8").read()

def section(name):
    m = re.search(r"^## %s\s*\n(.*?)(?=^## |\Z)" % name, notes, re.M | re.S)
    return m.group(1).strip() if m else ""

fecha = datetime.date.today().isoformat()
m = re.search(r"\*\*Iniciado:\*\*\s*([0-9]{4}-[0-9]{2}-[0-9]{2})", notes)
if m:
    fecha = m.group(1)

objetivo = section("Objetivo") or "_(pendiente: copiar del enunciado del lab)_"
recon    = section("Recon") or section("Reconocimiento")
hipotesis= section("Hipotesis")
payloads = section("Payloads probados")
solucion = section("Solucion")
aprend   = section("Aprendizaje")
evid     = section("Evidencia")

vuln = hipotesis or solucion or "_(pendiente)_"
exploit_parts = []
if payloads:
    exploit_parts.append("Payloads probados:\n\n```\n%s\n```\n" % payloads)
if solucion and solucion != vuln:
    exploit_parts.append("Solución:\n\n%s\n" % solucion)
if not exploit_parts:
    exploit_parts.append("_(pendiente: request/response reales)_")
exploit = "\n".join(exploit_parts)

w = []
w.append("# %s — %s" % (lab["title"], lab["category_name"]))
w.append("")
w.append("## Info")
w.append("- **ID**: `%s`" % lab["id"])
w.append("- **Dificultad**: %s" % lab["difficulty"].title())
w.append("- **URL**: %s" % lab["url"])
w.append("- **Fecha**: %s" % fecha)
w.append("- **Estado**: %s" % lab["status"])
w.append("")
w.append("> GENERADO por `start-lab.sh publish` desde NOTES.md — revisar y completar "
         "las secciones _pendiente_ antes de sincronizar al repo.")
w.append("")
w.append("## Objetivo")
w.append(objetivo)
w.append("")
w.append("## Reconocimiento")
w.append(recon or "_(pendiente)_")
w.append("")
w.append("## Vulnerabilidad")
w.append(vuln)
w.append("")
w.append("## Explotación")
w.append(exploit)
w.append("")
w.append("## Evidencia")
w.append(evid or ("Capturas y requests en `%s/evidence/`" % workdir))
w.append("")
w.append("## Impacto")
w.append("_(pendiente)_")
w.append("")
w.append("## Remediation")
w.append("_(pendiente)_")
w.append("")
w.append("## Lección aprendida")
w.append(aprend or "_(pendiente)_")
w.append("")

outdir = os.path.join(root, "out", cat)
os.makedirs(outdir, exist_ok=True)
outpath = os.path.join(outdir, lab["id"] + ".md")
with open(outpath, "w", encoding="utf-8") as fh:
    fh.write("\n".join(w))
print("Writeup generado: %s" % outpath)
print("Estado del lab: %s (marcar con: start-lab.sh status %s %s hecho)" % (lab["status"], cat, num))
PYEOF
}

cmd_burp() {
  [[ -f "$BURP_JAR" ]] || die "no existe $BURP_JAR"
  command -v java >/dev/null 2>&1 || die "java no encontrado en PATH"
  mkdir -p "${ROOT}/.cache"
  echo "Arrancando Burp Suite Community: $BURP_JAR"
  echo "Proxy por defecto: 127.0.0.1:8080  (CA cert: http://burpsuite en el navegador proxied)"
  nohup java -jar "$BURP_JAR" >"${ROOT}/.cache/burp.log" 2>&1 &
  echo "PID=$!  log=${ROOT}/.cache/burp.log"
}

cmd_open() {
  local cat="$1" num="$2" rec
  rec="$(lab_lookup "$cat" "$num")" || die "numero invalido: $num"
  [[ -n "$rec" ]] || die "no existe el lab '${cat}' #${num}  (prueba: start-lab.sh list ${cat})"

  local id difficulty title url status catname
  IFS=$'\t' read -r id difficulty title url status catname <<<"$rec"

  local workdir="${ROOT}/${cat}/${id}"
  mkdir -p "${workdir}/evidence" || die "no pude crear ${workdir}"

  local notes="${workdir}/NOTES.md"
  if [[ ! -f "$notes" ]]; then
    {
      printf '# %s\n\n' "$title"
      printf -- '- **ID:** `%s`\n' "$id"
      printf -- '- **Categoria:** %s (`%s`)\n' "$catname" "$cat"
      printf -- '- **Nivel:** %s\n' "$difficulty"
      printf -- '- **Lab URL:** %s\n' "$url"
      printf -- '- **Instancia (pegar la URL `*.web-security-academy.net`):** \n'
      printf -- '- **Iniciado:** %s\n\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
      printf '## Objetivo\n\n_(copiar el enunciado del lab)_\n\n'
      printf '## Recon\n\n\n## Hipotesis\n\n\n## Payloads probados\n\n```\n\n```\n\n'
      printf '## Solucion\n\n\n## Evidencia\n\nCapturas y requests en `./evidence/`\n\n'
      printf '## Aprendizaje\n\n'
    } >"$notes" || die "no pude escribir $notes"
  fi

  printf '\n'
  printf '  Lab      : %s\n' "$title"
  printf '  ID       : %s   (%s / #%s)\n' "$id" "$cat" "$num"
  printf '  Nivel    : %s\n' "$difficulty"
  printf '  Estado   : %s\n' "$status"
  printf '  URL      : %s\n' "$url"
  printf '  Workdir  : %s\n' "$workdir"
  printf '  Notas    : %s\n' "$notes"
  printf '\n'
  printf '  Pasos:\n'
  printf '    1. Abre la URL, login en tu cuenta PortSwigger y pulsa "ACCESS THE LAB".\n'
  printf '    2. Arranca Burp:   %s burp\n' "$0"
  printf '    3. Proxy el navegador por 127.0.0.1:8080 (o usa el Burp browser).\n'
  printf '    4. Al empezar:     %s status %s %s en-progreso\n' "$0" "$cat" "$num"
  printf '    5. Al resolverlo:  %s status %s %s hecho\n' "$0" "$cat" "$num"
  printf '\n'

  if command -v xdg-open >/dev/null 2>&1 && [[ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]]; then
    xdg-open "$url" >/dev/null 2>&1 &
    echo "  (abriendo en el navegador...)"
  else
    echo "  (headless: sin navegador; abre la URL desde tu maquina)"
  fi
}

# ---- dispatch ----------------------------------------------------------------

[[ $# -ge 1 ]] || { usage; exit 1; }

case "$1" in
  -h|--help|help) usage ;;
  list)     shift; cmd_list "${1:-}" ;;
  cats)     cmd_cats ;;
  search)   shift; cmd_search "$@" ;;
  progress) cmd_progress ;;
  status)   shift; cmd_status "$@" ;;
  publish)  shift; cmd_publish "$@" ;;
  burp)     cmd_burp ;;
  regen)    "$PY" "$GEN" ;;
  *)
    [[ $# -eq 2 ]] || { usage; exit 1; }
    cmd_open "$1" "$2"
    ;;
esac
