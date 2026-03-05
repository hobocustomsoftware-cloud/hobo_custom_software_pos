@echo off
REM HoBo POS - Run Docker stack from repo root. Uses root .env when present.
set COMPOSE_FILE=compose/docker-compose.server.yml
if exist ".env" (
  if "%1"=="" (docker compose -f %COMPOSE_FILE% --env-file .env up -d --build) else (docker compose -f %COMPOSE_FILE% --env-file .env %*)
) else (
  echo Warning: .env not found. Using defaults from compose file.
  echo For production: copy .env.example to .env and set POSTGRES_PASSWORD, DJANGO_SECRET_KEY
  if "%1"=="" (docker compose -f %COMPOSE_FILE% up -d --build) else (docker compose -f %COMPOSE_FILE% %*)
)
