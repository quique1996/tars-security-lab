# TARS Lab — Capacidades por Ámbito (2026-08-09)

> Documento maestro: qué podemos lograr HOY con lo que tenemos, verificado en vivo.
> Hardware: GEEKOM (Ryzen 9, 16GB, 850G+1.7T libres) · Mini (M4 16GB Metal, 100G+1.6Ti libres) · Air (M1 8GB).
> Nodos 24/7. Todo autónomo vía Hermes.

---

## 1. Redes / Active Directory

**Tenemos:** dc1 (Samba AD DC, TARS.LOCAL) · Kali full (nmap, msf, responder, impacket) · Metasploitable 2 · 5 VMs vulnerables más sin importar · krb5 native · nxc/impacket venv · kerberoast chain COMPLETA probada.

**Podemos lograr:**
- **Dominar la cadena AD completa**: kerberoast → crack → DA (probado: svc_sql=Summer2026 → Domain Admins)
- **Delegación**: S4U2Self (probado), S4U2Proxy (probado que Samba lo impone), coerción printerbug/petitpotam (siguiente)
- **Ataques de identidad**: AS-REP roast, password spray, LLMNR/NBT-NS poisoning con responder
- **Lateral movement**: psexec, wmiexec, SMB relay entre las 3 VMs
- **BloodHound alternativo**: sweep de ACLs con samba-tool (probado: 50 objetos)
- **Labs de redes**: FRR en Docker (3 routers, OSPF/BGP route injection) — pendiente de montar

**Límite real:** Samba no es Windows — secretsdump/NTDS no funciona, BloodHound CE no ingesta. Para eso: Windows 11 victim VM (requiere 6GB RAM — solo con VMs apagadas).

---

## 2. Web / Bug Bounty

**Tenemos:** DVWA + Juice Shop + WebGoat (running) · PortSwigger Academy (274 labs catalogados, runner script) · interactsh (OOB) · httpx/subfinder/naabu · Kali full (burpsuite, sqlmap, ffuf, gobuster, hydra) · pipeline DPG/Intigriti (JWT, RoE, alias) · MOBSF.

**Podemos lograr:**
- **Dominar web security**: 274 labs PortSwigger por categoría (SQLi, XSS, SSRF, deserialización, JWT, GraphQL...) → writeups automáticos → portfolio
- **Juice Shop completo**: 5/109 resueltos hoy via API — el resto con el runner
- **Bug bounty real**: DPG/Intigriti con recon automatizado (subfinder→httpx→naabu), OOB con interactsh, reporting con evidencia
- **Mobile**: MOBSF para estática (probado con Aegis), Frida para dinámica (pendiente)

**Límite real:** los hallazgos reales dependen de los programas activos (RoE de Intigriti respetado); Burp necesita GUI (o usar CLI tools).

---

## 3. AI Red Team (el diferenciador)

**Tenemos:** battery ASI01-10 completa (script + clasificador determinista, 24 ataques) · ornith:9b (Mini) + qwen3:8b (GEEKOM, con fix num_ctx) · garak (nightly) · promptfoo · fine-tuning mlx-lm (probado) · datasets del lab.

**Podemos lograr:**
- **Reportes ASI01-10 reproducibles** (ornith 24/24 hecho hoy — el artefacto que nadie más publica)
- **Fine-tuning de defensa**: entrenar un modelo que RECONOCE prompt injection (dataset = battery)
- **garak nightly** con verificación dual (exit + report lines)
- **Benchmark comparativo ornith vs qwen3** en las 10 categorías
- **MCP hijack** antes/después (el fix del bind da el before/after)

**Límite real:** qwen3 battery incompleta por OOM — se resuelve moviendo qwen3 a Mini (16GB Metal) o con VMs apagadas.

---

## 4. Purple / Blue (Wazuh + Caldera)

**Tenemos:** Wazuh 4/4 agents + 38 reglas custom (T1033/T1057 + supresión) · Caldera 5.3 con 2 agents · purple-loop script semanal · watchdogs (wazuh 5min, disk, nightly) · Netdata.

**Podemos lograr:**
- **Cobertura medible**: cada técnica de Caldera → ¿Wazuh la detecta? (probado: T1057 detectado)
- **Expandir reglas**: T1110 (spray), T1558 (kerberoast), T1098 (ACL) → subir cobertura >80%
- **Detection engineering**: escribir reglas TDD-style (inyector probado 6/6), sin tumbar el manager (lección aprendida)
- **SOC personal**: dashboards Grafana purple + Netdata + ATT&CK Navigator layer (todo listo)

**Límite real:** la cobertura mide el lab, no una red real — pero el método es idéntico al de producción.

---

## 5. Mission Control (lo visual)

**Tenemos:** Netdata (:19999, 24 contenedores, v2.10) · ATT&CK Navigator layer (12 técnicas) · Attack Flow (op Discovery) · repo con todo.

**Podemos lograr:**
- **"Ver que todo trabaje"**: Netdata en tiempo real (ya)
- **"Ver los flujos"**: Attack Flow de cada operación de Caldera (auto-generable)
- **"Ver la cobertura"**: layer del Navigator auto-actualizada desde purple-loop
- **Dashboard único**: Grafana como hub (pendiente, 3h)

---

## 6. Mobile / IoT / Hardware

**Tenemos:** MOBSF (estática, probada) · QEMU (ARM/MIPS para firmware) · 1.7T libres para corpus de firmwares · Kali full.

**Podemos lograr:**
- **Análisis estático de APKs** (probado con Aegis)
- **Firmware analysis**: binwalk + QEMU ARM/MIPS en GEEKOM (disco hay de sobra)
- **Frida dinámica** (pendiente de setup, 2h)
- **Emulación de routers IoT** con los 1.7T de /data

**Límite real:** sin hardware físico (Proxmark3, Flipper, HackRF) el lado RF/RFID queda teórico — el lab digital ya lo soporta todo.

---

## 7. Physical Red Team / GEOINT

**Tenemos:** skill `physical-recon-geoint` (workflow de 10 pasos) · SpiderFoot en GEEKOM · plan de 6 fases con presupuesto (~$900 total).

**Podemos lograr HOY ($0):**
- **Dossiers GEOINT** de cualquier edificio público (satélite, street-view, OSM, OSINT corporativo)
- **Writeup de metodología** — el artefacto de portfolio

**Con hardware (~$900):** clonación RFID (Proxmark3+Flipper), bypass físico (lockpicks, imán N52), dropboxes → Sliver (el C2 ya está), purple físico.

---

## 8. Robótica

**Tenemos:** GEEKOM con 16 cores · ROS2 + Gazebo corren de sobra (discos libres).

**Podemos lograr:** simulaciones de robots con ROS2/Gazebo, visión computacional, y en el futuro control real con hardware (~$200 para un rover básico). Es el ámbito más joven — el lab ya lo soporta.

---

## 9. Monetización (sin vender)

**Tenemos:** repo público · battery ASI completa · AD evidence · purple loop · pipeline bug bounty · CTFs.

**Podemos lograr (realista):**
| Vía | Potencial | Estado |
|---|---|---|
| Bug bounty DPG/Intigriti | $300-5K/hallazgo | pipeline listo, 1 hallazgo/mes = $300+ |
| CTFs (Hackerverse, Huntress) | $100-750/evento | mensual |
| GitHub OSS Fund | $10K one-shot | repo con 5 commits, necesita tracción |
| Synack SRT | $500-2K medios | requiere hallazgos publicados |
| Puestos AI Red Team | $40-90/hr remoto | reporte ASI = portafolio |

**Meta $100/mes alcanzable** con 1 hallazgo de DPG o 1 CTF. Todo canaliza evidencia → dinero, cero ventas.

---

## 10. Aprendizaje (PhD track)

**Tenemos:** 5 VMs vulnerables + 274 labs + battery ASI + fine-tuning + AD lab + mission control + KG (6045 puntos).

**Podemos lograr:**
- **Redes profundas**: GNS3/FRR (Nivel 1) — el lab ya lo corre
- **AD avanzado**: la cadena completa practicada hasta el dominio
- **AI security doctoral**: battery reproducible + fine-tuning + papers — el nivel que nadie más tiene
- **Cada hallazgo → skill** (regla): 4 skills patched esta noche
- **KG como segundo cerebro**: 6045 puntos y creciendo

---

## Resumen ejecutivo

| Ámbito | Madurez hoy | Siguiente jugada (1-3h) |
|---|---|---|
| AD/Redes | 🔥 alto (chain completa) | coerción delegación + spray |
| Web/Bounty | 🔥 alto (274 labs + pipeline) | runner PortSwigger semanal |
| AI Red Team | 🔥 EL diferenciador | qwen3 battery (fix num_ctx) |
| Purple | 🔥 medio-alto (loop cerrado) | 3 reglas más + Grafana |
| Mission Control | ✅ base puesta | auto-generar layers/flows |
| Mobile | 🟡 medio (estática OK) | Frida dinámica |
| IoT/HW | 🟡 base (QEMU+corpus) | binwalk + emulación |
| Physical | 🟡 método listo ($0) | dossier GEOINT demo |
| Robótica | 🟢 arrancando | ROS2/Gazebo |
| Monetización | 🟡 pipeline listo | 1 hallazgo + 1 CTF |
