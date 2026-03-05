#!/usr/bin/env bash
# Run Playwright e2e (31 screenshots) inside Docker. Requires backend + frontend already up and healthy.
# Usage: from repo root: ./scripts/run_e2e_docker.sh
# Or: scripts/run_e2e_docker.sh
# Screenshots land in demo_results/feature_verification/

set -e
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

COMPOSE="docker compose"
docker compose version >/dev/null 2>&1 || COMPOSE="docker-compose"
COMPOSE_FILE="compose/docker-compose.yml"
ENV_FILE=".env.docker"
if [ ! -f "$ENV_FILE" ]; then ENV_FILE=".env"; fi
if [ ! -f "$ENV_FILE" ]; then ENV_FILE=""; fi

echo "==> Using compose file: $COMPOSE_FILE"
if [ -n "$ENV_FILE" ] && [ -f "$ENV_FILE" ]; then
  echo "==> Env file: $ENV_FILE"
  COMPOSE_ENV="--env-file $ENV_FILE"
else
  COMPOSE_ENV=""
fi

# Ensure stack is up and healthy
echo "==> Bringing up backend and frontend (if not already running)..."
$COMPOSE -f "$COMPOSE_FILE" $COMPOSE_ENV up -d --build backend frontend

echo "==> Waiting for backend and frontend to be healthy..."
HEALTHY=0
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
  BID=$($COMPOSE -f "$COMPOSE_FILE" $COMPOSE_ENV ps -q backend 2>/dev/null | head -1)
  FID=$($COMPOSE -f "$COMPOSE_FILE" $COMPOSE_ENV ps -q frontend 2>/dev/null | head -1)
  BACKEND_OK=""
  FRONTEND_OK=""
  [ -n "$BID" ] && BACKEND_OK=$(docker inspect --format '{{.State.Health.Status}}' "$BID" 2>/dev/null || true)
  [ -n "$FID" ] && FRONTEND_OK=$(docker inspect --format '{{.State.Health.Status}}' "$FID" 2>/dev/null || true)
  if [ "$BACKEND_OK" = "healthy" ] && [ "$FRONTEND_OK" = "healthy" ]; then
    echo "    Backend and frontend are healthy."
    HEALTHY=1
    break
  fi
  echo "    Waiting for health... backend=$BACKEND_OK frontend=$FRONTEND_OK ($i/20)"
  sleep 5
done
if [ "$HEALTHY" -ne 1 ]; then
  echo "    Timeout. Check: $COMPOSE -f $COMPOSE_FILE ps"
  exit 1
fi

mkdir -p demo_results/feature_verification
echo "==> Running e2e-tester (Playwright 31 screenshots)..."
$COMPOSE -f "$COMPOSE_FILE" $COMPOSE_ENV --profile e2e run --rm e2e-tester

echo "==> Done. Screenshots: demo_results/feature_verification/"
