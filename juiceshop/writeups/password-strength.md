# Password Strength

| Campo | Valor |
|-------|-------|
| **Challenge** | Password Strength |
| **Categoría** | Broken Authentication |
| **Dificultad** | 2 (Medium) |

## Descripción de la Vulnerabilidad

El challenge consiste en iniciar sesión como administrador usando su contraseña original, sin cambiarla previamente ni usar SQL Injection. La contraseña del administrador es extremadamente débil y puede ser adivinada o crackeada fácilmente.

## Técnica / Payload Utilizado

1. El email del administrador es `admin@juice-sh.op`
2. La contraseña por defecto del admin en JuiceShop es `admin123`
3. Simplemente iniciar sesión en `/#/login` con:
   - Email: `admin@juice-sh.op`
   - Password: `admin123`
4. Alternativamente, si se obtuvo el hash de la contraseña (de otros challenges), se puede crackear con john o hashcat:
   - `john --format=bcrypt hash.txt`
   - O usar rainbow tables para hashes débiles

## Evidencia

Las credenciales `admin@juice-sh.op` / `admin123` permiten iniciar sesión correctamente como administrador. La contraseña es trivialmente débil.

## Remediation

- Forzar políticas de contraseñas fuertes (mínimo 12 caracteres, mayúsculas, minúsculas, números, símbolos)
- No usar contraseñas por defecto en cuentas administrativas
- Implementar detección de contraseñas comunes (check against Have I Been Pwned o listas de contraseñas comunes)
- Requerir cambio de contraseña en el primer login

## Lección Aprendida

Las contraseñas débiles son uno de los vectores de ataque más simples y efectivos. "admin123" es una de las contraseñas más comunes en el mundo. Las políticas de contraseñas deben ser obligatorias y verificadas.

---

> Writeup generado para OWASP JuiceShop — Lab de ciberseguridad TARS