#!/usr/bin/env bash
# ဆေးဆိုင် အပြည့်အစုံ simulation: Register → Login → Role → License → Payment → ကုန်ကျစရိတ် → Dollar rate → ဆိုင်ခွဲ → Manager/Staff → Product → Reports → P&L → Scan
# Backend (port 8000) နှင့် Frontend (port 5173) နှစ်ခုလုံး ဖွင့်ထားပါ။
#
# သုံးနည်း:
#   Terminal 1: cd WeldingProject && python manage.py runserver 0.0.0.0:8000
#   Terminal 2: cd yp_posf && npm run dev
#   Terminal 3: ./scripts/run_pharmacy_full_simulation.sh
#
# Screenshots: demo_results/simulation_screenshots/pharmacy_full_<timestamp>/
set -e
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

BASE_URL="${PLAYWRIGHT_BASE_URL:-http://127.0.0.1:5173}"

echo "============================================================"
echo "HoBo POS – ဆေးဆိုင် အပြည့်အစုံ Simulation"
echo "============================================================"
echo "Base URL: $BASE_URL"
echo ""

if ! command -v npx &>/dev/null; then
  echo "npx မတွေ့ပါ။ Node.js တပ်ဆင်ပါ။"
  exit 1
fi

cd "$REPO_ROOT/yp_posf"
if [ ! -d "node_modules" ]; then
  echo "npm install လုပ်နေပါတယ်..."
  npm install --legacy-peer-deps -q
fi
npx playwright install chromium 2>/dev/null || true

echo "Playwright ပြေးနေပါတယ် (pharmacy_full_flow)..."
PLAYWRIGHT_BASE_URL="$BASE_URL" npx playwright test e2e/pharmacy_full_flow.spec.js --project=chromium

LATEST=$(ls -td "$REPO_ROOT/demo_results/simulation_screenshots"/pharmacy_full_* 2>/dev/null | head -1)
if [ -n "$LATEST" ]; then
  echo ""
  echo "============================================================"
  echo "Screenshots သိမ်းပြီး folder: $LATEST"
  echo "============================================================"
  ls -la "$LATEST" 2>/dev/null || true
fi
