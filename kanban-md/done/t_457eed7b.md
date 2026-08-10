# Hardening MCP: desactivar 5 muertos + pinear versiones + scopes

- id: t_457eed7b
- status: done
- priority: 85
- assignee: unassigned
- created: 2026-08-05T23:10:10
- completed: 2026-08-05T23:25:21
- project: 

## Body

Ejecutar acciones de MCP-AUDITORIA-2026-08-05.md: 1) hermes config unset mcp_servers.{linear,unreal-engine,vercel,x-docs,xapi} 2) pinear context7/playwright/recraft a version exacta 3) docker-mcp: limitar tools o desactivar 4) tokens fine-grained. Criterio: hermes config check OK + MCPs restantes arrancan.
