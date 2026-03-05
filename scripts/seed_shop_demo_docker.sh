#!/usr/bin/env bash
# Docker backend container ထဲမှာ seed_shop_demo ပြေးရန်
# Repo root မှ run ပါ: ./scripts/seed_shop_demo_docker.sh [--shop pharmacy|mobile|...|all] [--flush]
# ဥပမာ: ./scripts/seed_shop_demo_docker.sh --shop pharmacy --flush
set -e
cd "$(dirname "$0")/.."
COMPOSE="docker compose"
docker compose version >/dev/null 2>&1 || COMPOSE="docker-compose"
COMPOSE_FILE=compose/docker-compose.yml

# Default: all, no flush
SHOP="all"
FLUSH=""
while [[ $# -gt 0 ]]; do
  case $1 in
    --shop) SHOP="$2"; shift 2 ;;
    --flush) FLUSH="--flush"; shift ;;
    pharmacy|pharmacy_clinic|mobile|computer|solar|hardware|general|all) SHOP="$1"; shift ;;
    *) echo "Usage: $0 [--shop pharmacy|mobile|computer|solar|hardware|general|all] [--flush]"; exit 1 ;;
  esac
done

echo "Running seed_shop_demo in Docker backend (--shop $SHOP ${FLUSH})..."
$COMPOSE -f "$COMPOSE_FILE" exec backend python manage.py seed_shop_demo --shop "$SHOP" ${FLUSH:+"$FLUSH"}
echo "Done. Login: admin@example.com / admin123 (သို့) 09123456789"
