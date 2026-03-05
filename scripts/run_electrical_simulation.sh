#!/usr/bin/env bash
# =============================================================================
# လျှပ်စစ်ပစ္စည်းဆိုင် (Electrical/Solar) – တစ်လစာ feature list simulation
# Browser ဖွင့်ပြီး Register (သို့) Seeded login → Setup (electronic_solar) → feature list အကုန် screenshot
#
# Optional: တစ်လစာ data ထည့်ချင်ရင် RUN_SIMULATE_MONTH=1 သတ်မှတ်ပါ။
#   Login: owner@solar.com / demo123 (ဝန်ထမ်း/owner, manager, cashier, inventory စတာ simulate_month မှာ ပါပြီး)
#
# Prerequisites:
#   - ./scripts/setup_venv_ubuntu2510.sh (done once)
#   - Node 20+ and npm (for frontend)
#
# Usage:
#   chmod +x scripts/run_electrical_simulation.sh
#   ./scripts/run_electrical_simulation.sh
#
# With 1-month data (then login owner@solar.com in e2e):
#   RUN_SIMULATE_MONTH=1 ./scripts/run_electrical_simulation.sh
# =============================================================================

set -e
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

VENV_DIR="${VENV_DIR:-$REPO_ROOT/venv}"
BACKEND_PORT="${BACKEND_PORT:-8000}"
FRONTEND_PORT="${FRONTEND_PORT:-5173}"
BASE_URL="http://127.0.0.1:${FRONTEND_PORT}"
SCREENSHOT_BASE="$REPO_ROOT/demo_results/simulation_screenshots"
RUN_SIMULATE_MONTH="${RUN_SIMULATE_MONTH:-0}"

echo "============================================================"
echo "HoBo POS - လျှပ်စစ်ပစ္စည်းဆိုင် Simulation (Electrical/Solar)"
echo "============================================================"

# ---- 1) Activate venv ----
if [ ! -d "$VENV_DIR" ]; then
  echo "Venv not found. Run first: ./scripts/setup_venv_ubuntu2510.sh"
  exit 1
fi
# shellcheck source=/dev/null
source "$VENV_DIR/bin/activate"

# ---- 2) Optional: one-month simulation (DB only, then e2e will login) ----
if [ "$RUN_SIMULATE_MONTH" = "1" ]; then
  echo "[0/5] Running one-month simulation (simulate_month --skip-delay)..."
  cd "$REPO_ROOT/WeldingProject"
  python manage.py migrate --noinput -q 2>/dev/null || true
  python manage.py simulate_month --skip-delay
  cd "$REPO_ROOT"
  echo "  Done. E2E will login as owner@solar.com / demo123"
fi

# ---- 3) Start Backend (background) ----
echo "[1/5] Starting Backend on port $BACKEND_PORT ..."
cd "$REPO_ROOT/WeldingProject"
python manage.py migrate --noinput -q 2>/dev/null || true
python manage.py runserver "0.0.0.0:${BACKEND_PORT}" &
BACKEND_PID=$!
cd "$REPO_ROOT"

# ---- 4) Start Frontend (background) ----
echo "[2/5] Starting Frontend on port $FRONTEND_PORT ..."
if [ ! -d "$REPO_ROOT/yp_posf/node_modules" ]; then
  (cd "$REPO_ROOT/yp_posf" && npm install --legacy-peer-deps -q)
fi
(cd "$REPO_ROOT/yp_posf" && npm run dev) &
FRONTEND_PID=$!

# ---- 5) Wait for both ----
echo "[3/5] Waiting for Backend and Frontend..."
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

# ---- 6) Run Playwright electrical shop simulation ----
echo "[4/5] Running Playwright electrical shop simulation (browser)..."
mkdir -p "$SCREENSHOT_BASE"
cd "$REPO_ROOT/yp_posf"
if [ ! -d "node_modules" ]; then
  npm install --legacy-peer-deps -q
fi
npx playwright install chromium 2>/dev/null || true

if [ "$RUN_SIMULATE_MONTH" = "1" ]; then
  USE_SEEDED_LOGIN=1 SEEDED_USER=owner@solar.com SEEDED_PASS=demo123 \
    PLAYWRIGHT_BASE_URL="$BASE_URL" npx playwright test e2e/electrical_shop_simulation.spec.js --project=chromium
else
  PLAYWRIGHT_BASE_URL="$BASE_URL" npx playwright test e2e/electrical_shop_simulation.spec.js --project=chromium
fi
E2E_EXIT=$?

# ---- 7) Stop background ----
kill $BACKEND_PID $FRONTEND_PID 2>/dev/null || true
wait $BACKEND_PID $FRONTEND_PID 2>/dev/null || true

# ---- 8) Report ----
LATEST=$(ls -td "$SCREENSHOT_BASE"/electrical_* 2>/dev/null | head -1)
if [ -n "$LATEST" ]; then
  echo ""
  echo "============================================================"
  echo "Screenshots saved to:"
  echo "  $LATEST"
  echo "============================================================"
  ls -la "$LATEST" 2>/dev/null || true
fi
exit $E2E_EXIT
