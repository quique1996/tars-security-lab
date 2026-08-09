#!/bin/bash
# weekly-lab-report.sh — resumen semanal del lab (domingo 05:00) → Telegram
set -uo pipefail
D="/opt/ad-lab/evidence"
TS=$(date +%Y%m%d)
OUT="$D/weekly-report-$TS.md"

# Cobertura púrpura (último purple-weekly)
PURPLE=$(ls -t $D/purple-weekly-*.md 2>/dev/null | head -1)
COVERAGE="n/a"
[ -n "$PURPLE" ] && COVERAGE=$(grep "Coverage:" "$PURPLE" | cut -d: -f2 | tr -d ' ')

# Alertas Wazuh (últimos 7 días)
ALERTS=$(docker exec wazuh-wazuh.manager-1 sh -c "grep -cE '2026 Aug 0[2-9]' /var/ossec/logs/alerts/alerts.log" 2>/dev/null || echo 0)

# FPs (100530 sin supresión — debería ser 0)
FPS=$(docker exec wazuh-wazuh.manager-1 sh -c "grep -cE '100530' /var/ossec/logs/alerts/alerts.json" 2>/dev/null || echo 0)

# Skills nuevas (contar en el profile)
SKILLS=$(ls ~/.hermes/profiles/stella/skills/security/ 2>/dev/null | wc -l)

# Uptime
UP=$(uptime -p 2>/dev/null | sed 's/up //')

cat > "$OUT" <<EOF
# Weekly Lab Report — $TS
- Cobertura púrpura: $COVERAGE
- Alertas Wazuh (7d): $ALERTS
- FPs 100530: $FPS
- Skills security: $SKILLS
- Uptime GEEKOM: $UP
- Purple evidence: $PURPLE
EOF
echo "WROTE $OUT"
# Telegram delivery (si el bot está configurado)
[ -n "${TELEGRAM_BOT_TOKEN:-}" ] && [ -n "${TELEGRAM_CHAT_ID:-}" ] && \
  curl -s -m 10 -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  -d "chat_id=${TELEGRAM_CHAT_ID}" -d "text=$(cat "$OUT")" >/dev/null 2>&1
exit 0
