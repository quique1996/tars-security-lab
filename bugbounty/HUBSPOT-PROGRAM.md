# Programa HubSpot — HackerOne (mrpuff0420) — 2026-08-08

## Plataforma
- HackerOne (NO Intigriti). Requiere cuenta HackerOne aparte.
- Email para trial: usar **@WEAREHACKERONE.COM** (alias que HackerOne da a researchers, equivale a intigriti.me).
- Trial portal: https://offers.hubspot.com/free-trial → crear instancia propia para practicar.
- API key: con trial se crea y se usan los APIs de https://developers.hubspot.com/docs/api/overview

## CTF Challenge (autorizado, $20k)
- Target: app.hubspot.com, portal ID **46962361** (este portal SÍ es autorizado; NO tocar otros portals ajenos).
- Objetivo: vulnerabilidades de permisos / bypass de access control (sin SE, sin user interaction, sin brute-force) para leer:
  - flag 1: propiedad `firstname` → $15,000 USD
  - flag 2 (opcional): propiedad `super_secret` → +$5,000 USD (total $20k)
- Regla: primer submission valido gana y pausa el CTF. Verificar si sigue abierto antes de invertir.
- Entregar: nombre+valor de la propiedad flag, repro steps, y email al address en la propiedad email del record con subject "HubSpot CTF Challenge".

## Foco (lo que paga)
- Auth flows: signup (email/Google/Apple/MS), login (email/SSO/OAuth), MFA, account recovery, OAuth.
- High impact: XSS→ATO, cross-portal data leakage (portal A no debe leer portal B), SSRF/RCE, sensitive data exposure.
- IDOR: cross-portal IDORs = elegibles y priorizados. Same-portal: el backend API layer es el boundary (UI grayed-out NO cuenta).
  - Higher priority: cross-portal access, PII/PHI access, financial/billing, privesc a Super Admin, ATO.
  - Lower/Informational: CRUD en objetos no-sensibles, toggles sin impacto.

## Scope (in-scope assets)
- app*.hubspot.com (Critical, eligible)
- api*.hubspot.com, api*.hubapi.com (Critical)
- *.hubspotemail.net (Medium)
- chatspot.ai, hubspot.net, Customer Connected Domain, Customer Portal, HubSpot iOS/Android, Sales O365 add-in
- "Other HubSpot-owned (sub)domains not listed as Out of Scope" (Low, requiere prueba de propiedad)

## Out-of-scope (NO rewardable)
- Rate limits en API, brute force login/forgot-password, DoS, email flooding
- Race condition que bypass subscription limits
- Social engineering (HubSpot empleados/usuarios)
- Vulnerable libraries sin PoC
- Clickjacking, missing headers, missing best-practice
- XSS que NO ejecuta en contexto *.hubspot.com (solo en hs-sites, hubspotpagebuilder, preview domains = no reward)
- Cualquier dominio no listado explicitamente en In-Scope

## Pagos (Critical tiers)
- C1 Elevated Critical: $5,000–$10,000 (compromiso sistemas internos HubSpot, RCE, source code, prod DB)
- C2 Standard Critical: $3,000–$5,000 (cross-portal access, ATO arbitrario, takeover de pago)

## RoE / Reporte
- Sin scanners (implícito, estándar HackerOne).
- Reporte debe incluir: attack scenario, clear repro steps, recommended fix.
- CVSS base pero ajustado por likelihood/impact.
- NO acceder portals ajenos fuera del CTF 46962361.
