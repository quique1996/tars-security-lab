# Repetitive Registration

| Campo | Valor |
|-------|-------|
| **Challenge** | Repetitive Registration |
| **Categoría** | Improper Input Validation |
| **Dificultad** | 1 (Easy) |

## Descripción de la Vulnerabilidad

El challenge consiste en seguir el principio DRY (Don't Repeat Yourself) durante el registro de un usuario. JuiceShop requiere que el usuario confirme su contraseña en el formulario de registro, pero esta validación puede ser bypassada.

## Técnica / Payload Utilizado

1. Navegar a la página de registro (`/#/register`)
2. El formulario requiere: email, password, y password repeat (confirmación)
3. **Método 1 (UI bypass):** Usar las herramientas de desarrollador del navegador (F12) para eliminar el campo de confirmación de contraseña del DOM, luego enviar el formulario con solo email y password
4. **Método 2 (API bypass):** Interceptar la petición POST `/api/Users` con un proxy y eliminar el campo `passwordRepeat` del JSON
5. **Método 3 (UI manipulation):** Modificar el campo de validación en el HTML para que acepte cualquier valor, o cambiar el valor del campo `passwordRepeat` vía JavaScript en la consola: `document.getElementById('passwordRepeat').value = document.getElementById('password').value`

## Evidencia

El usuario se registra exitosamente sin que los campos de contraseña coincidan o sin el campo de confirmación. El servidor responde con HTTP 201 Created.

## Remediation

- La validación de confirmación de contraseña debe hacerse en el servidor, no solo en el cliente
- Implementar validación server-side de que `password === passwordRepeat`
- No depender de validaciones del frontend como control de seguridad

## Lección Aprendida

Las validaciones del lado del cliente (frontend) son puramente cosméticas desde una perspectiva de seguridad. Un atacante puede modificar cualquier cosa en el navegador: el DOM, JavaScript, las peticiones HTTP. La validación real debe estar en el servidor.

---

> Writeup generado para OWASP JuiceShop — Lab de ciberseguridad TARS