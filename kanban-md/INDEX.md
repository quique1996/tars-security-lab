# KANBAN — TARS Fleet (Markdown Edition)

> Migrado desde `~/.hermes/kanban.db` (SQLite) → Markdown sincronizado en Git, 2026-08-10.
> Single source of truth: **este directorio**, versionado en `tars-security-lab/kanban-md/`.
> Indexable por RAG (Obsidian/Qdrant) y legible por humanos.

## Estados

| Estado | Count | Directorio |
|--------|-------|------------|
| done | 116 | `done/` |
| ready | 45 | `ready/` |
| blocked | 15 | `blocked/` |
| scheduled | 3 | `scheduled/` |
| archived | 26 | `archived/` |
| **total** | **205** | — |

## Ready — prioridad (top 15 por priority desc)

| ID | Título |
|----|--------|
| t_107a8dc6 | KG: expansion masiva +1001 (math/stats/econ/prob/biohack/bio) |
| t_d213e9aa | KG: estado OPTIMO confirmado - 8386 entidades/10943 rel |
| t_c7f610b5 | KG: expansion ciencias exactas + artes + humanidades (265) |
| t_0d3629bb | KG: ingesta masiva 2025 sub-temas en 19 dominios |
| t_b8ce42c9 | KG: conexiones entre dominios (kg-connector.py) |
| t_7de8450f | KG: ingesta cvelistV5 (GitHub) |
| t_fda03ab0 | KG: ingesta 1253 Sigma rules |
| t_e2b9388e | KG: tipar 1540 entidades |
| t_f34b9050 | EXO: diagnosticar descarga Qwen3-14B estancada |
| t_51fed6f8 | APPLE CLUSTER: integrar iMac 24 M3 al cluster exo |
| t_542822a0 | APPLE CLUSTER: exo + llama.cpp RPC Mini M4 + Air M1 |
| t_fbf63ade | ORNITH LAB AGENT: agente IA que resuelve labs GEEKOM |
| t_00d4c594 | AMB: MISP + OpenCTI threat intel stack |
| t_d3866e7a | AMB: CVE triage LLM - cvelistV5 + NVD a Qdrant |
| t_78a9de0a | BLACK: Implementar reto DVWA/SQLi en ornith-lab-agent |

## Convención

- Una tarea = un archivo `.md` en su directorio de estado.
- Frontmatter: `id`, `status`, `priority`, `assignee`, `created`, `completed`, `project`.
- Mover tarea = `git mv ready/t_x.md done/t_x.md` + actualizar frontmatter.
- Regenerar desde SQLite (legacy): script en `scripts/kanban-export.py` (si existe) o re-export con el mismo formato.
