# Diccionario Threats-Resilience-Governance — KG expansion (2026-08-08)

Corpus denso para ingestión en Qdrant kg_full.

## Phishing kits
Plantillas de phishing vendidas. Evasión de detección, branding clonado. OSINT de infra.

## Credential stuffing
 lista de credenciales filtradas probadas en múltiples sitios. MitigAR: MFA, rate limit, device fingerprint.

## Password spraying
Probar contraseña común contra muchas cuentas. Evita lockout. Detectar: fallos masivos.

## Brute force
Fuerza bruta de login. Mitigar: lockout, CAPTCHA, MFA, rate limit.

## Dictionary attack
Diccionario de passwords comunes + reglas. Hashcat/JTR. Mitigar: passphrase fuerte.

## Rainbow tables
Tablas precomputadas de hashes. Mitigar: salt único por password.

## Pass-the-cookie
Reuso de cookie de sesión robada (session hijack). Detectar: token binding, device change.

## Golden SAML
Forjar assertion SAML con clave de AD FS. Persistencia en federación. Detectar: anomalías.

## Kerberoast detection
Eventos 4769 con TicketEncryptionType RC4. Monitorizar AS-REQ anómalos.

## Lateral movement detection
Logon type 3 anómalo, PsExec, WMI. BehaviOR analytics (UEBA).

## Data exfil detection
Volumen de salida anómala, DNS tunneling, cloud upload. DLP + UEBA.

## Ransomware detection
Cifrado masivo de archivos, shadow copy delete, rename storm. EDR behavioral.

## C2 detection
Beaconing patterns, JA3/JA4 fingerprints, DNS anomalies. NDR + threat intel.

## Insider threat
Empleado malicioso o negligente. UEBA, PAM, DLP, segregation of duties.

## Supply chain defense
SBOM, pin deps, hash verify, vendor risk, SLSA level. Reduce superficie de ataque.

## Resilience testing
Chaos engineering de seguridad. Game days. Valida recuperación ante fallo.

## Business continuity
BCP/DR plan. RTO/RPO definidos. Backups inmutables. Pruebas de recuperación.

## Disaster recovery
Failover, restore de backups. RPO/RTO. Inmutable/air-gapped protege de ransomware.

## Risk register
Inventario de riesgos con likelihood/impact. Tratamiento: mitigate/transfer/accept.

## Security policy
Documentos de alto nivel. Aceptación de uso, clasificación de datos, incident response.

## Standards compliance
ISO 27001, NIST, PCI, HIPAA. Auditorías externas. Certificación mejora postura.

## Vendor management
Due diligence de terceros. Contratos con cláusulas de seguridad. Monitoring continuo.

## Security training
Onboarding, phishing simulado, rol específico. Cultura de seguridad consciente.

## Board reporting
Métricas de riesgo en lenguaje de negocio. Presupuesto alineado a riesgo.

## Security budget
Invertir en detección > prevención sola. Priorizar por risk-informed defense.
