# RoE Confirmado — DPG/AD (fuente: pagina live del programa, 2026-08-08)

## Programa
- URL: app.intigriti.com/researcher/programs/dpgm/algemeendagblad/detail
- Public, Open, Media & Entertainment.
- Assets Tier 2: myaccount.ad.nl, webwinkel.ad.nl, www.ad.nl, www.ad.nl/abonnementen.
- Asset Tier 3: *.ad.nl (wildcard).
- Usuario ya ENROLLED (researcher console).

## Rules of Engagement (textual del programa)
- Header OBLIGATORIO: `X-Intigriti-Username: {Username}` -> usar `mrpuff0420`.
- Max 5 req/seg (automated tooling limit).
- NO scanners automaticos (explicito: "We cannot accept any submissions found by using automatic scanners").
- User agent: Not applicable.
- Identificarse como researcher con Intigriti username y/o intigriti.me email.

## Pagos (impact-based)
- Tier 2: Low €50, Medium €300, High €800, Critical €1,200, Exceptional €2,200.
- Tier 3: Low €25, Medium €50, High €100, Critical €200, Exceptional €500.

## Severity (ejemplos official)
- Exceptional: RCE en prod, full DB access (update/delete).
- Critical: SQLi, acceso a todo PII de cliente o usuario objetivo, IDOR numerico mass write/read en features criticas, path traversal a archivos locales.
- High: acceso a PII de usuario aleatorio, stored XSS (excl self-XSS), vertical auth bypass.
- Medium: DOM XSS, reflected XSS, IDOR con datos no criticos, CSRF con impacto significativo, lateral auth bypass.
- Low: reflected XSS con mucha interaccion, CSRF en feature no critico, open redirect.
- UUID IDOR: evaluado como LOW salvo enumeracion realista (UUIDv1 / leak de UUIDs).

## Out of scope (confirmado)
- XSS en www.ad.nl/abonnementen (known issue).
- Blind SSRF sin impacto de negocio (pingbacks insuficientes).
- Self-XSS, CSRF sin/low impact.
- CORS misconfig en endpoints no sensibles.
- Missing headers/cookie flags, verbose messages sin datos sensibles.
- Host header injection sin impacto, open redirect en privacy consent.
- Username/email enumeration, email bombing.
- Subdomain takeover sin tomar la subdomain, arbitrary file upload sin prueba de existencia.
- CPDoS: en contenido altamente cacheado se evalua con CVSS Attack Complexity "High".
- DPG comparte codebase con Volkskrant/Parool/Trouw/etc -> issue ya encontrado en otra marca = DUPLICADO.

## Credenciales
- El programa NO provee credenciales. El researcher debe crear sus propias cuentas en el sitio objetivo (self-register).
