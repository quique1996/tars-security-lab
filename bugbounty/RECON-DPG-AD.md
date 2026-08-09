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
  - **Verificar versión UUID**: dígito 13 (`...11ef...` = v1). Si es v1 → generar candidatos intermedios entre 2 UUIDs propios capturados.
  - Probar: cambiar `authId` por otro UUID generado cercano en tiempo; si la API devuelve consent state de OTRO usuario → IDOR cross-user.
  - `readOnly=false` → ¿se puede ESCRIBIR/modificar consent de otro usuario? (privesc de estado, mass write = Critical).
- **SSRF/Open Redirect vía `siteUrl`**: si el backend usa `siteUrl` para fetch/server-side render sin validación estricta de host → SSRF a metadata cloud (Critical si impacto) u open redirect (Low). Probar allow-list bypass (`www.ad.nl.attacker.com`). Verificar que no caiga en out-of-scope privacy endpoints.
- **CORS misconfig** en /api/consent (Intigriti blog "Exploiting CORS"): si reflejan `Origin` con `Access-Control-Allow-Credentials: true` → robo de respuesta con token de víctima. Probar `Origin: null`, subdominio `evil.ad.nl`.
- **`/api/metrics` (pg.dpgmedia.net)**: ⚠️ **`.net` ESTÁ FUERA DE SCOPE** (`*.ad.nl`, `*.dpgmedia.nl` sí). NO tocar sin confirmar con Intigriti. Si estuviera in-scope: info leak / Prometheus expuesto.
- **HPP (Parameter Pollution)**: `authId=<mío>&authId=<víctima>` para saltar validación de autorización.
- **Web cache deception**: si consent+PII se cachea (headers `X-Cache`/`Age`) → posible leak a otros usuarios.
- **integratorId=ad**: tampering a `volkskrant`/`parool`/`trouw` → cross-tenant access / info leak de config.
- Auth bypass en flujo myaccount (vertical High)
- Stored XSS en webwinkel (High, área no excluida)
- SQLi en parámetros de búsqueda/filtro (Critical)
- Path traversal en descargas (Critical)
- SSRF con impacto (metadata cloud) — blind sin impacto = out

### Checklist manual (con header Intigriti, rate 5 req/seg, SIN scanners)
```bash
# Baseline propia sesión
curl -s -D - 'https://pg.ad.nl/api/consent?language=nl&siteUrl=https%3A%2F%2Fwww.ad.nl&readOnly=false&authId=<MI_UUID>&integratorId=ad' \
  -H 'X-Intigriti-Username: mrpuff0420' -o /dev/null
```
1. Guardar 2 UUIDs propios (t1, t2) → verificar versión UUID (v1 vs v4, dígito 13).
2. **IDOR:** repetir con `authId` de 2ª cuenta propia → ¿lee/escribe su consent? Documentar diff.
3. **CORS:** añadir `-H 'Origin: https://evil.example'` → revisar ACAO/ACAC.
4. **integratorId:** probar `volkskrant/parool/trouw` → diff en respuesta.
5. **SSRF:** `siteUrl` → colaborador propio (Interactsh) con header Intigriti; esperar DNS/HTTP hit para impacto.
6. **HPP:** duplicar `authId`. **Throttle sleep 0.2s. Sin fuzzing automático.**

### Red flags de duplicado (DPG comparte codebase)
- Un hallazgo en `pg.ad.nl` **casi seguro replica** en `volkskrant.nl/parool.nl/trouw.nl` (misma CMP). Reportar como **UN solo issue multi-marca**, no varios.
- Consent/CMP endpoints son heavily-tested → revisar known-issues de Intigriti.
- UUID IDOR sin enumeración = Low/duplicado garantizado por RoE. No reportar sin PoC de predicción.
- SSRF/XSS en `/abonnementen` y privacy endpoints = **out-of-scope explícito**.

## Compliance
- Header Intigriti en TODA request. Rate limit 5 req/seg.
- NO scanners (prohibido por RoE). Recon manual/semántico.
- Sin PII; si aparece, parar y reportar.
- NO tocar out-of-scope: /abonnementen XSS, privacy endpoints, paywall.

## Evidencia
- JSON recon: /data/bugbounty/recon/dpg/dpg_*.json
- Script: recon_browser.py (Playwright, header Intigriti)
