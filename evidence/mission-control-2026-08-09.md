# Mission Control — TARS Lab (2026-08-09)

> "Quiero ver los flujos, quiero ver que todo trabaje" — el lab visual.

## Stack visual (4 capas)

### 1. Netdata — "ver que todo trabaje" (INSTALADO)
- **URL:** http://100.123.17.12:19999 (GEEKOM)
- **Estado:** v2.10.0, monitoreando 24 contenedores + host en tiempo real
- **Qué ver:** CPU/RAM/disco/red de GEEKOM, contenedores docker, VMs
- **Siguiente:** conectar Mini + Air como hosts remotos (streaming)

### 2. MITRE ATT&CK Navigator — "ver la cobertura" (LAYER LISTA)
- **URL:** https://mitre-attack.github.io/attack-navigator (instancia live, client-side)
- **Layer:** `evidence/attack-navigator-layer.json` en el repo (cargar via "Open Existing Layer")
- **Qué ver:** matriz ATT&CK con verde (detectado: T1057, T1558.003) / rojo (gap: T1003, T1110)
- **Siguiente:** automatizar la generación de la layer desde el purple loop

### 3. Attack Flow — "ver los flujos" (FLOW LISTO)
- **URL:** https://center-for-threat-informed-defense.github.io/attack-flow/ui/
- **Flow:** `evidence/attack-flow-purple-discovery.json` (operación Caldera real: sandcat → T1033 → T1057 → DETECTADO por Wazuh)
- **Qué ver:** el ataque como flujo visual de nodos y links, con assets y técnicas
- **Siguiente:** generar flows de cada operación Caldera automáticamente

### 4. Grafana purple dashboard (PENDIENTE — subagente en curso)
- Wazuh agents + alerts + reglas + Caldera agents + cobertura
- Data source: GEEKOM (Wazuh API) + scripts

## Cómo usar (hoy)
1. Abrir Netdata: http://100.123.17.12:19999 — ver el lab vivo
2. Abrir Navigator: https://mitre-attack.github.io/attack-navigator → Open Existing Layer → subir `attack-navigator-layer.json`
3. Abrir Attack Flow UI: https://center-for-threat-informed-defense.github.io/attack-flow/ui/ → cargar `attack-flow-purple-discovery.json`

## Roadmap visual
- [ ] Netdata multi-host (Mini + Air como remotes)
- [ ] Layer ATT&CK auto-generada desde purple-loop.sh
- [ ] Attack Flow auto-generado desde ops de Caldera
- [ ] Grafana purple (Wazuh + Caldera + cobertura)
- [ ] Dashboard único (Grafana como hub, Netdata como fuente)
