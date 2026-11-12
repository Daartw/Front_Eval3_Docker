# Frontend — Gestión de Productos

[![CI](https://github.com/Daartw/Front_Eval3_Docker/actions/workflows/ci.yml/badge.svg)](https://github.com/Daartw/Front_Eval3_Docker/actions/workflows/ci.yml)

Generador en **Java** que produce un sitio estático (HTML, CSS y JavaScript) servido con **Nginx** en Docker.
Es el frontend de una aplicación full stack dockerizada:

| Servicio | Repositorio | Puerto |
|---|---|---|
| Usuarios | [BackJs_Eval3_Docker](https://github.com/Daartw/BackJs_Eval3_Docker) | 8081 |
| Productos | [BackPy_Eval3_Docker](https://github.com/Daartw/BackPy_Eval3_Docker) | 8082 |
| Frontend (este) | `Front_Eval3_Docker` | 80 |

## Características

- Catálogo de productos (solo lectura) cargado desde el servicio de productos, con catálogo de respaldo si no responde.
- Registro de usuarios contra el servicio de usuarios, con validación en el formulario.
- Interfaz responsiva sin dependencias externas.
- Content Security Policy, cabeceras de seguridad en Nginx y salida segura de los datos del backend.

## Requisitos

- Java 17 o superior
- Maven 3.6 o superior

## Configuración

Las URLs de los backends se definen al **generar** el sitio, en este orden de prioridad:

1. Variables de entorno `BACKEND_USERS_URL` y `BACKEND_PRODUCTS_URL`.
2. Archivo `.env` (ver `.env.example`).
3. Valores por defecto: `http://localhost:8081` y `http://localhost:8082`.

Deben tener la forma `http(s)://host[:puerto]`.

## Generar y ver el sitio

```bash
mvn clean compile exec:java
```

Los archivos quedan en `output/` (`index.html`, `styles.css`, `script.js`). Como la página consulta los
backends, sírvela con un servidor web en vez de abrir el archivo directamente:

```bash
cd output && python -m http.server 8080      # http://localhost:8080
```

Recuerda autorizar ese origen en `CORS_ORIGINS` de ambos backends.

Con Docker:

```bash
docker build \
  --build-arg BACKEND_USERS_URL=http://localhost:8081 \
  --build-arg BACKEND_PRODUCTS_URL=http://localhost:8082 \
  -t front_eval3 .
docker run --rm -p 80:80 front_eval3
```

## Estructura del proyecto

```
.
├── pom.xml                      # Configuración Maven
├── Dockerfile                   # Construcción en dos etapas (Maven → Nginx)
├── nginx/default.conf           # Nginx con cabeceras de seguridad
└── src/main/java/com/eval3/frontend/
    └── StaticPageGenerator.java # Generador del sitio
```

## Seguridad

Ver [SECURITY.md](SECURITY.md) para las medidas implementadas y cómo reportar una vulnerabilidad.

## Autor

Daniel Araya Rebolledo — [@Daartw](https://github.com/Daartw)
