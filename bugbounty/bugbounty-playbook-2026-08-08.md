# Bug Bounty Playbook — DPG/AD + Aikido (mrpuff0420)

Entorno: GEEKOM container `bugbounty` (python:3.12-slim), /data/bugbounty montado.
Principios: recon MANUAL/semántico (DPG prohíbe scanners), header Intigriti obligatorio, rate limit 5 req/seg.

## Programas
- DPG/AD: scope `*.ad.nl` (Tier3) + myaccount/webwinkel/www.ad.nl (Tier2). Paga €25–€→€2,200. Header `X-Intigriti-Username: mrpuff0420`. No scanners.
- Aikido: scope `*.aikido.dev` + app.aikido.dev. Paga €50–2,500. Header `X-Intigriti: mrpuff0420`. Max 5 req/seg. Trial con @intigriti.me.

## Vectores priorizados (mapeados al KG)
1. IDOR numérico (KG: dict-ad-webapp-recon "AD DCSync"/"AD Kerberoasting" no aplica; sí "WebApp broken access control", "API BOLA"). DPG baja UUID IDOR a Low → buscar numeric IDs y enumeración real.
2. Auth flaws: reset de password, OAuth/OIDC, MFA bypass, session (KG: "Mobile OWASP MASVS", "WebApp auth flaws").
3. Stored XSS en áreas NO excluidas (DPG excluye /abonnementen). Buscar en myaccount, webwinkel, comentarios.
4. SQLi en parámetros (Critical en DPG). KG: "WebApp injection".
5. Path traversal / LFI (Critical). KG: "WebApp injection".
6. Vertical/lateral auth bypass (High/Medium). KG: "WebApp broken access control".
7. SSRF con impacto real (metadata cloud). DPG: blind sin impacto = out.

## Workflow por target
1. Mapear endpoints del login/account flow (Burp/ZAP manual proxy).
2. Identificar parámetros ID (user_id, account_id, order_id numéricos).
3. Probar acceso cruzado con 2 cuentas propias (Aikido: tenant propio; DPG: 2 cuentas trial).
4. Documentar PoC mínimo + impacto + CVSS.
5. Reporte via plantilla bugbounty-REPORTE.md.

## Notas de cumplimiento
- Nunca tocar out-of-scope (DPG: /abonnementen XSS, privacy endpoints, paywall).
- No PII. Si aparece, parar y reportar.
- Rate limit respetado (sleep 0.25s entre req).
- Header Intigriti presente en TODA request.
