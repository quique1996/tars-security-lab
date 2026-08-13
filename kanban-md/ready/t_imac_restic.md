---
id: t_imac_restic
status: ready
priority: high
assignee: tars
created: 2026-08-12
project: imac-verificador
---

# IMAC: Fase 2 — Backup central restic remoto

GEEKOM cron 2:00 → restic sftp a iMac:/Volumes/RESPALDO/restic-geekom (backup /data + pentest-evidence)
Mini cron 2:30 → restic sftp a iMac:/Volumes/RESPALDO/restic-mini (backup /Volumes/Workspace)
Verificación semanal de snapshots.
