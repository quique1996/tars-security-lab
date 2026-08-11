# SQL injection vulnerability in WHERE clause allowing retrieval of hidden data — SQL injection

## Info
- **ID**: `sqli-01`
- **Dificultad**: Apprentice
- **URL**: https://portswigger.net/web-security/sql-injection/lab-retrieve-hidden-data
- **Fecha**: 2026-08-09 (smoke test del pipeline)
- **Estado**: ⚠️ SOLVED (banner) — **writeup PENDIENTE de evidencia real**

## Estado honesto
Este lab se usó el 2026-08-09 para **probar el pipeline `solve-lab.py`** (exploit → banner → writeup).
El banner "Congratulations" se verificó, pero **la evidencia capturada no incluye el payload**
(la request registrada solo contiene el header de prueba, sin el `' OR '1'='1` real).

**No es un writeup de portfolio todavía.** El payload real y el request/response del exploit
quedan pendientes de re-ejecutar con una instancia viva.

## Objetivo
SQL injection vulnerability in WHERE clause allowing retrieval of hidden data

## Vulnerabilidad (teoría — el lab Apprentice clásico)
La query del producto filtra por categoría sin parametrizar:

```sql
SELECT * FROM products WHERE category = '<INPUT>' AND released = 1
```

Payload de la clase (el clásico de este lab):

```sql
' OR 1=1--
```

Resultado: `category = '' OR 1=1--' AND released = 1` → devuelve TODAS las filas
(incluidas las `released = 0`, ocultas).

## Explotación
PENDIENTE — re-ejecutar con instancia viva y capturar request/response real.

```bash
# Cuando haya instancia viva (ver README del pipeline):
python3 portswigger/scripts/solve-lab.py sqli 1 https://<instancia>.web-security-academy.net
```

## Evidencia
`evidence/sqli-01/request-01.txt` — solo smoke test (banner), sin payload. Re-capturar.

## Impacto
_(completar tras re-ejecutar)_

## Remediation
_(completar tras re-ejecutar)_

## Lección aprendida
**El pipeline funciona (banner verificado), pero un writeup sin payload real no vale para portfolio.**
Regla: solo marcar "hecho" con evidencia request/response completa del exploit.
