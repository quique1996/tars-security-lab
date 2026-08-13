# PLAN iMac M3 — NODO VERIFICADOR + ARCHIVO (2026-08-12)

> Rol: dar trabajo real a la iMac M3 SIN LLM local (decisión de Quique).
> iMac = tercero de confianza: audita, archiva, respalda, sirve datasets.
> Verificado: andreamora@100.70.240.126, macOS 26.5.1, RESPALDO 931GB libres, SSH OK.

## Fases

### FASE 1 — Auditor independiente (30 min, mayor ROI)
**Qué**: script `imac-audit.sh` en la iMac que verifica desde FUERA que los nodos dicen la verdad.
**Checks**:
- GEEKOM: Wazuh UP (docker ps), CALDERA UP (curl 127.0.0.1:8888 vía SSH), /data montado, RAM disponible, puertos 7012/8888/8889 cerrados desde fuera
- Mini: Qdrant UP, ornith:9b responde, disco libre
- Air: gateway Hermes UP
**Flujo**: cron cada 15min → log local → alerta Telegram si discrepancia (nodo reporta OK pero check externo falla).
**Evidencia**: `/Volumes/RESPALDO/audit/audit.log` + alertas.

### FASE 2 — Backup central restic (30 min)
**Qué**: la iMac recibe restic remoto de GEEKOM y Mini.
**Flujo**:
- GEEKOM cron 2:00 → `restic -r sftp:andreamora@100.70.240.126:/Volumes/RESPALDO/restic-geekom backup /data /root/pentest-evidence`
- Mini cron 2:30 → `restic -r sftp:andreamora@100.70.240.126:/Volumes/RESPALDO/restic-mini backup /Volumes/Workspace`
**Evidencia**: snapshots listados + verificación semanal.

### FASE 3 — Data hoarder (1h + descarga background)
**Qué**: la iMac descarga UNA VEZ los datasets que el ecosistema necesita y los sirve vía HTTP Tailscale.
**Datasets**:
- SecLists (~1GB) → ffuf/gobuster/hydra
- rockyou + wordlists (~15GB) → hashcat/john
- CVE feeds NVD + cvelistV5 (~5GB) → CVE triage
- SigmaHQ rules (~500MB) → reglas Wazuh
- YARA rules (~200MB) → detección
- Papers/PDFs seguridad (~50GB) → investigación
**Flujo**: cron diario → descarga → sirve `http://100.70.240.126:8080/datasets/` (Tailscale) → GEEKOM/Kali curl.
**Evidencia**: `/Volumes/RESPALDO/datasets/` con checksums.

### FASE 4 — Mirror git + evidencia (15 min)
**Qué**: réplica del conocimiento.
- `git remote add backup` → bare repo en iMac → cada commit se replica
- rsync diario de `pentest-evidence/` + `writeups/` desde GEEKOM → iMac
**Evidencia**: `git log` iMac == `git log` Air.

### FASE 5 — Uptime externo (15 min)
**Qué**: monitoreo independiente.
- Script ligero (o Uptime Kuma 2ª instancia) → checks HTTP/SSH a los 3 nodos desde fuera
**Evidencia**: historial de uptime independiente.

## Orden de ejecución
1. Fase 1 (auditor) — valor inmediato
2. Fase 4 (mirror git) — rápido
3. Fase 2 (restic) — redundancia real
4. Fase 3 (datasets) — background
5. Fase 5 (uptime) — cierre

## Restricciones
- SIN LLM local en iMac (decisión Quique 2026-08-12)
- iMac de Andrea — no instalar nada invasivo, solo scripts + SSH
- Todo vía Tailscale (100.70.240.126)
