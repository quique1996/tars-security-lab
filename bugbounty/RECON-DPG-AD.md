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
- **IDOR en `authId` UUID del endpoint /api/consent** (Técnica fundamentada 2025-2026):
  - "Sandwich attack" (dev.to/mohamed_aboelkheir): si el UUID no es v4 aleatorio sino v1 (timestamp+MAC), es predecible → enumeración real → eleva UUID IDOR de Low a Critical.
  - Probar: cambiar `authId` por otro UUID generado cercano en tiempo; si la API devuelve consent state de OTRO usuario → IDOR cross-user.
  - `readOnly=false` → ¿se puede ESCRIBIR/modificar consent de otro usuario? (privesc de estado).
- **SSRF/Open Redirect vía `siteUrl`**: si el backend usa `siteUrl` para fetch/server-side render sin validación estricta de host → SSRF a metadata cloud (Critical si impacto) u open redirect (Low). Verificar que no caiga en out-of-scope privacy endpoints.
- **CORS misconfig** en /api/consent y /api/metrics (Intigriti blog "Exploiting CORS"): si reflejan `Origin` con `Access-Control-Allow-Credentials: true` → robo de respuesta con token de víctima.
- **`/api/metrics` (pg.dpgmedia.net)**: excessive data exposure — ¿filtra PII en payload? ¿acepta POST sin auth?
- Auth bypass en flujo myaccount (vertical High)
- Stored XSS en webwinkel (High, área no excluida)
- SQLi en parámetros de búsqueda/filtro (Critical)
- Path traversal en descargas (Critical)
- SSRF con impacto (metadata cloud) — blind sin impacto = out

### Checklist manual (con header Intigriti, rate 5 req/seg, SIN scanners)
1. GET `/api/consent?authId=<propio>` → capturar respuesta (estado consent).
2. Repetir con `authId` de otro usuario (generado/observado) → ¿devuelve datos ajenos? (IDOR).
3. POST `/api/consent` con `readOnly=false` y `authId` ajeno → ¿escribe estado ajeno? (privesc).
4. Manipular `siteUrl` a `http://169.254.169.254/` → ¿SSRF? (solo si impacto real).
5. Enviar `Origin: https://evil.com` → ¿CORS refleja con credentials? (si sí, documentar PoC).
6. Inspeccionar headers de respuesta en `/api/metrics` → ¿leaks de PII/token?
7. Verificar duplicado: buscar mismo patrón en volkskrant.nl/parool.nl antes de submit.

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
