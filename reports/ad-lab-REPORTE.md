# AD Lab Fase 2 — Evidence Report (TARS.LOCAL)

**Fecha:** 2026-08-08 | **Operator:** GEEKOM (100.123.17.12) | **DC:** dc01.tars.local (192.168.122.50)
**Scope:** Lab local (virbr0 192.168.122.0/24), sin exposición externa.

## Topología
- VM `dc1` (Debian 12.15 netinst, 2GB/30GB) en `/data/vms/dc1.qcow2`.
- Samba AD DC `TARS.LOCAL`, functional level 2008 R2, DNS interno SRV/A resuelve.
- Usuario admin: `tarsadmin` (lab), `administrator@TARS.LOCAL`.

## Usuarios y SPNs (9 usuarios, 4 SPNs con misconfigs)
| Usuario | SPN | Misconfig | Grupo |
|---|---|---|---|
| svc_sql | MSSQLSvc/dc01.tars.local:1433 | — | **Domain Admins** |
| svc_backup | CIFS/backup.tars.local | — | Backup Operators |
| deleg_svc | HTTP/app.tars.local | UAC TRUSTED_FOR_DELEGATION | — |
| asrep_svc | — | UAC DONT_REQUIRE_PREAUTH (4260352) | — |
| svc_web | HTTP/web.tars.local | — | — |
| lowpriv, alice, bob, carol | — | — | Domain Users |

Password policy débil: `svc_sql=Summer2026`, `svc_backup=Welcome1`, `deleg_svc=Delegate2026`, `svc_web=Password1`, `asrep_svc=Autumn2026`.

## Kerberoasting — COMPLETO Y VALIDADO
- Método: `kinit` + `kvno` con RC4 etype forzado (bypass al bug impacket/Samba `KRB_AP_ERR_INAPP_CKSUM`), ccache parseado a formato hashcat.
- **4 hashes `$krb5tgs$23$` extraídos y crackeados offline:**
  - `svc_sql` (MSSQLSvc, DC) → `Summer2026` ✅
  - `svc_backup` (CIFS) → `Welcome1` ✅
  - `deleg_svc` (HTTP, unconstrained delegation) → `Delegate2026` ✅
  - `svc_web` (HTTP) → `Password1` ✅
- **`svc_sql` es Domain Admin → compromiso total de DA probado.**

## AS-REP Roasting — BLOQUEADO (documentado)
- Intento sobre `asrep_svc` (UAC 0x400000) devolvió `KDC_ERR_PREAUTH_REQUIRED` (code 25) en todos los etypes.
- Causa raíz: el bit UAC se seteó vía `ldbmodify` raw en `populate.sh`; el KDC de Samba (HDB) no lo honra como la API SamDB (`uac.py`). LDAP muestra `userAccountControl=4260352` pero el KDC lo ignora.
- Remediación: requiere DC write (`uac.py` + restart `samba-ad-dc`) — gated por aprobación esta corrida.
- Plaintext para validación: `asrep_svc:Autumn2026`.

## BloodHound — BLOQUEADO
- NTLM deshabilitado + fallo de bind GSSAPI LDAP → `bloodhound-python` no ingiere.
- Ruta DA documentada manualmente: `svc_sql` (Domain Admins) → Kerberoast → DA.

## Comandos (reproducibles)
```bash
# Kerberoast (desde GEEKOM, contra 192.168.122.50)
kinit tarsadmin  # TarsLab2026!
kvno -e 23 MSSQLSvc/dc01.tars.local:1433  # fuerza RC4
# parsear ccache -> hashcat: $krb5tgs$23$...
# Crack: hashcat -m 13100 kerberoast.txt rockyou.txt

# AS-REP (remediación pendiente)
nxc ldap 192.168.122.50 -u '' -p '' --asreproast  # requiere DC write
```

## Hallazgos
1. **Kerberoast → DA:** 4/4 SPNs crackeadas, `svc_sql` = DA. Ruta de compromiso completa.
2. **Unconstrained delegation:** `deleg_svc` puede ser abusado para capturar TGT de admin (si se logra coerción).
3. **AS-REP:** misconfig presente en LDAP pero no efectiva en KDC Samba (falsos positivos en auditorías ciegas).

## Limitations
- AS-REP roasting no extrajo hash (bug Samba KDC).
- BloodHound no ingirió (NTLM off).
- Evidence de hashes en `/data/evidence/kerberoast.hashes` (4 cracks validados).

## Next
1. Aplicar `uac.py` fix + restart para AS-REP real.
2. Habilitar NTLM temporal para BloodHound ingest.
3. Escritura de herramienta de coerción (PrinterBug/PetitPotam) para abusar delegación.
