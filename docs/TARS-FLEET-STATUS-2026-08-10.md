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
