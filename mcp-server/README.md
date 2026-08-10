# TARS Tactical MCP Server (Mini M4)

Servidor MCP táctico del Cognitive Core. Mini juzga y escribe al KG; GEEKOM ejecuta ataques vía SSH (file-pipe). Mini nunca ataca localmente.

## Instalación (Mini M4)

```bash
cd ~/Projects/tars-security-lab/mcp-server   # o ruta local en Mini
python3 -m venv .venv && source .venv/bin/activate
pip install "mcp[cli]" pyyaml
```

## Smoke test (sin MCP client)

```bash
python -m mcp_server_tactical.tools
python -m mcp_server_tactical.server   # espera; valida que FastMCP carga
```

## Servidor MCP

```bash
python -m mcp_server_tactical.server    # stdio — conectar desde Hermes/Air
```

## Tools expuestas

| Tool | Qué hace | Boundary |
|------|----------|----------|
| `geekom_run(script)` | Ejecuta bash en GEEKOM | Ejecución delegada, jamás local |
| `kg_ingest(entity, relation, target, provenance)` | Escribe KG con backup | Unico writer = Mini |
| `judge(findings, rubric)` | ornith:9b evalúa severidad | keep_alive=0 |
| `map_atlas(findings)` | Mapea a MITRE ATLAS | Heurística + extensión |
| `report(battery, findings, judge)` | Reporte MD en docs/reports/ | Evidencia primero |

## Flujo Agentic Red Team

```
GEEKOM ejecuta batería → stdout JSON → geekom_run()
  → map_atlas() → judge() → kg_ingest() (provenance)
  → report() → docs/reports/<battery>-<date>.md
  → Air revisa, push a GitHub (portfolio)
```

## Presupuestos

- Qdrant: `mem_limit 2g`, loopback-only, payload on disk — compose en `/Users/quiquebs/qdrant-compose/docker-compose.yml`
- Ollama: `keep_alive=0`, 1 modelo activo (Q4_K_M)
- KG: backup automático previo a cada write (`.bak-<provenance>`)
