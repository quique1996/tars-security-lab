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
# Usa case_judge.py separado (evita bugs de heredoc/escaping del shell)
log "[3/5] Judge + KG (Mini)..."
scp -o ConnectTimeout=10 /tmp/case-battery-$STAMP.json "$MINI:/tmp/battery-results.json" 2>/dev/null
scp -o ConnectTimeout=10 "$REPO/scripts/case_judge.py" "$MINI:/tmp/case_judge.py" 2>/dev/null
ssh -o ConnectTimeout=10 "$MINI" 'export PATH=/opt/homebrew/bin:$PATH; cd ~/Projects/tars-security-lab/mcp-server && source .venv/bin/activate && python3 /tmp/case_judge.py' 2>&1 | tail -3 || log "judge/KG FAIL"

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
