# Practica Sesion 5b — GraphQL Training + Chains (mrpuff0420)

## GraphQL training (endpoint publico, NO real)
- Introspection: 200, schema expuesto ✅
- Query valido: {countries{name}} -> 200 con datos ✅
- Batching: array x3 en 1 HTTP req (concepto; countries endpoint no acepta array, pero la tecnica aplica en Aikido)
- Cuando tengas tenant Aikido: BASE=app.aikido.dev/graphql + header X-Intigriti: mrpuff0420
  - Probar introspection, IDOR via {user(id:OTRO){...}}, alias/batching rate-limit bypass.

## DVGA (lab local) - NO arranco
- Imagen dolevf/dvga fallo (connection refused, sin logs). Puerto 5001 ocupado.
- Alternativa: practicar GraphQL en Aikido (tenant) donde hay 703 endpoints.
- Nota: no perder tiempo en DVGA; el training con endpoint publico cubre la sintaxis.

## Attack Chains (catalogo sub-agente, 8 cadenas)
1. XSS -> ATO (High->Critical)
2. IDOR -> ATO (High->Critical)
3. SQLi -> RCE (Critical)
4. JWT -> privesc (High->Critical)
5. SSRF -> metadata -> creds (Critical)
6. Info leak -> reset bypass (High->Critical)
7. Prototype pollution -> RCE (Critical)
8. Race -> balance/limit (Medium->High)

Ver CATALOGO-CHAINS-2026.md para pasos manuales completos.

## Scripts: /data/bugbounty/scripts/juice_graphql_train.py
