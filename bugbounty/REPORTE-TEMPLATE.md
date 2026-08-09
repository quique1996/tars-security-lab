# Reporte Template — Bug Bounty (mrpuff0420)

Programa: [DPG/AD | Aikido | BMW | Ubisoft]
Fecha: 2026-08-08
Severity (CVSS): [ ]

## Resumen
[Una línea: qué vulnerabilidad, dónde, impacto.]

## Affected Asset
- URL/Endpoint: 
- Tipo: [Web | API | Mobile | Infra]
- En scope: [Sí/No — citar RoE]

## Vulnerability Details
- CWE: [ ]
- Tipo: [IDOR | Auth Bypass | XSS | SQLi | SSRF | Path Traversal | CORS | Otro]
- Descripción técnica:
[Explicar la falla de manera concisa.]

## Proof of Concept (mínimo, ético)
```
[Paso a paso reproducible. Uso de header X-Intigriti obligatorio.
Sin scanners (si el programa lo prohíbe). Sin PII.]
```
- Request (curl/python con header Intigriti):
```
curl -H "X-Intigriti-Username: mrpuff0420" https://...
```
- Response (relevante):

## Impact
[Qué puede hacer un atacante. Mapear a severity del programa.]

## Remediation (sugerida)
[Fix técnico breve.]

## Cumplimiento
- [ ] Header Intigriti presente en TODA request.
- [ ] Rate limit respetado (5 req/seg).
- [ ] Sin escáneres (si RoE lo prohíbe).
- [ ] Sin PII; si apareció, parado y reportado.
- [ ] No out-of-scope (citar exclusions del programa).
- [ ] Verificado que NO es duplicado (DPG: mismo bug en otro DPG Media = dup).

## Evidencia / Archivos
- Recon JSON: /data/bugbounty/recon/...
- Script usado: recon_browser.py / manual_probe.py
