#!/bin/sh
# Run migrations and collectstatic before starting the app (Standalone/Demo).
# Used by docker-compose backend command on container start.
# Waits for Postgres to be ready before running migrations (in addition to depends_on: condition: service_healthy).

set -e

echo "[init] Waiting for database..."
max=30
i=0
while [ $i -lt $max ]; do
  if python -c "
import os; os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'WeldingProject.settings')
import django; django.setup()
from django.db import connection; connection.ensure_connection()
" 2>/dev/null; then
    echo "[init] Database ready."
    break
  fi
  i=$((i + 1))
  if [ $i -eq $max ]; then
    echo "[init] Database not ready after ${max}s, exiting."
    exit 1
  fi
  echo "[init] Retry $i/$max in 2s..."
  sleep 2
done

echo "[init] Running migrations..."
python manage.py migrate --noinput
echo "[init] Seeding base units..."
python manage.py seed_base_units
echo "[init] Collecting static files..."
python manage.py collectstatic --noinput --clear 2>/dev/null || true
echo "[init] Done. Starting application."
