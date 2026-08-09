# Bug Bounty TTPs Avanzados 2026 — Sesion 2 (mrpuff0420)

## SQLi (DPG Critical)
- UNION SELECT: encontrar nº columnas por trial-error. SQLite: sqlite_master para schema dump.
- WAF bypass: comentarios anidados `*/`, `/**,/`, array params `id[]=1)/*&id[]=*/OR/*`, case/comment splitting `uni*on+sel*ect`, `SLEEP()` blind time-based con throttle.
- Second-order: payload almacenado se ejecuta en otro contexto.
- Juice lab: `')) UNION SELECT sql,'2'..'9' FROM sqlite_master--` -> schema leak.

## XSS avanzado (DPG High stored / Medium reflected)
- mXSS (CVE-2024-47875 DOMPurify <3.1.3): SVG self-closing, namespace switch (`<math><mtext><table><mglyph><style>`).
- DOM clobbering: form[id=implementation]>input[name=createHTMLDocument] para clobber funciones de sanitizer. Clobber window.CONFIG_SRC para controlar script src. CVE-2025-1647 Bootstrap 3.
- Prototype pollution -> XSS: Object.prototype.innerHTML / srcdoc / template. jQuery .attr() gadget.
- CSP bypass: dangling markup, SVG, polyglot.
- Stored XSS Juice: POST /api/Products description con iframe (201 guardado, sanitizer puede filtrar en render).

## Auth/JWT (DPG High / Aikido auth)
- alg:none, kid injection (path traversal en kid), JKU/JWKU header injection, RS256->HS256 confusion.
- CVE-2022-21449 (ECDSA sig exclusion). Refresh token reuse.
- OAuth abuse: remember-me cookie -> email header spoof (Juice CISO PoC).

## Race Condition / TOCTOU (bounty alto)
- Limit bypass en transferencias, coupon reuse, role upgrade, password reset.
- Burp Turbo Intruder / scripting concurrente. En lab: usar threading con throttle.

## Business Logic
- Price manipulation, cart manipulation, negative quantity, discount stacking.

## Web Cache (DPG CPDoS / cache poisoning)
- Unkeyed input: X-Forwarded-Host, X-Original-URL, Accept-Language. Param Miner Guess headers.
- Cache deception: usuario accede recurso sensible, atacante envenena cache para otros.
- CPDoS: header que provoca error cacheado (DPG evalúa con CVSS Attack Complexity High).
- HTTP/2-3 header smuggling, fat GET (body param unkeyed).

## Compliance (todos los programas)
- Header Intigriti obligatorio (DPG X-Intigriti-Username, Aikido X-Intigriti).
- Rate limit 5 req/seg (sleep 0.2-0.3s).
- DPG PROHIBE scanners -> todo manual.
- Sin PII; si aparece, parar y reportar.
- Out-of-scope: DPG XSS /abonnementen, privacy endpoints, paywall, UUID IDOR sin enumeracion, blind SSRF.
- Red flag dup: DPG comparte codebase (Volkskrant/Parool/Trouw) -> 1 issue multi-marca.
