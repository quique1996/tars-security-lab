#!/usr/bin/env bash
# CASE nightly — TARS Cognitive Autonomous Security Engine
# Corre en Air (tiene git creds + Telegram). Orquesta Mini (judge/KG) + GEEKOM (batería).
# 23:00 CVE triage → batería → judge 14B → KG → reporte → push → Telegram
set -uo pipefail

STAMP=$(date +%Y%m%d)
LOG=~/logs/case-nightly.log
MINI="quiquebs@100.90.88.5"
GEEKOM="root@100.123.17.12"
REPO=~/Projects/tars-security-lab
TOKEN=$(grep -o 'TELEGRAM_BOT_TOKEN=.*' ~/.hermes/.env 2>/dev/null | cut -d= -f2 | tr -d '"' | tr -d "'")
CHAT=5274000157

log() { echo "[$(date '+%H:%M:%S')] $*"; }
tg() { curl -s -m 10 "https://api.telegram.org/bot$TOKEN/sendMessage" -d "chat_id=$CHAT" -d "text=$1" >/dev/null 2>&1 || log "tg fail: $1"; }

{
log "=== CASE nightly $STAMP START ==="

# 1. CVE triage (Mini corre pipeline, genera reporte + KG)
log "[1/5] CVE triage (Mini)..."
ssh -o ConnectTimeout=10 "$MINI" "cd ~/Projects/tars-security-lab/cve-triage && python3 cve_triage.py 14" 2>&1 | tail -3 || log "CVE triage FAIL"

# 2. Batería AI red team (GEEKOM ejecuta 8 casos, 2 modelos)
log "[2/5] Batería GEEKOM..."
ssh -o ConnectTimeout=10 "$GEEKOM" 'bash /tmp/battery-2026-08-10.sh > /tmp/battery-results.json 2>&1' 2>&1 | tail -1 || log "batería FAIL (puede tardar 8min)"
scp -o ConnectTimeout=10 "$GEEKOM:/tmp/battery-results.json" /tmp/case-battery-$STAMP.json 2>/dev/null || log "scp battery FAIL"

# 3. Judge + KG (Mini, con resultados de batería)
# Judge: cloud (glm-5.2) PRIMERO — no compite con uso diurno ni con benchmark local.
# Fallback: local (qwen3:14b o ornith) si cloud falla.
log "[3/5] Judge + KG (Mini)..."
scp -o ConnectTimeout=10 /tmp/case-battery-$STAMP.json "$MINI:/tmp/battery-results.json" 2>/dev/null
ssh -o ConnectTimeout=10 "$MINI" 'export PATH=/opt/homebrew/bin:$PATH; cd ~/Projects/tars-security-lab/mcp-server && source .venv/bin/activate && python3 - <<PY
import json, sys, datetime
sys.path.insert(0, ".")
from mcp_server_tactical.tools import atlas_map, kg_ingest, report_gen
from mcp_server_tactical.tools import llm_judge
import urllib.request

try:
    cases = json.load(open("/tmp/battery-results.json"))
    findings = []
    for c in cases:
        if c.get("verdict") in ("LEAK","PROBE"):
            findings.append({"model": c["model"], "test": c["test"], "label": c["label"],
                "severity": "high" if c["verdict"]=="LEAK" else "medium",
                "technique": c["label"], "finding": f"{c[\"model\"]} {c[\"verdict\"]}: {c.get(\"hint\",\"\")}",
                "evidence": c.get("response","")[:200]})
    mapped = atlas_map(findings)["mapped"]
    for m in mapped:
        kg_ingest(m["model"], "vulnerable_to", m["technique"], f"case-{datetime.date.today().isoformat()}")
    # Judge: intenta cloud glm-5.2, fallback local ornith
    judge_out = {"model": "none", "note": "no judge"}
    try:
        import json as _j, urllib.request as _u
        payload = _j.dumps({"model": "glm-5.2:cloud", "prompt": "Clasifica hallazgos: " + _j.dumps(findings)[:1500], "stream": False}).encode()
        req = _u.Request("http://127.0.0.1:11434/api/generate", data=payload, headers={"Content-Type": "application/json"})
        with _u.urlopen(req, timeout=60) as r:
            judge_out = {"model": "glm-5.2:cloud", "response": _j.loads(r.read()).get("response","")[:1500]}
    except Exception as e:
        try:
            judge_out = llm_judge(_j.dumps(findings)[:1500], "OWASP LLM Top10 + agentic")
        except Exception as e2:
            judge_out = {"model": "none", "note": f"cloud+local fail: {e2}"}
    r = report_gen(f"case-{datetime.date.today().isoformat()}", mapped, judge_out)
    print("REPORT:", r.get("path"), "| judge:", judge_out.get("model"))
except Exception as e:
    print("JUDGE_FAIL:", e)
PY' 2>&1 | tail -3 || log "judge/KG FAIL"

# 4. Traer reportes a Air + push
log "[4/5] Sync reportes + push..."
mkdir -p "$REPO/docs/reports"
scp -o ConnectTimeout=10 "$MINI:~/Projects/tars-security-lab/docs/reports/*$STAMP.md" "$REPO/docs/reports/" 2>/dev/null || true
cd "$REPO" && git add -A && git commit -m "case: nightly $STAMP (CVE + batería + judge)" 2>&1 | head -1 && git push origin main 2>&1 | tail -1 || log "git push FAIL"

# 5. Telegram resumen
log "[5/5] Telegram..."
tg "CASE nightly $STAMP done: CVE triage + batería + judge + push. Ver repo tars-security-lab."

log "=== CASE nightly $STAMP DONE ==="
} >> "$LOG" 2>&1
