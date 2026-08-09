#!/bin/bash
# nightly-alert.sh — alerta si garak SUSPICIOUS/FAILED en el run de 03:30
# Corre a las 03:45 (post-pentest-nightly). Verifica el summary.md de hoy.
set -uo pipefail
D="/root/pentest-evidence/$(date +%Y%m%d)"
LOG="/var/log/nightly-alert.log"

[ -f "$D/summary.md" ] || { echo "$(date -u +%FT%TZ) no summary yet" >> "$LOG"; exit 0; }

if grep -qE "garak (SUSPICIOUS|FAILED)" "$D/summary.md" 2>/dev/null; then
  echo "$(date -u +%FT%TZ) ALERT: garak problem in $D" >> "$LOG"
  grep -E "garak" "$D/summary.md" | systemd-cat -t nightly-alert 2>/dev/null
  exit 1
fi

echo "$(date -u +%FT%TZ) OK" >> "$LOG"
exit 0
