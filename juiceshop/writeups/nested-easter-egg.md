# Nested Easter Egg

| Campo | Valor |
|-------|-------|
| **Challenge** | Nested Easter Egg |
| **Categoría** | Cryptographic Issues |
| **Dificultad** | 4 (Very Hard) |

## Descripción de la Vulnerabilidad

JuiceShop contiene un easter egg que está oculto detrás de múltiples capas de cifrado. El primer easter egg es relativamente fácil de encontrar, pero el easter egg anidado ('el verdadero') requiere descifrar una cadena codificada en base64 y luego aplicar criptografía adicional.

## Técnica / Payload Utilizado

1. Encontrar el primer easter egg navegando a `http://127.0.0.1:3000/ftp/` y descargando `eastere.gg`
2. El archivo contiene una pista en base64
3. Decodificar el base64: `echo <base64_string> | base64 -d`
4. La cadena decodificada contiene otra capa — puede ser ROT13 o cifrado César
5. Aplicar ROT13 a la cadena decodificada
6. El resultado revela el easter egg anidado con un código/clave
7. En algunas versiones, el archivo `eastere.gg` está bloqueado por el filtro de extensiones, requiriendo Poison Null Byte (`%2500.pdf`) para descargarlo

## Evidencia

La cadena decodificada y descifrada revela un easter egg oculto. La clave del challenge se envía al resolver el puzzle criptográfico.

## Remediation

- No almacenar información sensible ni secretos en archivos accesibles públicamente
- No ofuscar como método de seguridad — usar cifrado real con claves adecuadas
- Eliminar archivos de desarrollo/easter eggs de entornos de producción

## Lección Aprendida

La ofuscación no es seguridad. Múltiples capas de codificación (base64, ROT13) pueden ser revertidas fácilmente. Los easter eggs pueden exponer funcionalidad oculta o información sensible.

---

> Writeup generado para OWASP JuiceShop — Lab de ciberseguridad TARS