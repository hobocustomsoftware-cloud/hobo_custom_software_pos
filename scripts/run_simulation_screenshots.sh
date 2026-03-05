#!/usr/bin/env bash
# Browser ဖွင့်ပြီး simulation စမ်းကာ screenshot များ ယူမယ်。
# Backend က 8000 မှာ run ထားရမယ် (သို့) ဒီ script က backend ကို မစတင်ပါ။
#
# သုံးနည်း:
#   1) Backend စတင်ပါ: source venv/bin/activate && cd WeldingProject && python manage.py runserver 0.0.0.0:8000
#   2) ဒီ script ပြေးပါ: ./scripts/run_simulation_screenshots.sh
#
# Screenshot များ: demo_results/simulation_screenshots/<timestamp>/
set -e
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

BACKEND_URL="${BACKEND_URL:-http://127.0.0.1:8000}"
# Vue app က /app/ မှာ serve လုပ်ထားရင် base URL က http://127.0.0.1:8000/app
BASE_URL="${BACKEND_URL}/app"

echo "============================================================"
echo "HoBo POS - Simulation + Screenshots (browser ဖွင့်မယ်)"
echo "============================================================"
echo "Backend URL: $BACKEND_URL"
echo "Playwright base: $BASE_URL"
echo ""

if ! command -v npx &>/dev/null; then
  echo "npx မတွေ့ပါ။ Node.js တပ်ဆင်ပါ: sudo apt install npm   သို့မဟုတ် https://nodejs.org"
  exit 1
fi

if ! curl -sf "${BACKEND_URL}/health/" >/dev/null 2>&1; then
  echo "Backend မရပါ။ စတင်ပါ:"
  echo "  source venv/bin/activate && cd WeldingProject && python manage.py runserver 0.0.0.0:8000"
  exit 1
fi
echo "Backend OK."

cd "$REPO_ROOT/yp_posf"
if [ ! -d "node_modules" ]; then
  echo "npm install လုပ်နေပါတယ်..."
  npm install --legacy-peer-deps -q
fi
npx playwright install chromium 2>/dev/null || true

echo "Playwright ပြေးနေပါတယ် (browser ပွင့်မယ်)..."
PLAYWRIGHT_BASE_URL="$BASE_URL" npx playwright test e2e/full_simulation.spec.js --project=chromium

LATEST=$(ls -td "$REPO_ROOT/demo_results/simulation_screenshots"/[0-9]* 2>/dev/null | head -1)
if [ -n "$LATEST" ]; then
  echo ""
  echo "============================================================"
  echo "Screenshots သိမ်းပြီး folder: $LATEST"
  echo "============================================================"
  ls -la "$LATEST" 2>/dev/null || true
fi
