# Política de seguridad

## Reportar una vulnerabilidad

Si encuentras un problema de seguridad, **no abras un issue público**. Usa
**Security → Report a vulnerability** en este repositorio o escribe a
**danie.arayar@duocuc.cl** con:

- Descripción del problema y su impacto.
- Pasos para reproducirlo.
- Versión o commit afectado.

Responderé dentro de 7 días.

## Medidas implementadas

- Los datos que llegan del backend se muestran como **texto**, nunca como HTML (previene XSS).
- **Content Security Policy** estricta: solo scripts y estilos propios, y conexiones únicamente a los dos backends configurados.
- Sin manejadores de eventos en línea ni scripts en línea.
- Las URLs de los backends se validan al generar el sitio.
- Nginx con cabeceras de seguridad, sin versión expuesta y sin servir archivos ocultos.

## Al desplegar

- Publica el sitio y los backends detrás de HTTPS.
- No guardes secretos en `.env`: este proyecto solo espera ahí las URLs públicas de los backends.
