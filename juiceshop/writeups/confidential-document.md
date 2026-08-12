# Confidential Document

| Campo | Valor |
|-------|-------|
| **Challenge** | Confidential Document |
| **Categoría** | Sensitive Data Exposure |
| **Dificultad** | 1 (Easy) |

## Descripción de la Vulnerabilidad

JuiceShop tiene un documento confidencial accesible a través del directorio de archivos públicos. El documento se encuentra en `/ftp/` y puede ser accedido mediante directory listing si el servidor no está configurado correctamente.

## Técnica / Payload Utilizado

1. Navegar a la URL `http://127.0.0.1:3000/ftp/`
2. Se observa un directory listing con archivos
3. Identificar el archivo `acquisitions.md` — un documento confidencial de la empresa
4. Descargarlo accediendo directamente a `http://127.0.0.1:3000/ftp/acquisitions.md`

## Evidencia

El archivo `acquisitions.md` contiene información confidencial sobre adquisiciones de la empresa. El contenido del documento confirma que es un documento interno no destinado al público.

## Remediation

- Deshabilitar directory listing en el servidor web
- Mover archivos confidenciales fuera del directorio público
- Implementar control de acceso basado en autenticación para archivos sensibles
- Configurar el servidor para retornar 403/404 en lugar de listar el contenido del directorio

## Lección Aprendida

La exposición de directorios y archivos confidenciales es una vulnerabilidad común. Los archivos públicos deben separarse claramente de los privados, y el servidor no debe listar el contenido de directorios.

---

> Writeup generado para OWASP JuiceShop — Lab de ciberseguridad TARS