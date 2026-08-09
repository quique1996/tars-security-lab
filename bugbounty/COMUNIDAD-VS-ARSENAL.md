# Metodología Comunidad Bug Bounty 2025–2026 vs. Nuestro Arsal

## 1. Cómo arranca la comunidad (HackerOne / Intigriti)
- **Elegir programa por skill**: front-end → XSS; DB/SQL → SQLi; e-commerce → price/logic; API → IDOR/BOLA. Intigriti recomienda alinear punto fuerte con programa.
- **Recon primero, siempre**: subdomain enum, content discovery, tech stack fingerprint, Wayback/archive URLs, GitHub leaks, Postman collections, CT logs.
- **Manual > scanners**: HackerOne/Intigriti prohíben scanners en la mayoría. El valor está en lógica de negocio que automatización no ve.
- **Reporting**: PoC reproducible impreso en papel, attack scenario, impact, recommended fix. Intigriti exige CVSS + scope validation assistant.

## 2. Blogs / writeups reales recientes (técnica clave)
- **IDOR → ATO ($500)**: cambiar `id` en request de verificación de teléfono/email; server acepta datos de otra cuenta sin re-validar. (infosecwriteups, Sep 2025)
- **Logic flaw → total control**: manipular `email` en request de perfil; 200 OK pero no aplica → luego login con email cambiado = takeover. (Synack / krishna kumar 2026)
- **SSRF 5 técnicas 1 bug**: mismo endpoint explotado vía cloud metadata, URL parse, redirect, DNS rebinding, PDF gen. (medium oksuzkayra16)
- **2FA bypass ($6000)**: tras login válido, response manipulation / OTP step skippable → acceso sin segundo factor. (mokhansec)
- **XSS $350/15min**: param `name` en `/profile?name=<img src=1 onerror=alert(1337)>` reflected. (infosecwriteups)
- **SQLi**: UNION-based para schema leak; WAF bypass con comentarios/encoding. (NiaziSec / Intigriti SQLi blog Apr 2026)
- **Race condition**: Turbo Intruder / parallel requests para bypass limits, duplicar transacciones. (YesWeHack race guide)
- **GraphQL**: introspection + batching queries; BatchQL (assetnote). (assetnote.io)

## 3. Canales / videos (qué enseñan)
- **NahamSec**: recon-driven hunting, live streams, scope selection, "The No BS Roadmap". Free recon course.
- **STÖK**: metodología moderna recon + tooling (ffuf/ParamMiner style, subdomain enum).
- **InsiderPHD (Katie)**: on-ramp limpio a vuln classes reales a ritmo beginner.
- **The XSS Rat**: web-app vuln classes + reporting craft.
- **AssetNote**: GraphQL/param mining técnicas profundas.
- **Intigriti BugQuest 2026**: 31 días de Broken Access Control (API doc mining, 3rd-party intel, UUID/v1, IDOR).

## 4. Nuestro arsenal actual (lo que YA tenemos)
- KG 6029 puntos, catalogos TTPs (XSS/SQLi/chains), RoE DPG/Aikido, flujo operativo.
- Lab Juice Shop: IDOR/BOLA, SQLi UNION, XSS stored/reflected, CSRF, GraphQL training, 8 chains.
- Scripts GEEKOM: recon_browser (Playwright, pasa Akamai), manual_probe, juice_*, analyze_js (703 endpoints Aikido).
- Programas: DPG/AD (web clásica, SQLi=Critical, XSS=High, NO scanners), Aikido (SaaS BOLA/IDOR/SSRF), HubSpot (HackerOne, CRM cross-portal, CTF $20k).

## 5. GAPS de práctica (comunidad usa, nosotros NO hemos tocado)
1. **Param mining SPA-aware**: content-length total no sirve en SPAs (probado: baseline 7.8KB vs 738KB con param). Necesita diff de JSON keys / DOM text único o minar endpoints API directos.
2. **Wayback/archive recon**: se colgó en GEEKOM; correr desde Mac local o con fallback.
3. **Auth bypass / response manipulation**: 2FA bypass, OTP skip, status code manipulation.
4. **JWT en la wild**: alg:none, RS256→HS256, kid path traversal, CVE-2022-21449.
5. **Race condition real**: Turbo Intruder-style parallel requests (en lab Juice Shop).
6. **Cache poisoning / web cache deception**: headers X-Forwarded-Host, unkeyed params.
7. **Subdomain takeover**: DNS CNAME check (para HubSpot customer connected domains).
8. **SSRF cloud metadata**: apuntar a 169.254.169.254 (Aikido/HubSpot cloud).

## 6. Siguiente práctica priorizada (pre-real)
- **P1 (DPG)**: param mining SPA-aware en /api/* (authId, userId, order) + IDOR cross-account con 2 cuentas.
- **P2 (Aikido)**: BOLA cross-workspace en /api/accounts; JWT alg confusion si aplica.
- **P3 (HubSpot CTF)**: trial portal + cross-portal IDOR contra portal 46962361 (flag firstname).
- **P4 (general)**: race condition en Juice Shop; SSRF metadata en lab; response-manipulation auth bypass.

## 7. Regla de oro comunidad que ya cumplimos
"Manual testing finds the bounties." Scanners no entran. Nuestro recon_browser (Playwright) es exactamente el approach de la comunidad: cliente con fingerprint real, no urllib bot.
