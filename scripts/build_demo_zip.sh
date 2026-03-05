#!/usr/bin/env bash
# Demo folder ဖန်တီးပြီး လိုအပ်တာတွေပဲ ကူးကာ zip ထုတ်ခြင်း။
# Repo root မှ run ပါ: ./scripts/build_demo_zip.sh
# ထွက်လာမယ့် ဖိုင်: build/hobo_pos_demo.zip (ဖြည်ပြီး Docker နဲ့ trial တစ်လ စမ်းလို့ရသည်)
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BUILD_DIR="$REPO_ROOT/build"
DEMO_NAME="hobo_pos_demo"
DEMO_DIR="$BUILD_DIR/$DEMO_NAME"
ZIP_PATH="$BUILD_DIR/${DEMO_NAME}.zip"

cd "$REPO_ROOT"
mkdir -p "$BUILD_DIR"
rm -rf "$DEMO_DIR"
mkdir -p "$DEMO_DIR"

echo "Copying files into $DEMO_DIR ..."

# rsync with exclusions (same structure as repo so Docker build context works)
RSYNC_EXCLUDE=(
  --exclude='.git'
  --exclude='node_modules'
  --exclude='__pycache__'
  --exclude='*.pyc'
  --exclude='.env'
  --exclude='venv'
  --exclude='.venv'
  --exclude='.cursor'
  --exclude='*.log'
  --exclude='postgres_data'
  --exclude='.vscode'
  --exclude='dist'
  --exclude='.nuxt'
  --exclude='.next'
  --exclude='*.sqlite3'
  --exclude='media/*'
  --exclude='static_frontend'
  --exclude='license.lic'
  --exclude='data/machine_id'
)

# Copy main dirs (compose, WeldingProject, yp_posf, deploy, scripts)
for dir in compose WeldingProject yp_posf scripts; do
  if [[ -d "$REPO_ROOT/$dir" ]]; then
    if command -v rsync >/dev/null 2>&1; then
      rsync -a "${RSYNC_EXCLUDE[@]}" "$REPO_ROOT/$dir" "$DEMO_DIR/" || cp -r "$REPO_ROOT/$dir" "$DEMO_DIR/"
    else
      cp -r "$REPO_ROOT/$dir" "$DEMO_DIR/"
    fi
    (cd "$DEMO_DIR/$dir" && find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null; true)
    (cd "$DEMO_DIR/$dir" && find . -type d -name node_modules -exec rm -rf {} + 2>/dev/null; true)
  fi
done

# deploy/ for postgres backup mount (compose expects ../deploy/backup)
mkdir -p "$DEMO_DIR/deploy/backup"

# Docs for demo
mkdir -p "$DEMO_DIR/docs"
for f in RESET_TRIAL_20_OUTLETS.md SEED_SHOP_DEMO.md; do
  [[ -f "$REPO_ROOT/docs/$f" ]] && cp "$REPO_ROOT/docs/$f" "$DEMO_DIR/docs/"
done

# .env.example
if [[ -f "$REPO_ROOT/.env.example" ]]; then
  cp "$REPO_ROOT/.env.example" "$DEMO_DIR/"
fi
if [[ -f "$REPO_ROOT/compose/.env.docker.example" ]]; then
  cp "$REPO_ROOT/compose/.env.docker.example" "$DEMO_DIR/compose/.env.example" 2>/dev/null || true
fi

# Demo README
cat > "$DEMO_DIR/README_DEMO.md" << 'README'
# HoBo POS – Demo Trial တစ်လ စမ်းခြင်း

ဒီ folder ကို ဖြည်ပြီး Docker နဲ့ စမ်းလို့ရပါသည်။ **Demo trial တစ်လ** နဲ့ **တစ်ဆိုင်တည်း** သို့မဟုတ် **ဆိုင်ခွဲ ၃/၄/၅ ဆိုင်** စမ်းလို့ရအောင် ပါဝင်ပါသည်။

## လိုအပ်ချက်

- Docker + Docker Compose
- Port များ လွတ်ရမယ်: 8888 (Frontend), 8001 (Backend), 5434 (Postgres), 6380 (Redis)

## ၁။ Docker စတင်မယ်

```bash
cd hobo_pos_demo
docker compose -f compose/docker-compose.yml up -d --build
```

ပထမအကြိမ် build ကြာနိုင်ပါတယ် (၂–၅ မိနစ်)။

## ၂။ Demo DB ရှင်းပြီး Trial တစ်လ + ဆိုင်များ ထည့်မယ်

**တစ်ဆိုင်တည်း စမ်းမယ်:**
```bash
docker compose -f compose/docker-compose.yml exec backend python manage.py reset_trial_20_outlets --flush --outlets 1
```

**ဆိုင်ခွဲ ၃ ဆိုင် (သို့) ၅ ဆိုင် စမ်းမယ်:**
```bash
docker compose -f compose/docker-compose.yml exec backend python manage.py reset_trial_20_outlets --flush --outlets 3
# သို့
docker compose -f compose/docker-compose.yml exec backend python manage.py reset_trial_20_outlets --flush --outlets 5
```

## ၃။ App ဖွင့်မယ်

Browser မှာ: **http://localhost:8888/app/**

- **Login:** admin / admin123
- Trial က ယနေ့ကစပြီး ၃၀ ရက်။
- ပစ္စည်း/ categories ထည့်ချင်ရင်:  
  `docker compose -f compose/docker-compose.yml exec backend python manage.py seed_shop_demo --shop general`

## ရပ်မယ်

```bash
docker compose -f compose/docker-compose.yml down
```
README

echo "Creating zip: $ZIP_PATH"
(cd "$BUILD_DIR" && zip -rq "${DEMO_NAME}.zip" "$DEMO_NAME")

if [[ -f "$ZIP_PATH" ]]; then
  echo "Done. Demo zip: $ZIP_PATH"
  echo "Size: $(du -h "$ZIP_PATH" | cut -f1)"
else
  echo "Done. Folder: $DEMO_DIR (zip failed or skipped)"
fi
