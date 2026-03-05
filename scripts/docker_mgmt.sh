#!/usr/bin/env bash
# Run Django management commands inside Docker backend (avoids "postgres host not found" and /app I/O errors).
# Usage: ./scripts/docker_mgmt.sh seed_demo_users
#        ./scripts/docker_mgmt.sh seed_demo_data
# Prerequisite: docker compose up -d (at least postgres + backend running).
set -e
cd "$(dirname "$0")/.."
COMPOSE="docker compose"
command -v docker >/dev/null 2>&1 || { echo "Docker not found."; exit 1; }
docker compose version >/dev/null 2>&1 || COMPOSE="docker-compose"
if [ $# -eq 0 ]; then
  echo "Usage: $0 <command> [args...]"
  echo "Example: $0 seed_demo_users"
  echo "         $0 seed_demo_data"
  echo "Ensure backend is running first: $COMPOSE up -d"
  exit 1
fi
exec $COMPOSE exec backend python manage.py "$@"
