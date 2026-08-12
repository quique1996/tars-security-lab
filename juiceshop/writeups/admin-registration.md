# Admin Registration

| Campo | Valor |
|-------|-------|
| **Challenge** | Admin Registration |
| **Categoría** | Improper Input Validation |
| **Dificultad** | 3 (Hard) |

## Descripción de la Vulnerabilidad

El challenge consiste en registrar un usuario con privilegios de administrador. JuiceShop permite el registro de usuarios normales, pero el rol de administrador no debería ser asignable desde el formulario público. Sin embargo, la API no valida correctamente el campo de rol, permitiendo que un atacante incluya el rol `admin` en la petición de registro.

## Técnica / Payload Utilizado

1. Abrir la página de registro de JuiceShop (`/#/register`)
2. Interceptar la petición POST `/api/Users` con un proxy (Burp Suite / OWASP ZAP)
3. Añadir el campo `"role":"admin"` al JSON del cuerpo de la petición
4. La petición modificada se ve así:

```json
{
  "email": "attacker@juice-sh.op",
  "password": "12345",
  "passwordRepeat": "12345",
  "role": "admin"
}
```

5. El servidor acepta el campo `role` y crea el usuario con privilegios administrativos

## Evidencia

Al enviar la petición modificada, el servidor responde con HTTP 201 Created. El nuevo usuario puede acceder a rutas administrativas y la API confirma el rol asignado.

## Remediation

- Validar en el servidor (server-side) que el campo `role` nunca pueda ser establecido por el cliente durante el registro
- Implementar un allowlist estricto de campos aceptados en el cuerpo de la petición (ignorar campos no esperados como `role`)
- Asignar roles internamente en el backend, no basándose en input del usuario

## Lección Aprendida

Nunca confíes en los datos enviados por el cliente para controlar privilegios o roles. La validación debe ocurrir siempre en el servidor, no solo en el frontend. Un atacante puede añadir campos arbitrarios al JSON de cualquier petición.

---

> Writeup generado para OWASP JuiceShop — Lab de ciberseguridad TARS