# HoBo POS - Production Backend (build from repo root: docker build -f server/Dockerfile .)
# This file must be named exactly "Dockerfile" (no extension, e.g. not Dockerfile.txt).
# Multi-stage: frontend (Vue) + Django. TZ=Asia/Yangon for Myanmar.

# ---- Stage 1: Vue frontend ----
FROM node:22-bullseye AS frontend
WORKDIR /fe
COPY yp_posf/package*.json ./
ENV NODE_OPTIONS="--max-old-space-size=4096"
RUN npm cache clean --force && npm install --legacy-peer-deps
COPY yp_posf/ .
ARG VITE_API_URL=/api
ARG VITE_BASE=/app/
ENV VITE_API_URL=$VITE_API_URL VITE_BASE=$VITE_BASE
RUN npm run build

# ---- Stage 2: Django backend ----
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
# Yangon timezone (Myanmar)
ENV TZ=Asia/Yangon

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

WORKDIR /app

RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app

COPY server/requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY WeldingProject/ .
COPY --from=frontend /fe/dist /app/static_frontend
COPY server/init.sh /app/init.sh
RUN chmod +x /app/init.sh

RUN chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

# Single Dockerfile for both Standalone and Demo; Gunicorn as web server
CMD ["gunicorn", "WeldingProject.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "2", "--threads", "2", "--timeout", "60", "--access-logfile", "-", "--error-logfile", "-"]

HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/health/')" || exit 1
