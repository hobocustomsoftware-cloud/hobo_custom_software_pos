#!/usr/bin/env bash
# Cloud တင်ဖို့ လိုအပ်တာပဲ ကူးပြီး zip ထုတ်သည်။
# ပါမည်: compose/, WeldingProject/, yp_posf/, .env.example, DEPLOY_README.txt
# Run from repo root: bash scripts/build_cloud_deploy_zip.sh
# Windows မှာ \r error ပြရင်: sed -i 's/\r$//' scripts/build_cloud_deploy_zip.sh

set -e
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"
OUT_NAME="hobo_pos_cloud_deploy_$(date +%Y%m%d)"
TMP_DIR="${TMPDIR:-/tmp}/${OUT_NAME}"
ZIP_PATH="${REPO_ROOT}/${OUT_NAME}.zip"

echo "=== Cloud deploy zip (လိုအပ်တာပဲ) ==="
rm -rf "$TMP_DIR" "$ZIP_PATH"
mkdir -p "$TMP_DIR"

# ၁။ compose/ (docker-compose.yml စတာ)
cp -r compose "$TMP_DIR/"

# ၂။ WeldingProject/ (backend) - မလိုတာတွေ မကူးပါ
rsync -a WeldingProject/ "$TMP_DIR/WeldingProject/" \
  --exclude='__pycache__' \
  --exclude='*.pyc' \
  --exclude='.env' \
  --exclude='*.sqlite3' \
  --exclude='staticfiles' \
  --exclude='media' \
  --exclude='data' \
  --exclude='license.lic' \
  --exclude='*.log'

# ၃။ yp_posf/ (frontend) - node_modules, dist မကူးပါ (server မှာ build လုပ်မယ်)
rsync -a yp_posf/ "$TMP_DIR/yp_posf/" \
  --exclude='node_modules' \
  --exclude='dist' \
  --exclude='__pycache__' \
  --exclude='.env' \
  --exclude='*.log'

# ၄။ .env.example
if [ -f .env.example ]; then cp .env.example "$TMP_DIR/"; else touch "$TMP_DIR/.env.example"; fi

# ၅။ တင်နည်း အတိုချုပ်
cat > "$TMP_DIR/DEPLOY_README.txt" << 'EOF'
=== HoBo POS - Cloud တင်နည်း (လိုအပ်တာပဲ) ===

1. unzip လုပ်ပါ: unzip hobo_pos_cloud_deploy_*.zip && cd hobo_pos_cloud_deploy_*

2. .env ဖန်တီးပါ:
   cp .env.example .env
   nano .env
   ပြင်: DJANGO_SECRET_KEY, POSTGRES_PASSWORD, DJANGO_ALLOWED_HOSTS=your-ip-or-domain
   Demo: SKIP_LICENSE=true ထည့်ပါ

3. စတင်ပါ:
   docker compose -f compose/docker-compose.yml up -d --build

4. ဖွင့်ပါ: http://YOUR_IP:8888/app/
EOF

# zip ထုတ်ပါ
cd "$(dirname "$TMP_DIR")"
zip -rq "$ZIP_PATH" "$(basename "$TMP_DIR")"
rm -rf "$TMP_DIR"
echo "Created: $ZIP_PATH"
echo "Size:   $(du -h "$ZIP_PATH" | cut -f1)"
