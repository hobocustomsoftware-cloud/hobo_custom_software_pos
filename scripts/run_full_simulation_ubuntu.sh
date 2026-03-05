#!/usr/bin/env bash
# =============================================================================
# Full simulation: Register → Setup Wizard → feature list → daily report
# Starts Backend + Frontend, runs Playwright, saves screenshots to folder.
# Ubuntu 25.10 / venv. Run from repo root.
#
# Prerequisites:
#   - ./scripts/setup_venv_ubuntu2510.sh (done once)
#   - Node 20+ and npm (for frontend)
#
# Usage:
#   chmod +x scripts/run_full_simulation_ubuntu.sh
#   ./scripts/run_full_simulation_ubuntu.sh
# =============================================================================

set -e
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

VENV_DIR="${VENV_DIR:-$REPO_ROOT/venv}"
BACKEND_PORT="${BACKEND_PORT:-8000}"
FRONTEND_PORT="${FRONTEND_PORT:-5173}"
BASE_URL="http://127.0.0.1:${FRONTEND_PORT}"
SCREENSHOT_BASE="$REPO_ROOT/demo_results/simulation_screenshots"

echo "============================================================"
echo "HoBo POS - Full simulation (Register → Setup → Features → Screenshots)"
echo "============================================================"

# ---- 1) Activate venv ----
if [ ! -d "$VENV_DIR" ]; then
  echo "Venv not found. Run first: ./scripts/setup_venv_ubuntu2510.sh"
  exit 1
fi
# shellcheck source=/dev/null
source "$VENV_DIR/bin/activate"

# ---- 2) Start Backend (background) ----
echo "[1/4] Starting Backend on port $BACKEND_PORT ..."
cd "$REPO_ROOT/WeldingProject"
python manage.py migrate --noinput -q 2>/dev/null || true
python manage.py runserver "0.0.0.0:${BACKEND_PORT}" &
BACKEND_PID=$!
cd "$REPO_ROOT"

# ---- 3) Start Frontend (background) ----
echo "[2/4] Starting Frontend on port $FRONTEND_PORT ..."
if [ ! -d "$REPO_ROOT/yp_posf/node_modules" ]; then
  (cd "$REPO_ROOT/yp_posf" && npm install --legacy-peer-deps -q)
fi
(cd "$REPO_ROOT/yp_posf" && npm run dev) &
FRONTEND_PID=$!

# ---- 4) Wait for both ----
echo "[3/4] Waiting for Backend and Frontend..."
for i in $(seq 1 60); do
  if curl -sf "http://127.0.0.1:${BACKEND_PORT}/health/" >/dev/null 2>&1; then
    BACKEND_UP=1
  else
    BACKEND_UP=0
  fi
  if curl -sf "$BASE_URL" >/dev/null 2>&1; then
    FRONTEND_UP=1
  else
    FRONTEND_UP=0
  fi
  if [ "$BACKEND_UP" = 1 ] && [ "$FRONTEND_UP" = 1 ]; then
    echo "  Backend and Frontend are up."
    break
  fi
  if [ "$i" -eq 60 ]; then
    echo "  Timeout waiting for services. Stopping..."
    kill $BACKEND_PID $FRONTEND_PID 2>/dev/null || true
    exit 1
  fi
  sleep 1
done
sleep 2

# ---- 5) Run Playwright full simulation ----
echo "[4/4] Running Playwright full simulation (screenshots to demo_results/simulation_screenshots/)..."
mkdir -p "$SCREENSHOT_BASE"
cd "$REPO_ROOT/yp_posf"
if [ ! -d "node_modules" ]; then
  npm install --legacy-peer-deps -q
fi
npx playwright install chromium 2>/dev/null || true
PLAYWRIGHT_BASE_URL="$BASE_URL" npx playwright test e2e/full_simulation_spec.js --project=chromium
E2E_EXIT=$?

# ---- 6) Stop background ----
kill $BACKEND_PID $FRONTEND_PID 2>/dev/null || true
wait $BACKEND_PID $FRONTEND_PID 2>/dev/null || true

# ---- 7) Report ----
LATEST=$(ls -td "$SCREENSHOT_BASE"/[0-9]* 2>/dev/null | head -1)
if [ -n "$LATEST" ]; then
  echo ""
  echo "============================================================"
  echo "Screenshots saved to folder:"
  echo "  $LATEST"
  echo "============================================================"
  ls -la "$LATEST" 2>/dev/null || true
fi
exit $E2E_EXIT
