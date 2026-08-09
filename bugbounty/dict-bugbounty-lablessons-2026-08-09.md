# Bug Bounty — Lecciones de Lab (mrpuff0420) — Sesion 3

## Por que FALLA en lab (y que hacer en real)
- SQLi blind `SLEEP`: SQLite/Juice no lo ejecuta por ORM. En real: identificar DB engine (error message, banner) y usar `SLEEP`(MySQL)/`pg_sleep`(PG)/`WAITFOR DELAY`(MSSQL).
- XSS sanitizado: sanitize-html muta payloads anidados. En real: encontrar sink sin sanitizer (innerHTML/v-html/dangerouslySetInnerHTML), o usar mXSS que el sanitizer no detecta en su version especifica (CVE en DOMPurify<3.1.3).
- Race en feedback: endpoint no estado-mutable. En real: cupon/stock/saldo/role-upgrade con check-then-act.
- Web cache: header no reflejado en Juice. En real: usar Param Miner (Guess headers) + cache-buster + revisar Age.

## Checklist pre-real (DPG/Aikido)
1. Identificar DB engine (error verbose / banner) ANTES de SQLi blind.
2. Mapear sinks de render (buscar innerHTML/v-html en JS bundles) para XSS.
3. Identificar endpoints con estado mutable para race (checkout/coupon/stock).
4. Web cache: cache-buster obligatorio, revisar Age/reflejo.

## Compliance
- Header Intigriti REAL: DPG `X-Intigriti-Username: mrpuff0420`, Aikido `X-Intigriti: mrpuff0420`.
- Rate 5 req/seg (sleep 0.2-0.3s). DPG NO scanners.
- Sin PII.
