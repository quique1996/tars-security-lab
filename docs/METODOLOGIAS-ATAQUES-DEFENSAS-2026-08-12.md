# METODOLOGÍAS, ATAQUES Y DEFENSAS AVANZADAS (2026-08-12)

> Ampliación del CYBERSECURITY-TOOLKIT-MASTER: metodologías de engagement, ATT&CK v19,
> ataques avanzados (AD, cloud, containers, supply chain) y el 4º nodo (iMac M3).
> Fuentes: hard2bit, intersecinc, OWASP WSTG, novee.security, MITRE ATT&CK updates, d3security, cymulate, unit42.

---

## 1. METODOLOGÍAS DE PENTESTING (cómo estructurar un engagement)

| Metodología | Ámbito | Fases/Conceptos clave |
|---|---|---|
| **PTES** | Engagement completo | 7 fases: Pre-engagement (scope, ROE, legal), Intelligence Gathering (OSINT), Threat Modeling, Vulnerability Analysis, Exploitation, Post-Exploitation (privesc, lateral), Reporting. **No empieza con scanning — empieza con el contrato.** |
| **OWASP WSTG** | Web/API depth | WSTG-INPV (input validation), WSTG-ATHN, WSTG-SESS, WSTG-BUSL... "El Top 10 dice qué buscar; el WSTG dice cómo". |
| **NIST SP 800-115** | Planificación/aseguramiento | 4 fases: Planning, Discovery, Attack, Reporting. Estándar para gobiernos/regulados. |
| **OSSTMM (ISECOM)** | Seguridad operacional | **RAV (Risk Assessment Value)**: métrica que cuantifica exposición vs controles. Canales: human, physical, wireless, telecom, data networks. Fases: Induction, Interaction, Inquiry. |
| **MITRE ATT&CK** | Emular adversarios | NO es metodología de pentest — es knowledge base de TTPs. Se usa con ATT&CK Navigator para planear cobertura y mapear hallazgos. |
| **ISSAF** | Procedimientos custom | Detallado y customizable, alternativa a PTES. |

**Cómo los combinan los profesionales:** PTES para estructurar el engagement + WSTG para profundidad web/API + NIST para planificación/aseguramiento + OSSTMM para medición operacional + ATT&CK para emular adversarios y medir detección.

**Contexto 2026:** DORA (UE) exige TLPT cada 3 años siguiendo TIBER-EU; PCI DSS v4.0.1 req 11.4 (pentest anual); NIS2 art. 21 (medidas de gestión de riesgo). PTES identificó 63 vulns vs NIST 49 en benchmark controlado — profundidad vs escalabilidad.

## 2. MITRE ATT&CK v19 (abril 2026) — CAMBIOS CRÍTICOS

### El split de Defense Evasion
| Antes (v18) | Ahora (v19) | ID | Intención del adversario |
|---|---|---|---|
| Defense Evasion (TA0005) | **Stealth** | TA0005 (mantiene ID) | Ocultarse sin tocar defensas: masquerading, obfuscation, hide artifacts, process injection, indicator removal |
| | **Defense Impairment** | **TA0112** (nuevo) | Deshabilitar/degradar defensas: tampering, logging disruption, EDR interference |

### Técnicas nuevas v19
| Técnica | Descripción |
|---|---|
| **T1685: Disable or Modify Tools** | Fusión de T1562 + T1562.001 + T1562.006 |
| **T1687: Exploitation for Defense Impairment** | Explotar vuln para deshabilitar defensas |
| **T1684: Social Engineering** (con .001 Impersonation, .002 Email Spoofing) | Reorganización de T1656/T1672 |
| **T1682: Query Public AI Services** | Adversarios consultando servicios de IA públicos (nuevo, AI-enabled) |
| **T1683: Generate Content** | Adversarios generando contenido con IA (AI-enabled) |
| **T1694: Insecure Credentials** (.001 Default, .002 Hardcoded) | Credenciales inseguras |
| **T1686.003: Disable or Modify System Firewall: Windows Host Firewall** | Sub-técnica nueva |

**Impacto operativo para nuestro lab:**
- Wazuh necesita reglas nuevas para TA0112, T1685, T1687, T1686.003, T1684
- 37 nuevos software entries, 178 threat groups, 59 campaigns trackeados
- **AI-enabled techniques (T1682, T1683) conectan directamente con nuestro AI red team**

## 3. ATAQUES AVANZADOS POR DOMINIO (más allá del toolkit base)

### Active Directory (95%+ de Fortune 500 usa AD)
| Ataque | Técnica | Herramienta |
|---|---|---|
| Kerberoasting | T1558.003 | bloodhound-python, impacket |
| Pass-the-Hash / Pass-the-Ticket | T1550.002/.003 | impacket, mimikatz |
| DCSync | T1003.006 | mimikatz, secretsdump |
| AD CS attacks (ESC1-ESC8) | T1649 | certipy |
| Cross-forest trust abuse | T1482 | bloodhound |
| Credential replay | T1558 | responder, ntlmrelayx |
| AS-REP roasting | T1558.004 | impacket GetNPUsers |

### Cloud / Container / Supply Chain
| Ataque | Técnica | Nota |
|---|---|---|
| **Container escape (runC CVE-2019-5736)** | T1611 | Unit42 documentó la cadena completa |
| Azure IMDS / metadata SSRF | T1552.005 | Cloud attack path |
| Entra ID enumeration / Conditional Access bypass | T1087 | Black Hat 2026 trainings |
| **Supply chain (SolarWinds/ADFS pattern)** | T1195 | Cozy Bear comprometió 140 resellers vía ADFS débil — Zero Trust es la mitigación |
| K8s: kube-hunter, kube-bench | T1611 | Misconfig cluster |

### AI/LLM avanzado (Black Hat USA 2026 temas)
| Ataque | Descripción |
|---|---|
| **Prompt injection que manipula tool use** | Inyección que hace que el agente llame tools maliciosas |
| **Excessive agency** | LLM con demasiados permisos → acciones destructivas |
| **Insecure RAG pipelines** | Envenenamiento de contexto recuperado |
| **Memory poisoning** | Contaminar memoria persistente del agente |
| **MCP-specific supply-chain vulnerabilities** | Servidores MCP maliciosos en la cadena |

## 4. DEFENSAS AVANZADAS

| Defensa | Contra qué |
|---|---|
| **Zero Trust** | Supply chain, lateral movement, credential abuse (hubiera parado el compromiso de Cozy Bear) |
| **Detection Strategies (ATT&CK v19)** | Vendor-agnostic, dan log sources explícitos, parámetros tunables y visibilidad gaps — Mobile primero, enterprise siguiendo |
| **SBOM + SCA** | Supply chain: inventario de componentes, monitoring CI/CD |
| **Container security (trivy, falco, kube-bench)** | Container escapes, misconfig |
| **Stealth vs Defense Impairment validation** | Stealth → ¿puedes ver al atacante ocultándose? Defense Impairment → ¿pueden deshabilitar tus defensas y lo detectas? |
| **Guardrails AI (LLM Guard, NeMo)** | Prompt injection, PII, excessive agency |
| **Segmentation testing (PCI 11.4)** | Aislamiento real de redes |

## 5. 4º NODO: iMac M3 (VERIFICADO 2026-08-12)

| Dato | Valor |
|---|---|
| Host | iMac-de-Andrea.local |
| IP | 100.70.240.126 (Tailscale) |
| macOS | 26.5.1 |
| SSH | andreamora@100.70.240.126 — OK (latencia 13-89ms) |
| Disco | 228Gi (sistema), plan: RESPALDO 932GB storage |
| Rol (Plan Maestro) | Storage / Qdrant destino / selfhosted — SIEMPRE PRENDIDO |
| Pendiente | pubkey SSH, definir servicios selfhosted, mover respaldos |

## 6. ACCIONES PARA EL LAB (derivadas de esta investigación)

1. **ATT&CK v19**: actualizar reglas Wazuh — añadir TA0112, T1685, T1687, T1684 a las reglas Sigma→Wazuh existentes
2. **WSTG**: usar WSTG-INPV etc. como checklist para los writeups de JuiceShop (mapear cada challenge a WSTG)
3. **PTES**: estructurar los reportes del lab siguiendo las 7 fases (portfolio diferenciador)
4. **AD lab**: dc1 VM (apagada) → encender y montar bloodhound + impacket para Kerberoasting/AS-REP
5. **AI-enabled ATT&CK**: T1682/T1683 mapeados a nuestro AI red team (garak/PyRIT)
6. **iMac**: instalar pubkey SSH, definir rol storage (respaldos del lab)
