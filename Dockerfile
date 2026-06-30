# ── Etapa 1: Construcción con Maven ──────────────────────────────────────────
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Copiar definición del proyecto y resolver dependencias (caché de capas)
COPY pom.xml ./
RUN mvn dependency:go-offline -q

# Copiar el código fuente
COPY src ./src

# Compilar el proyecto
RUN mvn compile -q

# Copiar el archivo .env si existe (opcional); el generador lo usa en runtime
COPY .env* ./

# Ejecutar el generador: produce los archivos en /app/output/
RUN mvn exec:java -q

# ── Etapa 2: Servidor web con los archivos estáticos ──────────────────────────
FROM nginx:alpine

# Eliminar la página de bienvenida predeterminada de Nginx
RUN rm -rf /usr/share/nginx/html/*

# Copiar los archivos generados (index.html, styles.css, script.js)
COPY --from=builder /app/output /usr/share/nginx/html

# Exponer el puerto HTTP estándar
EXPOSE 80

# Nginx arranca en primer plano por defecto
CMD ["nginx", "-g", "daemon off;"]
