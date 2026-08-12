# Error Handling

| Campo | Valor |
|-------|-------|
| **Challenge** | Error Handling |
| **Categoría** | Security Misconfiguration |
| **Dificultad** | 1 (Easy) |

## Descripción de la Vulnerabilidad

JuiceShop no maneja los errores de manera consistente ni segura. Al provocar un error en la aplicación (por ejemplo, enviando input inválido o accediendo a rutas inexistentes con parámetros especiales), el servidor responde con stack traces o mensajes de error que exponen información sensible sobre la infraestructura.

## Técnica / Payload Utilizado

1. Existen múltiples formas de resolver este challenge:
   - Enviar input inválido a formularios (ej. caracteres especiales en campos de búsqueda)
   - Manipular parámetros de URL con valores inesperados
   - Acceder a endpoints REST con métodos HTTP no soportados
2. Un método común es acceder a: `http://127.0.0.1:3000/rest/products/search?q='` (con una comilla simple que provoca un error SQL)
3. El servidor retorna un error con stack trace que incluye información de la base de datos y del framework

## Evidencia

La respuesta del servidor incluye un stack trace completo con información sobre el framework (Express.js), la base de datos (SQLite/PostgreSQL), y rutas internas del servidor.

## Remediation

- Implementar manejo de errores global con middleware que capture todas las excepciones
- Nunca exponer stack traces o mensajes de error técnicos en respuestas a usuarios
- Utilizar mensajes de error genéricos para el cliente mientras se loguean los detalles internamente
- Configurar `NODE_ENV=production` para suprimir detalles de error en Express.js

## Lección Aprendida

Los errores no manejados correctamente exponen información crítica sobre la infraestructura que un atacante puede usar para planear ataques más sofisticados. El manejo de errores es una capa fundamental de defensa.

---

> Writeup generado para OWASP JuiceShop — Lab de ciberseguridad TARS