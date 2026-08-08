# Diccionario Threats/Hardening/Compliance/Tooling — KG expansion (2026-08-08)

Corpus denso para ingestión en Qdrant kg_full.

## Ransomware LockBit
Affiliate model, double extortion. TTPs: AD enumeration, LOLBins, shadow copy delete.

## Ransomware BlackCat/ALPHV
Rust, cross-platform, triple extortion. Acceso vía credentials/exploits.

## Ransomware Clop
Mass data exfil vía zero-day en file-transfer (GoAnywhere, MOVEit). Extorsión basada en volumen.

## BEC 2025 stats
FBI IC3: 24,768 quejas, $3.05B pérdidas. 2% amenazas pero 21% outcomes (Microsoft).

## Deepfake CEO fraud
Voice/video clone para autorizar pagos. Control: out-of-band verification obligatoria.

## Supply chain TeamPCP
npm/PyPI @bitwarden/cli, @redhat-cloud-services (80k downloads). Typosquatting cross-ecosystem.

## Supply chain Colorama
Typo-squatting + name confusion (colorama/colorizr) Windows/Linux. Obfuscated payloads.

## AI agent threats
Prompt injection en agentes (CVE-2026-30623 LiteLLM RCE), tool abuse, MCP server hijack.

## MCP security
CVE-2026-33032 nginx-ui, CVE-2026-0755 gemini-mcp-tool, "Mother of All AI Supply Chains".

## LLM jailbreak
Roleplay, game mechanics, base64 obfuscation, char-splitting. Extrae system prompt.

## OT Purdue model
Levels 0-3 OT, 4-5 IT, DMZ 3.5. IT/OT convergence disolvió boundary. Zero trust dentro de zonas.

## OT threats
APT multi-level, ICS malware, ransomware. Segmentación + continuous monitoring.

## Zero Trust NIST 800-207
Never trust always verify. Microsegmentación, identidad como perímetro, PEP/PDP.

## Hardening CIS/STIG
Benchmarks y Security Technical Implementation Guides. Reduce superficie de ataque.

## Backup 3-2-1-1-0
3 copies, 2 media, 1 offsite, 1 immutable/air-gapped, 0 errors. Inmutabilidad WORM.

## GRC NIST CSF 2.0
6 funciones: Govern, Identify, Protect, Detect, Respond, Recover. Risk-based.

## GRC ISO 27001
ISMS certifiable, Annex A controls. Global. Mapea a SOC2/HIPAA/NIS2.

## GRC DORA/NIS2
EU financial (DORA enero 2025), NIS2 (penalidades Q1 2026, €10M/2%). ICT risk reporting.

## CTI MITRE ATT&CK
Framework de TTPs. Mapea detecciones, threat hunts, adversary emulation.

## CTI STIX/TAXII
Lenguaje y protocolo de intercambio de inteligencia. MISP/OpenCTI agregan feeds.

## Kali Linux tools
Frida, Objection, MobSF, Burp, NetExec, Evilginx3, BloodHound, Impacket. Lab ofensivo.

## REMnux/Ghidra
RE malware (REMnux), disassembler (Ghidra), Volatility (memory). DFIR.

## SpiderFoot/Maltego
OSINT automation (SpiderFoot), link analysis (Maltego). Recon pasivo.

## Pacu/ScoutSuite
AWS exploitation (Pacu), multi-cloud audit (ScoutSuite). Cloud pentest.

## kube-hunter/Trivy
K8s pentest (kube-hunter), image/IaC scan (Trivy). Container security.
