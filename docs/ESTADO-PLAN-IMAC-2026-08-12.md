# ESTADO PLAN iMac — CIERRE 2026-08-12

> Rol: iMac M3 = nodo verificador + archivo (SIN LLM local, decisión Quique).
> Verificado: andreamora@100.70.240.126, macOS 26.5.1, RESPALDO 931GB.

## Fases completadas

### Fase 1: Auditor independiente ✅
- Script: `~/audit/imac-audit.sh` (iMac)
- LaunchAgent: `~/Library/LaunchAgents/com.tars.imac-audit.plist` (StartInterval 900s, RunAtLoad) — PID 97456
- Logs: `~/audit/audit.log` + `~/audit/alerts.log`
- Checks: GEEKOM (wazuh/caldera/data/ram/puertos 7012/8888/8889), Mini (qdrant/ornith/disco), Air (gateway)
- Último resultado: OK (todos verdes)
- Llaves: iMac id_ed25519 → Air + Mini

### Fase 4: Mirror git ✅
- Bare repo: `~/git/tars-security-lab.git` (iMac)
- Remote `backup` en Air + push inicial OK (0555b89)
- Cron Air: `0 4 * * * git push backup main`

## Fases pendientes

### Fase 2: Backup restic 🟡
- GEEKOM tiene restic + cron 6:00 → Mini (existente)
- Llave GEEKOM → iMac agregada
- PENDIENTE: script `restic-backup-imac.sh` (repo sftp iMac) + cron 2:00

### Fase 3: Data hoarder ⏳
- PENDIENTE: SecLists, rockyou, CVE feeds, SigmaHQ, YARA, papers → servir HTTP Tailscale

### Fase 5: Uptime externo ⏳
- PENDIENTE: checks HTTP/SSH independientes

## Notas
- crontab en iMac BLOQUEADO por macOS (Operation not permitted) → usar launchd
- /Volumes/RESPALDO no escribible vía SSH → logs en ~/audit/
- Alertas Telegram del auditor: pendiente configurar
