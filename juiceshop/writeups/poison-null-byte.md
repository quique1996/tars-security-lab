# Poison Null Byte

| Campo | Valor |
|-------|-------|
| **Challenge** | Poison Null Byte |
| **Categoría** | Improper Input Validation |
| **Dificultad** | 4 (Very Hard) |

## Descripción de la Vulnerabilidad

El challenge consiste en bypassear un control de seguridad usando un Poison Null Byte para acceder a un archivo que no está destinado a ser visto. JuiceShop tiene un filtro que solo permite descargar archivos con extensión .pdf o .zip del directorio `/ftp/`, pero este filtro puede ser bypassado con un null byte.

## Técnica / Payload Utilizado

1. Navegar a `http://127.0.0.1:3000/ftp/` para ver los archivos disponibles
2. Identificar un archivo de interés que no tenga extensión .pdf o .zip (ej. `eastere.gg`)
3. El filtro del servidor verifica que la extensión del archivo solicitado sea .pdf o .zip
4. Usar Poison Null Byte en la URL: `http://127.0.0.1:3000/ftp/eastere.gg%2500.pdf`
   - `%25` decodifica a `%` → `%2500` → `%00` → null byte
   - El filtro ve `.pdf` al final y permite la descarga
   - El servidor web procesa la URL y trunca en el null byte, sirviendo `eastere.gg`
5. El archivo se descarga exitosamente

## Evidencia

El archivo `eastere.gg` (u otro archivo no permitido) se descarga correctamente a pesar del filtro de extensiones. El contenido del archivo es accesible.

## Remediation

- No depender de la validación de extensiones de URL como control de seguridad
- Implementar un allowlist de archivos permitidos en lugar de validar extensiones
- Usar el manejador de archivos del framework que no sea vulnerable a null bytes
- Mover archivos sensibles fuera del directorio público
- Actualizar el servidor web/framework a versiones que no sean vulnerables a Poison Null Byte

## Lección Aprendida

Los Poison Null Bytes son una técnica clásica para bypassear filtros basados en strings. La diferencia entre cómo el filtro de seguridad interpreta un string y cómo el sistema de archivos lo procesa puede ser explotada. La validación debe hacerse en múltiples capas.

---

> Writeup generado para OWASP JuiceShop — Lab de ciberseguridad TARS