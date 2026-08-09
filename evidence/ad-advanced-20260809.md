# AD Advanced — 2026-08-09 (evidencia consolidada)

**Host:** GEEKOM (100.123.17.12) · **DC:** 192.168.122.50 (dc1, Samba 4.17.12, TARS.LOCAL)
**Nota:** host inestable (load 197, swap lleno) — trabajo en ráfagas cortas. Hallazgos verificados.

## 1. Recon (completado)
- DC up: dc01, Samba 4.17.12, TARS.LOCAL, 192.168.122.50
- Usuarios enumerados: alice, bob, carol, lowpriv, svc_web, svc_backup, svc_sql, deleg_svc, asrep_svc, Administrator
- Creds confirmadas de /root/populate.sh:
  - svc_backup = Welcome1 (Backup Operators)
  - svc_web = Password1
  - deleg_svc = Delegate2026 (unconstrained delegation)
  - asrep_svc = Autumn2026

## 2. ACL enumeration (completado)
- `nxc ldap --bloodhound` FALLA: ldap3↔Samba `LDAPSessionTerminatedByServerError` (pitfall conocido)
- Impacket LDAP API mismatch; SamDB Python API **segfaults** en el DC
- **`samba-tool dsacl get` FUNCIONA** — dump del ACL de svc_backup:
  - **Solo ACLs default de Samba** (DA/SY/AO/PS/AU/RS/RU/CA/BA/EA/ED)
  - **Sin GenericAll/WriteDACL/WriteOwner custom** → no hay ruta de ACL abuse en este lab

## 3. S4U2Proxy (completado — hallazgo de arquitectura)
- `samba-tool delegation show deleg_svc`:
  - **UF_TRUSTED_FOR_DELEGATION=True** (unconstrained — confirmado)
  - **UF_TRUSTED_TO_AUTHENTICATE_FOR_DELEGATION=False** (NO S4U2Proxy)
  - **Sin msDS-AllowedToDelegateTo**
- S4U2Self re-validado: `kvno -I Administrator deleg_svc` → TGS "for client Administrator@TARS.LOCAL" (funciona)
- **Conclusión:** S4U2Proxy NO es explotable contra este lab (el flag no está seteado). La delegación sin restricción se explota vía coerción (printerbug/petitpotam) — pendiente.

## 4. NTDS via svc_backup/VSS (no ejecutado)
- secretsdump DRSUAPI falla contra Samba (conocido)
- VSS no disponible en Samba (sin servicio VSS)
- **Pendiente:** svc_backup=Welcome1 (Backup Operators) — probar lectura de archivos del DC vía SMB (ntbackup privilege)

## 5. Password spray (no ejecutado)
- Wordlist: TarsLab2026!, Summer2026, Password123, Winter2026, Spring2026, Autumn2026, Tars2026!, Lab2026!, Admin123, Summer2025
- Targets no-DA: lowpriv, alice, bob, carol, svc_web, svc_backup, deleg_svc, asrep_svc
- **Pendiente:** nxc smb 192.168.122.50 -u users.txt -p wordlist-lab.txt --continue-on-success

## Próximos pasos (con host estable)
1. Coerción de delegación sin restricción (printerbug/petitpotam → RBCD o relay)
2. svc_backup: ntbackup privilege → leer archivos del DC
3. Password spray con wordlist-lab.txt
