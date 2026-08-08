# Diccionario Identity/Data/Network-Security — KG expansion (2026-08-08)

Corpus denso para ingestión en Qdrant kg_full.

## IAM least privilege
Otorgar mínimo necesario. Revisión periódica de permisos. Revocar acceso huérfano.

## IAM MFA
Multi-factor obligatorio. FIDO2 phishing-resistant > TOTP > SMS. Microsoft 2025: MFA bloquea 99%.

## IAM SSO
Single Sign-On (SAML, OIDC). Un login para múltiples apps. Reduce password sprawl.

## IAM federation
Trust con IdP externo (Google, Azure AD). SAML assertion. Evita cuentas duplicadas.

## PAM vaulting
Password vaulting (CyberArk, Vault). Check-out de credenciales con sesión grabada.

## PAM session broker
Proxy de sesión PAM. Graba y controla acceso a privilegiado. Detecta abuso.

## PAM just-in-time
Acceso temporal elevado (JIT). Expira automáticamente. Reduce superficie de cuenta admin.

## IAM role explosion
Demasiados roles = difícil auditar. Consolidar con grupos y policies bien definidas.

## MFA fatigue
Bombardeo de push para que usuario apruebe por cansancio. Mitigar: number matching, geo-fencing.

## SSO SAML attack
XML signature wrapping, XXE, forced authentication. Defensa: validación estricta.

## OAuth authorization code
Flujo estándar con PKCE. State parameter anti-CSRF. Token en backend, no frontend.

## Passwordless
FIDO2/WebAuthn. Clave pública, sin shared secret. Phishing-resistant por diseño.

## Account takeover
Credential stuffing, phishing, session hijack. Detectar: login anómalo, nuevo device.

## DLP
Data Loss Prevention. Inspección de contenido en motion/at-rest/endpoint. Bloquea exfil.

## Data classification
Pública, interna, confidencial, restringida. Labels dictan controles. GPO/MIP automatizado.

## Data encryption at rest
AES-256, LUKS, BitLocker. Disco cifrado. Key en KMS/HSM separado.

## Data encryption in transit
TLS 1.3, mTLS. Certificados válidos. HSTS. Evita MITM.

## Data tokenization
Reemplazar PAN con token. Reduce alcance PCI. Vault de tokens.

## Data masking
Ofuscar datos sensibles en no-prod (PII). Anonymization, pseudonymization.

## Database security
Least privilege SQL, prepared statements, audits. SQL injection prevention.

## Network segmentation
VLANs, subnets, firewalls. Aislar crítico de genérico. Zero trust interno.

## Network microsegmentation
Por carga de trabajo (Calico, NSX). Zero trust a nivel de host. Previene lateral.

## Network NAC
Network Access Control. Valida postura del device antes de acceso. 802.1X.

## Network SD-WAN
WAN definido por software. Cifrado de tunnels, QoS, SASE integration.

## Network SASE
Secure Access Service Edge. SD-WAN + security (SWG, CASB, ZTNA) en cloud.

## Network ZTNA
Zero Trust Network Access. Acceso por identidad + postura, no por IP/VPN.

## Network VPN
Tunnel cifrado. Split-tunneling cuidadoso. VPN como no suficiente para ZT (overlay).

## Network DNS security
DNSSEC, DoH/DoT, blocklist. Prevente DNS hijacking, C2 por DNS.

## Network IDS/IPS
Snort, Suricata. FIRMAS de intrusión. Detecta/previene exploits conocidos.

## Network honeypot
Decoy para detectar recon/ataque. Canary tokens, HFish. Alerta en acceso.

## Network traffic analysis
Zeek/Bro. Logs de conexión ricos. Detecta beaconing, lateral, exfil.

## Network bastion host
Jump server para acceso admin. Auditado, MFA, sin acceso directo a prod.

## WAF rules
OWASP Top 10, rate limiting, geo-blocking. Protege app de L7. Cloudflare/AWS WAF.

## Email security gateway
Defensa de phishing, sandboxing de adjuntos, DMARC enforcement. M365 Defender.

## DMARC/DKIM/SPF
Autenticación de email. Previene spoofing. DMARC quarantine/reject para dominios propios.

## Certificate transparency
Logs de certificados. Monitorizar emisión no autorizada de certs para tu dominio.

## PKI
Public Key Infrastructure. CA, certs, revocation (CRL/OCSP). Raíz offline.

## Secrets management
Vault, AWS Secrets Manager. Rotación, audit, dynamic secrets. No en código.

## Key rotation
Rotar credenciales/claves periódicamente. Reduce ventana de compromiso.

## Secure coding
Input validation, output encoding, parameterized queries. OWASP ASVS como guía.

## Threat modeling STRIDE
Spoofing, Tampering, Repudiation, Info Disclosure, DoS, Elevation. Por componente.

## Security architecture
Defense in depth, zero trust, least privilege. Diseño desde inicio, no afterthought.
