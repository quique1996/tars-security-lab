# Bug Bounty TTPs Sesion 4 (mrpuff0420) — 2026-08-09

## DB Engine Fingerprint (SQLi)
- Forzar error: `x')) UNION SELECT '1'--` -> el error revela engine.
- Indicadores: `SQLITE_ERROR`=SQLite, `You have an error in your SQL syntax`=MySQL, `ERROR: syntax error at or near`=Postgres, `Microsoft SQL Server`=MSSQL, `ORA-`=Oracle.
- Ajustar payload por engine:
  - MySQL: `SLEEP(5)`, `BENCHMARK(5000000,MD5(1))`, `extractvalue(1,concat(0x7e,version()))` error-based.
  - Postgres: `pg_sleep(5)`, `pg_read_file('/etc/passwd')`, `convert_from`.
  - MSSQL: `WAITFOR DELAY '0:0:5'`, `xp_cmdshell`.
  - SQLite: `sqlite_version()`, `randomblob()`, UNION sqlite_master.
- Ciego vs error-based vs union: union si columnas conocidas; error-based si verbose; blind si silencioso (time-based con throttle).

## XSS en sinks reales
- Identificar en JS bundles: `innerHTML`, `outerHTML`, `insertAdjacentHTML`, `document.write`, `srcdoc`, jQuery `.html()/.append()`, Vue `v-html`, React `dangerouslySetInnerHTML`, Angular `[innerHTML]`.
- Sanitizers: DOMPurify (CVE-2024-47875 mXSS <3.1.3), sanitize-html (no recursivo), Sanitizer API (setHTML Firefox 148).
- mXSS que sobrevive mutacion: `<noscript>`, `<template>`, namespace confusion (`<math><mtext><table>`).
- CSP strict bypass: Trusted Types, `navigate-to`, `require-trusted-types-for`.
- Reflected en SPA: payload viaja en API pero XSS fire en render del componente -> confirmar en browser.

## GraphQL (Aikido/DPG si aplica)
- Introspection: `query{__schema{queryType{name}}}` (si no deshabilitado).
- Batching bypass: array de mutations en 1 request -> evade rate limit. Aliases para brute force OTP/2FA.
- IDOR via GraphQL: query con ID de otro usuario.

## CSRF (si aplica)
- SameSite Lax: GET-based state change, newly-issued cookie grace window.
- Referer suppression: `<meta name=referrer content=never>`.
- Method override: POST->GET. Content-Type text/plain bypass.
- XSS anula CSRF (corre en contexto del sitio).

## Compliance
- Header Intigriti REAL: DPG `X-Intigriti-Username: mrpuff0420`, Aikido `X-Intigriti: mrpuff0420`.
- Rate 5 req/seg. DPG NO scanners.
- Sin PII. Out-of-scope: DPG XSS /abonnementen, UUID IDOR sin enumeracion.
