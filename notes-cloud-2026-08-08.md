# Corpus Cloud/Container/OSINT/Malware — KG expansion (2026-08-08)

Fuentes: GetAstra cloud tools 2026, Aqua kube-hunter/Trivy, Lampyre/espectrosint OSINT, REMnux/Ghidra malware. Para ingestión en Qdrant kg_full.

## 1. CLOUD (AWS/Azure/GCP)
- **Ataques:** enum de recursos, misconfig (S3 público, IAM over-permissive), privilege escalation (Pacu modules), credential leakage, SSRF a metadata (169.254.169.254), container escape a cloud.
- **Herramientas:** Pacu (AWS exploit framework), ScoutSuite (multi-cloud config audit), Prowler (compliance), CloudFox (attack path), CloudBrute (asset discovery), Cloudsplaining (IAM risk).
- **Defensa:** least-privilege IAM, S3 private+encryption, IMDSv2 (mitiga SSRF metadata), guardrails de config, CloudTrail logging.

## 2. CONTAINER / KUBERNETES
- **Ataques:** imagen vulnerable (CVEs), misconfig (privileged pod, hostPath mount), RBAC escalation (kubectl-who-can), API server expuesto, container escape (runc/CVE), secrets en plaintext.
- **Herramientas:** kube-hunter (active hunting), Trivy (image/IaC/SBOM scan), kube-bench (CIS benchmark), kubectl-who-can.
- **Defensa:** imagenes minimales + scan en CI, RBAC least-priv, PodSecurityPolicy/Admission controllers, network policies, secrets en vault no env vars.

## 3. OSINT / RECON
- **Herramientas:** Maltego (link analysis), SpiderFoot (framework, ya en GEEKOM), theHarvester (emails/subdomains), Shodan (infra recon), Recon-ng, Sherlock (usernames), Google Dorks, Social-Search.
- **Social Engineering Toolkit (SET):** phishing, credential harvest, spear-phishing.
- **Defensa:** OPSEC personal, awareness training, DMARC/DKIM/SPF (anti-spoofing), email filtering, 2FA hardware.

## 4. MALWARE ANALYSIS / REVERSE ENGINEERING
- **Static:** Ghidra 11 (AI-assisted decompilation), Radare2, strings, binwalk, peid.
- **Dynamic:** REMnux (Linux distro con 100+ tools), FLARE VM (Windows), Volatility (memory forensics), Wireshark (network), sandboxes (Cuckoo/CAPE).
- **Técnicas:** unpacking, behavioral analysis, IOC extraction, YARA rules, detonación en VM aislada.
- **Defensa:** EDR, allowlisting, patching, threat intel (YARA/MISP), user training.

## 5. RELACIONES KG
- (cloud, vulnerable_a, s3_public) ← (pacu, escala, iam)
- (k8s, vulnerable_a, privileged_pod) ← (trivy, escanea, imagen)
- (osint, usa, maltego) ← (spiderfoot, ya_desplegado, GEEKOM)
- (malware, analiza, ghidra) ← (remnux, distro, analysis_vm)
- (social_eng, usa, set) ← (defensa, awareness_training)
