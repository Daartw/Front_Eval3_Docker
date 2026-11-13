# ── Etapa 1: Construcción con Maven ──────────────────────────────────────────
FROM maven:3.9-eclipse-temurin-25 AS builder

WORKDIR /app

# Copiar definición del proyecto y resolver dependencias (caché de capas)
COPY pom.xml ./
RUN mvn dependency:go-offline -q

# Copiar el código fuente
COPY src ./src

# Compilar el proyecto
RUN mvn compile -q

# URLs de los backends. Se pueden entregar al construir:
#   docker build --build-arg BACKEND_USERS_URL=http://mi-servidor:8081 \
#                --build-arg BACKEND_PRODUCTS_URL=http://mi-servidor:8082 -t front_eval3 .
# Si no se entregan, el generador usa el archivo .env (si existe) o localhost.
ARG BACKEND_USERS_URL=""
ARG BACKEND_PRODUCTS_URL=""
ENV BACKEND_USERS_URL=${BACKEND_USERS_URL} \
    BACKEND_PRODUCTS_URL=${BACKEND_PRODUCTS_URL}

# Copiar el archivo .env si existe (opcional). Solo contiene las URLs públicas de los
# backends y queda en esta etapa de construcción: no llega a la imagen final.
COPY .env* ./

# Ejecutar el generador: produce los archivos en /app/output/
RUN mvn exec:java -q

# ── Etapa 2: Servidor web con los archivos estáticos ─────────────────────────
FROM nginx:stable-alpine

# Configuración propia: cabeceras de seguridad y sin página de bienvenida
RUN rm -rf /usr/share/nginx/html/*
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# Copiar los archivos generados (index.html, styles.css, script.js)
COPY --from=builder /app/output /usr/share/nginx/html

# Exponer el puerto HTTP estándar
EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget -qO /dev/null http://127.0.0.1/ || exit 1

# Nginx arranca en primer plano por defecto
CMD ["nginx", "-g", "daemon off;"]
