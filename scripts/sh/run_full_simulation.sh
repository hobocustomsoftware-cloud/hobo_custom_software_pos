#!/usr/bin/env bash
# =============================================================================
# HoBo POS - Full simulation and E2E stress test (single command, 100% automated)
# 0. Auto-setup: create venv + pip install if needed; npm install if node_modules missing
# 1. Start Django backend and Vue frontend in the background
# 2. Wait for both servers to be ready
# 3. Run 60-day simulation data (run_simulation_data)
# 4. Run Playwright E2E stress test (headless)
# 5. Stop background servers when done (pass or fail)
# Run from repo root: ./run_full_simulation.sh  (or bash run_full_simulation.sh)
# =============================================================================

set -e
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

# Use python3 if python is not available (e.g. WSL)
if command -v python &>/dev/null; then
  PYTHON_CMD=python
else
  PYTHON_CMD=python3
fi

# Canonical venv path: use VENV_DIR if set, else repo .venv (created if missing)
VENV_DIR="${VENV_DIR:-$ROOT_DIR/.venv}"
REQUIREMENTS_FILE="$ROOT_DIR/WeldingProject/requirements.txt"
FRONTEND_DIR="$ROOT_DIR/yp_posf"

BACKEND_URL="${BACKEND_URL:-http://127.0.0.1:8000}"
FRONTEND_URL="${FRONTEND_URL:-http://127.0.0.1:5173}"
FRONTEND_CHECK_URLS="${FRONTEND_CHECK_URLS:-http://localhost:5173/,http://localhost:5174/,http://127.0.0.1:5173/,http://127.0.0.1:5174/}"
BACKEND_HEALTH="${BACKEND_URL}/health/"
MAX_WAIT="${MAX_WAIT:-120}"

BACKEND_PID=""
FRONTEND_PID=""

source_venv() {
  if [[ -f "$VENV_DIR/bin/activate" ]]; then
    # shellcheck source=/dev/null
    source "$VENV_DIR/bin/activate"
    return 0
  fi
  if [[ -f "$VENV_DIR/Scripts/activate" ]]; then
    # Windows (Git Bash, etc.)
    # shellcheck source=/dev/null
    source "$VENV_DIR/Scripts/activate"
    return 0
  fi
  return 1
}

# ----- 0. Auto-setup: venv + backend deps + frontend deps -----
echo "[0/6] Auto-setup (venv + backend + frontend)..."

# Backend: ensure venv exists and Django (and deps) are installed
venv_exists() { [[ -f "$VENV_DIR/bin/activate" ]] || [[ -f "$VENV_DIR/Scripts/activate" ]]; }
if ! venv_exists; then
  echo "  Creating virtualenv at $VENV_DIR..."
  $PYTHON_CMD -m venv "$VENV_DIR"
fi
source_venv

if ! $PYTHON_CMD -c "import django" 2>/dev/null; then
  echo "  Installing backend dependencies..."
  if [[ -f "$REQUIREMENTS_FILE" ]]; then
    pip install -q -r "$REQUIREMENTS_FILE"
  else
    echo "  (no requirements.txt) Installing minimal Django stack..."
    pip install -q django djangorestframework djangorestframework-simplejwt django-cors-headers
  fi
fi
echo "  Backend deps OK."

# Frontend: npm install if node_modules missing
if ! [[ -d "$FRONTEND_DIR/node_modules" ]]; then
  echo "  Installing frontend dependencies (npm install)..."
  ( cd "$FRONTEND_DIR" && npm install )
else
  echo "  Frontend deps OK (node_modules present)."
fi

# Playwright: ensure Chromium is installed so the test runs headless without prompts
if command -v npx &>/dev/null; then
  ( cd "$FRONTEND_DIR" && npx playwright install chromium 2>/dev/null || true )
fi

echo "  Auto-setup done."
echo ""

# ----- Cleanup and trap (only after setup so we don't kill on early failure) -----
cleanup() {
  echo ""
  echo "[Cleanup] Stopping background servers..."
  if [[ -n "$BACKEND_PID" ]] && kill -0 "$BACKEND_PID" 2>/dev/null; then
    kill "$BACKEND_PID" 2>/dev/null || true
    echo "  Backend (PID $BACKEND_PID) stopped."
  fi
  if [[ -n "$FRONTEND_PID" ]] && kill -0 "$FRONTEND_PID" 2>/dev/null; then
    kill "$FRONTEND_PID" 2>/dev/null || true
    echo "  Frontend (PID $FRONTEND_PID) stopped."
  fi
  if command -v lsof &>/dev/null; then
    lsof -ti:8000 | xargs kill -9 2>/dev/null || true
    lsof -ti:5173 | xargs kill -9 2>/dev/null || true
    lsof -ti:5174 | xargs kill -9 2>/dev/null || true
  fi
}
trap cleanup EXIT INT TERM

# ----- 1. Start backend (Django) -----
echo "[1/6] Starting Django backend on ${BACKEND_URL}..."
(
  cd "$ROOT_DIR/WeldingProject"
  source_venv
  exec $PYTHON_CMD manage.py runserver 0.0.0.0:8000
) &
BACKEND_PID=$!
echo "  Backend PID: $BACKEND_PID"

# ----- 2. Start frontend (Vue/Vite) -----
echo "[2/6] Starting Vue frontend..."
(
  cd "$FRONTEND_DIR"
  exec npm run dev
) &
FRONTEND_PID=$!
echo "  Frontend PID: $FRONTEND_PID"

# ----- 3. Wait for both servers -----
echo "[3/6] Waiting for servers to be ready (max ${MAX_WAIT}s)..."

wait_for() {
  local url="$1"
  local name="$2"
  local elapsed=0
  while [[ $elapsed -lt $MAX_WAIT ]]; do
    local code
    code="$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 2 "$url" 2>/dev/null || echo 000)"
    if [[ "$code" =~ ^[23] ]]; then
      echo "  $name is ready."
      return 0
    fi
    sleep 2
    elapsed=$((elapsed + 2))
    echo "  Waiting for $name... ${elapsed}s"
  done
  echo "  ERROR: $name did not become ready in ${MAX_WAIT}s" >&2
  return 1
}

wait_for_frontend() {
  local elapsed=0
  while [[ $elapsed -lt $MAX_WAIT ]]; do
    local urls
    IFS=',' read -ra urls <<< "$FRONTEND_CHECK_URLS"
    for url in "${urls[@]}"; do
      url="${url%%/}"
      local code
      code="$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 2 "$url/" 2>/dev/null || echo 000)"
      if [[ "$code" =~ ^[23] ]]; then
        FRONTEND_URL="${url}"
        echo "  Frontend is ready at $FRONTEND_URL"
        return 0
      fi
    done
    sleep 2
    elapsed=$((elapsed + 2))
    echo "  Waiting for Frontend... ${elapsed}s"
  done
  echo "  ERROR: Frontend did not become ready in ${MAX_WAIT}s" >&2
  return 1
}

wait_for "$BACKEND_HEALTH" "Backend"
wait_for_frontend

# ----- 4. Run 60-day simulation data -----
echo "[4/6] Running 60-day simulation data (run_simulation_data)..."
(
  cd "$ROOT_DIR/WeldingProject"
  source_venv
  $PYTHON_CMD manage.py run_simulation_data
)
echo "  Simulation data done."

# ----- 5. Run Playwright E2E stress test (headless) -----
echo "[5/6] Running Playwright E2E stress test (headless)..."
(
  cd "$FRONTEND_DIR"
  export PLAYWRIGHT_BASE_URL="$FRONTEND_URL"
  npx playwright test tests/e2e_stress_test.spec.js --project=chromium
)
PLAYWRIGHT_EXIT=$?

# ----- 6. Summary -----
REPORT_DIR="$ROOT_DIR/yp_posf/simulation_reports"
LATEST_RUN=$(ls -td "$REPORT_DIR"/run_* 2>/dev/null | head -1)
echo ""
echo "========================================"
echo "Full simulation and test finished."
echo "========================================"
echo "Reports: $REPORT_DIR"
echo "  Latest run: ${LATEST_RUN:-<none>}"
echo "  - run_<timestamp>/business_day_report.json  (console/API errors)"
echo "  - run_<timestamp>/screenshots/             (01_dashboard.png ... 09_closing_dashboard.png)"
echo ""
if [[ $PLAYWRIGHT_EXIT -ne 0 ]]; then
  echo "Playwright exited with code $PLAYWRIGHT_EXIT (see above)."
  exit $PLAYWRIGHT_EXIT
fi
echo "Done."
