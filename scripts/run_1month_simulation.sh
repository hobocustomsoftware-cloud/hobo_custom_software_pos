#!/usr/bin/env bash
set -e
cd "$(dirname "$0")/.."
COMPOSE_FILE=compose/docker-compose.yml
ENV_FILE=.env

echo "============================================================"
echo " 1-Month Business Simulation Test"
echo "============================================================"

echo "[1/5] Fix Backend first: ensure stack is up..."
docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" up -d --build backend frontend
sleep 10

echo "[2/5] START browser and show Owner Registration (headed)..."
cd yp_posf
export PLAYWRIGHT_BASE_URL=http://localhost:80
npx playwright test e2e/one_month_simulation.spec.js --project=chromium --headed
EXIT=$?
cd ..

echo "[3/5] Phase 2: Run backend data (500+ products, 1000+ sales):"
echo "  docker compose -f $COMPOSE_FILE --env-file $ENV_FILE exec backend python manage.py simulation_1month_data"
echo "[4/5] Then run Phase 3-4 with: PLAYWRIGHT_LOGIN_EMAIL=... PLAYWRIGHT_LOGIN_PASSWORD=..."
echo "  cd yp_posf && npx playwright test e2e/one_month_simulation.spec.js -g 'Phase 3' --project=chromium"

echo "[5/5] Recording docker stats to performance_audit.md..."
mkdir -p demo_results
echo "# Performance Audit - 1-Month Simulation" > demo_results/performance_audit.md
echo "" >> demo_results/performance_audit.md
echo "## Peak RAM/CPU" >> demo_results/performance_audit.md
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" >> demo_results/performance_audit.md 2>&1 || true

echo "Screenshots: demo_results/one_month_simulation/"
ls demo_results/one_month_simulation/*.png 2>/dev/null || true
exit $EXIT
