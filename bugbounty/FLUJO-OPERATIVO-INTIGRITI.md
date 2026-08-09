# Flujo Operativo Bug Bounty — Intigriti (mrpuff0420) — 2026-08-08

Basado en KB Intigriti (researchers) + RoE vivo de DPG/AD y Aikido.

## 1. Identidad y headers (RoE)
- Intigriti username: mrpuff0420
- Header DPG/AD: `X-Intigriti-Username: mrpuff0420` (OBLIGATORIO en cada request)
- Header Aikido: `X-Intigriti: mrpuff0420`
- Rate limit: <=5 req/seg (DPG explicito). Usar sleep 0.2s entre requests.
- NO scanners (DPG lo prohíbe explicitamente; Akamai bloquea headless en login/registro).

## 2. Cuentas de prueba (CRITICO — resuelve bloqueo Akamai)
- DPG NO da credenciales via programa? Revisar boton "Request new credentials" en la pagina del programa (KB: algunos programas las dan auto). Si no, usar intigriti.me alias.
- intigriti.me alias: mrpuff0420@intigriti.me reenvia a tu email registrado.
  - Wildcards: mrpuff0420+1@intigriti.me, mrpuff0420+aikido@intigriti.me -> multiples cuentas SIN crear varios Intigriti.
  - Esto es la forma OFICIAL de crear 2 cuentas para IDOR cross-user (KB lo recomienda).
- Aikido: sign up con mrpuff0420@intigriti.me (el alias es tu identidad de researcher).
  - Crear 2 workspaces bajo el tenant para BOLA cross-tenant.

## 3. Flujo de recon (ya hecho, autorizado)
- DPG: www/myaccount/webwinkel.ad.nl mapeados, APIs /api/consent, /api/metrics.
- Aikido: 703 endpoints mapeados (accounts, auth, audit-reports, ai_pentest).
- WAF Akamai: resolver con navegador real (no headless en login).

## 4. Flujo de testing (manual, SIN scanners)
1. Identificar vectores en scope (IDOR, SQLi, XSS, auth bypass, SSRF, BOLA).
2. Probar con 2 cuentas propias (intigriti.me wildcard) para demostrar impacto.
3. Respetar rate limit 5 req/seg.
4. NO tocar PII ajena real; usar solo cuentas propias.
5. Documentar PoC (request/response) en reporte.

## 5. Flujo de reporte (KB Intigriti)
- Ir a programa -> Create Submission.
- Titulo en ingles. Seleccionar Asset (myaccount.ad.nl, webwinkel.ad.nl, etc).
- Endpoint opcional pero recomendado.
- Tipo de vulnerabilidad (IDOR, SQLi, XSS, etc).
- CVSS calculator (o manual severity).
- Reproduccion: "Can my report be printed on a sheet of paper and still be understood?" -> SI.
  - Pegar el request POST/GET (REDACTAR cookie/Authorization token).
  - NO screenshots del request (dificil de reproducir).
- Impact: explicito, por que importa.
- Recommended solution: opcional.
- IP usada en testing: incluir (para que el cliente valide en logs).
- Scope validation assistant: revisa antes de enviar; si warn, cruzar con scope del programa.

## 6. Validez y triage
- Si dudas si es valido: enviar reporte claro y conciso. Triage reproduce.
- Cliente tiene say final en severity/aceptacion.
- UUID IDOR: LOW salvo enumeracion real (DPG). Self-XSS/blind SSRF = OOS.

## 7. Pagos
- DPG Tier 2: Critical €1,200 / High €800 / Medium €300 / Low €50.
- DPG Tier 3 (*.ad.nl): Critical €200 / High €100 / Medium €50 / Low €25.
- Aikido: verificar en pagina del programa (no extraido aun).

## 8. Red flags (evitar ban/duplicado)
- Scanners = suspension/ban.
- DPG XSS /abonnementen = dup OOS.
- UUID IDOR sin enumeracion = LOW/OOS.
- DPG comparte codebase 14 marcas -> 1 issue multi-marca.
- Respetar rate limit o bajan invites a privados.
