# Forged Feedback

| Campo | Valor |
|-------|-------|
| **Challenge** | Forged Feedback |
| **Categoría** | Broken Access Control |
| **Dificultad** | 3 (Hard) |

## Descripción de la Vulnerabilidad

JuiceShop permite a los usuarios dejar feedback (reseñas con estrellas y comentarios). El challenge consiste en publicar feedback a nombre de otro usuario. La aplicación no valida correctamente que el ID de usuario en la petición coincida con el usuario autenticado.

## Técnica / Payload Utilizado

1. Iniciar sesión con cualquier usuario
2. Navegar a la página de feedback y dejar una reseña
3. Interceptar la petición POST `/api/Feedback` con un proxy
4. Modificar el campo `UserId` en el cuerpo de la petición para apuntar al ID de otro usuario (ej. el ID del administrador, que normalmente es 1)
5. La petición modificada:

```json
{
  "comment": "Feedback forjado",
  "rating": 5,
  "UserId": 2
}
```

6. El servidor acepta el feedback asociándolo al usuario cuyo ID fue especificado en el campo `UserId`

## Evidencia

El feedback aparece en la cuenta del usuario cuyo ID fue forjado, no en la del usuario autenticado que lo envió. El servidor responde con HTTP 201 Created.

## Remediation

- Derivar el `UserId` del token de autenticación / sesión del usuario, nunca del cuerpo de la petición
- Implementar validación server-side que compare el `UserId` en la petición con el usuario autenticado
- Rechazar peticiones donde el `UserId` no coincida con la sesión activa

## Lección Aprendida

Nunca confíes en datos del cliente para identidad. El ID del usuario debe derivarse siempre de la sesión autenticada en el servidor, no de campos editables en la petición.

---

> Writeup generado para OWASP JuiceShop — Lab de ciberseguridad TARS