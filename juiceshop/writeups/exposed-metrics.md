# Exposed Metrics

| Campo | Valor |
|-------|-------|
| **Challenge** | Exposed Metrics |
| **Categoría** | Sensitive Data Exposure |
| **Dificultad** | 1 (Easy) |

## Descripción de la Vulnerabilidad

JuiceShop expone un endpoint de métricas que debería estar restringido. El endpoint sigue el formato estándar de Prometheus y es accesible sin autenticación, revelando información sobre el uso de la aplicación.

## Técnica / Payload Utilizado

1. Identificar que el challenge menciona un sistema de monitoreo popular (Prometheus)
2. Prometheus usa un endpoint estándar `/metrics` para exponer métricas
3. Acceder a `http://127.0.0.1:3000/metrics`
4. El endpoint responde con métricas en formato Prometheus text format, exponiendo datos de uso de la aplicación

## Evidencia

El endpoint `/metrics` retorna datos en formato Prometheus que incluyen contadores de requests, latencia, y otros datos operacionales de la aplicación.

## Remediation

- Restringir el acceso al endpoint `/metrics` mediante autenticación o control de acceso basado en IP
- Mover el endpoint a un puerto interno o red privada
- Utilizar un reverse proxy para filtrar el acceso al endpoint de métricas

## Lección Aprendida

Los endpoints de monitoreo son a menudo olvidados en la configuración de seguridad. Deben recibir el mismo nivel de protección que cualquier endpoint administrativo.

---

> Writeup generado para OWASP JuiceShop — Lab de ciberseguridad TARS