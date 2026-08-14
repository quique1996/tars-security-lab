# OWASP Juice Shop — Writeups

Resolución autónoma de challenges de Juice Shop vía solver automatizado en GEEKOM.

**Estado: 15/109 challenges resueltos** (14% — actualizado 2026-08-14, verificado via /api/challenges)

## Resumen

| Métrica | Valor |
|---------|-------|
| Challenges totales | 109 |
| Resueltos (verificados API) | 15 |
| Writeups (documentados) | 45 |
| Nodo | GEEKOM (100.123.17.12) |
| Método | Solver Python (`juiceshop-solver.py`) + Playwright |

## Categorías cubiertas

| Categoría | Resueltos |
|-----------|-----------|
| Sensitive Data Exposure | 10 |
| Injection | 7 |
| Improper Input Validation | 5 |
| Broken Authentication | 4 |
| Miscellaneous | 3 |
| Broken Access Control | 2 |
| Broken Anti Automation | 2 |
| Security Misconfiguration | 2 |
| Unvalidated Redirects | 2 |
| Vulnerable Components | 2 |
| Cryptographic Issues | 1 |
| Security through Obscurity | 1 |
| XXE | 1 |

## Técnicas utilizadas

- **SQL Injection**: login bypass (`'--`), UNION SELECT (extracción de credenciales, sqlite_master)
- **NoSQL injection**: PATCH con operadores `$ne`
- **XXE**: external entity → /etc/passwd
- **Upload**: tamaño/type bypass
- **Poison null byte**: backup files (`%2500.md`)
- **CAPTCHA bypass**: pinear captchaId
- **Credenciales por defecto**: logins conocidos (admin, Amy, Bender, Jim, MC SafeSearch)
- **Forgot-password**: responder preguntas de seguridad

## Writeups

Cada archivo `.md` en este directorio documenta un challenge resuelto: vulnerabilidad, técnica, payload, evidencia, remediación.

## Infraestructura

- Solver: `/root/juiceshop-solver.py` en GEEKOM (1750 líneas, ~70 técnicas)
- Cron: cada 30 min
- Verification loop: ornith:9b evalúa fallos
- Hill-climbing: detecta patrones, prioriza
