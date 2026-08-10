# PortSwigger Web Security Academy — Gimnasio Web (TARS Lab)

> Gimnasio de web security: 274 labs oficiales, 31 categorías, writeups al repo.
> Los labs NO son self-hostable (instancias cloud efímeras por cuenta de PortSwigger);
> este directorio es la capa de automatización + evidencia + writeups.

## Estado (canónico)

| Qué | Dónde |
|---|---|
| Estado máquina-legible (fuente de verdad) | `labs.json` (274 labs) |
| Tracker humano | `tracker.md` (regenerado desde `labs.json`, NO editar a mano) |
| Launcher + CLI de estado | `scripts/start-lab.sh` (corre en GEEKOM `/opt/portswigger/`) |
| Generador de tracker | `scripts/generate_tracker.py` |
| Writeups | `writeups/<categoria>/<id>.md` — 1 lab resuelto = 1 writeup |
| Sync GEEKOM → repo | `../scripts/portswigger-sync.sh` (Air) |

## Progreso

- **Resueltos:** (contar en `tracker.md` — Summary)
- **Writeups publicados:** `writeups/`

## Cómo se trabaja (flujo por lab)

1. **Abrir lab:** en GEEKOM → `start-lab.sh <categoria> <numero>` (ej: `start-lab.sh sqli 2`).
   Crea `NOTES.md` con plantilla (objetivo/recon/hipótesis/payloads/solución/evidencia/aprendizaje).
2. **Login + instancia:** la cuenta PortSwigger la crea y la controla Quique (Akamai bloquea
   headless). Abrir la URL del lab, login, pulsar **ACCESS THE LAB**, pegar la URL de
   instancia `*.web-security-academy.net` en `NOTES.md`.
3. **Resolver:** con Burp Community (`start-lab.sh burp`, proxy 127.0.0.1:8080) o curl.
   Evidencia (requests/responses reales) a `evidence/`.
4. **Marcar hecho:** `start-lab.sh status <cat> <num> hecho` → actualiza `labs.json` y regenera `tracker.md`.
5. **Publicar writeup:** `start-lab.sh publish <cat> <num>` → convierte `NOTES.md` en writeup
   formateado en `out/<cat>/<id>.md` (usa la plantilla del repo).
6. **Sync al repo:** en Air → `~/scripts/portswigger-sync.sh` → rsync GEEKOM → `portswigger/`
   (labs.json, tracker.md, writeups nuevos) → commit + push. El tracker del repo queda en cero
   conflictos con el de GEEKOM (misma fuente: labs.json).

## Categorías (31)

`sql-injection, cross-site-scripting, csrf, clickjacking, dom-based, cors, xxe, ssrf,
request-smuggling, os-command-injection, ssti, path-traversal, access-control (idor),
authentication, websockets, web-cache-poisoning, deserialization, info-disclosure,
business-logic, host-header, oauth, file-upload, jwt, essential-skills, prototype-pollution,
graphql, race-conditions, nosql, api-testing, llm-attacks, web-cache-deception`

## Por qué no hay Docker/local (verificado)

El namespace `portswigger/` en Docker Hub contiene solo imágenes de Burp Enterprise.
Cada lab es una instancia cloud por cuenta con backend de estado (wiener:peter, carrito,
exploit server, Collaborator). El "solved" se valida server-side. No es empaquetable.
Complemento local: DVWA / Juice Shop / WebGoat ya corren en GEEKOM (no entran al tracker).

## Reglas

- 1 lab resuelto = 1 writeup con evidencia real (request/response), no teoría.
- `labs.json` es la única fuente de estado; `tracker.md` se regenera, nunca se edita a mano.
- No inventar soluciones: un lab solo se marca `hecho` con banner "solved" verificado.
