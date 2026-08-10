"""MCP entrypoint — expone las tools tácticas como servidor MCP (stdio).

Uso: python -m mcp_server_tactical.server
Cliente MCP (Hermes/Air) conecta via stdio y llama a las 5 tools.
"""
from __future__ import annotations

import sys
from pathlib import Path

# Permitir import del paquete cuando se ejecuta como script
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from mcp_server_tactical.tools import (
    atlas_map,
    geekom_proxy,
    kg_ingest,
    llm_judge,
    report_gen,
)

# FastMCP opcional — si no está instalado, el módulo sigue importable
# para smoke tests y para uso como librería.
try:
    from mcp.server.fastmcp import FastMCP

    mcp = FastMCP("tars-tactical")

    @mcp.tool()
    def geekom_run(script: str, timeout: int = 300) -> dict:
        """Ejecuta un script bash en el GEEKOM (nodo de ataque). Mini nunca ataca localmente."""
        return geekom_proxy(script, timeout)

    @mcp.tool()
    def kg_ingest_tool(entity: str, relation: str, target: str, provenance: str) -> dict:
        """Escribe una relacion al Knowledge Graph (Mini = unico writer). Backup previo."""
        return kg_ingest(entity, relation, target, provenance)

    @mcp.tool()
    def judge(findings: str, rubric: str = "OWASP LLM Top10 + agentic") -> dict:
        """Juzga hallazgos con ornith:9b (keep_alive=0)."""
        return llm_judge(findings, rubric)

    @mcp.tool()
    def map_atlas(findings: list) -> dict:
        """Mapea hallazgos a técnicas MITRE ATLAS."""
        return atlas_map(findings)

    @mcp.tool()
    def report(battery: str, findings: list, judge_output: dict) -> dict:
        """Genera reporte Markdown en docs/reports/ del repo."""
        return report_gen(battery, findings, judge_output)

    def main() -> None:
        mcp.run()

except ImportError:
    # Sin mcp instalado: exponemos CLI de smoke test
    def main() -> None:
        print("FastMCP no instalado. Las tools funcionan como librería:", file=sys.stderr)
        print("  from mcp_server_tactical.tools import geekom_proxy, llm_judge", file=sys.stderr)
        print("Para servidor MCP: pip install \"mcp[cli]\"", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
