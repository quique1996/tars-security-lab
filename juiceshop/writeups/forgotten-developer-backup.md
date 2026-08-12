# Forgotten Developer Backup

| Campo | Valor |
|-------|-------|
| **Challenge** | Forgotten Developer Backup |
| **Categoría** | Sensitive Data Exposure |
| **Dificultad** | 4 (Very Hard) |

## Descripción de la Vulnerabilidad

Un desarrollador olvidó un archivo de backup en el directorio público `/ftp/` de JuiceShop. El archivo tiene una extensión no permitida por el filtro de descarga del servidor, por lo que un acceso directo resulta en error. El desafío consiste en bypassear este filtro de tipo de archivo.

## Técnica / Payload Utilizado

1. Navegar a `http://127.0.0.1:3000/ftp/` y observar el directory listing
2. Identificar el archivo `package.json.bak` (o `eastere.gg` dependiendo de la versión) — un backup de configuración del desarrollador
3. Al intentar descargar el archivo directamente, el servidor bloquea archivos que no sean .pdf o .zip
4. Bypassear el filtro usando un Poison Null Byte: añadir `%00.pdf` al final del nombre del archivo
5. URL final: `http://127.0.0.1:3000/ftp/package.json.bak%2500.pdf`
   - `%25` es la codificación URL de `%`, por lo que `%2500` decodifica a `%00`
   - El filtro ve `.pdf` al final y permite la descarga
   - El servidor web trunca en el null byte y sirve el archivo .bak

## Evidencia

El archivo descargado contiene configuración del proyecto, incluyendo dependencias y posibles credenciales del desarrollador. El servidor sirvió el archivo a pesar de tener una extensión no permitida.

## Remediation

- Implementar un allowlist estricto de extensiones permitidas en lugar de un denylist
- Validar la extensión real del archivo en el servidor (no solo la extensión en la URL)
- Eliminar archivos de backup y configuración de directorios públicos
- Parchar el servidor contra ataques de Poison Null Byte

## Lección Aprendida

Los archivos de backup olvidados en directorios accesibles son una fuente común de filtración de información. El Poison Null Byte demuestra que los filtros basados en extensiones de URL son bypassables.

---

> Writeup generado para OWASP JuiceShop — Lab de ciberseguridad TARS