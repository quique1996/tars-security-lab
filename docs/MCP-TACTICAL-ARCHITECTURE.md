# MCP TACTICAL SERVER — Mac mini M4 (Cognitive Core)

> Arquitectura: **Mini = servidor MCP (orquestación/juicio)** · **GEEKOM = ejecutor de tools (entorno de ataque)**.
> El Mini NUNCA ejecuta ataques; delega vía MCP al GEEKOM y juzga resultados con el KG.

## Principio (Single Responsibility)

```
Quique/Air (cliente MCP)
        │  MCP (JSON-RPC over stdio/HTTP)
        ▼
Mini M4 — mcp-server-tactical (Python, stdio)
   ├── tools/llm_judge.py        → juicio de resultados (ornith:9b, keep_alive=0)
   ├── tools/kg_ingest.py        → escribir hallazgos al KG (canonical, único writer)
   ├── tools/atlas_map.py        → mapeo a MITRE ATLAS (tácticas/técnicas)
   ├── tools/report_gen.py       → reporte Agentic AI Red Team en Markdown
   └── tools/geekom_proxy.py     → delega EJECUCIÓN al GEEKOM vía SSH (file-pipe)
```

## Contrato de delegación (Mini → GEEKOM)

```python
# tools/geekom_proxy.py (esqueleto)
import subprocess, json

GEEKOM = "root@100.123.17.12"

def run_on_geekom(script: str, timeout: int = 300) -> dict:
    """Ejecuta script en GEEKOM vía stdin (file-pipe pattern)."""
    proc = subprocess.run(
        ["ssh", "-o", "ConnectTimeout=8", GEEKOM, "bash -s"],
        input=script, capture_output=True, text=True, timeout=timeout,
    )
    return {"exit_code": proc.returncode, "stdout": proc.stdout[-8000:], "stderr": proc.stderr[-2000:]}
```

## Flujo Agentic AI Red Team → Reporte ATLAS

```
1. GEEKOM ejecuta batería (prompt injection, ASI, RAG poisoning) → stdout JSON
2. Mini recibe resultados vía MCP (geekom_proxy)
3. kg_ingest: escribe hallazgos al KG (con provenance: node, timestamp, battery)
4. atlas_map: técnicas detectadas → MITRE ATLAS (AML.T0058, T0061, T0062…)
5. llm_judge: ornith:9b evalúa severidad (keep_alive=0, Q4_K_M)
6. report_gen: genera docs/reports/<battery>-<date>.md (formato ya usado en tars-security-lab)
7. Air (cliente) revisa y publica al repo GitHub
```

## Filesystem layout (repo tars-security-lab)

```
mcp-server/
├── pyproject.toml
├── mcp_server_tactical/
│   ├── __init__.py
│   ├── server.py            # FastMCP/stdio entrypoint
│   ├── tools/
│   │   ├── llm_judge.py
│   │   ├── kg_ingest.py
│   │   ├── atlas_map.py
│   │   ├── report_gen.py
│   │   └── geekom_proxy.py
│   └── kg.py                # helper: read/write KG con backup+provenance
├── config.yaml              # hosts, modelos, budgets
└── README.md
```

## Reglas de oro

- **Un solo writer del KG**: Mini. El MCP server es la ÚNICA puerta de escritura.
- **keep_alive=0** en ornith:9b → descarga de RAM al terminar (presupuesto 10GB).
- **Nunca** exponer Qdrant fuera de loopback (compose: 127.0.0.1).
- **Evidencia primero**: todo reporte referencia stdout/archivo del GEEKOM, no narración.
