# Practica Sesion 5 — GraphQL + CSRF (mrpuff0420)

LAB LOCAL Juice Shop. Amplia superficie: GraphQL (Aikido-like) y CSRF (DPG-like).

## Resultados (2026-08-09)
| Practica | Resultado | Leccion |
|---|---|---|
| GraphQL introspection | 200 pero devuelve HTML SPA, NO schema | Juice Shop de esta version NO expone /graphql. No practicable aqui. |
| GraphQL IDOR/batching | no aplica (sin endpoint) | Aikido (703 endpoints) es el target real de GraphQL. |
| CSRF cambio email | 401 UnauthorizedError (JWT malformado) | Juice usa JWT Bearer -> CSRF NO aplica. CSRF real requiere session cookie sin token. |
| CSRF en DPG | pendiente (myaccount cookie-based) | DPG SI es candidato CSRF real. |

## Conclusiones para reales
1. **GraphQL**: practicar en Aikido (tenant trial) donde hay 703 endpoints. Probar introspection, IDOR via query con ID ajeno, batching/alias rate-limit bypass.
2. **CSRF**: solo aplica en DPG (cookie session). Probar cambio email/password/2FA sin CSRF token validando Origin/Referer. Aikido (JWT) no aplica.
3. **Juice Shop** ya agoto vectores practicables: IDOR, SQLi UNION, XSS stored/reflected (sanitizer), auth bypass concept, race/cache (no estado-mutable), GraphQL (no expuesto), CSRF (JWT).

## Scripts: /data/bugbounty/scripts/juice_graphql.py, juice_csrf.py
