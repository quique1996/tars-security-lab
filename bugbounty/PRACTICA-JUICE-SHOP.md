# Practica Lab — OWASP Juice Shop (mrpuff0420)

LAB LOCAL, sin RoE/PII. Entrena tecnica para DPG/AD y Aikido.

## Setup
- GEEKOM: container `lab-juice-shop` (Up), red `bugbounty-net`.
- Container `bugbounty` (Playwright) alcanza `http://lab-juice-shop:3000` (STATUS 200).
- Scripts: juice_practice.py (register/login/JWT), juice_idor.py (IDOR test).

## Resultado del entrenamiento (2026-08-08)
1. Register 2 users (alice id=27, bob id=28) -> 201.
2. Login -> 200, JWT emitido (`eyJ...`).
3. **IDOR/BOLA demostrado**: con token de customer (role=customer),
   `GET /api/Users/{id}` devuelve 200 con datos de OTROS usuarios:
   - id=1 -> admin@juice-sh.op (role=admin)  ← lectura cross-user no autorizada
   - id=28 -> bob (role=customer)
   - Sin validacion de ownership en el endpoint.

## Mapeo a programas reales
| Juice Shop (lab) | DPG/AD real | Aikido real |
|---|---|---|
| `/api/Users/{id}` IDOR | `/api/consent?authId=<UUID>` | `/api/accounts/getAccountDetails` |
| customer lee admin | swap authId UUID | BOLA tenant: leer cuenta ajena |
| numero secuencial | UUID (sandwich v1 si aplica) | object ID en JWT/response |

## Lecciones para el real
- Usar 2 cuentas propias para demostrar impacto (no cuentas ajenas reales).
- Throttle 0.25s (5 req/seg) respetado en script.
- En DPG: verificar version UUID (v1 vs v4) antes de reportar IDOR.
- En Aikido: necesita tenant trial @intigriti.me + 2 workspaces para BOLA.

## Compliance
- Lab local: NO aplica RoE. Pero entrenamos con los mismos habits:
  header Intigriti (en reales), sin scanners, throttle, sin PII.
