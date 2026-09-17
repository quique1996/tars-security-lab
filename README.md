# TARS Security Lab

Laboratorio personal de red team / blue team / purple team corriendo sobre una flota real de 3 nodos, no una VM de curso. Cada hallazgo de ataque tiene su contraparte de detección verificada en el mismo SIEM, y cada pieza de infraestructura rota (incluyendo la propia automatización) queda documentada, no escondida.

Este README describe el estado real al 16-sep-2026. Donde una capa de detección está diseñada pero no desplegada, se dice explícitamente — no se cuenta como "hecho" lo que solo está propuesto.

## Flota (3 nodos, roles reales)

| Nodo | Hardware | Rol | Qué corre ahí |
|---|---|---|---|
| Ned | Mac mini M4 | Coordinador | Orquestación de agentes (Hermes), crons de la flota, gestión de secretos (Bitwarden), despacho de tareas a los nodos de labs |
| Geekom | Ryzen 9 7940HS, 16GB | Fábrica + labs | Wazuh SIEM (manager+indexer+dashboard, Docker), Suricata IDS, labs vulnerables (crAPI, VAmPI, DVWA, Juice Shop), honeypots (cowrie, OpenCanary), Ollama (modelos locales), VMs libvirt (metasploitable2, kali-lab, dc1) |
| iMac | — | Respaldo | Nodo verificador / segundo punto de vista para hallazgos, respaldo de datos |

Red: mesh Tailscale entre los 3 nodos. El tráfico de laboratorio (crAPI, VAmPI, DVWA, Juice Shop) vive en redes libvirt/docker aisladas del segmento de producción de la flota; solo crAPI expone puertos en `0.0.0.0` por diseño del lab (marcado como riesgo bajo intencional, no descuido).

## Labs activos con proof-of-detection

No se lista un lab como "activo" solo porque el contenedor esté corriendo. La tabla exige evidencia de al menos una cadena completa ataque→detección o ataque→writeup verificado en vivo.

| Lab | Estado | Ataque ejecutado | Detección | Evidencia |
|---|---|---|---|---|
| VAmPI (erev0s/vampi) | Docker up, Geekom | Werkzeug Debugger Console: PIN calculado externamente (username/MAC/boot_id) → RCE como root, GET-only | Capa Wazuh/Sigma del manager verificada contra el mismo host (ver abajo); la regla puntual para este patrón (`GET /console?...cmd=pinauth`) queda documentada como remediación propuesta, no desplegada aún — se marca así a propósito | `bb7-vampi-werkzeug-rce.md`, CVSS 9.8, output real `uid=0(root)` |
| VAmPI | Docker up, Geekom | `/users/v1/{username}` sin auth (PII) + `/_debug` con passwords en texto plano | — | `bb4-vampi-auth.md` |
| crAPI | Docker up (healthy), Geekom | BOLA + Missing Auth chain: acceso a 7 órdenes ajenas incl. admin, JWT con firma corrompida aceptada | — | `bb3-crapi-chain.md`, confirmado con PoC de 2 cuentas |
| Juice Shop | Docker up, Geekom | `/rest/admin/*` sin auth + `/ftp` con directory listing | — | `bb5-juiceshop-admin.md` |
| metasploitable2 | VM libvirt, Geekom | Backdoor vsftpd 2.3.4 (CVE-2011-2523) | — | `bb2-vdp-practica.md`, evidencia forense completa |
| cowrie (honeypot SSH) | Docker up, Geekom, `0.0.0.0:2222` | — (honeypot: la superficie es el sensor) | Captura de intentos de login/comandos vía Wazuh (localfile del honeypot) | Endurecimiento HL-2 de la flota; puerto expuesto pendiente de decisión humana sobre inventariado formal |
| Wazuh + Suricata (capa de detección) | Docker up, Geekom | — | Suricata 7.0.3, 52,689 reglas ET, ingesta `eve.json` al agente Wazuh 003, alerta de prueba end-to-end confirmada (id 86601) | — |

**Hallazgo estructural cross-app** (no es un bug individual, es un patrón): en VAmPI, Juice Shop y crAPI aparece el mismo defecto — control de acceso *declarado* (spec OpenAPI, convención de nombre, middleware) pero *no aplicado* de forma consistente en runtime. Se repite en tres stacks distintos (Flask, Node/Angular, Django multi-módulo); no es casualidad de una app, es un patrón de diseño de auth que falla igual.

## Capa de detección: qué está verificado y qué no

Reglas Sigma → Wazuh desplegadas y validadas con `wazuh-logtest` contra el manager real (no contra un log sintético desconectado):

| Regla | Técnica ATT&CK | Lógica | Verificación |
|---|---|---|---|
| 100400 | T1110.003 (password spraying) | Misma IP falla auth SSH contra 5+ cuentas distintas en 180s | `wazuh-logtest`: 5 líneas con usuarios distintos → dispara en la 5ª |
| 100401 | T1110.001 (brute force cuenta única) | 8+ fallos contra la MISMA cuenta en 120s, cualquier IP (cubre credential stuffing distribuido) | `wazuh-logtest`: 8 líneas con IP rotando → dispara en la 8ª. Nota honesta: la versión desplegada en el manager difiere de esta (sombreada por la regla builtin 5712); reemplazo pendiente de decisión |
| 100402 | T1059 (command and scripting interpreter) | Comando `sudo` con patrón de one-liner sospechoso (base64, pipe a shell, descarga+ejecución remota, reverse shell `/dev/tcp`) | `wazuh-logtest`: dispara con `curl \| bash` y con `python3 -c os.system(...)`; NO dispara con `ls -la` benigno (falso positivo descartado explícitamente) |

Cobertura ATT&CK del ruleset local: 8 → 10 técnicas tras esta ronda (antes/después documentado en `attack-layer-before/after.json`).

## Circuito ataque → detección → writeup

El patrón operativo del lab, con el caso VAmPI como ejemplo completo de punta a punta:

1. **Recon:** escaneo del lab marca `/console` respondiendo 200 → se abre tarjeta de trabajo con prioridad.
2. **Ataque:** cadena completa ejecutada y verificada con output real del sistema (no self-report) — PIN calculado, RCE confirmado con `id` devolviendo `uid=0(root)`.
3. **Detección (honesta):** se documenta qué capa de detección ya existe y cubre patrones relacionados (Wazuh/Sigma general, Suricata), y se deja explícito qué regla puntual falta desplegar para cerrar el vector exacto. No se afirma "detectado" donde solo hay "detectable en teoría".
4. **Writeup:** reproducción paso a paso, cálculo del CVSS, remediación en capas (inmediata / config / detectiva / arquitectura), referencias externas (CWE, PoC públicos equivalentes). Indexado en el portafolio de bug bounty con severidad y estado.

Este circuito se repitió, con distintos niveles de profundidad, en las 5 piezas listadas en la tabla de labs.

## Contribución OSS: issue reportado y confirmado por el maintainer

El sistema de automatización de la flota (`hermes-agent`) tiene un scheduler de crons que, en un incidente real (16-sep), se saltó silenciosamente la ejecución de un job diario sin dejar fila en la base de ejecuciones ni abrir un incidente — 36 horas de pipeline sin alerta y sin rastro, no detectado por monitoreo sino por auditoría manual.

- **Issue:** [hermes-agent#113603](https://github.com/NousResearch/hermes-agent/issues/113603) — reproducción con SQL contra `executions.db`, análisis de la causa (`last_status=error` no fuerza el siguiente disparo; `last_dispatch` queda obsoleto; hipótesis de que un ciclo disable→resume re-ancla `next_run_at` sin dejar ledger).
- El maintainer confirmó la lectura del bug y aportó el mecanismo interno exacto (comentario en el issue).
- El fix local mientras el upstream no cierra el issue: un chequeo de "missed silently" en el guardian de la flota, que compara la última ejecución conocida contra la cadencia esperada del job y alerta si no hay fila reciente — documentado como workaround, no como solución definitiva.

La lección de fondo, y el motivo de publicar esto: si un sistema de automatización no deja rastro cuando salta un paso, nadie puede auditarlo después. El mismo principio que rige el resto de este lab (self-report no es evidencia) aplica al propio orquestador.

## Qué no está cerrado (honesto, no vendido como terminado)

- Regla Sigma puntual para el patrón `/console?...cmd=pinauth` de Werkzeug: propuesta, no desplegada.
- 100401 en el manager real difiere de la versión candidata de este repo; reemplazo pendiente de decisión.
- Puerto de cowrie (`0.0.0.0:2222`) fuera del inventario formal de servicios expuestos; decisión de exposición pendiente.
- Caldera (MITRE) clonado, servicio aún no activo.

## Roadmap

- [x] Wazuh + Suricata desplegados y verificados con logtest / alerta E2E
- [x] Cadena de ataque VAmPI documentada de punta a punta (recon → RCE → writeup → remediación)
- [x] Issue upstream reportado con repro y confirmado por el maintainer
- [ ] Cerrar la regla Sigma puntual del vector VAmPI/Werkzeug
- [ ] Reconciliar la regla 100401 desplegada vs la candidata de este repo
- [ ] Caldera como servicio + ejercicio purple mensual
- [ ] Publicar 3-5 skills del lab como paquetes OSS independientes
