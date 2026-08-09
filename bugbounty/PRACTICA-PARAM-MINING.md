# Practica: Param Mining + Recon (2026-08-08)

## Ejecutado
- Script: recon_mining_pw.py (Playwright, RoE DPG header Intigriti) en https://myaccount.ad.nl
- 23 params probados (?debug, ?id, ?user, ?authId, ?userId, etc) con diff de content-length >200 bytes.

## Resultado / Leccion
- Baseline "/" = 7,858 bytes (privacy gate / redirect).
- Con cualquier param: ~738,044 bytes (la SPA carga el app shell completo).
- CONCLUSION: en SPAs, el diff de content-length TOTAL no sirve para param mining — el bundle JS se carga igual.
- Fix para prox practice: diff de subcampos especificos (JSON keys en API response, o texto unico en DOM), no length total. O minar params contra endpoints de API (no la raiz SPA).

## Nota tecnica (leccion comunidad)
- urllib puro es BLOQUEADO por Akamai en DPG (headless detectado). Playwright con UA real pasa.
- Wayback CDX (web.archive.org) se colgo en el container GEEKOM → usar desde Mac local o con timeout corto + fallback.
- Param mining aislado: param_mine_only.py (urllib, falla por Akamai); recon_mining_pw.py (Playwright, funciona).
