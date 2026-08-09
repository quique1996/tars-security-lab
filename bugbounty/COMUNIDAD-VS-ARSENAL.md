# Metodología Comunidad Bug Bounty 2025–2026 vs. Nuestro Arsal

## 1. Cómo arranca la comunidad (HackerOne / Intigriti)
- **Elegir programa por skill**: front-end → XSS; DB/SQL → SQLi; e-commerce → price/logic; API → IDOR/BOLA. Intigriti recomienda alinear punto fuerte con programa.
- **Recon primero, siempre**: subdomain enum, content discovery, tech stack fingerprint, Wayback/archive URLs, GitHub leaks, Postman collections, CT logs.
- **Manual > scanners**: HackerOne/Intigriti prohíben scanners en la mayoría. El valor está en lógica de negocio que automatización no ve.
- **Reporting**: PoC reproducible impreso en papel, attack scenario, impact, recommended fix. Intigriti exige CVSS + scope validation assistant.

## 2. Blogs / writeups reales recientes (técnica clave) — [fuentes verificadas]
- **IDOR billing** — POST a endpoint de billing revela datos de otros usuarios; UUID no valida contexto. (infosecwriteups how-i-found-a-idor-issue-in-5-mins)
- **SSRF 5 bypasses** — redirect, 169.254.169.254 metadata AWS, Collaborator, DNS rebind, PDF gen. (medium/@oksuzkayra16 five-bounties-one-bug)
- **2FA bypass response manipulation** — cambiar `"success":false`→`true` / forzar 200 en respuesta OTP. (medium/@0mex; $6000: mokhansec bypassing-2fa)
- **Blind XSS → RCE** — payload en header (User-Agent/X-Forwarded) ejecuta en panel admin interno. (is4curity from-blind-xss-to-rce)
- **Race condition single-packet** — Turbo Intruder Engine.BURP2 para precio/rate-limit/ATO. (YesWeHack race guide)
- **SQLi legacy** — 1213 SQLi pagados en HackerOne 2025 (~$1074/reporte); vivo en params legacy. (Reddit/HackerOne data)
- **IDOR→ATO** — cambiar `id` en request de verificación sin re-validar. (infosecwriteups)
- **Logic flaw→takeover** — manipular `email` en perfil; 200 pero no aplica → login con email cambiado. (Synack)
- **XSS $350/15min** — `?name=<img src=1 onerror=alert(1337)>` reflected. (infosecwriteups)

## 3. Canales / videos — qué enseñan [fuentes]
- **NahamSec / Jason Haddix**: recon wide-scope, automatización, content discovery ("efficiency pays"). (youtube krCsMZfbuB4)
- **AssetNote**: GraphQL introspection + batching (BatchQL), attack surface. (assetnote.io exploiting-graphql)
- **TheXSSRat**: metodología end-to-end 2026 por clase de vuln; XSS stored/blind/DOM.
- **Prototype pollution**: detección manual + automatización. (youtube em1QOZvN4M8)
- **Param Miner (Burp)**: parámetros ocultos + cache poisoning. (nahamsec Resources-for-Beginner-Bug-Bounty-Hunters)
- **Intigriti BugQuest 2026**: 31 días Broken Access Control (API doc mining, 3rd-party intel, UUIDv1, IDOR).
- **InsiderPHD**: on-ramp limpio a vuln classes reales.

## 4. Nuestro arsenal vs comunidad (veredicto del análisis)
- **Ya cubrimos BIEN** (Juice Shop + KG 6029 + TTPs): IDOR/BOLA, SQLi, XSS reflejado, CSRF, GraphQL training, chains, recon_browser/manual_probe. Alinea con DPG (SQLi Critical, XSS High) y Aikido (BOLA/IDOR/SSRF).
- **GAP REAL**: no es la *clase* de vuln (eso lo dominamos en lab), sino las **técnicas de descubrimiento/bypass en la wild**:
  - Recon activo real: param mining (Param Miner style), wayback/gau, content discovery a escala → clave para wildcard DPG.
  - Auth/2FA bypass por response manipulation (200/`success:true`) → no está en training.
  - Race condition single-packet (Turbo Intruder) → directo a SaaS Aikido.
  - SSRF a metadata cloud (169.254.169.254) + bypasses → core Aikido SSRF.
  - Blind XSS out-of-band (headers, campos admin) → más realista que reflejado de lab.
  - Otros no tocados: JWT en la wild, subdomain takeover, cache poisoning real, prototype pollution, POST-based XSS, multipart/content-type bypass.

## 5. GAPS de práctica (comunidad usa, nosotros NO hemos tocado)
1. **Param mining SPA-aware**: content-length total no sirve en SPAs (probado: baseline 7.8KB vs 738KB con param). Necesita diff de JSON keys / DOM text único o minar endpoints API directos.
2. **Wayback/archive recon**: se colgó en GEEKOM; correr desde Mac local o con fallback.
3. **Auth bypass / response manipulation**: 2FA bypass, OTP skip, status code manipulation.
4. **JWT en la wild**: alg:none, RS256→HS256, kid path traversal, CVE-2022-21449.
5. **Race condition real**: Turbo Intruder-style parallel requests (en lab Juice Shop).
6. **Cache poisoning / web cache deception**: headers X-Forwarded-Host, unkeyed params.
7. **Subdomain takeover**: DNS CNAME check (para HubSpot customer connected domains).
8. **SSRF cloud metadata**: apuntar a 169.254.169.254 (Aikido/HubSpot cloud).

## 6. Siguiente práctica priorizada (sub-agente + Stella fusionado)
- **P1 Race condition single-packet** en Juice Shop → transferir a Aikido SaaS (BOLA/límites). Alta prioridad.
- **P2 SSRF metadata + bypasses** (redirect, DNS rebind) → core Aikido.
- **P3 2FA/auth bypass response manipulation** en lab → aplicable a DPG login.
- **P4 Param mining + content discovery** con recon_browser sobre scope DPG wildcard → endpoints legacy con SQLi/XSS.
- **P5 Blind XSS OOB** (payloads en headers) → XSS High en DPG sin depender de reflejado.
- **P3b HubSpot CTF** (portal 46962361): cross-portal IDOR para leer `firstname`+`super_secret` ($20k). Requiere cuenta HackerOne + trial.

## 7. Regla de oro comunidad que ya cumplimos
"Manual testing finds the bounties." Scanners no entran. Nuestro recon_browser (Playwright) es exactamente el approach de la comunidad: cliente con fingerprint real, no urllib bot.
