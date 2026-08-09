# Bug Bounty TTPs Avanzados 2026 (mrpuff0420) — dict-secops-bugbounty-2026-08-08

## Web App / API TTPs (mapeados a DPG/AD + Aikido)

### IDOR / BOLA (Broken Object Level Authorization)
- Sustituir ID numérico en parámetros (user_id, account_id, order_id) con cuenta propia #2.
- UUID IDOR: DPG lo baja a Low salvo enumeración real (UUIDv1 = time-based, predecible; leak de UUIDs vía otra API).
- GraphQL IDOR: query/mutation con ID de otro usuario; GraphQL no enforcea ownership.
- BOLA en APIs REST: GET /api/v1/projects/{id} con tenant Ajeno (Aikido RLS bypass).
- Mass assignment: POST con campos extra (role=admin, tenant_id=otro).

### Auth Flaws
- JWT alg:none: token sin firma aceptado.
- JWT nbf bypass: nbf futuro aceptado.
- OAuth/OIDC: redirect_uri manipulation, code injection, state missing.
- Password reset: token predecible, reset a email controlado, HOST header injection en link.
- MFA bypass: falta verificación en algunos endpoints, cookie 2FA reutilizable.
- Session: jsessionid fijo, logout no invalida, token en URL.

### Injection
- SQLi (DPG Critical): parámetros en buscadores, filtros, order_by.
- Command injection en funciones de export/convert.
- Template injection (SSTI) en campos renderizados.
- Path traversal / LFI: ../../ en parámetros de archivo (DPG Critical).

### XSS (donde NO está excluido)
- Stored XSS en myaccount, webwinkel, comentarios, perfiles (DPG High).
- DOM XSS (Medium), Reflected (Medium/Low).
- DPG excluye /abonnementen XSS y privacy endpoints → evitar.

### SSRF
- SSRF con impacto: metadata cloud (169.254.169.254), internal services (DPG Critical si impacto).
- Aikido AutoFix pipeline: SSRF a Lambda metadata / escape de aislamiento Fargate.
- Blind SSRF sin impacto = out-of-scope en ambos.

### GraphQL
- Introspection (info schema), alias-based rate limit bypass, batching bypass (login brute).
- Resource exhaustion (query anidado profundo).

### Prototype Pollution
- JSON merge en objetos; inject __proto__ para escalar privilegios / bypass checks.

### CPDoS (Cache Poisoning DoS)
- Header injectado en respuesta cacheada (DPG evalúa con CVSS Attack Complexity High).

### Multi-tenant escape (Aikido específico)
- AutoFix ejecuta código tenant en Fargate/Firecracker aislado.
- Si reuse de env entre tenants (Lambda tenant-isolation off) → leak de secretos/temp files.
- SSRF desde sandbox a metadata AWS.

## Recon pasivo vs activo
- Pasivo: crt.sh/OTX (rate-limited); JS files, sitemap, API docs.
- Activo autorizado: navegador real (WAF bloquea urllib) + header Intigriti + 5 req/seg.
- DPG PROHÍBE scanners → todo manual.

## Compliance
- Header obligatorio: DPG `X-Intigriti-Username`, Aikido `X-Intigriti`.
- Sin PII; si aparece, parar y reportar.
- No out-of-scope (DPG: /abonnementen XSS, privacy, paywall; Aikido: mismo-tenant privesc salvo cross-team).
- Rate limit 5 req/seg respetado.
