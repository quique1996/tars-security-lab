# Diccionario AD/WebApp/Recon/Phishing — KG expansion (2026-08-08)

Corpus denso para ingestión en Qdrant kg_full.

## AD Kerberoasting
T1558.003: pedir TGS para SPN, crackear hash RC4 (AES si weak). Tool: Rubeus, Impacket GetUserSPNs.

## AD AS-REP roasting
T1558.004: cuentas con DONT_REQ_PREAUTH, pedir AS-REP, crackear. No funciona en Samba Heimdal por defecto.

## AD DCSync
T1003.006: replicar secretos de DC vía MS-DRSR. Requiere permiso replication. Mimikatz lsadump::dcsync.

## AD Golden Ticket
Forjar TGT con hash krbtgt (T1558.001). Persistencia total. Detección: anomalías en TGT lifetime.

## AD Silver Ticket
Forjar ST con hash de service (T1558.002). Acceso a servicio específico. Más sigiloso que Golden.

## AD NTLM relay
Interceptar NTLM auth, relay a otro servicio (SMB/LDAP). Mitm6 + ntlmrelayx. Defensa: SMB signing, LDAP channel binding.

## AD Pass the Hash
Reuso de hash NTLM (T1550.002). No requiere password. Detectar: logon type 9,源地 anomalías.

## AD Pass the Ticket
Reuso de ticket Kerberos (T1550.003). Overpass-the-hash: hash→TGT.

## AD BloodHound
Grafo de relaciones AD. Shortest path to DA. Sharphound collector. Mapeo de attack paths.

## AD Unconstrained delegation
Cuenta con TRUSTED_FOR_DELEGATION. TGT de cualquiera que se conecta queda en memoria. Riesgo DA.

## AD Constrained delegation
TRUSTED_TO_AUTH_FOR_DELEGATION. Permite delegar a SPNs específicos. Abusable con S4U2Self/Proxy.

## AD ACL abuse
Permisos en objetos AD (WriteOwner, GenericAll). Grant rights, add to group. BloodHound lo mapea.

## AD GPP passwords
Group Policy Preferences cPassword (MS14-025). Encriptación reversable. Gpprefdecrypt.

## WebApp broken access control
OWASP A01. IDOR, force browsing, missing authz. Burp Authz, manual testing.

## WebApp injection
OWASP A03. SQLi, command injection, LDAP injection. SQLMap, input validation.

## WebApp SSRF
Server-Side Request Forgery. Acceso a metadata (169.254.169.254), internal services. Blind SSRF.

## WebApp XSS
Reflected, stored, DOM. CSP, output encoding. PortSwigger labs.

## WebApp auth flaws
JWT none algo, weak reset tokens, session fixation. JWT_Tool, manual review.

## WebApp deserialization
Insecure deserialization (Java/Python/.NET). RCE. Ysoserial, payloads.

## Recon subdomain enum
Sublist3r, amass, crt.sh, brute force. Descubre assets ocultos.

## Recon port scanning
nmap -sV -sC, masscan. Identifica servicios/versiones expuestas.

## Recon OSINT
LinkedIn, breach corpor, GHDB. Mapea empleados, tecnologías, subdominios.

## Recon tech stack
Wappalyzer, builtwith. Identifica frameworks con CVEs conocidos.

## Phishing infra GoPhish
Separar infra de phishing de C2. SPF/DKIM/DMARC para deliverability.

## Phishing landing pages
Clonar login legítimo. Evilginx3 como proxy para capturar credenciales + MFA tokens (AITM).

## Phishing payloads
Documentos macro, links, HTA, ISO. Evasión de AV con obfuscation.

## Pretexting framework
Investigar objetivo, crear escenario, establecer canal, ejecutar, extraer. OSINT previo esencial.

## C2 Sliver
Open source, multi-platform, WireGuard mTLS. Beacon vs session. Madlant alternative a Cobalt Strike.

## C2 Cobalt Strike
Commercial, Malleable C2 profiles para evasión. Team server + beacon. Estándar de industria.

## C2 redirector CDN
CloudFront/Cloudflare como frente de alto-reputación. Team server nunca expuesto.

## C2 domain aging
Registrar dominios con antelación, reputación limpia. Separar por función (C2/phishing/payload).

## Evasion AMSI
Bypass Antimalware Scan Interface en PowerShell. Memory patch, obfuscation, dotnet.

## Evasion LOLBins
Living-off-the-land: certutil, bitsadmin, wmic. Sin dropper detectable.

## Persistence services
Crear servicio Windows (T1543.003). Run keys (T1547.001). Scheduled tasks (T1053).

## Persistence WMI
Event subscription persistente (T1546.003). Difícil de detectar.

## Persistence registry
Run/RunOnce, AppInit DLLs. Auto-exec en logon.

## Lateral movement WinRM
Invoke-Command, evil-winrm. Requiere credenciales válidas.

## Lateral movement PsExec
Ejecución remota vía SMB. Requiere admin. Ruido detectable.

## Lateral movement RDP
Remote Desktop. Restricted admin mode mitiga PtH. Network level auth.

## Exfil DNS tunneling
Codificar datos en subdominios. Detectar: volumen anómalo, domain generation.

## Exfil cloud
Subir a Drive/Dropbox con credenciales robadas. DLP y CASB mitigan.

## Privilege escalation Windows
Unquoted service path, weak service perms, AlwaysInstallElevated, token impersonation.

## Privilege escalation Linux
SUID binaries, cron jobs, sudo misconfig, kernel exploits.

## Obfuscation PowerShell
Invoke-Obfuscation, base64, string splitting. Evade firma y AMSI.

## Credential access browser
Extracción de credenciales guardadas (LaZagne, browser decrypt). Defensa: master password.

## Credential access LSASS
Volcado de proceso LSASS (T1003.001). Mimikatz, ProcDump. Detectar: handle a lsass.

## Responder/LLMNR
Envenenamiento de LLMNR/NBT-NS. Captura hashes NTLM en red local. Mitm6 para IPv6.

## SMB relay chain
Responder captura → ntlmrelayx relay a SMB/LDAP con signing off. Compromiso de host.

## Kerberos delegation abuse
S4U2Self + S4U2Proxy para impersonar. Rubeus s4u. Requiere constrained delegation.

## ADCS attack
ESC1-ESC8: plantillas vulnerable de AD CS. Certipy. Certificado → persistencia/silver ticket.

## GPO attack
Envenenar GPO para ejecución en múltiples hosts. Abusable si se tiene edición de GPO.

## Defender ASR
Attack Surface Reduction rules. Bloquea LOLBins, script obfuscation. Mitiga evasión.

## WDAC/AppLocker
Allowlist de ejecutables. Bloquea binarios no firmados. WDAC más robusto que AppLocker.

## LAPS
Local Admin Password Solution. Rotación de local admin por equipo. Mitiga PtH lateral.
