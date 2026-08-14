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

## Progreso 2026-08-13
- Repo restic GEEKOM→iMac INICIALIZADO (sftp:andreamora@100.70.240.126:restic/geekom)
- Script /root/restic-backup-imac.sh + cron 7am (espejo del de Mini, retención 7d/4w/6m)
- Primer snapshot VERIFICADO 2026-08-13 19:16 (EXIT=0)
- Check semanal /root/restic-check-weekly.sh (dom 8am, --read-data ambos repos)
- PENDIENTE: incluir /data + pentest-evidence en el backup; repo Mini→iMac
