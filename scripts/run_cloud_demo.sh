#!/usr/bin/env bash
# Cloud Readiness Demo: fix backend (compose with .env), docker stats log, run demo in headed browser
set -e
REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"
COMPOSE="docker compose"
docker compose version >/dev/null 2>&1 || COMPOSE="docker-compose"
ENV_FILE=".env"
COMPOSE_FILE="compose/docker-compose.yml"

echo "[1] Starting stack with .env (fixes Postgres auth)..."
$COMPOSE -f "$COMPOSE_FILE" --env-file "$ENV_FILE" up -d --build
sleep 20

echo "[2] Logging docker stats to demo_results/performance_metrics.txt..."
mkdir -p demo_results
echo "=== docker stats at $(date) ===" > demo_results/performance_metrics.txt
docker stats --no-stream >> demo_results/performance_metrics.txt 2>&1 || true
(for i in 1 2 3 4 5 6 7 8 9 10; do docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" >> demo_results/performance_metrics.txt 2>&1; sleep 5; done) &
STATS_PID=$!

echo "[3] Running Cloud Readiness Demo (headed browser)..."
cd yp_posf
export PLAYWRIGHT_BASE_URL=http://localhost:80/app
export PLAYWRIGHT_HEADED=1
npx playwright test e2e/cloud_readiness_demo.spec.js --project=chromium --headed
EXIT=$?
kill $STATS_PID 2>/dev/null || true
cd ..

echo "Screenshots: demo_results/cloud_readiness/"
ls -la demo_results/cloud_readiness/*.png 2>/dev/null || true
echo "Performance log: demo_results/performance_metrics.txt"
exit $EXIT
