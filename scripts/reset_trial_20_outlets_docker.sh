#!/usr/bin/env bash
# Docker backend ထဲမှာ reset_trial_20_outlets ပြေးရန်
# Repo root မှ run ပါ: ./scripts/reset_trial_20_outlets_docker.sh [--flush] [--outlets 1|3|4|5|20]
# ဥပမာ: ./scripts/reset_trial_20_outlets_docker.sh --flush --outlets 1   (တစ်ဆိုင်တည်း)
#         ./scripts/reset_trial_20_outlets_docker.sh --flush --outlets 5   (ဆိုင်ခွဲ ၅ ဆိုင်)
set -e
cd "$(dirname "$0")/.."
COMPOSE="docker compose"
docker compose version >/dev/null 2>&1 || COMPOSE="docker-compose"
COMPOSE_FILE=compose/docker-compose.yml

FLUSH=""
OUTLETS="1"
while [[ $# -gt 0 ]]; do
  case $1 in
    --flush) FLUSH="--flush"; shift ;;
    --outlets) OUTLETS="$2"; shift 2 ;;
    1|3|4|5|20) OUTLETS="$1"; shift ;;
    *) echo "Usage: $0 [--flush] [--outlets 1|3|4|5|20]"; exit 1 ;;
  esac
done

echo "Running reset_trial_20_outlets in Docker backend (trial တစ်လ + ဆိုင် $OUTLETS) ${FLUSH}..."
$COMPOSE -f "$COMPOSE_FILE" exec backend python manage.py reset_trial_20_outlets ${FLUSH:+"$FLUSH"} --outlets "$OUTLETS"
echo "Done. Login: admin / admin123"
