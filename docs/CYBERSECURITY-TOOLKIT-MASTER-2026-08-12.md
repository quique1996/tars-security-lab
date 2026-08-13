# CYBERSECURITY TOOLKIT MASTER — 2026-08-12

> Mapa maestro de herramientas de ciberseguridad del ecosistema TARS: inventario real verificado por nodo, usos, funciones, trucos, ataques y defensas.
> Fuentes: investigación web multi-fuente (hackerdna, appsecsanta, wazuh blog, medium, penligent, vectra, synack, github repos) + verificación en vivo de los 3 nodos.

---

## 1. Inventario REAL por nodo (verificado 2026-08-12 en vivo)

### GEEKOM (100.123.17.12 — Offensive Lab, 28 containers + 3 VMs)

| Herramienta | Tipo | Path | Estado |
|---|---|---|---|
| nuclei v3.5.0 | Escáner de vulnerabilidades por templates | `/opt/pentest/bin/nuclei` | ✅ |
| ffuf | Fuzzing web (directorios, parámetros) | `/opt/pentest/bin/ffuf` | ✅ |
| httpx | Prober HTTP (hosts vivos, tech-detect) | `/opt/pentest/bin/httpx` | ✅ |
| subfinder v2.11.0 | Subdomain enum pasiva | `/opt/pentest/bin/subfinder` | ✅ |
| sqlmap v1.10.8 | Automatización SQLi | `~/.local/bin/sqlmap` (pipx) | ✅ |
| john | Password cracking (400+ formatos) | `/usr/sbin/john` | ✅ |
| ncat | Netcat moderno (Nmap) | `/usr/sbin/ncat` | ✅ |
| dnsmasq | DNS local (lab) | `/usr/sbin/dnsmasq` | ✅ |
| garak v0.16.0 | LLM vulnerability scanner (NVIDIA) | `/usr/local/bin/garak` | ✅ |
| HexStrike v6.0 | MCP server 150+ tools pentesting | `/opt/hexstrike-ai` (venv py3.13, systemd, 127.0.0.1:8889) | ✅ |
| PentAGI | Multi-agente pentest autónomo (Go+React) | Docker `vxcontrol/pentagi:latest` | ✅ Up 2d |
| CALDERA | Adversary emulation (MITRE) | Proceso nativo python3, 127.0.0.1:8888 | ✅ sandcat activo |
| Wazuh SIEM | SIEM + 3 agents (fedora, Air, Mini) | Docker wazuh-* | ✅ |
| Atomic Red Team MCP | Baterías MITRE ATT&CK | Docker `atomic-red-team-mcp-server` | ✅ |
| spiderfoot | OSINT automation | Docker | ✅ |
| MobSF | Mobile app security (APK/IPA) | Docker `docker-mobsf-1` | ✅ |
| DVWA / Juice Shop / WebGoat | Labs vulnerables | Docker lab-* (127.0.0.1) | ✅ (WebGoat 404 pendiente) |
| metasploitable2 / kali-lab / dc1 | VMs ofensivas | libvirt | ✅/✅/off |

### Air M1 (Control — brew)

| Herramienta | Uso |
|---|---|
| nmap, nuclei, sqlmap, ffuf, httpx (brew) | Cockpit ofensivo |
| openosint CLI (venv cyberagents) | OSINT 19 tools |
| deadend_cli (venv cyberagents) | Pentest web auto-corrección |
| Hermes + HexStrike MCP (150 tools vía tunnel) | Orquestador |

### Mini M4 (Brain — brew)

| Herramienta | Uso |
|---|---|
| nmap, sqlmap, ffuf, gobuster, httpx, ncat | Engine de fuzzing pesado |
| ornith:9b (Ollama local) | Analizador / verificación |

---

## 2. HERRAMIENTAS POR CATEGORÍA — usos, trucos, comandos

### 2.1 Reconocimiento pasivo

| Tool | Función | Trucos |
|---|---|---|
| **subfinder** | Enumeración pasiva de subdominios (certificados, DNS, APIs) | `-all` usa todas las fuentes; `-silent` para pipelines; combinar con altdns para mutaciones |
| **amass** | Enum pasiva/activa masiva | `-passive` evita ruido; OWASP Amass v4 es la referencia |
| **gau** | URLs históricas de wayback/urlscan | `--threads 5`; alimenta `nuclei` con URLs reales |
| **katana** | Crawler (ProjectDiscovery) | `-headless -depth 3` para SPA; genera URLs de JS |
| **spiderfoot** | OSINT automation multi-fuente | Correlación cruzada de IOCs; módulos de email/dominio/IP |
| **sherlock/maigret/holehe** | Usernames en redes sociales / email | `holehe` detecta cuentas por email en 120+ servicios |

### 2.2 Enumeración activa

| Tool | Función | Trucos |
|---|---|---|
| **nmap** | Escaneo de puertos/servicios | `-sV -sC` (versión+scripts); `-p-` (todos los puertos); `--script vuln`; scripts NSE = 600+ |
| **naabu** | Port scan rápido (PD) | Para grandes rangos antes de nmap |
| **httpx** | Prober HTTP: hosts vivos, título, tech | `-title -tech-detect -status-code -follow-redirects`; **el paso que todos se saltan y todos lamentan** (filtrar vivos antes de nuclei) |
| **ffuf** | Fuzzing dirigido | Útil con hipótesis concreta, no brute ciego: mutar 1 variable (path, header, parámetro, auth); `-recursion`; wordlists SecLists |
| **gobuster** | Fuzzing dirs/DNS/vhosts | `dir`, `dns`, `vhost` modos |
| **dirsearch** | Fuzzing directorios | Alternativa a ffuf para wordlists grandes |

**Pipeline de recon 2026 (verificado como el que funciona):**
```bash
cat scope.txt | subfinder -silent | sort -u > subs.txt
cat subs.txt | httpx -silent -title -tech-detect -status-code -follow-redirects > live.txt
cat scope.txt | gau --threads 5 > gau_urls.txt
katana -list live.txt -silent -headless -depth 3 > katana_urls.txt
cat live.txt | nuclei -severity low,medium,high,critical -rate-limit 20 > nuclei_hits.txt
# validación manual en Burp — nunca confiar ciegamente en el scanner
```

### 2.3 Escaneo de vulnerabilidades

| Tool | Función | Trucos |
|---|---|---|
| **nuclei v3.5.0** | Escáner por templates (9k+ templates) | `-t cves/,exposures/` para scoping; `-rl 50` rate-limit (evitar bans); `-severity medium,high,critical`; templates custom YAML |
| **nikto** | Escáner web legacy | Complemento, no reemplazo de nuclei |
| **semgrep** | SAST multi-lenguaje | Reglas custom; integración CI |
| **trivy** | Container/filesystem vuln scan | SBOM, secretos, IaC |

### 2.4 Explotación web

| Tool | Función | Trucos |
|---|---|---|
| **sqlmap** | Automatización SQLi completa | `sqlmap -r request.txt --batch --level=3 --risk=2`; `--dbs --tables --dump`; `--os-shell` si hay xp_cmdshell/INTO OUTFILE; `--tamper` para WAF bypass |
| **Burp Suite** | Proxy + tools web | Repeater/Intruder; extensions (Autorize, Active Scan++); macros para tokens |
| **Metasploit** | Exploit framework | `msfconsole`; auxiliaries; post-exploitation; msfvenom payloads |
| **HexStrike 150 tools** | MCP: nmap, nuclei, sqlmap, ghidra, pwntools... | Orquestado por LLM vía MCP; ideal para automatizar cadena completa |

### 2.5 Password cracking

| Tool | Función | Trucos |
|---|---|---|
| **hashcat** | Cracking GPU (más rápido) | `-m 1000 -a 0 ntlm.txt rockyou.txt -r best64.rule` (NTLM+dict+reglas); `-m 0` MD5, `-m 1000` NTLM, `-m 3200` bcrypt, `-m 22000` WPA; mask attacks `-a 3 ?u?l?l?l?d?d?d`; sesiones `--session` |
| **john** | Cracking CPU, 400+ formatos | `john --wordlist=rockyou.txt --rules=KoreLogic shadow.txt`; **usar john cuando hashcat no soporta el formato** (keychains macOS, Lotus Notes, KeePass); `--show` para ver cracks |
| **hydra** | Fuerza bruta de servicios | `hydra -L users.txt -P passwords.txt ssh://target -t 4`; soporta ssh, ftp, http-post, smb, rdp |

**Regla práctica 2026**: hashcat gana en velocidad siempre que soporte el formato; john para formatos raros. KoreLogic y best64.rule son los sets de reglas estándar.

### 2.6 Privilege escalation

| Tool | Función | Trucos |
|---|---|---|
| **LinPEAS/WinPEAS** | Escaneo automático de privesc | Correr y grepear; SUID, capabilities, cron, sudo -l, servicios débiles |
| **GTFOBins** | Binarios abusables para escalada | Buscar binario → vector de escape |
| **bloodhound/neo4j** | AD attack paths | `bloodhound-python` + `cypher` queries; shortest path to DA |

### 2.7 Adversary emulation (RED)

| Tool | Función | Trucos |
|---|---|---|
| **CALDERA** | Breach-and-attack simulation autónoma (MITRE) | Agent sandcat en 127.0.0.1:8888; operations con adversary profiles; plugins atomic; API REST 8888/7010/7012/8022; **puertos 7012/8888 cerrados a red externa (firewalld trusted+FedoraWorkstation)** |
| **Atomic Red Team** | Tests MITRE ATT&CK individuales | `Invoke-AtomicTest T1053`; baterías TTP por técnica; MCP server para orquestar desde LLM |

**Flujo ART + Wazuh (verificado, fuente wazuh.com/blog):**
1. Ejecutar Atomic Test (ej. T1053 Scheduled Task)
2. Wazuh recibe el evento (Sysmon/auditd)
3. Regla custom por `win.eventdata.ruleName` con `technique_id=T1053` → alerta nivel 10 con mapping MITRE

### 2.8 Blue team / SIEM (DEFENSA)

| Tool | Función | Trucos |
|---|---|---|
| **Wazuh** | SIEM + XDR open-source | 3 agents (GEEKOM+Air+Mini); reglas custom con `<field name="win.eventdata.ruleName" type="pcre2">technique_id=T1053`; mapping `<mitre><id>`; niveles 0-15 |
| **Sigma** | Reglas de detección YAML portables | SigmaHQ 3000+ reglas; convertir a query de Wazuh/Elastic/Splunk; **validar con ART, no asumir** |
| **Velociraptor** | DFIR + hunting | Colección de artefactos; combinado con ART para validar detecciones |

**Detección por comportamiento > IOC** (2026): el false-positive tuning es 80% del trabajo; validar cada regla con emulación real (ART), no con teoría.

### 2.9 Mobile (DEFENSA/RED)

| Tool | Función | Trucos |
|---|---|---|
| **MobSF** | Static + dynamic analysis de APK/IPA/APPX | REST API para CI/CD; `api/v1/scan`; static (código, permisos, hardcoded secrets) + dynamic (runtime, tráfico); 20.8k★; integra MASVS/MASTG de OWASP |

### 2.10 AI Red Team (NICHO TARS)

| Tool | Función | Trucos | Licencia |
|---|---|---|---|
| **garak (NVIDIA)** | "Nmap para LLMs": 100+ probes | `garak --model_type openai --model_name X --probes dan,latentinjection`; probe library: jailbreaks, prompt injection, encoding evasion, data leakage; plugins custom; CI-friendly | Apache 2.0 |
| **PyRIT (Microsoft)** | Framework red team agentic | Targets+orchestrators+scorers+converters; multi-turn; Azure AI Foundry; **mejor para sistemas agénticos y chat** | MIT |
| **promptfoo** | Evaluación LLM + red team en CI | On-ramp rápido; EU AI Act compliance; adquirido por OpenAI (mar 2026) | MIT |
| **DeepTeam** | 40+ tipos de vulnerabilidad LLM mapeados OWASP Top 10 | **Ya instalado y verificado: 100% pass glm-5.2 vs batería ASI 2026** | OSS |
| **Giskard** | Testing LLM + RAG | Auto-genera test cases de RAG; 40+ probes | Freemium |
| **Augustus** | LLM vuln scanner con playbooks | Attack playbooks estructurados | OSS |
| **FuzzyAI (CyberArk)** | Fuzzer de jailbreaks bulk | Probes masivos cross-provider | OSS |
| **ART (IBM)** | Adversarial robustness ML clásico | Evasión, extracción, poisoning en modelos clásicos/deep | OSS |

**Stack 2026 (fuente appsecsanta)**: garak para breadth en CI → PyRIT para multi-turn agéntico → guardrails en runtime.

### 2.11 Agentes de pentesting autónomos

| Tool | Función | Estado en lab |
|---|---|---|
| **PentAGI** | 4 sub-agentes (Searcher/Coder/Installer/Pentester) orquestados; terminal+browser+editor | ✅ Docker Up 2d |
| **HexStrike AI** | 150+ tools vía MCP, 12+ agentes | ✅ MCP integrado a Hermes (150 tools) |
| **CAI** | 72+ tools en 9 categorías, 300+ backends | Pendiente |
| **Strix** | Multi-agente CI/CD, validación PoC | Pendiente |
| **Lyrie AI** | CLI 7 fases, output SARIF | Pendiente |
| **Deadend CLI** | Auto-corrección, WASM, bajo footprint | ✅ Air (venv cyberagents) |

### 2.12 Guardrails defensivos AI (DEFENSA)

| Tool | Función |
|---|---|
| **LLM Guard** | Runtime: PII anonymization, prompt injection detection, content moderation |
| **NeMo Guardrails (NVIDIA)** | Colang programmable rails (input/dialog/output) |
| **Prompt Inspector** | Librería de detección de prompt injection por scoring |
| **Guardrails AI** | Validadores reutilizables, structured output |
| **Cerbos** | Policy engine authz para AI agents/MCP |
| **Agentic Radar** | CLI scanner de agentic workflows |

---

## 3. ATAQUES MAPEADOS (ofensivo por dominio)

| Dominio | Ataques clave | Herramientas |
|---|---|---|
| **Recon** | Subdomain enum pasiva, crawling, URL harvesting, tech fingerprint | subfinder, amass, gau, katana, httpx |
| **Web** | SQLi (UNION, blind, time-based), XSS (reflejado, DOM, persistido), SSRF, XXE, SSTI, CSRF, NoSQLi, IDOR, path traversal, file upload | sqlmap, Burp, ffuf, nuclei, payloads |
| **Auth** | Brute force, password spraying, default creds, JWT attacks (alg:none, key confusion), OAuth misconfig | hydra, john, jwt_tool |
| **Cripto** | Hash cracking, downgrade, oracle padding | hashcat, john |
| **Red Team** | Adversary emulation TTPs MITRE ATT&CK, breach-and-attack | CALDERA, ART |
| **Mobile** | Static analysis, hardcoded secrets, insecure storage, traffic interception | MobSF |
| **AI/LLM** | Prompt injection, jailbreaks (DAN), data poisoning, model extraction, RAG poisoning, tool abuse, encoding evasion, indirect injection vía MCP | garak, PyRIT, promptfoo, DeepTeam, FuzzyAI |
| **OSINT** | Email lookup, username search, breach data, metadata geo | spiderfoot, sherlock, holehe, openosint |

## 4. DEFENSAS MAPEADAS (detección por ataque)

| Amenaza | Detección | Herramienta |
|---|---|---|
| Scheduled task abuso (T1053) | Sysmon ruleName + regla Wazuh | Wazuh + ART |
| DLL side-loading (T1574) | ruleName technique_id + mapping MITRE | Wazuh |
| UAC bypass (T1548.002) | ruleName + MITRE mapping | Wazuh |
| Defense evasion genérico | Reglas custom por technique_id | Wazuh + Sigma |
| Prompt injection en producción | Guardrails input/output | LLM Guard, NeMo, Prompt Inspector |
| Exfiltración LLM | DLP en tráfico de modelos | WitnessAI, Protecto (comercial) |
| Agentes maliciosos MCP | Policy authz por tool | Cerbos, Alter AI |
| Fuga de datos RAG | Grounding + detección de vectores | Vectara, Giskard tests |

## 5. FRAMEWORKS (taxonomías de referencia)

| Framework | Ámbito | Notas |
|---|---|---|
| **MITRE ATT&CK** | Ciber tradicional | 14 tactics; base de ART, CALDERA, Wazuh rules |
| **MITRE ATLAS** | AI adversarial | 15 tactics, 66 techniques, 46 sub-techniques, 26 mitigations, 33 case studies; update oct 2025: +14 técnicas para AI agents (con Zenity Labs); tactics AML.TA0004 (ML Model Access), AML.TA0012 (ML Attack Staging) |
| **OWASP LLM Top 10** | LLM apps | LLM01 Prompt Injection, LLM02 Sensitive Info Disclosure, LLM08 Vector/Embedding Weaknesses; base de DeepTeam |
| **NIST AI RMF** | Gobernanza AI | + Generative AI Profile; control mapping para compliance |
| **EU AI Act** | Compliance | Obligatorio ago 2026 para sistemas de riesgo alto |

## 6. FUENTES

- hackerdna.com/blog/penetration-testing-tools (12 essentials 2026 + hashcat/john/hydra/sqlmap)
- appsecsanta.com/ai-security-tools (41 AI security tools, 4 pilares: testing/runtime/agentic/governance)
- wazuh.com/blog/emulation-of-attck-techniques-and-detection-with-wazuh (ART + Wazuh rules)
- vectra.ai/topics/ai-red-teaming (PyRIT vs Garak, MITRE ATLAS oct 2025)
- synack.com/blog/best-ai-red-teaming-tools (comparativa 2026)
- penligent.ai/hackinglabs/bug-bounty-hunter-software-in-2026 (stack recon que funciona)
- medium.com/meetcyber (pipeline nmap+nuclei+ffuf)
- github.com/mobsf (MobSF 20.8k★, static+dynamic, MASVS)
- caldera.readthedocs.io + github.com/apache/caldera (adversary emulation)
- cloudsecurityguy.substack.com (5 proyectos AI security que consiguen empleo 2026)
- Infra verificado en vivo: 3 nodos TARS 2026-08-12

## 7. PRÓXIMOS PASES (gaps del toolkit)

1. Instalar: hashcat (GPU en GEEKOM tiene iGPU — evaluar), bloodhound, jwt_tool, amass, gau, katana, naabu, nikto, Velociraptor
2. Integrar CAI + Strix + Lyrie (pendientes de la lista de agentes)
3. Validar detecciones Wazuh con ART (purple team real)
4. PyRIT + promptfoo en el pipeline AI red team (solo garak/DeepTeam hoy)
5. Guardrails runtime: LLM Guard o NeMo para el chatbot Bokken/GolfPremia
6. Documentar writeups de cada técnica en tars-security-lab
