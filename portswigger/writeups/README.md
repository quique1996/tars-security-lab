# PortSwigger Writeups — Índice

> 1 lab resuelto = 1 writeup. Estructura: `writeups/<categoria>/<id>.md`
> (id = id del tracker, ej. `sqli-01`, `xss-30`). El id cruza con `tracker.md` y `labs.json`.

## Índice

| ID | Categoría | Lab | Dificultad | Fecha |
|---|---|---|---|---|
| sqli-01 | SQL injection | [SQLi en WHERE clause — hidden data](sqli/sqli-01.md) | Apprentice | 2026-08-05 |
| xss-30 | XSS | [Reflected XSS con CSP bypass](xss/xss-30.md) | Expert | 2026-08-05 |

## Plantilla (usar para cada writeup)

```markdown
# <Lab Name> — <Categoría>

## Info
- **Dificultad**: Apprentice / Practitioner / Expert
- **URL**: <link al lab>
- **Fecha**: <YYYY-MM-DD>
- **Estado**: SOLVED (verificado, banner "solved")

## Objetivo
<qué pide el lab>

## Reconocimiento
<endpoints, parámetros, headers, comportamiento observado>

## Vulnerabilidad
<qué bug es y por qué existe>

## Explotación
<request/response reales, paso a paso>

## Impacto
<qué se logra: RCE, data leak, account takeover...>

## Remediation
<cómo se arregla>

## Lección aprendida
<qué se lleva a bug bounty real>
```

## Origen del writeup

El flujo normal es: `start-lab.sh <cat> <num>` → resolver → `start-lab.sh status <cat> <num> hecho`
→ `start-lab.sh publish <cat> <num>` → `portswigger-sync.sh` (Air) trae el writeup al repo.
