@echo off
REM HoBo POS - Docker: migrate + run one simulation (တစ်ခါတည်း)
REM Run from repo root: scripts\docker_migrate_and_simulate.bat
setlocal
set COMPOSE_FILE=compose\docker-compose.yml
set ROOT=%~dp0..
cd /d "%ROOT%"

echo [1/4] Checking Docker stack...
docker compose -f "%COMPOSE_FILE%" ps -q backend >nul 2>&1
if errorlevel 1 (
  echo Starting Docker stack (backend may take 1-2 min to be healthy)...
  docker compose -f "%COMPOSE_FILE%" up -d --build
  echo Waiting 90s for backend to be ready...
  timeout /t 90 /nobreak >nul
) else (
  echo Backend container exists. Waiting 5s...
  timeout /t 5 /nobreak >nul
)

echo.
echo [2/4] Running migrations...
docker compose -f "%COMPOSE_FILE%" exec -T backend python manage.py migrate --noinput
if errorlevel 1 (
  echo [WARN] migrate failed. Backend may still be starting. Retry in 30s...
  timeout /t 30 /nobreak >nul
  docker compose -f "%COMPOSE_FILE%" exec -T backend python manage.py migrate --noinput
)
if errorlevel 1 (
  echo [ERROR] Migrate failed. Check: docker compose -f "%COMPOSE_FILE%" logs backend
  exit /b 1
)

echo.
echo [3/4] Running one simulation (run_simulation --days 7 --sales-per-day 2)...
docker compose -f "%COMPOSE_FILE%" exec -T backend python manage.py run_simulation --days 7 --sales-per-day 2
if errorlevel 1 (
  echo [WARN] Simulation failed. Rebuild backend to pick up fixes: docker compose -f "%COMPOSE_FILE%" up -d --build backend
  echo Then: docker compose -f "%COMPOSE_FILE%" exec backend python manage.py run_simulation --days 7
  exit /b 1
)
if errorlevel 1 (
  echo [WARN] run_simulation failed. Try: docker compose -f "%COMPOSE_FILE%" exec backend python manage.py run_simulation --days 7
  exit /b 1
)

echo.
echo [4/4] Done. App: http://localhost/app/  API: http://localhost:8000/
exit /b 0
