# Practica Sesion 4 — Juice Shop (mrpuff0420)

LAB LOCAL. XSS en sink real (reflected) + DB engine fingerprint.

## Resultados (2026-08-09)
| Practica | Resultado | Aprendizaje |
|---|---|---|
| XSS reflected buscador | 200, payload NO en API JSON | SPA refleja en frontend (innerHTML), no en API. Confirmar XSS en browser, no en JSON. |
| DB fingerprint por error | 500 -> `SQLITE_ERROR` explicito | Engine=SQLite identificado. Tecnica: forzar error y leer banner. |
| SQLi UNION SQLite | 200 schema leak | Con engine identificado, UNION funciona. |

## Tecnica clave: DB engine fingerprint
- Forzar error: `x')) UNION SELECT '1'--` -> error revela engine.
- Juice: `SQLITE_ERROR` -> SQLite.
- En real: mismo approach. Luego ajustar payload:
  - MySQL: `SLEEP()`, `BENCHMARK()`, `extractvalue()` error-based
  - Postgres: `pg_sleep()`, `pg_read_file()`
  - MSSQL: `WAITFOR DELAY`, `xp_cmdshell`
  - SQLite: `sqlite_version()`, `randomblob()`, UNION sqlite_master

## XSS reflected en SPA
- El payload viaja en API pero el reflejo XSS ocurre en el render del componente (innerHTML).
- Confirmar con navegador real (Playwright) que el alert fire, no solo en API.
- En DPG/Aikido: buscar campos que hagan innerHTML/v-html/dangerouslySetInnerHTML en JS bundles.

## Scripts: /data/bugbounty/scripts/juice_s4.py
