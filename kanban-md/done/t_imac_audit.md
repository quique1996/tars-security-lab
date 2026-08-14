---
id: t_imac_audit
status: done
priority: high
assignee: tars
created: 2026-08-12
project: imac-verificador
---

# IMAC: Fase 1 — Auditor independiente (script imac-audit.sh)

Script en iMac que verifica desde FUERA que los nodos dicen la verdad:
- GEEKOM: Wazuh UP, CALDERA UP, /data montado, RAM, puertos 7012/8888/8889 cerrados
- Mini: Qdrant UP, ornith:9b responde, disco
- Air: gateway UP
Cron 15min → log + alerta Telegram si discrepancia. Evidencia: /Volumes/RESPALDO/audit/
