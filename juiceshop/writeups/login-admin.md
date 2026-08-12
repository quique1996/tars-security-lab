# Login Admin

| Campo | Valor |
|-------|-------|
| **Challenge** | Login Admin |
| **Categoría** | Injection |
| **Dificultad** | 2 (Medium) |

## Descripción de la Vulnerabilidad

El challenge consiste en iniciar sesión con la cuenta del administrador de JuiceShop. La página de login es vulnerable a SQL Injection, permitiendo bypass de autenticación sin necesidad de conocer la contraseña del administrador.

## Técnica / Payload Utilizado

1. Navegar a la página de login (`/#/login`)
2. El email del administrador es `admin@juice-sh.op`
3. En el campo de password, usar SQL Injection para bypass de autenticación:
   - Email: `admin@juice-sh.op`
   - Password: `' OR 1=1--`
4. Alternativamente, si no se conoce el email, se puede usar:
   - Email: `' OR 1=1--`
   - Password: cualquier cosa
5. La inyección hace que la consulta SQL retorne verdadero para todas las filas, autenticando con el primer usuario (que es el admin)

## Evidencia

Tras enviar el payload, el sistema inicia sesión como administrador. La consulta SQL resultante es algo como:

```sql
SELECT * FROM Users WHERE email = 'admin@juice-sh.op' AND password = '' OR 1=1--'
```

## Remediation

- Utilizar consultas parametrizadas (prepared statements) en lugar de concatenación de strings para consultas SQL
- Implementar un ORM que maneje la sanitización de inputs automáticamente
- Validar y sanitizar todos los inputs del usuario en el servidor
- Implementar rate limiting en el endpoint de login

## Lección Aprendida

La SQL Injection es una de las vulnerabilidades más críticas y comunes. El uso de consultas parametrizadas elimina esta clase de ataque completamente. Nunca concatenes input de usuario en consultas SQL.

---

> Writeup generado para OWASP JuiceShop — Lab de ciberseguridad TARS