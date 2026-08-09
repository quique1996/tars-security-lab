# Catalogo Attack Chains 2026 (mrpuff0420) — Sesion 5 (sub-agente)

Regla base: header Intigriti REAL (DPG X-Intigriti-Username, Aikido X-Intigriti), rate <=5 req/seg, SIN scanners. PoC manual.

## 1. XSS -> Account Takeover (DPG: High -> Critical)
- XSS reflejado/stored -> JS roba cookie (no HttpOnly) o CSRF token via fetch -> POST cambio email/password.
- Si HttpOnly: robar CSRF token via fetch y forjar request same-origin.
- Severity: High; Critical con ATO 0-click.
- 🚩 DPG XSS /abonnementen = dup; cualquier XSS DPG ya existente en otro dominio = dup.

## 2. IDOR -> Account Takeover (Aikido: High -> Critical)
- IDOR en /api/user/{id} + missing authz -> GET PII / PATCH reset email / disable 2FA.
- 2 cuentas: desde A cambia {id} a B.
- Severity: High/Critical.
- 🚩 UUID v4 no enumerable sin fuga previa = informativo/OOS. Necesita fuente del UUID.

## 3. SQLi -> RCE/File Read (DPG: Critical)
- UNION/error -> pg_read_file/LOAD_FILE -> RCE via INTO OUTFILE / xp_cmdshell.
- MySQL: `UNION SELECT LOAD_FILE('/etc/passwd')` / `INTO OUTFILE` webshell. Postgres: `pg_read_file` + `lo_export` (CVE-2025-1094). MSSQL: `xp_cmdshell`.
- Sin sqlmap. Severity: Critical.

## 4. JWT -> Privesc (auth High -> Critical)
- alg confusion RS256->HS256 o alg:none. Firmar HS256 con RSA pubkey como secreto, payload role:admin. JKU injection a tu JWKS.
- Severity: High/Critical.

## 5. SSRF -> Metadata -> Creds (Aikido: High -> Critical)
- SSRF en webhook/siteUrl/import imagen -> 169.254.169.254/latest/meta-data/.
- IMDSv2: robar token X-aws-ec2-metadata-token -> /iam/security-credentials/<rol> -> AccessKey/Secret/Token.
- Demostrar sts get-caller-identity (NO pivotar sin permiso). Severity: Critical.

## 6. Info Leak -> Reset Bypass (auth High -> Critical)
- stack trace / .git / backup expone secreto -> toma de reset de admin.
- Fuzz manual: /.git/config, .env, /backup.zip. Severity: High; Critical si reset admin.

## 7. Prototype Pollution -> RCE (DPG/Aikido: High -> Critical)
- PP server-side + gadget template engine (EJS/Handlebars/Pug).
- Deteccion black-box: {"__proto__":{"json spaces":10}} observa cambio respuesta.
- Gadget: {"__proto__":{"block":{"type":"Text","line":"process.mainModule.require('child_process')..."}}}
- Severity: Critical con RCE; High si solo pollution.

## 8. Race -> Balance/Limit Bypass (Medium -> High)
- coupon/stock/saldo. Single-packet attack.
- Severity: Medium->High.

## Red flags
- DPG: XSS /abonnementen dup; UUID IDOR sin enumeracion OOS; scanners = ban.
- Aikido: Self-XSS excluido; UUID IDOR sin enumeracion OOS.
- DPG comparte codebase 14 marcas -> 1 issue multi-marca.
