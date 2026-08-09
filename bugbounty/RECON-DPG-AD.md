# Bug Bounty — Reporte de Recon (mrpuff0420)

## Programa: DPG / Algemeen Dagblad (Intigriti dpgm/algemeendagblad)
- Scope: *.ad.nl, *.dpgmedia.nl (Tier3) + myaccount/webwinkel/www.ad.nl/abonnementen (Tier2)
- Header: `X-Intigriti-Username: mrpuff0420` | Rate: 5 req/seg | NO scanners
- Payout: €25–2,200 (avg €180)

## Recon autorizado (browser real, WAF Akamai pasado)
Ejecutado 2026-08-08 desde GEEKOM container `bugbounty` (Playwright/Chromium).
STATUS 200 en todos los targets (WAF acepta tráfico de browser legítimo).

### Superficie mapeada
| Target | Status | APIs en scope | Forms | Scripts |
|---|---|---|---|---|
| www.ad.nl | 200 | pg.ad.nl/api/consent, pg.dpgmedia.net/api/metrics, pg.dpgmedia.nl/api/consent | 1 | 16 |
| myaccount.ad.nl | 200 | pg.dpgmedia.nl/api/consent (authId UUID) | 0 | 0 |
| webwinkel.ad.nl | 200 | webwinkel.ad.nl/api/collect, pg.ad.nl/api/consent | 3 | 32 |

### Endpoints candidatos (EN SCOPE, *.ad.nl / *.dpgmedia.nl)
1. `https://pg.ad.nl/api/consent?language=nl&siteUrl=<url>&readOnly=false&authId=<UUID>&integratorId=ad`
2. `https://pg.dpgmedia.nl/api/consent?...` (mismo patrón)
3. `https://pg.dpgmedia.net/api/metrics`
4. `https://webwinkel.ad.nl/api/collect` (Shopify collect)
5. Shopify shop-js chunks: `authorize`, `validators`, `useUserRecognitionSignal` → lógica auth/sesión

### Parámetros manipulables
- `authId` (UUID v4 en consent) — IDOR/consent state manipulation, UUIDv1 prediction si aplica
- `integratorId=ad` — posible tampering de integrador
- `siteUrl` — SSRF/Open Redirect si no validado (verificar out-of-scope privacy endpoints)
- `readOnly=false` — ¿se puede escribir consent de otro usuario?

### Vectores priorizados (mapeados a severity DPG)
- IDOR numérico en APIs de account/carrito (Critical si mass)
- Auth bypass en flujo myaccount (vertical High)
- Stored XSS en webwinkel (High, área no excluida)
- SQLi en parámetros de búsqueda/filtro (Critical)
- Path traversal en descargas (Critical)
- SSRF con impacto (metadata cloud) — blind sin impacto = out

### Red flags de duplicado (DPG comparte codebase)
- Mismo bug en Volkskrant/Parool/Trouw/dpgmedia.nl = duplicado
- Verificar si ya reportado en otro DPG antes de submit

## Compliance
- Header Intigriti en TODA request. Rate limit 5 req/seg.
- NO scanners (prohibido por RoE). Recon manual/semántico.
- Sin PII; si aparece, parar y reportar.
- NO tocar out-of-scope: /abonnementen XSS, privacy endpoints, paywall.

## Evidencia
- JSON recon: /data/bugbounty/recon/dpg/dpg_*.json
- Script: recon_browser.py (Playwright, header Intigriti)
