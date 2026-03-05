#!/bin/sh
# HoBo POS - Run Docker stack from repo root. Uses root .env when present.
COMPOSE_FILE=compose/docker-compose.server.yml
[ $# -eq 0 ] && set -- up -d --build
if [ -f .env ]; then
  exec docker compose -f "$COMPOSE_FILE" --env-file .env "$@"
else
  echo "Warning: .env not found. Using defaults from compose file."
  echo "For production: cp .env.example .env and set POSTGRES_PASSWORD, DJANGO_SECRET_KEY"
  exec docker compose -f "$COMPOSE_FILE" "$@"
fi
