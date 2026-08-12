# Zero Stars

| Campo | Valor |
|-------|-------|
| **Challenge** | Zero Stars |
| **Categoría** | Improper Input Validation |
| **Dificultad** | 1 (Easy) |

## Descripción de la Vulnerabilidad

El challenge consiste en dar una reseña de cero estrellas a la tienda. El frontend de JuiceShop tiene una validación que impide seleccionar menos de una estrella en el formulario de feedback, pero el backend no valida este mismo criterio.

## Técnica / Payload Utilizado

1. Navegar a la página de feedback / complaint
2. El frontend usa un control de estrellas que tiene un mínimo de 1 estrella (no se puede seleccionar 0)
3. **Método 1 (DevTools):** Abrir las herramientas de desarrollador (F12) y modificar el valor del rating en el DOM o en el modelo Angular:
   - En la consola: `document.querySelector('[ng-reflect-model]').setAttribute('ng-reflect-model', '0')`
   - O modificar directamente la variable del modelo
4. **Método 2 (API bypass):** Interceptar la petición POST `/api/Feedback` y cambiar el valor de `rating` a `0`:

```json
{
  "comment": "Terrible",
  "rating": 0,
  "UserId": 1
}
```

5. **Método 3 (Angular manipulation):** Usar `ng.modify` o acceder al scope de Angular para cambiar el valor del modelo a 0

## Evidencia

El feedback con rating 0 se envía exitosamente. El servidor responde con HTTP 201 Created, aceptando la calificación de cero estrellas.

## Remediation

- Validar el rango del rating en el servidor (mínimo 1, máximo 5)
- Implementar validación server-side para todos los campos con restricciones
- No confiar en las validaciones del frontend como única capa de defensa

## Lección Aprendida

Las validaciones del frontend son solo para UX, no para seguridad. El backend debe reimplementar todas las validaciones. Un atacante puede enviar cualquier valor en la petición HTTP, independientemente de lo que el frontend permita.

---

> Writeup generado para OWASP JuiceShop — Lab de ciberseguridad TARS