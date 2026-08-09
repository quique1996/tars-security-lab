#!/bin/bash
# wazuh-watchdog.sh — alerta si el manager de Wazuh cae (cada 5 min via cron)
# Fail-closed: si no puede verificar, alerta (mejor falso positivo que silencio)
set -uo pipefail
CTN="wazuh-wazuh.manager-1"
LOG="/var/log/wazuh-watchdog.log"
ALERT="/tmp/wazuh-watchdog-alerted"

# 1. ¿El contenedor está up?
if ! docker ps --format '{{.Names}}' 2>/dev/null | grep -q "^${CTN}$"; then
  echo "$(date -u +%FT%TZ) ALERT: container ${CTN} DOWN" >> "$LOG"
  [ -f "$ALERT" ] || { touch "$ALERT"; echo "WAZUH_MANAGER_DOWN" | systemd-cat -t wazuh-watchdog 2>/dev/null; }
  exit 1
fi

# 2. ¿El manager responde? (agent_control exit 0 = alive)
if ! docker exec "$CTN" /var/ossec/bin/agent_control -l >/dev/null 2>&1; then
  echo "$(date -u +%FT%TZ) ALERT: manager not responding" >> "$LOG"
  [ -f "$ALERT" ] || { touch "$ALERT"; echo "WAZUH_MANAGER_UNRESPONSIVE" | systemd-cat -t wazuh-watchdog 2>/dev/null; }
  exit 1
fi

# 3. OK — reset alert flag
rm -f "$ALERT"
echo "$(date -u +%FT%TZ) OK" >> "$LOG"
exit 0
