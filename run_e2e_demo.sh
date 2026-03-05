#!/usr/bin/env bash
# Run E2E Demo (Register -> Wizard -> Product -> Sale) in headed browser.
# Ensures Docker stack is up, then runs Playwright and lists 31 screenshots.
set -e
REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_ROOT"

COMPOSE="docker compose"
docker compose version >/dev/null 2>&1 || COMPOSE="docker-compose"
COMPOSE_FILE="compose/docker-compose.yml"

echo "[1/4] Checking Docker..."
if ! docker info >/dev/null 2>&1; then
  echo "Docker is not running. Start Docker Desktop and retry."
  exit 1
fi

echo "[2/4] Starting backend and frontend if needed..."
$COMPOSE -f "$COMPOSE_FILE" up -d --build backend frontend 2>/dev/null || true
sleep 5

echo "[3/4] Running E2E demo (headed browser)..."
cd yp_posf
export PLAYWRIGHT_BASE_URL=http://localhost:80
export PLAYWRIGHT_DEMO_FLOW=1
export PLAYWRIGHT_HEADED=1
npx playwright test e2e/feature_verification.spec.js --project=chromium
EXIT=$?
cd ..

echo "[4/4] Listing screenshots in demo_results/feature_verification/"
if [ -d "demo_results/feature_verification" ]; then
  for f in demo_results/feature_verification/*.png; do [ -f "$f" ] && echo "  $(basename "$f")"; done | sort
  COUNT=$(ls -1 demo_results/feature_verification/*.png 2>/dev/null | wc -l)
  echo ""
  echo "Total: $COUNT / 31 screenshots"
  [ "$COUNT" -eq 31 ] && echo "All 31 screenshots saved in demo_results/feature_verification/"
else
  echo "Folder demo_results/feature_verification not found."
fi
exit $EXIT
