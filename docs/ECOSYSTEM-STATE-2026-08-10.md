# TARS Ecosystem — Estado y Arquitectura (2026-08-10)

> Verificado en vivo 2026-08-10 16:20 CST. Evidencia, no documentación.
> Repo: `tars-security-lab` (quique1996) — SSOT de kanban, docs y MCP server.

---

## 1. Topología (3 nodos, sin VPS)

```
                    INTERNET
                       │
        ┌──────────────┼──────────────┐
        │              │              │
   AIR M1          MINI M4        GEEKOM A7 MAX
   100.79.3.6      100.90.88.5     100.123.17.12
   Control         Cognitive Core  Offensive Compute
   8GB RAM         16GB RAM        14GB RAM / Radeon 780M
   Tailscale       Tailscale       Tailscale (root SSH)
```

**Regla de oro**: cada nodo UNA responsabilidad (SRP). Mini es el ÚNICO writer del KG. GEEKOM ejecuta ataques; Mini juzga; Air controla y publica.

---

## 2. Nodo por nodo

### Air M1 — Control & Gateway (8GB)
| Qué | Detalle |
|---|---|
| Rol | Interfaz humana, ruteo, verificación, publicación |
| Hermes | v0.20.0, gateway UP (PID 31066) |
| Ollama | loopback-only `127.0.0.1:11434` (fix 2026-08-10; NO reabrir Ollama.app) |
| Tooling ofensivo | nmap, nuclei, sqlmap, ffuf, httpx (brew) + openosint + deadend (venv cyberagents) |
| Skills | 470 SKILL.md |
| Disco | 29Gi free (228Gi) |
| Prohibido | inferencia pesada (8GB insuficiente) |

### Mini M4 — Cognitive Core (16GB)
| Qué | Detalle |
|---|---|
| Rol | Cerebro canónico: KG, Qdrant, embeddings, juicio LLM, gateway |
| Hermes | gateway UP (PID 1812) |
| Ollama | loopback-only (plist brew parcheado con OLLAMA_HOST) |
| Modelos | ornith:9b (local, MLX), nomic-embed-text, all-minilm + cloud (glm-5, minimax-m3...) |
| Qdrant | Docker, `mem_limit 2g`, loopback-only, `restart=unless-stopped`, 11 collections (hermes_brain 1,781 pts) |
| KG | 1,540 entidades / 4,015 relaciones (canónico) |
| Tooling ofensivo | nmap, sqlmap, ffuf, gobuster, httpx, ncat (brew) + uv/pipx |
| Disco | 97Gi free (228Gi) + externos (Workspace 466GB, Backups 1.8TB) |
| Presupuesto | 10GB inferencia, 2GB Qdrant, 4GB SO. Un LLM activo a la vez (keep_alive=0) |

### GEEKOM A7 MAX — Offensive Compute (14GB, x86)
| Qué | Detalle |
|---|---|
| Rol | Ejecutor de ataques, lab ofensivo, AI red team, hosting Docker |
| Load | 0.13 (sano; el scrub btrfs de 133GB terminó solo) |
| Target | `multi-user.target` (headless, aplica al reboot) |
| Containers | 28 running: wazuh (SIEM 3), pentagi (5), netlab (r1/r2/r3 = routers FRR), security-lab (dvwa/juice/webgoat), n8n, spiderfoot, mobsf, atomic-red-team-mcp, portainer, gotify, vaultwarden, netdata, beszel |
| VMs (QEMU) | 3: dc1 (AD, 2GB), kali-lab (4GB), metasploitable2 (1GB) — el lab AD que produce evidencia kerberoast |
| Ollama | Vulkan, llama3.1:8b + qwen3:8b (AI red team semanal) |
| Tooling | john, ncat, garak v0.16.0, nuclei v3.5.0, ffuf, httpx, subfinder, sqlmap v1.10.8 |
| Disco | 815Gi free (952Gi) |

---

## 3. Herramientas y qué hace cada una

### MCP Tactical Server (Mini, esqueleto — push 4f1486f)
| Tool | Qué hace | Boundary |
|---|---|---|
| `geekom_run(script)` | Ejecuta bash en GEEKOM vía SSH stdin | Ejecución delegada, jamás local |
| `kg_ingest(entity, rel, target, provenance)` | Escribe al KG con backup automático | Único writer = Mini |
| `judge(findings, rubric)` | ornith:9b evalúa severidad | keep_alive=0 |
| `map_atlas(findings)` | Mapea a MITRE ATLAS (AML.T0058/T0061/T0062...) | Heurística + extensión |
| `report(battery, findings, judge)` | Genera Markdown en docs/reports/ | Evidencia primero |

### Qdrant (Mini)
- 11 collections: `hermes_brain` (1,781 pts, vector fast-all-minilm-l6-v2), `kg_full`, `cyber_knowledge`, `rag_poison_test`, `ornith_lab_memory`, `agent_memory`, `hermes_memories`, `bgw_knowledge`, `mem0migrations`, `rag_demo`, `test_768`
- Compose: `/Users/quiquebs/qdrant-compose/docker-compose.yml` (bind `/Users/quiquebs/qdrant_data`, 2g, loopback)
- Healthcheck removido del compose (imagen no trae curl); verificar desde host: `curl 127.0.0.1:6333/healthz`

### Kanban (SSOT en git)
- 190 tasks en `kanban-md/`: done 98, ready 63, blocked 13, scheduled 3, archived 13
- Convención: una tarea = un archivo .md; mover = `git mv` + frontmatter
- INDEX.md con top 15 ready priorizados

### AI Red Team semanal (GEEKOM, cron)
- `ai-redteam-weekly` (dom 8:00): ai-redteam-eval.py (17 casos OWASP LLM Top10+agentic) vs llama3.1:8b + qwen3:8b → Telegram
- Primer run 2026-08-05: llama3.1 3/18 clean 2 LEAK; qwen3 16/18 clean 2 LEAK

---

## 4. Qué se arregló hoy (2026-08-10)

| Fix | Antes | Después |
|---|---|---|
| Ollama Air | IPv6 `*:11434` (app) | loopback-only (launchd) |
| Ollama Mini | IPv6 `*:11434` (plist brew) | loopback-only (plist parcheado) |
| Qdrant | 0.0.0.0, sin límites, restart=no | loopback, 2g, restart=unless-stopped |
| GEEKOM | target gráfico | multi-user.target (headless) |
| Kanban | SQLite (no versionado) | Markdown en git (RAG-indexable) |
| MCP | — | Esqueleto 5 tools + docs |

## 5. Pendientes (ordenados)

1. **P0**: Deploy MCP venv en Mini + primera batería end-to-end (geekom_run → judge → report → push)
2. **P1**: Headless en caliente GEEKOM (parar gdm/gnome-remote-desktop/accounts-daemon)
3. **P1**: Decidir VMs (dc1/kali/metasploitable2) — mantener si producen evidencia AD
4. **P2**: Documentar lab Wazuh + attack chains en repo (diferenciador portfolio)
5. **P2**: PortSwigger writeups (2/274) — pipeline curl → writeup → repo
6. **P2**: 2-3 blog posts AI red teaming
7. **P3**: Ejecutar 63 ready (KG expansion 13, ORNITH LAB AGENT, CVE triage LLM)
8. **P3**: Retención state.db (736MB datos reales, NO purgar — política)
