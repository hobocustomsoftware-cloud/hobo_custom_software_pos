#!/usr/bin/env bash
# Docker ထဲက data အားလုံး ဖျက်ပြီး အသစ်ပြန်စရန် (Postgres, media, license_data)
# ပြေးပြီးရင် Register ပြန်လုပ်ပြီး သို့မဟုတ် seed_demo_users ပြေးပြီး owner/demo123 နဲ့ စမ်းပါ။
set -e
cd "$(dirname "$0")/.."
COMPOSE="docker compose"
docker compose version >/dev/null 2>&1 || COMPOSE="docker-compose"

echo "===== Docker data reset (volumes ဖျက်ပြီး အသစ်ပြန်စမယ်) ====="
echo ""
echo "သတိပြုရန်: Postgres DB, media, license_data အားလုံး ပျက်သွားမယ်။"
read -p "ဆက်လုပ်မလား? (y/n): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
  echo "ပယ်လိုက်ပါပြီ။"
  exit 0
fi

echo ""
echo "[1/4] Containers ရပ်နေပါတယ်..."
$COMPOSE down
echo ""

echo "[2/4] Volumes ဖျက်နေပါတယ်..."
$COMPOSE down -v
echo ""

echo "[3/4] Frontend build ရှိမရှိ စစ်နေပါတယ်..."
if [ ! -f "yp_posf/dist/index.html" ]; then
  echo "  yp_posf/dist မရှိသေးပါ။ Frontend ပြန် build လုပ်ပါမယ်..."
  (cd yp_posf && npm run build)
  echo "  Build ပြီးပါပြီ။"
else
  echo "  yp_posf/dist ရှိပါပြီ။"
fi
echo ""

echo "[4/4] Docker ပြန်စတင်နေပါတယ်..."
$COMPOSE up -d
echo ""

echo "===== ပြီးပါပြီ ====="
echo "  - DB အသစ်ဖြစ်သွားပါပြီ။"
echo "  - စမ်းရန်: http://localhost:8000/app/ ဖွင့်ပြီး Register လုပ် သို့မဟုတ်: $COMPOSE exec backend python manage.py seed_demo_users (owner/demo123)"
echo "  - 401 / logo 404 ပျောက်ချင်: yp_posf မှာ npm run build ပြန်လုပ်ပြီး backend ပြန် start လုပ်ပါ။"
