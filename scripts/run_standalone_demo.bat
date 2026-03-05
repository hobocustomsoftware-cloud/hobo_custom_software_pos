@echo off
REM Run after: run.bat (or docker compose -f compose/docker-compose.server.yml --env-file .env up -d)
REM Ensures migrations, Unit seed, and superuser admin/admin123.
REM Requires: .env in repo root with POSTGRES_PASSWORD matching the postgres container (or use same default).

set COMPOSE_PROJECT_NAME=compose
set BACKEND=compose-backend-1

echo [1] Checking Docker containers...
docker ps --filter "name=compose-backend-1" --format "{{.Names}} {{.Status}}" | findstr /C:"Up" >nul
if errorlevel 1 (
  echo Backend container not running. Start stack first: run.bat or docker compose -f compose/docker-compose.server.yml up -d
  exit /b 1
)

echo [2] Applying migrations...
docker exec %BACKEND% python manage.py migrate --noinput
if errorlevel 1 (
  echo Migrate failed. Check backend logs: docker logs %BACKEND%
  exit /b 1
)

echo [3] Seeding Myanmar units (viss, tical, etc.)...
docker exec %BACKEND% python manage.py seed_myanmar_units
if errorlevel 1 (
  echo Seed failed.
  exit /b 1
)

echo [4] Creating superuser admin / admin123 (if not exists)...
echo from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.filter(username='admin').exists() or User.objects.create_superuser('admin', 'admin@example.com', 'admin123') | docker exec -i %BACKEND% python manage.py shell
if errorlevel 1 (
  echo Superuser creation failed or already exists.
)

echo.
echo Done. Frontend/App: http://localhost (Nginx) or http://localhost:8000 (Backend)
echo Login: admin / admin123
pause
