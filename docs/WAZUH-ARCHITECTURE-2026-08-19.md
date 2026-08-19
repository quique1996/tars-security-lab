# Wazuh SIEM — Arquitectura del Lab TARS (2026-08-19)

> Documentación dedicada de la capa de detección (blue team) del lab.
> Todo lo descrito está verificado en `evidence/` y `ops/` de este repo.
> Nivel 1 del curso: arquitectura Wazuh + attack chains + findings prompt injection.

---

## 1. Rol en el lab

Wazuh es la capa de **detección** del purple loop: el lab no solo ataca
(red team), sino que **mide su propia detección** (blue team). La regla SRP
del ecosistema se mantiene: GEEKOM ataca y aloja; Mini juzga y memoriza;
Air controla y publica.

```
┌─────────────────────────────────────────────────────────────┐
│                     GEEKOM A7 MAX (Ryzen 9 7940HS)          │
│                                                             │
│   ┌──────────────┐   ┌──────────────┐   ┌───────────────┐  │
│   │  wazuh-manager│   │ wazuh-indexer│   │wazuh-dashboard│  │
│   │  (ossec)      │   │ (OpenSearch) │   │  (Kibana UI)  │  │
│   │  reglas+decoders│  │  almacén     │   │  visualización│  │
│   └──────┬───────┘   └──────┬───────┘   └───────────────┘  │
│          │  agent_control    │                               │
│   ┌──────┴───────────────────┴──────┐                       │
│   │  Wazuh agents (3 activos)        │                       │
│   │  fedora (GEEKOM) · Air · Mini    │                       │
│   └──────────────────────────────────┘                       │
└─────────────────────────────────────────────────────────────┘
```

**Componentes (3 contenedores Docker):**
- `wazuh-manager` — motor ossec: recibe eventos, aplica decoders + reglas, genera alertas.
- `wazuh-indexer` — OpenSearch: almacén de alertas/índices.
- `wazuh-dashboard` — UI (Kibana) para visualización y búsqueda.

**Agentes:** 3 activos (fedora en GEEKOM, Air, Mini). El watchdog
(`ops/wazuh-watchdog.sh`) verifica cada 5 min que el manager esté up y
responda (`agent_control -l`), fail-closed: si no puede verificar, alerta.

---

## 2. Reglas custom (50+)

Reglas inyectadas vía `ops/inject_rules.py` en `local_rules.xml`, con mapeo
MITRE ATT&CK. Las de mayor valor para el purple loop:

| Regla | Level | Match | MITRE | Descripción |
|-------|-------|-------|-------|-------------|
| 100600 | 8 | `whoami\|id -u\|lastlog\|logname` | T1033 | User discovery |
| 100601 | 8 | `ps aux\|ps -ef\|ps -ax` | T1057 | Process discovery |
| 100602 | 6 | `cat /etc/passwd\|getent passwd` | T1033 | Account enumeration |
| 100530 | — | (web shell) | T1059 | Suspicious process / web shell |
| 100531 | 0 | `tailscaled\|sshd\|be-child ssh` | — | Supresión de 100530 para SSH admin legítimo |
| 100501 | 12 | `mcp.tool.args` destino externo no permitido | T1071 | MCP tool-call tool-hijack |
| 100502 | 10 | `mcp-toolhijack-poc\|tool-call-hijack` | — | Actividad red-team MCP detectada |

**Nota de diseño:** la regla 100531 (supresión) es clave — evita falsos
positivos del tráfico SSH admin legítimo (tailscaled/sshd) que dispararía
100530. Sin ella, el purple loop no distinguiría ataque de administración.

---

## 3. Purple loop (Caldera → Wazuh)

`ops/purple-loop.sh` automatiza el ciclo semanal (domingo 04:00):

1. **Baseline** — cuenta líneas de `alerts.json` antes de la op.
2. **Launch op** — lanza operación Discovery de Caldera contra el agente
   sandcat (`ceewjl`) en el host fedora.
3. **Wait** — espera a que termine (máx 5 min), fuerza finish si loopea.
4. **Measure** — cuenta abilities ejecutadas y hits de reglas 100600-2.
5. **Evidence** — escribe `purple-weekly-<ts>.md` con cobertura.

**Resultado verificado (2026-08-09):** operación Discovery ejecutó 6 técnicas,
Wazuh detectó 1 (T1057 vía regla 100601). Cobertura medible 1/6.

### Attack Flow (visual)
`evidence/attack-flow-purple-discovery.json` — flujo de la operación real:
sandcat desplegado (T1105) → whoami (T1033) → cat /etc/passwd (T1033) →
ps aux (T1057) → **DETECTADO por Wazuh 100601**. Cargable en
https://center-for-threat-informed-defense.github.io/attack-flow/ui/

### ATT&CK Navigator (cobertura)
`evidence/attack-navigator-layer.json` — matriz con verde (detectado:
T1057, T1558.003) / rojo (gap: T1003, T1110). Cargable en
https://mitre-attack.github.io/attack-navigator → Open Existing Layer.

---

## 4. Cobertura de detección (estado 2026-08-09)

| Técnica | Táctica | Score | Estado |
|---------|---------|-------|--------|
| T1057 Process Discovery | discovery | 100 | **Detectado** (regla 100601) |
| T1558.003 Kerberoasting | credential-access | 100 | **Detectado** (chain AD completo) |
| T1558.004 AS-REP Roasting | credential-access | 100 | Documentado (imposible vs Samba Heimdal) |
| T1558.001 Golden Ticket | credential-access | 100 | Documentado |
| T1033 User Discovery | discovery | 50 | Parcial (regla 100600) |
| T1098 Account Manipulation | persistence | 50 | Pendiente de probar |
| T1078 Valid Accounts | defense-evasion | 50 | Parcial |
| T1059 Command Interpreter | execution | 50 | Parcial (100530+100531) |
| T1190 Exploit Public-Facing | initial-access | 50 | Labs web disponibles |
| T1003.001 LSASS Memory | credential-access | 0 | **Gap** (sin Windows victim) |
| T1003.003 NTDS | credential-access | 0 | **Gap** (secretsdump falla vs Samba) |
| T1110 Brute Force | credential-access | 0 | **Gap** (password spray pendiente) |

---

## 5. Operación y mantenimiento

- **Watchdog:** `ops/wazuh-watchdog.sh` (cron cada 5 min) — alerta si manager cae o no responde.
- **Inyección de reglas:** `ops/inject_rules.py <local_rules.xml>` — idempotente (SKIP si ya presentes).
- **Purple loop:** `ops/purple-loop.sh` (cron domingo 04:00) — genera evidencia semanal.
- **Logs de alertas:** `/var/ossec/logs/alerts/alerts.json` dentro del manager.

---

## 6. Roadmap de la capa de detección

- [ ] Batería Atomic Red Team completa vs Wazuh (validar las 50+ reglas)
- [ ] Layer ATT&CK auto-generada desde `purple-loop.sh`
- [ ] Attack Flow auto-generado desde cada op de Caldera
- [ ] Grafana purple dashboard (Wazuh + Caldera + cobertura)
- [ ] Agente Wazuh en Air/Mini (pendiente de sudo)
