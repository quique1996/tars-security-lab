# Bug Bounty TTPs Sesion 5 (mrpuff0420) — 2026-08-09

## SSRF (Aikido critico)
- Cloud metadata: 169.254.169.254/latest/meta-data/iam/security-credentials/ (AWS), v1beta1 GCP.
- Bypass allowlist: redirect propio (Location: 169.254.169.254), DNS rebinding (1u.ms), encode (@, decimal, xip.io), 127.0.0.1@, [::1].
- Blind SSRF: Burp Collaborator, Apache /server-status, out-of-band exfil.
- Vector en DPG: siteUrl en /api/consent (confirmar fetch server-side). Aikido: webhook/integration URL.

## Insecure Deserialization
- PHP: unserialize() -> POP chain (__destruct, __wakeup). Java: ObjectInputStream -> CommonsCollections gadget. Python: pickle.loads() -> __reduce__ RCE. Node: node-serialize.
- Impacto: RCE, file write, auth bypass. Detectar: formato base64/comprimido en cookie/session/token.
- DPG/Aikido: buscar session cookie con datos estructurados, params con objeto serializado.

## Prototype Pollution -> RCE (Node)
- Client: Object.prototype.innerHTML -> DOM XSS. Server: __proto__ en JSON -> privesc (role:admin), DoS, RCE via gadget (NODE_OPTIONS, template engine).
- Detectar: JSON con __proto__, constructor.prototype. Aikido (Node SaaS) candidato.
- Silent Spring (USENIX 23): 8 RCE en apps reales (NPM CLI, Parse Server, Rocket.Chat).

## Account Takeover chains
- IDOR en password reset: token predecible/reusable -> reset cuenta ajena.
- Email change sin authz: IDOR en /api/user/{id} -> cambiar email -> reset password.
- OAuth misconfig: remember-me cookie -> email header spoof (Juice CISO PoC).
- 2FA disable via IDOR.

## Information Disclosure
- Backup files: .php.bak, .swp, ~, .git (source disclosure).
- Debug headers: X-Powered-By, server, stack trace, verbose error (DPG SQLITE_ERROR revelo engine).
- .env, config.json, robots.txt, sitemap expone paths.
- Severity: suele ser Low/Medium salvo que exponga PII/creds -> High.

## Attack Chains (lo que paga)
- XSS -> CSRF/ATO: XSS roba token -> cambio email/password.
- IDOR -> ATO: IDOR user -> reset email/2FA disable.
- SQLi -> RCE: pg_read_file/LOAD_FILE -> INTO OUTFILE/xp_cmdshell.
- JWT -> privesc: alg:none/RS256->HS256 -> token admin.
- SSRF -> metadata -> IAM -> lateral.
- Info leak -> reset bypass: stack trace/.git expone token -> reset admin.
- Prototype pollution -> RCE: gadget template engine.
- Race -> balance/limit bypass.

## Compliance
- Header Intigriti REAL: DPG `X-Intigriti-Username: mrpuff0420`, Aikido `X-Intigriti: mrpuff0420`.
- Rate 5 req/seg. DPG NO scanners. Sin PII.
- Red flags: DPG XSS /abonnementen, UUID IDOR sin enumeracion, scanners prohibidos.
