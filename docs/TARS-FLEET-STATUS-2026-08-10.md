# TARS FLEET — Estado Completo y Plan Maestro (2026-08-10)

> Documento de referencia única. Verificado en vivo 2026-08-10 19:30 CST.
> Meta: trabajo remoto de ciberseguridad (AI Red Teamer / AI Security Engineer).

---

## 1. Arquitectura actual (4 nodos + iPhone + HDDs + cloud)

```
                    ☁️ 2× OLLAMA PRO ($40/mes) — espina dorsal inferencia
                     cloud1=enriquebs1996 · cloud2=quiquebedolla
                     glm-5.2 · qwen3-coder:480b (no tocan RAM de nadie)

  ┌─────────────┬─────────────┬─────────────┬─────────────┐
  │  AIR M1     │  MINI M4    │  GEEKOM     │  iMac M3    │
  │  8GB        │  16GB       │  14→32GB    │  16GB       │
  │  Control    │  Brain      │  Offensive  │  Storage    │
  │  tu mesa    │  KG+Qdrant  │  lab + 30B  │  vector +   │
  │  portfolio  │  14B judge  │  (sept)     │  services   │
  └─────────────┴─────────────┴─────────────┴─────────────┘
        │              │              │              │
        └──────────────┴──────┬───────┴──────────────┘
                         📱 iPhone 17 Pro Max
                          A19 Pro 12GB — Qwen3 8B local (13 tok/s)
                          nodo móvil + sensor de campo + control remoto
```

### HDDs (Mini M4, verificados 2026-08-10)
| Disco | Tamaño | Libre | Uso nuevo planificado |
|---|---|---|---|
| Workspace | 466GB | 225GB | Dataset store (corpus, CVEs, Sigma, writeups) |
| Backups | 1.8TB | 1.4TB | Checkpoints KG + Qdrant (restic), Time Machine |
| RESPALDO | 1.8TB | 1.6TB | Cold storage (datasets crudos, ISO, evidencias) |
| EXO | 1.2GB | 254MB | Cluster exo — limpiar (casi lleno) |

---

## 2. Qué se hizo (2026-08-10 — jornada completa)

### Rondas 1-2 — Auditoría + Fixes SRE (Uncle Bob)
- Ollama loopback Air (matar Ollama.app IPv6) + Mini (plist brew) — verificado solo 127.0.0.1
- Qdrant: 0.0.0.0→loopback, mem_limit 2g, restart=unless-stopped (11/11 collections preservadas)
- GEEKOM headless: multi-user.target + gdm/remote-desktop/accounts-daemon/bluetooth inactive
- Kanban SQLite → Markdown (190 tasks) en git
- state.db: 743MB datos reales, NO purgar (script retention)

### Ronda 3 — MCP + Batería end-to-end REAL
- MCP Tactical Server desplegado en Mini (venv, 5 tools: geekom_run, kg_ingest, llm_judge, atlas_map, report_gen)
- Batería 8 casos × 2 modelos: llama3.1 limpio (jailbreak BLOCKED), qwen3 LEAK T1 (system prompt) + T3 (canary) + PROBE T2
- Flujo: atlas_map (T3→AML.T0034) → kg_ingest (KG 4015→4018) → report_gen → push
- Blog draft: `blog/why-your-local-llm-agent-leaks.md`

### Ronda 4 — CVE Triage + VMs
- CVE triage pipeline (NVD+KEV+EPSS+ornith): 4,254 CVEs → top-10 → reporte → KG 4028
- Mejora: EPSS 0.0 de CVEs frescos no penaliza (fix verificado 6/6 tests)
- metasploitable2 APAGADA (dc1+kali quedan)
- Skill `tars-mcp-pipeline` creada

### Ronda 5 — PortSwigger + verificación
- sqli-01 SOLVED con evidencia real: payload `Accessories'--`, productos ocultos + banner
- solve-lab.py corre en Air local (NO GEEKOM — corrección de proceso)
- Playbook `migrate-qdrant-to-imac.sh` (commit f3b7c34)
- Fix kg_ingest backup: `knowledge-graph.json.bak-*` (6/6 tests PASS)

### Ronda 6 — Plan 4 nodos + ejecución
- **Twenty CRM APAGADO** (reversible docker start) — libera RAM Mini
- **qwen3:14b descargando en Mini** (~9.3GB, Q4)
- iMac M3 verificado: tailnet 100.70.240.126, SIEMPRE PRENDIDO, port 22 OPEN, latencia 12-20ms, pero **SSH BLOQUEADO** (andrea/quique/enrique/bedolla → permission denied)
- iPhone 17 Pro Max: A19 Pro 12GB, Qwen3 8B local viable (~13 tok/s, 6.5GB)
- Investigación Brave: Ollama Pro $20/mes con límites 5h/7d; MLX distributed para clusters

### Commits publicados (12)
```
41f729c kanban 190 tasks + docs MCP
4f1486f mcp server skeleton
c5bf9c7 ecosystem state
57fff85 docs lab + battery script
f96b25f battery report
d5f15b7 blog + retention policy
abd228f cve-triage + roadmap + kanban done
da7742f roadmap ronda 4 + EPSS fix
777e397 portswigger honesto
58e2946 sqli-01 SOLVED evidencia real
f3b7c34 migrate-qdrant-to-imac playbook
(2 pendientes: docs estado + roadmap v3)
```

---

## 3. Estado en vivo (2026-08-10 19:30)

| Nodo | Estado | Datos |
|---|---|---|
| Air M1 | ✅ | Hermes v0.20.0, gateway UP, Ollama loopback, 470 skills, 29Gi free |
| Mini M4 | ✅ | gateway UP, Qdrant UP (11 collections, healthz passed), KG 1552/4028, Twenty stopped, qwen3-14B descargado (verificando sha), 16GB |
| GEEKOM | ✅ | load 0.20, 28 containers, headless, 2 VMs (dc1+kali), metaspl off |
| iMac M3 | ⚠️ | Tailnet OK, port 22 OPEN, SSH bloqueado (necesita pubkey + username) |
| iPhone 17 PM | 📱 | No integrado aún (Fase 3 plan) |
| Cloud | ✅ | 2× Ollama Pro ($40/mes), límites 5h/7d |

---

## 3b. Modelos Ollama Cloud — ranking verificado (Brave, ago 2026)

| Modelo | Score | Mejor para | Uso |
|---|---|---|---|
| GLM-5.2 (Z.ai) | 87 | Agentic, long-horizon | CASE nocturno, orquestación |
| Kimi K2.7 Code | 86 | Coding, SWE-Bench | Subagentes payloads, writeups |
| MiniMax M3 | — | Creative, copy | Blog posts |
| qwen3-coder:30b | fuerte | Coding local | GEEKOM sept (32GB) |
| deepseek-v4-fl | cloud | General | Fallback |

Stack actual ya es top-3 2026. Patrón subagentes AWS 2026: RECON (glm-5.2) → EXPLOIT (kimi) → REPORT (glm-5.2), paralelo dominio fijo.

## 4. Plan Maestro v5 (aprobado en progreso)

### Fase 0 — Hoy (en curso)
- ✅ Twenty apagado, 14B descargado, playbook iMac listo
- ⏳ iMac: comando SSH (bloque dado) + username
- ⏳ iPhone: Tailscale + PocketPal AI (Qwen3 8B) + Telegram

### Fase 1 — Mini = AI Security Core (día 1-2)
1. Verificar qwen3-14B + benchmark vs ornith:9b
2. Colima 4GB→2GB (RAM para 14B)
3. Mover jellyfin/vaultwarden/grafana/uptime → iMac
4. Gate: judge 14B responde + críticos UP

### Fase 2 — CASE nocturno (día 3-4)
```
23:00 CVE triage → 00:00 batería GEEKOM + cloud paralelo → 01:00 judge 14B + KG
→ 02:00 kg-sync + restic backup → 03:00 blog draft → 07:00 resumen (+iPhone)
```

### Fase 3 — iPhone operativo (día 3-4)
Tailscale + Qwen3 8B local + Shortcuts (foto→nota→Mini) + Telegram alerts

### Fase 4 — Storage pipeline (semana 2)
Limpiar EXO · restic semanal (Qdrant+KG→Backups) · dataset store en Workspace

### Fase 5 — GEEKOM 32GB (septiembre)
30B Q4 local → judge 3 niveles: 8B iPhone + 14B Mini + 30B GEEKOM + 480B cloud

### Fase 6 — Portfolio Factory (semana 2-4)
PortSwigger batch · blog posts nocturnos · GitHub Actions CI

### Fase 7 — Purple team autónomo (mes 2)
Wazuh detecta → n8n alerta → CASE investiga → reporte ATLAS → KG → push iPhone

---

## 5. Qué terminamos teniendo

1. Ecosistema que produce solo (evidencia nueva cada mañana)
2. Portfolio AI Security Engineer con lab documentado (diferenciador #1)
3. 4 niveles de juicio: 8B móvil → 14B core → 30B GEEKOM → 480B cloud
4. Storage profesional 3-2-1 (restic + dataset store + cold storage)
5. Control desde cualquier lado (iPhone)
6. Pipeline completo: ataque (GEEKOM) → detección (Wazuh) → juicio (Mini/cloud) → memoria (KG/Qdrant) → publicación (Air/repo) → alerta (iPhone)

## 6. Pendientes (en orden)

1. Desbloquear iMac (pubkey + username)
2. Verificar 14B + benchmark judge
3. Colima 4GB→2GB
4. CASE nocturno (crons)
5. iPhone setup (Fase 3)
6. Storage pipeline (restic)
7. GEEKOM 32GB (sept)
8. Portfolio factory
9. Purple team autónomo

---

## 7. Benchmark Judge (verificado 2026-08-10, mismo prompt temp=0)

| Modelo | tok/s | total | Mapping | Veredicto |
|---|---|---|---|---|
| **ornith:9b** | **16.7** | 30.5s | T1506 Prompt Injection/Identity Hijacking (LLM-specific) ✅ | **GANA** |
| qwen3:14b | 11.1 | 518s (load lento) | T1078.001 Access Token Manipulation (clásico, menos preciso) | pierde |

**Decisión judge**: ornith:9b es el judge local PRIMARIO (rápido + mapping LLM-specific correcto). qwen3-14B opcional de noche. CASE usa cloud glm-5.2 primero, fallback local ornith.

## 8. Señales externas (X/Brave, 2026-08-10) — 3 fotos analizadas

### Xirp (Spotify) — validación de patrón
- Vendor-neutral agentic dev environment: maneja sesiones Claude/Gemini/Codex juntas, 1,300 ingenieros, "switch models mid-task, route every job to best price/performance"
- **Lección**: ya hacemos routing por precio/performance (2× Ollama Pro + fallbacks). Xirp NO aplica directo (usamos Hermes+Ollama, no Claude/Codex/Gemini). Validación del patrón, no herramienta nueva.

### Hermes Pixel Office (Teknium) — visualización de agentes
- Hermes corriendo con visualización pixel-art de agentes (3 agentes visibles, sesiones, progreso)
- **Oportunidad**: plugin Pixel para Hermes = demo visual para portfolio. Verificar en hermes-agent repo/plugins.

### Mac Studio remoto vía SSH (Iñaki) — validación de arquitectura
- "Infra para agents 24/7, single server accesible desde cualquier device incluso móvil, pseudo-sandboxed"
- **Lección**: EXACTAMENTE nuestro plan (TARS + SSH + Telegram). El iPhone vía Telegram ya cubre "acceso desde móvil". Validación, no cambio.

## 9. Qué agregar (decisiones)

1. **Judge**: ornith primario local (benchmark), glm-5.2 cloud primario global. 14B queda para fine-tuning futuro.
2. **Pixel plugin**: evaluar instalación (demo visual portfolio). PENDIENTE verificar disponibilidad.
3. **Xirp/MacStudio**: no son herramientas nuevas — validan nuestro diseño. Documentado para portfolio (referencias industria).

---

## 10. Investigación X/herramientas exponentes (2026-08-10, Brave)

### Qué QUITAMOS (no sirve / duplicado)
| Item | Razón |
|---|---|
| qwen3:14b como judge principal | Perdió benchmark (11.1 tok/s, T1078 clásico vs ornith T1506). **Queda solo para fine-tuning futuro** |
| Xirp (Spotify) | No aplica: usa Claude/Codex/Gemini, nosotros usamos Hermes+Ollama. Validación de patrón, no herramienta |
| MacStudio remoto (Iñaki) | Ya lo hacemos con TARS+SSH+Telegram. Validación, no cambio |
| LLM local en iPhone | Telegram a TARS lo resuelve mejor (glm-5.2 cloud). Solo PocketPal opcional offline |

### Qué AGREGAMOS (herramientas exponentes verificadas)
| Herramienta | Qué hace | Estado nuestro | Acción |
|---|---|---|---|
| **garak v0.16.0** (NVIDIA) | Scanner LLM, 120+ probes | ✅ Ya en GEEKOM | Usar en CASE (ya en ai-redteam semanal) |
| **PyRIT** (Microsoft) | Explotación multi-turno dinámica | ✅ Evidencia ya existe (2026-08-07) | Integrar a batería CASE |
| **promptfoo** | CI/CD red teaming, YAML configs | ✅ Configs en repo | Pipeline CI GitHub Actions |
| **DeepTeam** (Apache-2.0) | Red team LLM OWASP+NIST | ⏳ Kanban ready (t_0dc4cf4d, t_a045d828) | Implementar en GEEKOM |
| **Inspect** (Microsoft) | Framework evaluación seguridad | ❌ No | Evaluar |
| **Lakera/HiddenLayer/Mindgard** | Plataformas comerciales | ❌ No (costo) | Referencias portfolio/entrevistas |

### Lección clave (investigación)
El stack que YA tenemos (garak + PyRIT + promptfoo + DeepTeam en kanban) **es el top-3 open source de 2026**. No falta herramienta — falta **ejecutarlas en pipeline CI/CD** (promptfoo en GitHub Actions) y documentar. Las comerciales (Lakera/HiddenLayer) son para saberlas nombrar en entrevistas, no para comprar.

## 11. Plan actualizado (v7)

### Prioridades (cambiaron con la investigación)
1. **Pipeline CI/CD**: promptfoo + garak en GitHub Actions (portfolio profesional + automatiza evidencia)
2. **DeepTeam en GEEKOM** (kanban ready): red team LLM OWASP+NIST — más cobertura que garak solo
3. **CASE nocturno** (ya cronizado): sigue su curso, ahora con garak+PyRIT como baterías
4. **Fine-tuning 14B** (semana 2): ornith gana judge, 14B liberado para LoRA
5. **iMac** (cuando estés en casa): Fase 0 — migrar Qdrant/KG/selfhosted
6. **Pixel plugin Hermes**: evaluar demo visual portfolio

---

## 12. Las 5 fotos completas (2026-08-10) — análisis final

### Fotos 1-3 (ya documentadas): Xirp, Hermes Pixel, MacStudio — validan patrón
### Fotos 4-5 (NUEVAS): herdr (Ben Vinegar + Mr Panda)

**herdr** = "instant hacker terminal" (curl herdr.dev/install.sh | sh, panels CPU/MEM/NET/DISK/TACTICAL RADAR).
**Lección de Ben Vinegar**: "95% of what it offers was already out there" (tmux + opencode + themes).

| Decisión | Razón |
|---|---|
| NO instalar herdr como dependencia | Ya tenemos tmux + opencode (skill) + tui-widgets (skill). 95% es estética |
| Opcional: replicar look con tui-widgets | Demo visual de portfolio "hacker terminal" en Air |
| opencode ya cubierto | Skill `opencode` instalada (delegar coding a OpenCode CLI) |

### Lección transversal (las 5 fotos)
Todo lo que vimos (Xirp, herdr, MacStudio, Pixel) **ya lo hacemos o lo tenemos**:
routing multi-model (2×Ollama Pro), terminal remota (SSH+Telegram), dev 24/7 (CASE), agentes visuales (plugin Pixel opcional).
**La industria está construyendo lo que tú ya tienes** — eso es señal de que el diseño es correcto.

---

## 13. herdr — análisis PROFUNDO (corrige veredicto anterior)

**NO es solo "tmux con panels"** — es un multiplexor de agentes Rust:
- Background server persistente (~10MB binary, AGPL, local-first, code off-cloud)
- Detecta automáticamente 15+ coding agents (Claude, Codex, Devin, opencode...)
- Panes/tabs reales por agente + status 4 colores + mouse nativo
- **Sobrevive cierre de laptop/reinicio: "close the lid, drop the network, restart — agents keep working"**
- Zero-config, single-binary

| Decisión | Razón |
|---|---|
| **EVALUAR herdr en Air/GEEKOM** | La persistencia de sesiones es EXACTAMENTE lo que CASE necesita (agentes que sobreviven reinicio). No es estética: es runtime de agentes |
| Instalar SOLO si la persistencia justifica (benchmark vs tmux actual) | Ya tenemos tmux+opencode; herdr añade daemon persistente |

### Alternativas verificadas (si herdr no convence)
- **tmux-opencode** (plugin bash): browse/track/resume opencode sessions
- **Agent-Manager** (Tmux TUI para Claude/Codex/OpenCode)
- **RMUX** (Rust daemon SDK, Helvesec)
- **cmux** (terminal Ghostty nativo macOS para agentes paralelos — estado sobrevive restart)

## 14. Stack guardrails/seguridad de agentes (NUEVO — no lo teníamos)

| Herramienta | Qué hace | Open source | Acción |
|---|---|---|---|
| **LlamaFirewall** (Meta) | Guardrails: PromptGuard 2, inyección, misalignment, código inseguro | ✅ | **Evaluar en CASE** — capa de defensa del lado de Mini |
| **NeMo Guardrails** (NVIDIA) | Framework programable, DSL Colang, 6 tipos de guardrail | ✅ | Evaluar |
| **LLM Guard** (Protect AI) | Pipeline scanners input/output (inyección, PII) | ✅ | Evaluar |
| **Microsoft Agent Gov Toolkit** | Runtime-governance open source | ✅ | Evaluar |
| **RAMPART / Clarity** | CI safety testing | ✅ | CI/CD |
| **Trylon Gateway / RunLayer** | Firewall de red para agentes | ✅ | Avanzado |

**Impacto**: estas herramientas son **BLUE TEAM** para agentes — complementan nuestro RED TEAM (garak/PyRIT). Tener ambas = purple team completo = portfolio diferenciador.

## 15. PLAN v9 — prioridades actualizadas

1. **CASE nocturno** (ya cronizado, corre esta noche 23:00)
2. **CI/CD pipeline**: promptfoo+garak en GitHub Actions
3. **Evaluar herdr** (Air/GEEKOM): persistencia de agentes para CASE — benchmark vs tmux
4. **Evaluar LlamaFirewall o NeMo Guardrails** en Mini: blue team para agentes (defensa de nuestro propio CASE)
5. **DeepTeam en GEEKOM** (red team OWASP+NIST)
6. **iMac** (cuando estés en casa)
7. **Fine-tuning 14B**

---

## 16. Hermes subutilizado — auditoría de superficie (verificado)

| Superficie | Estado | Oportunidad |
|---|---|---|
| **Browser Use mode** | ✅ ACTIVADO (`browser/browser_use`) | **PortSwigger/bug bounty**: un script para todo el flujo, no tool call por click — resuelve labs sin sesión humana manual |
| **25 MCP servers** | ⚠️ Configurados | Auditar cuáles activos + conectar qdrant/tactical |
| **Plugins desktop** | ❌ 0 | UI plugins (pane de monitoreo nodos) |
| **Skins** | ❌ 0 (solo default) | Demo visual portfolio (tema dark-luxury/hacker) |
| **TUI widgets** | ❌ 0 | Widgets en vivo (load nodos, alertas Wazuh) |
| **Desktop plugins** | ❌ 0 | Cmd+K commands, panes |
| **Pets** | ✅ 4 | Estética — ok |

**Lección (fotos 6-8 + auditoría)**: Hermes ya trae lo que las fotos muestran como "nuevo" (Browser Use = foto 8, read tool = foto 7, agentes paralelos = foto 6). No usamos la superficie.

## 17. PLAN v10 — Hermes-centric

1. **Browser Use para PortSwigger**: resolver labs con 1 script (sin sesión humana por lab)
2. **Skins + TUI widgets**: demo visual portfolio (hacker terminal look sin herdr)
3. **Plugin desktop monitoreo**: pane de nodos en Hermes Desktop
4. **Auditar 25 MCP**: conectar tactical + qdrant de forma activa
5. **Jcode**: EVALUAR como harness alternativo (20x memory-efficient, Rust, swarms) — para Air 8GB
6. **CASE nocturno** (ya cronizado)
7. **CI/CD promptfoo+garak**
8. **Guardrails (LlamaFirewall/NeMo)** — blue team agentes

---

## 18. Hermes — INVENTARIO COMPLETO de lo que tenemos y NO usamos (verificado)

### Lo que YA usamos (activo en config)
- memory (holographic) + fact_store + session_search + skills (470)
- terminal, files, browser (incl. browser_use), mcp (25 servers)
- cron (case-nightly), kanban (190 tasks), delegation (subagentes)
- model_routing (kimi code, glm agentic)
- toolsets: hermes-cli, mcp, browser, files

### Lo que Hermes ofrece y NO estamos usando (inventario verificado)

| Feature | Qué da | Acción |
|---|---|---|
| **Browser Use mode** | 1 script por flujo web (browser_use CLI) — PortSwigger labs sin sesión humana | **#1 prioridad** |
| **computer_use** (cua-driver) | Control GUI de escritorio — ya lo tengo en tools pero no lo usamos para labs | Activar para labs con GUI |
| **code_execution** | Python sandboxed — execute_code ya disponible | Usar más (evita SSH para análisis) |
| **coding toolset** | LSP-backed edits | Activar para coding |
| **x_search** | X (Twitter) search via OAuth — **el MCP xapi dio 402** | Configurar OAuth de X para buscar sin créditos |
| **context_engine** | Pluggable context hooks | Evaluar |
| **curator** | Skill lifecycle automático | Activar consolidate |
| **checkpoints** | Max 50 snapshots | Activar para rollback |
| **stt/tts** | Voice input/output | Configurar TTS (edge gratis) para briefings de voz |
| **dashboard** (`hermes dashboard`) | Web admin panel + chat embedded | Abrir y monitorear nodos |
| **proxy** (`hermes proxy`) | OpenAI-compatible local proxy | Conectar jcode/opencode a Ollama cloud sin API key |
| **ACP server** | IDE integration (VS Code/Zed/JetBrains) | Activar si editas en IDE |
| **Skins/TUI widgets/Desktop plugins** | 0 instalados | Demo visual portfolio |
| **Event hooks** | Custom code en lifecycle (alerts, webhooks) | Alertas a Telegram en eventos |
| **kanban dispatcher** | Multi-profile workers automáticos | **Desbloquear**: asignar tareas ready a perfiles (Mini=researcher, GEEKOM=security) |

### Plan v11 — explotar la superficie

1. **Browser Use → PortSwigger labs** (1 script por lab, sin sesión humana)
2. **x_search con OAuth** — buscar X sin 402
3. **Kanban dispatcher**: 63 ready → perfiles automáticos (Mini researcher, GEEKOM security)
4. **Curator consolidate** — skills limpias automáticamente
5. **TTS para CASE**: resumen de voz en Telegram
6. **Dashboard** — panel de nodos
7. **Proxy Hermes** — jcode/opencode conectados a Ollama cloud
8. **Skins/TUI widgets** — demo visual portfolio
9. **Event hooks** — alertas en lifecycle
10. Todo lo anterior (CASE, CI/CD, guardrails, iMac)

### Teknium (lead engineer Hermes) — lección
Publica como "mejoras" lo que ya está en v0.20.0. **La fuente primaria es el repo + docs**, no X. Verificar features en skill hermes-agent antes de asumir que faltan.

---

## 19. Hermes v0.20.0 "Herald" — TODO lo que trae y NO usamos (verificado)

Ya corremos v0.20.0 en Air y Mini — pero NO usamos las features del release:

| Feature del release | Qué da | Estado |
|---|---|---|
| **Conversational Voice** | Streaming TTS, barge-in, wake words on-device, hands-free | NO usado — configurar TTS (edge gratis) para CASE/briefings |
| **A2A v1.0** (Agent2Agent) | Protocolo entre agentes — Mini ↔ GEEKOM ↔ Air como agentes que hablan | NO usado — es EXACTAMENTE nuestro multi-nodo |
| **Desktop Plugin SDK** | Plugin SDK + Kanban como plugin fundador + ctx.download + floating panes | 0 plugins instalados |
| **Kanban para Desktop GUI** | Tablero en la app | NO usado — kanban solo CLI/SQLite |
| **Outbound Webhooks** | Eventos → webhooks (alerts) | NO usado — conectar Wazuh → webhook → Telegram |
| **Artifacts** | Tarjetas versionadas con live preview (HTML/apps) en right-rail | NO usado — demos portfolio en el Desktop |
| **Grounded citations** | Citas verificables | NO usado — bueno para writeups |
| **Checkpoints v2** | Pruning real | NO usado |
| **iron-proxy firewall** | Proxy seguro | NO usado |
| **xurl skill** | X API CLI oficial (OAuth 2.0 PKCE auto-refresh) | ✅ Instalado — configurar para buscar X sin 402 |
| **Token efficiency** | Mejoras masivas (PRs read tool de Teknium) | Automático — ya en v0.20.0 |

### Teknium = lead engineer Hermes — lo que publica/repostea (verificado)
- **Herald Release** (v0.20.0): voice, A2A, plugins+kanban desktop, webhooks, perf tokens
- **Read tool PRs** (3): -79% tok FIFO guard, -48% unicode retry, -18% past-EOF
- **X API CLI skill** (`/xurl <prompt>`): búsqueda X sin 402
- **Voice chats más rápidos**: streaming TTS
- **Memory multi-level**: "remembers what it learns, persistent dedicated machine"

### PLAN v12 — explotar Herald (lo más grande hasta ahora)

1. **A2A v1.0**: conectar Mini ↔ GEEKOM ↔ Air como agentes A2A (en vez de SSH manual)
2. **Voice (TTS)**: CASE habla el resumen — "reemplaza google home" según Teknium
3. **Desktop plugins**: Kanban GUI + plugin monitoreo nodos
4. **xurl**: configurar OAuth → búsqueda X sin 402
5. **Webhooks outbound**: Wazuh → webhook → Telegram
6. **Artifacts**: demos portfolio en Desktop
7. **Grounded citations**: writeups con citas verificables
8. **iron-proxy**: usar como capa segura

+ CASE (hoy 23:00), CI/CD, guardrails, jcode, iMac, n8n (buzz de blocks — el AI Agent node es el bloque #1 en 2026)

---

## 20. DeepTeam — instalado y probado (2026-08-11)

### Instalación (Air, venv dedicado)
- `deepteam 1.0.7` en `.venv-deepteam` (Python 3.12 — GEEKOM/Mini tienen 3.14, incompatible)
- Deps completadas manualmente (el resolver de pip falla por conflicto de click): pydantic, pydantic_settings, rich, aiohttp, requests, nest_asyncio, jinja2, openai, sentry_sdk, ollama
- **Pitfall**: usar SIEMPRE `env -u PYTHONPATH -u VIRTUAL_ENV .venv-deepteam/bin/python` (PYTHONPATH quirk del venv Hermes)

### API (verificada)
- `RedTeamer(simulator_model, evaluation_model, target_purpose, async_mode, max_concurrent)`
- `rt.red_team(model_callback=..., framework=OWASP_ASI_2026(), attacks_per_vulnerability_type=1, ignore_errors=True, _upload_to_confident=False)`
- Frameworks: OWASP_ASI_2026, MITRE, NIST, Aegis, BeaverTails, EUAIAct
- **Pitfall**: `framework` es instancia (no clase); `red_team` no acepta `frameworks` (plural)

### Prueba real (llama3.1:8b vía tunnel Air→GEEKOM)
- Corrió 266s, 61 ataques intentados, **TODOS fallaron con ReadError**
- **Lección**: modelos locales vía tunnel NO sirven para red teaming automatizado (latencia alta). DeepTeam necesita modelo rápido (cloud) o local sin tunnel
- **Decisión**: usar glm-5.2:cloud para corridas reales de DeepTeam

### Kanban
- t_a045d828 → done (instalado; corrida real con cloud pendiente)

---

## 21. PentestGPT — instalado (2026-08-11)

- `pentestgpt 0.8.0` en `.venv-pentestgpt` (Air)
- **Pitfall**: greenlet falla en Python 3.12/3.14 — requiere Python 3.11 (usar `~/.hermes/hermes-agent/venv/bin/python3.11 -m venv`)
- Kanban t_d2b09827 → done (instalado; corrida real pendiente — requiere config API key)
