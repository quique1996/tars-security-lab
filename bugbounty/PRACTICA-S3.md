# Practica Sesion 3 — Juice Shop (mrpuff0420)

LAB LOCAL. Amplia vectores: SQLi blind, XSS mXSS, race condition, web cache.

## Resultados (2026-08-09)
| Vector | Payload | Resultado | Diagnostico |
|---|---|---|---|
| SQLi time-based blind | `x')) OR (SELECT SLEEP(2))--` | 500, no delay | ORM/param neutraliza SLEEP. Probar pg_sleep segun DB. |
| Stored XSS mXSS1 | `<svg><p><style><a id="</style><img src=x onerror=alert(1)>` | 201 pero sanitizer muto a `<p>"></p>` | sanitize-html filtra. Buscar sink sin sanitizer en real. |
| Stored XSS mXSS2 | `<math><mtext><table><mglyph><style><!--</style><img...>` | 201 muto a `<table>--></table>` | igual, filtrado. |
| Race feedback | 10 POST /api/Feedbacks paralelas | todas 500 | endpoint no apto (rate/validacion). Necesita estado mutable (cupon/saldo). |
| Web cache | X-Forwarded-Host/X-Original-URL/X-Rewrite-URL | 200 no reflejado | Juice no refleja. Usar Param Miner + cache-buster en reales. |

## Lecciones para reales
1. Blind SQLi: el payload depende del DB engine (SLEEP=MySQL/SQLite, pg_sleep=Postgres).
   - Juice=SQLite; su UNION funciona, blind no. En DPG (posiblemente PG/MySQL) probar ambos.
2. XSS: sanitizer puede mutar/matar payload. En real buscar campo que haga innerHTML directo
   sin pasar por sanitizer (ej. bio, comentario renderizado via v-html / dangerouslySetInnerHTML).
3. Race: requiere endpoint con estado mutable y check-then-act. Feedback no sirve; probar
   cupon/stock/saldo en apps reales o lab dedicado (PortSwigger race lab).
4. Web cache: requiere que el header sea UNKEYED y REFLEJADO en respuesta cacheable.
   Usar cache-buster (?cb=uniq) y revisar Age en 2da peticion.

## Practica previa (S1/S2)
- IDOR /api/Users/{id} customer->admin OK
- SQLi UNION schema leak OK
- Auth bypass remember-me concept

## Scripts: /data/bugbounty/scripts/juice_s3.py
