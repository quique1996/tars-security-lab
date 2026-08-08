# Diccionario Red Team TTPs — KG expansion (2026-08-08)

Corpus denso de TTPs ofensivos para ingestión en Qdrant kg_full.

## Recon pasivo
OSINT, recon de subdominios, certificados CT logs (crt.sh), breach databases (DeHashed), Google dorks (GHDB). Identifica superficie de ataque sin tocar el objetivo.

## Recon activo
Escaneo de puertos (nmap, masscan), enumeración de servicios, sondeo de red. Mapea activos expuestos.

## Phishing
Ingeniería social vía email con payload o credenciales falsas. Herramientas: GoPhish, SET. Requiere infra OPSEC separada.

## Spear phishing
Phishing dirigido a individuos específicos con contexto personalizado (pretexto). Mayor tasa de éxito que masivo.

## Watering hole
Comprometer sitio legítimo frecuentado por el objetivo para infectar visitantes.

## Exploitation de apps web
OWASP Top 10: broken access control, injection, SSRF, XSS. Burp Suite, SQLMap.

## Exploitation de AD
Kerberoasting (T1558.003), AS-REP roasting, DCSync (T1003.006), NTLM relay, PtH/PtT. BloodHound para mapeo.

## Credential dumping
Extracción de hashes/credenciales de memoria (Mimikatz, secretsdump). T1003.

## Pass the Hash
Reuso de hash NTLM para autenticación lateral sin password (T1550.002).

## Pass the Ticket
Reuso de tickets Kerberos (TGT/ST) para movimiento lateral (T1550.003).

## Golden Ticket
Forjar TGT con hash de krbtgt para persistencia total en AD (T1558.001).

## Silver Ticket
Forjar ST con hash de SPN service account para acceso a servicio específico (T1558.002).

## Lateral movement
Movimiento entre hosts vía SMB, WinRM, RDP, PsExec, WMI (T1021).

## Pivoting
Usar host comprometido como trampolín hacia redes no enrutadas (ssh tunnels, proxychains, chisel).

## Persistence
Backdoors, scheduled tasks (T1053), services (T1543), registry run keys (T1547), cuentas.

## Privilege escalation
Explotar misconfigs locales, unquoted service paths, AlwaysInstallElevated, token impersonation.

## C2 frameworks
Sliver, Cobalt Strike, Mythic, Havoc, BrutelRatel. Transportes HTTP/DNS/WireGuard (mTLS).

## C2 redirectors
Arquitectura de redirectores en capas (CDN → short-haul → long-haul → team server) para OPSEC.

## Evasión EDR
LOTL (PowerShell, WMI), AMSI bypass, obfuscation, fileless, proceso injection (T1055).

## Exfiltration
Fuga de datos vía DNS, HTTPS, cloud storage, canales alternativos (T1041, T1048).

## Ransomware TTPs
Cifrado de datos, destrucción de backups, doble extorsión (exfil + leak). LockBit, BlackCat.

## Wireless attacks
WPA2 handshake capture + crack, WPA3 downgrade, Evil Twin, PMKID. aircrack-ng, hashcat.

## Mobile attacks
SSL pinning bypass (Frida/Objection), root detection bypass, APK decompile (APKTool/JADX).

## Hardware attacks
UART/JTAG/SPI extraction, fault injection (glitching), side-channel. Bus Pirate, ChipWhisperer.

## Supply chain
Compromiso de dependencias (npm/PyPI), typosquatting, malicious maintainer. SLSA/SBOM defienden.

## LLM attacks
Prompt injection, jailbreak, system prompt extraction, data exfiltration, RAG poisoning.
