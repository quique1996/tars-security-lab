# Diccionario Blue Team / Detection — KG expansion (2026-08-08)

Corpus denso de detección y defensa para ingestión en Qdrant kg_full.

## SIEM
Security Information and Event Management. Agrega logs de múltiples fuentes, correlaciona, alerta. Splunk, Sentinel, Wazuh.

## SOC
Security Operations Center. Equipo que monitorea, detecta y responde a incidentes 24/7. Niveles 1/2/3 (triage/IR/threat hunt).

## Detection as Code
Reglas de detección versionadas como código (Sigma, YARA). Pipeline CI para testing. Reproducible y auditable.

## Sigma rules
Formato abierto de reglas de detección, agnóstico de SIEM. Convertible a Splunk/Elastic/KQL vía pySigma.

## YARA rules
Firmas para clasificar/archivos malware por patrones de bytes y strings. Reversing y EDR.

## Threat hunting
Búsqueda proactiva basada en hipótesis usando MITRE ATT&CK. No espera alertas; caza amenazas desconocidas.

## Telemetry sources
Logs de endpoint (EDR), red (NDR), auth (AD/IAM), cloud (CloudTrail), app. Cobertura amplia = mejor detección.

## EDR
Endpoint Detection and Response. Telemetría de procesos, red, archivos en endpoints. CrowdStrike, SentinelOne, Defender.

## NDR
Network Detection and Response. Inspección de tráfico de red para beaconing, C2, exfil.

## UEBA
User and Entity Behavior Analytics. Baseline de comportamiento, detecta anomalías (cuentas comprometidas).

## Incident response
NIST 800-61r3 / SANS PICERL (Prep, ID, Contain, Erad, Recovery, Lessons). Respuesta estructurada.

## Forensics
Preservación y análisis de evidencia (DFIR). Autopsy, Sleuth Kit, Volatility, FTK.

## Hardening
Fortalecimiento de sistemas: CIS Benchmarks, STIG, deshabilitar servicios, parches. Reduce superficie.

## Zero Trust
NIST 800-207: nunca confiar, siempre verificar. Microsegmentación, identidad como perímetro.

## IAM/PAM
Identity Access Management y Privileged Access Management. MFA, least privilege, vaulting de credenciales.

## ITDR
Identity Threat Detection and Response. Protege AD/Entra de ataques a identidad (Kerberoast, rogue DC).

## Cloud security
CSPMS, CWPPs, IAM roles, GuardDuty, Defender. Responsabilidad compartida.

## Container security
K8s network policies, OPA/Kyverno, Falco runtime, Trivy scan. Default-deny ingress.

## Backup resilience
3-2-1-1-0: copias inmutables/air-gapped. Ransomware targetea backups; inmutabilidad protege.

## Purple team
Colaboración ofensiva/defensiva para validar detecciones. Emula TTPs y mide telemetría capturada.

## Threat intel
CTI con MITRE ATT&CK, STIX/TAXII, MISP/OpenCTI. Enriquece detecciones y prioriza.

## Deception
Honeypots, honeytokens, canarios. Detectan movimiento lateral con falsos activos valiosos.
