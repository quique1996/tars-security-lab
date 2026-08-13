# ECOSISTEMA DE CIBERSEGURIDAD TARS — ESTADO COMPLETO (2026-08-12)

> Documento definitivo de consolidación. Todo lo que existe, qué hace cada cosa, en qué nodo vive, y su estado verificado.
> Repo: tars-security-lab · Commits de la sesión: c956fba, f4caceb, 03cbeea, 975c0cc, 77ba9c7

---

## 1. LOS NODOS (qué es cada uno)

| Nodo | Hardware | Rol | Qué corre |
|---|---|---|---|
| **Air M1** | Mac M1 8GB | CONTROL | Hermes Desktop (orquestador), túneles SSH (LaunchAgents), MCP host (HexStrike 150 tools), repos git, venv cyberagents (openosint, deadend) |
| **Mini M4** | Mac Mini M4 16GB | CEREBRO | Qdrant (RAG hermes_brain), KG canónico, ornith:9b (analizador local), 11 containers (twenty, jellyfin, vaultwarden, uptime-kuma, grafana...) |
| **GEEKOM** | Ryzen 7940HS, Fedora 44, 14GB RAM | OFFENSIVE LAB | 28 containers Docker + 3 VMs. Todo el stack de seguridad ofensivo/defensivo |
| **iMac M3** | iMac M3 16GB (de Andrea) | STORAGE | RESPALDO 932GB, sin modelos. SSH verificado (andreamora@100.70.240.126) |
| **Kali VM** | VM en GEEKOM (192.168.122.151) | OFFENSIVE BOX | Toolset completo (16+ tools), acceso `ssh kali-lab` desde Air vía ProxyJump |

## 2. SERVICIOS DE SEGURIDAD (qué hace cada uno)

### Defensa (Blue Team) — GEEKOM
| Servicio | Qué hace | Estado |
|---|---|---|
| **Wazuh SIEM** | Detección de intrusos: 3 agents (GEEKOM+Air+Mini), 50 reglas custom (SQLi, XSS, brute force SSH, Kerberoasting), mapeo MITRE ATT&CK | ✅ activo |
| **Atomic Red Team MCP** | Baterías de tests MITRE ATT&CK (T1053, T1110...) para validar que Wazuh detecta | ✅ activo |
| **Reglas Sigma→Wazuh** | T1110 (brute SSH — ampliada para Fedora 44), T1558 (Kerberoasting), T1098 | ✅ 4 alertas validadas |

### Ofensivo (Red Team) — GEEKOM
| Servicio | Qué hace | Estado |
|---|---|---|
| **CALDERA (MITRE)** | Adversary emulation: simula campañas completas de atacantes. Proceso nativo, 127.0.0.1:8888, sandcat activo | ✅ puertos cerrados a red |
| **PentAGI** | Pentesting autónomo multi-agente (Searcher/Coder/Installer/Pentester) | ✅ Docker Up |
| **HexStrike v6.0** | MCP server con 124 tools de pentesting. Integrado a Hermes (150 tools registradas) | ✅ systemd 127.0.0.1:8889 |
| **Solver JuiceShop v3** | Resuelve challenges de OWASP Juice Shop automáticamente | ✅ 46/109, 45 writeups |
| **garak v0.16.0** | "Nmap para LLMs" (NVIDIA): 100+ probes de jailbreak/injection | ✅ |
| **PyRIT (Microsoft)** | Framework AI red teaming: backend uvicorn 127.0.0.1:8001, target Ollama | 🟡 falta inicializar técnicas |
| **DeepTeam** | 40+ tipos de vulnerabilidad LLM, mapeo OWASP Top 10 | ✅ 100% pass vs ASI 2026 |

### Labs — GEEKOM
| Lab | Qué es | Estado |
|---|---|---|
| **DVWA** | Web vulnerable (SQLi, XSS, command injection) | ✅ 127.0.0.1 |
| **Juice Shop** | OWASP flagship: 109 challenges | ✅ 46 resueltos |
| **WebGoat** | OWASP training | 🟡 404 pendiente |
| **metasploitable2** | VM vulnerable (Metasploit) | ✅ running |
| **dc1** | VM Active Directory (para AD attacks) | ⏸ apagada |

## 3. HERRAMIENTAS INSTALADAS (qué hace cada una)

### Reconocimiento
| Tool | Qué hace |
|---|---|
| **subfinder** | Enumeración pasiva de subdominios |
| **amass v4.2.0** | Enumeración masiva de subdominios |
| **httpx** | Prober HTTP: hosts vivos, tech-detect |
| **katana v4.2.0** | Crawler web (SPA, JS) |
| **naabu** | Port scan rápido |
| **nmap** | Escaneo de puertos/servicios (600+ scripts NSE) |
| **spiderfoot** | OSINT automation multi-fuente |

### Fuzzing / Escaneo
| Tool | Qué hace |
|---|---|
| **ffuf** | Fuzzing web dirigido (paths, params, vhosts) |
| **nuclei v3.5.0** | Escáner por templates (9k+ templates) |
| **gobuster** | Fuzzing dirs/DNS/vhosts |
| **nikto** | Escáner web legacy |
| **wafw00f** | Detección de WAF |
| **theharvester** | OSINT de emails/dominios |

### Explotación
| Tool | Qué hace |
|---|---|
| **sqlmap v1.10.8** | Automatización SQLi completa |
| **hydra** | Fuerza bruta de servicios (ssh, ftp, http) |
| **jwt_tool 2.3.0** | Ataques JWT (alg:none, key confusion) |
| **responder** | LLMNR/NBT-NS poisoning |
| **evil-winrm** | WinRM shell para Windows |
| **metasploit** | Exploit framework (en Kali) |

### Password cracking
| Tool | Qué hace |
|---|---|
| **hashcat 7.1.2** | Cracking GPU/CPU (163 MH/s MD5 con PoCL) |
| **john** | Cracking CPU, 400+ formatos |

### AI Red Team
| Tool | Qué hace |
|---|---|
| **garak** | Probes de jailbreak/injection/encoding |
| **PyRIT** | Framework multi-turn agentic |
| **promptfoo** | Evaluación LLM + red team en CI |
| **DeepTeam** | 40+ vulnerabilidades LLM |

### Mobile / Forense
| Tool | Qué hace |
|---|---|
| **MobSF** | Análisis estático/dinámico de APK/IPA |
| **bloodhound-python** | AD attack paths (en Kali) |

## 4. INFRAESTRUCTURA DE SOPORTE

| Pieza | Qué hace | Estado |
|---|---|---|
| **Tunnel hexstrike-tunnel** | LaunchAgent: ssh -L 8889:127.0.0.1:8889 → GEEKOM | ✅ activo |
| **MCP hexstrike en Hermes** | 150 tools disponibles como mcp_hexstrike_* | ✅ registrado |
| **Cron juiceshop-solver-loop** | Diario 3:00: solver → sync writeups → commit | ✅ job 5b7cd04d17c2 |
| **Heartbeat GEEKOM** | Cada 15min: escribe a Mini + check disco (DID_NO_CONNECT) | ✅ |
| **Firewall GEEKOM** | Rich rules en trusted + FedoraWorkstation (7012, 8888, 8889, 31337, 80) | ✅ |
| **Disco TOSHIBA /data** | 1.8T, SMART enabled, 0 errores | ✅ montado sdd |

## 5. GAPS PENDIENTES (orden de prioridad)

1. **PyRIT**: inicializar AttackTechniqueRegistry (initializer techniques tags:all) + cambiar modelo a qwen3:8b
2. **Solver JuiceShop**: payloads frescos fallan por contrato API (captchaId, rutas import/avatar)
3. **ATT&CK v19**: actualizar reglas Wazuh (TA0112, T1685, T1687, T1684)
4. **AD lab**: encender dc1 + bloodhound/impacket (Kerberoasting, AS-REP)
5. **Puente HexStrike→Kali**: 124 tools con binarios de Kali
6. **USB WiFi passthrough** a Kali (monitor mode)
7. **gau**: dependencia rota
8. **WebGoat 404**
9. **iMac**: pubkey SSH + servicios storage
10. **DeepEval** (EVALS), certificaciones, monetización

## 6. ROADMAP

- **Fase A (1-2 días)**: fix PyRIT → primer scan AI red team; fix solver → 50+ resueltos; puente HexStrike→Kali
- **Fase B (semana)**: batería ART completa vs Wazuh, validar 50 reglas, reporte purple
- **Fase C (2-4 sem)**: portfolio lab, writeups HTB, CV con evidencia
- **Fase D**: DeepEval, guardrails runtime, monitoreo 24/7
