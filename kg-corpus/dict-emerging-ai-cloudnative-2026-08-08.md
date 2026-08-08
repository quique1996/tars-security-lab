# Diccionario Emerging/AI/Cloud-Native/Security-Culture — KG expansion (2026-08-08)

Corpus denso para ingestión en Qdrant kg_full.

## AI agentic threats
Agentes autónomos con tools. Prompt injection → acciones no autorizadas. CVE-2026-30623 LiteLLM RCE.

## AI supply chain
Mother of All AI Supply Chains (10 CVEs). Compromiso de modelos/pipelines de IA.

## AI model poisoning
Envenenamiento de training data. Backdoors en modelos. Detección difícil post-deploy.

## AI data exfiltration
RAG poisoning extrae datos de corpus. Indirect prompt injection en Slack/email.

## AI guardrails
Input/output filtering, tool allowlisting, human-in-loop. LlamaGuard, NeMo Guardrails.

## AI red teaming
Evaluar modelos con adversarial prompts, jailbreaks. Garak, PyRIT. Evidenciar riesgos.

## Quantum threats
Harvest-now-decrypt-later. Migración a PQC (NIST FIPS 203/204/205). AES-256 aún seguro.

## Deepfake detection
Análisis de artifacts (blinking, audio glitches). Verificación out-of-band sigue siendo clave.

## 5G security
SUCI (cifrado de SUPI), deshabilitar 2G para evitar downgrade. IMSI catcher mitigado.

## Synthetic media
Generación de audio/video falso. Uso en BEC, influencia. Fact-checking + autenticación.

## Cloud CSPM
Cloud Security Posture Management. Detecta misconfigs (S3 público, IAM over-permissive).

## Cloud CWPP
Cloud Workload Protection. Runtime protection de contenedores/VMs en cloud.

## Cloud WAF
Web Application Firewall gestionado (AWS WAF, Cloudflare). Rate limiting, reglas OWASP.

## Cloud KMS
Key Management Service. Encriptación en reposo/tránsito. HSM-backed keys.

## Cloud Secrets Manager
AWS Secrets Manager, Vault. Rotación automática. No hardcodear en env vars.

## Cloud VPC
Virtual Private Cloud. Subnets públicas/privadas, NACLs, security groups. Zero trust interno.

## Cloud IAM roles
AssumeRole temporal. Instance profiles. Principio de menor privilegio.

## Cloud metadata IMDSv2
Session tokens vía IMDS. IMDSv2 requiere token (mitiga SSRF theft). IMDSv1 vulnerable.

## CloudTrail
Log de API calls. Forense de compromiso. CloudWatch alarms en eventos críticos.

## Serverless Lambda
Funciones efímeras. Superficie: event sources, IAM per-function, env secrets.

## Serverless layers
Dependencias compartidas. Vulnerabilidades en capas (Log4Shell). Scan con Snyk.

## Edge computing
Lambda@Edge, Cloudflare Workers. Código en edge nodes. Geo-distributed monitoring.

## Container runtime
containerd, runc, gVisor. Escape via vulnerable runc (CVE-2019-5736). Kata containers aísla.

## Container image scanning
Trivy, Grype, Clair. CVEs en base images. Gate en CI (falla build si crítico).

## Kubernetes RBAC
Role/ClusterRole + Binding. Least privilege. Evitar wildcard verbs/resources.

## Kubernetes secrets
etcd sin encrypt por defecto. KMS provider para encrypt. No como env (visible en describe).

## Kubernetes pod security
Pod Security Admission: privileged, hostPath, hostNetwork denegados. Baseline/Restricted.

## Kubernetes admission
Validating/Mutating webhooks. OPA/Gatekeeper, Kyverno. Policy enforcement pre-admit.

## Service mesh
Istio, Linkerd. mTLS entre servicios. Observabilidad de tráfico este-oeste.

## IaC security
Terraform, CloudFormation. Checkov, tfsec. Detecta misconfig pre-deploy.

## Secret scanning
Gitleaks, TruffleHog. Previene commits de keys. Pre-commit hooks + CI.

## SAST
Static App Security Testing. Semgrep, CodeQL. Detecta vulns en código fuente.

## DAST
Dynamic AST. OWASP ZAP, Burp. Black-box contra app corriendo.

## SCA
Software Composition Analysis. Dependency-Check, Snyk. CVEs en librerías de terceros.

## DevSecOps
Shift-left. Security en pipeline. Gate de calidad, SBOM, attestation.

## Security culture
Training continuo, blame-free post-mortem, incentivos a reportar. Cultura > herramientas.

## Metrics that matter
MTTD, MTTR, detection coverage, false positive rate. Track para mejorar.

## Tabletop exercises
Simulacros de incidente. Valida runbooks, comunica roles. Sin sistemas reales.

## Red team metrics
Phishing click rate, detection rate de TTPs, time-to-detect. Mide eficacia defensiva.

## Purple team value
Feedback loop ofensiva→defensa. Cierra gaps de detección con evidencia.

## Threat-informed defense
Priorizar según TTPs del adversary real. MITRE ATT&CK como base.

## Risk quantification
FAIR framework. Cuantificar riesgo en $ para decisiones de negocio.

## Security awareness
Phishing simulado, reconocimiento SE, cultura de verificación. Reduce tasa de éxito.

## Vendor risk management
Terceros con acceso. Questionnaire, continuous monitoring, contractual clauses.

## Zero trust maturity
Identidad, dispositivo, red, aplicación, datos. Capa por capa. No binario.

## Compliance automation
SCAP, InSpec. Validación continua de controles. Audit-ready siempre.

## Security debt
Vulns no remediadas acumuladas. Priorizar por exploitability + impacto.

## Chaos engineering security
Inyectar fallos para probar resiliencia. Game days de seguridad.

## Bug bounty programs
HackerOne, Intigriti, YesWeHack. Crowdsourced vuln discovery. Scope + rules claros.

## Disclosure ethics
Coordinated vulnerability disclosure. No venta en mercados grises. Responsabilidad.

## Continuous verification
No confiar en "deployed secure". Verificar con tests, scanning, red team.
