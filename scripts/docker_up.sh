#!/usr/bin/env bash
# Docker full stack စတင်ရန် (postgres, redis, backend, frontend) - ပုံမှန် compose ဖိုင်
# Repo root မှ run ပါ: ./scripts/docker_up.sh
set -e
cd "$(dirname "$0")/.."
COMPOSE="docker compose"
docker compose version >/dev/null 2>&1 || COMPOSE="docker-compose"
COMPOSE_FILE=compose/docker-compose.yml
echo "Docker full stack စတင်နေပါတယ် (postgres, redis, backend, frontend)..."
$COMPOSE -f "$COMPOSE_FILE" up -d --build
echo ""
echo "ပြီးပါပြီ။ Postgres + Redis + Backend + Frontend ပါပြီးသား။"
echo "  - App: http://localhost (သို့) http://localhost/app/"
echo "  - Backend API: http://localhost:8000/api/"
echo "  - ရပ်ရန်: $COMPOSE -f $COMPOSE_FILE down"
