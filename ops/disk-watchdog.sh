#!/bin/bash
# disk-watchdog.sh — alerta si /data o / superan 90% (cada hora)
set -uo pipefail
LOG="/var/log/disk-watchdog.log"
THRESHOLD=90

for mount in / /data; do
  pct=$(df -h "$mount" 2>/dev/null | awk 'NR==2 {gsub("%",""); print $5}')
  [ -z "$pct" ] && continue
  if [ "$pct" -gt "$THRESHOLD" ]; then
    echo "$(date -u +%FT%TZ) ALERT: $mount at ${pct}%" >> "$LOG"
    echo "DISK_${mount}_AT_${pct}%" | systemd-cat -t disk-watchdog 2>/dev/null
  fi
done
echo "$(date -u +%FT%TZ) OK" >> "$LOG"
exit 0
