#!/bin/bash
# model-health.sh — vigila los 3 Ollama + RAM disponible (cada 30 min via cron)
# Air: localhost:11434 | GEEKOM: 100.123.17.12:11434 | Mini: via ssh macmini
set -uo pipefail
LOG="$HOME/logs/model-health.log"
mkdir -p "$HOME/logs"

check() { # $1=name $2=url
  if curl -s -m 4 "$2/api/tags" >/dev/null 2>&1; then
    echo "OK $1"
  else
    echo "DOWN $1"
  fi
}

# RAM disponible en Air (macOS: free + inactive + speculative = "available")
# vm_stat pages are 16KB each
AVAIL_GB=$(vm_stat | awk '
  /Pages free/ {f=$3} /Pages inactive/ {i=$3} /Pages speculative/ {s=$3}
  END {gsub(/\./,"",f); gsub(/\./,"",i); gsub(/\./,"",s); printf "%.1f", (f+i+s)*16384/1073741824}')

STATUS="$(check air http://localhost:11434) | $(check geekom http://100.123.17.12:11434) | $(check mini http://127.0.0.1:11435 2>/dev/null || echo 'mini-via-tunnel')"
echo "$(date -u +%FT%TZ) $STATUS | RAM_avail=${AVAIL_GB}Gi" >> "$LOG"

# Alerta si algo cae o RAM < 1Gi (Air es terminal 8GB — 1Gi es el piso real)
if echo "$STATUS" | grep -q DOWN || [ "$(echo "$AVAIL_GB" | cut -d. -f1)" -lt 1 ]; then
  echo "MODEL_HEALTH_ALERT: $STATUS RAM=${AVAIL_GB}Gi" | systemd-cat -t model-health 2>/dev/null
  exit 1
fi
exit 0
