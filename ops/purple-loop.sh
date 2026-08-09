#!/bin/bash
# purple-loop.sh — Caldera op → Wazuh cobertura → evidence (semanal, domingo 04:00)
# DRY: reemplaza los probes ad-hoc. Usa el patrón verificado 2026-08-09.
set -uo pipefail
K="KEY: ADMIN123"
B="http://127.0.0.1:8888"
CTN="wazuh-wazuh.manager-1"
ADV="0f4c3c67-845e-49a0-927e-90ed33c044e0"  # Discovery
PAW="ceewjl"
D="/opt/ad-lab/evidence"
TS=$(date +%Y%m%d-%H%M%S)
OUT="$D/purple-weekly-$TS.md"

# 1. Baseline
BASE=$(docker exec "$CTN" sh -c "wc -l < /var/ossec/logs/alerts/alerts.json" 2>/dev/null || echo 0)

# 2. Launch op
OP=$(curl -s -m 10 -H "$K" -H "Content-Type: application/json" -X POST "$B/api/v2/operations" \
  -d "{\"name\":\"purple-weekly-$TS\",\"adversary\":{\"adversary_id\":\"$ADV\"},\"agents\":[{\"paw\":\"$PAW\"}],\"group\":\"red\",\"autonomous\":1}" 2>/dev/null)
OP_ID=$(echo "$OP" | python3 -c "import sys,json; print(json.load(sys.stdin).get('id',''))" 2>/dev/null)
[ -z "$OP_ID" ] && { echo "ERROR: op launch failed"; exit 1; }

# 3. Wait for finish (max 5 min)
for i in $(seq 1 30); do
  sleep 10
  STATE=$(curl -s -m 5 -H "$K" "$B/api/v2/operations/$OP_ID" 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin).get('state',''))" 2>/dev/null)
  [ "$STATE" = "finished" ] && break
done
# Force finish if looping
curl -s -m 5 -X PATCH -H "$K" -H "Content-Type: application/json" "$B/api/v2/operations/$OP_ID" -d '{"state":"finished"}' >/dev/null 2>&1

# 4. Measure
EXEC=$(curl -s -m 5 -H "$K" "$B/api/v2/operations/$OP_ID" 2>/dev/null | python3 -c "
import sys,json
d=json.load(sys.stdin)
ok=[l for l in d.get('chain',[]) if l.get('status')==0]
print(len(ok))" 2>/dev/null)
NOW=$(docker exec "$CTN" sh -c "wc -l < /var/ossec/logs/alerts/alerts.json" 2>/dev/null || echo 0)
DETECT=$(docker exec "$CTN" sh -c "grep -cE '10060[012]' /var/ossec/logs/alerts/alerts.json" 2>/dev/null || echo 0)

# 5. Evidence
cat > "$OUT" <<EOF
# Purple Weekly — $TS
- Op: $OP_ID (Discovery)
- Baseline alerts: $BASE → now: $NOW (delta $((NOW-BASE)))
- Abilities executed: $EXEC
- Discovery rule hits (100600-2): $DETECT
- Coverage: $([ "$EXEC" -gt 0 ] && echo "$DETECT/$EXEC" || echo "n/a")
EOF
echo "WROTE $OUT"
exit 0
