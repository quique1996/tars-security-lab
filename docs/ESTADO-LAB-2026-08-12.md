# ESTADO DEL LAB — 2026-08-12 (consolidación de sesión)

> Documento de referencia persistente para cualquier sesión futura.
> Repo: tars-security-lab · Commits de referencia: 7454d53, c956fba, f4caceb, 03cbeea

## 1. Arquitectura (3 nodos)

| Nodo | Rol | Carga |
|---|---|---|
| Air M1 | Control | Hermes Desktop, túneles, MCP host, repos |
| Mini M4 | Cerebro | Qdrant (RAG), KG canónico, ornith:9b, 11 containers |
| GEEKOM | Offensive Lab | Fedora 44, 28 containers, 3 VMs, Wazuh, CALDERA, labs |

## 2. Inventario ciberseguridad

### Blue team
- Wazuh SIEM: 3 agents activos (fedora, Air, Mini), 50 reglas custom, mapeo MITRE
- Atomic Red Team MCP: baterías ATT&CK (Docker)
- Reglas Sigma→Wazuh: T1110 (brute SSH), T1558 (Kerberoasting), T1098

### Red team
- CALDERA: proceso nativo 127.0.0.1:8888, sandcat activo, puertos 7012/8888 cerrados a red
- PentAGI: Docker vxcontrol/pentagi (Up)
- HexStrike v6.0: MCP server, 124 tools reales, 127.0.0.1:8889, systemd, MCP en Hermes (150 tools)
- Solver JuiceShop v3: 46/109 resueltos, 45 writeups, cron juiceshop-solver-loop diario 3:00
- garak v0.16.0: LLM vuln scanner (NVIDIA)
- PyRIT: backend uvicorn 127.0.0.1:8001, target openai_chat→Ollama

### AI Red Team
- DeepTeam: 100% pass vs OWASP ASI 2026 (glm-5.2)
- Kali VM: kali-lab (192.168.122.151, alias ssh via ProxyJump root@GEEKOM), toolset 16+ tools
- garak, PyRIT, promptfoo configs en repo

### Tooling nuevo (2026-08-12)
- hashcat 7.1.2 + PoCL (163 MH/s MD5 CPU), amass v4.2.0, katana v4.2.0, naabu, jwt_tool 2.3.0
- gau: NO instalado (dependencia rota)

## 3. Fixes aplicados hoy

| Fix | Evidencia |
|---|---|
| RAM GEEKOM 1.2→6.5Gi | garak zombie muerto, mem0 eliminado (backup), qwen3 descargado |
| CALDERA 7012 cerrado | firewalld trusted + FedoraWorkstation, verificado 000 desde Air |
| Disco TOSHIBA recuperado | DID_NO_CONNECT, sdd por UUID, SMART enabled, heartbeat con check |
| HexStrike asegurado | patch host bind, systemd, firewall doble, tunnel LaunchAgent |
| Purple team gap | Fedora 44 srclimit_penalise ≠ Failed password → regla 100700 ampliada, 4 alertas validadas |
| Kali box | PermitRootLogin, llave Air, alias ssh kali-lab, 7 tools nuevas |

## 4. Gaps pendientes

1. PyRIT: AttackTechniqueRegistry vacío + .env apunta a llama3.2:3b (no existe; Ollama: qwen3:8b, llama3.1:8b)
2. Solver JuiceShop: payloads frescos fallan por contrato API (captchaId, rutas import/avatar)
3. gau: dependencia rota
4. USB WiFi TP-Link passthrough a Kali (monitor mode)
5. Puente HexStrike→Kali (124 tools con binarios Kali)
6. Wazuh 9200 indexer expuesto (auditoría)
7. WebGoat 404
8. DeepEval (EVALS), certificaciones, monetización
9. BloodHound sin neo4j UI
10. CAI/Strix/Lyrie sin instalar

## 5. Roadmap

- Fase A (1-2 días): fix PyRIT → primer scan AI red team; fix solver → 50+ resueltos; puente HexStrike→Kali
- Fase B (semana): batería ART completa vs Wazuh, validar 50 reglas, reporte purple
- Fase C (2-4 sem): portfolio lab, writeups HTB, CV con evidencia
- Fase D: DeepEval, guardrails runtime, monitoreo 24/7
