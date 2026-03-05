#!/bin/sh
# Run after: docker compose -f compose/docker-compose.server.yml up -d (or ./run.sh)
# Ensures migrations, Unit seed, and superuser admin/admin123.

set -e
BACKEND="${COMPOSE_BACKEND:-compose-backend-1}"

echo "[1] Checking Docker containers..."
if ! docker ps --filter "name=compose-backend-1" --format "{{.Names}} {{.Status}}" | grep -q "Up"; then
  echo "Backend container not running. Start stack first: ./run.sh or docker compose -f compose/docker-compose.server.yml up -d"
  exit 1
fi

echo "[2] Applying migrations..."
docker exec "$BACKEND" python manage.py migrate --noinput

echo "[3] Seeding Myanmar units (viss, tical, etc.)..."
docker exec "$BACKEND" python manage.py seed_myanmar_units

echo "[4] Creating superuser admin / admin123 (if not exists)..."
echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.filter(username='admin').exists() or User.objects.create_superuser('admin', 'admin@example.com', 'admin123')" | docker exec -i "$BACKEND" python manage.py shell

echo ""
echo "Done. Frontend/App: http://localhost (Nginx) or http://localhost:8000 (Backend)"
echo "Login: admin / admin123"
