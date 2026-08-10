# AD Suite Real — 2026-08-09 (evidencia consolidada)

**Target:** TARS.LOCAL · DC 192.168.122.50 (dc1, Samba 4.17.12) · Kali 192.168.122.151 · metasploitable2 192.168.122.246 (relay target)
**Nota de alcance:** GOAD no estaba disponible (RAM bloqueada, HW TIER1 pendiente — ver t_a6595f9f). La suite se ejecutó contra el lab Samba vivo de TARS.LOCAL. Todos los outputs crudos en este directorio; hashes verificables en `manifest.sha256`.

## Resultados

| # | Técnica | Estado | Evidencia |
|---|---------|--------|-----------|
| 01 | Enumeración SPN | OK — 4 SPN (svc_web, deleg_svc unconstrained, svc_backup, svc_sql DA) | `01-spn-enum.txt` |
| 02 | Kerberoasting | OK — 4/4 hashes obtenidos y **crackeados** (MSSQLSvc=Summer2026, CIFS=Welcome1, HTTP=Delegate2026, HTTP=Password1) | `02-kerberoast-hashes.txt`, `04-kerb-crack.txt` |
| 03 | AS-REP roasting | OK — asrep_svc **crackeado** (Autumn2026) | `03-asrep.txt`, `04-asrep-crack.txt` |
| 04 | secretsdump (DRSUAPI) | BLOQUEADO — Samba no implementa DRSUAPI GetNCChanges (RRP 0x2, DRSR, byte-indices); VSS no disponible en Samba; backup-vss acceso denegado 0x5 | `05-secretsdump-*.txt` |
| 05 | Enumeración shares svc_backup | OK — sysvol/netlogon READ como svc_backup:Welcome1 (Backup Operators) | `06-svcbackup-shares.txt` |
| 06 | BloodHound CE collector | BLOQUEADO — auth Kerberos LDAP falla vs Samba, fallback NTLM también (pitfall conocido, ver ad-advanced-20260809.md) | `07-bloodhound-ce.txt` |
| 07 | Coerción printerbug | BLOQUEADO — herramienta no disponible (repo GitHub eliminado, URL 404, sin paquete apt en Kali) | `08g-printerbug.txt`, `08j-printerbug-kali.txt` |
| 08 | Coerción petitpotam | PARCIAL — conecta a pipe lsarpc de DC, output cortado (host inestable) | `08e-petitpotam-r2.txt` |
| 09 | SMB relay (ntlmrelayx) | PARCIAL — **enumeración OK**: DC01 signing=True (relay a DC bloqueado — hallazgo defensivo positivo), metasploitable2 signing=False (relay viable). **Ataque NO completado**: bind 445 "Address already in use" por proceso relayx previo; round 6 (zona firewalld para 445) lanzado pero el worker murió antes de completarlo | `08a-*.txt`, `08d-relay-meta-result.txt`, `08h-*.txt`, `08i-relay-dcsmb-result.txt`, `run5.log` |
| 10 | GPO abuse | **OK — END-TO-END**: GPO `TARS-GPO-Abuse` creado ({40B48ABF-204C-4FF6-8576-F75F531FFF77}), payload startup (crea gpo_pwn + Administrators) escrito a SYSVOL vía smbclient, link a raíz de dominio, verificado en disco y vía samba-tool gpo show | `09a-09f-*.txt` |

## Hallazgos clave

1. **Kerberoast es el camino real en este lab**: 3 de 4 SPNs crackeados con passwords débiles de `populate.sh`; svc_sql es Domain Admins con `Summer2026`.
2. **AS-REP roasting funcional**: cuenta `asrep_svc` sin preauth → `Autumn2026` → acceso como esa cuenta.
3. **Samba limita la suite**: DRSUAPI (secretsdump), VSS y LDAP autenticado (BloodHound CE) no funcionan contra Samba — no es fallo del ataque sino del target. Alternativas verificadas en este lab: `samba-tool` suite (dsacl, delegation show, gpo) + impacket contra SMB.
4. **DC con SMB signing=True** (hallazgo defensivo): relay a DC bloqueado; el relay solo es viable contra targets sin signing (metasploitable2).
5. **GPO abuse reproducible de punta a punta** con samba-tool (crear GPO) + smbclient (payload a SYSVOL) + setlink a raíz del dominio.

## Pendiente para cuando GOAD / host estable

- secretsdump contra DC real de GOAD (Windows) — DRSUAPI funcional.
- BloodHound CE ingest completo (collector contra GOAD DC Windows).
- printerbug/petitpotam contra GOAD (MS-RPRN/MS-EFSRPC reales, Windows).
- Relay win completo: limpiar proceso relayx previo / abrir 445 en zona correcta y re-ejecutar ntlmrelayx + trigger.
- Scripts de la suite: `scripts/` (round2-6.sh, suite.sh, samba-kerberoast.sh, helpers).
