@echo off
setlocal
cd /d "%~dp0\.."
set COMPOSE=docker compose
docker compose version >nul 2>&1 || set COMPOSE=docker-compose
set COMPOSE_FILE=compose\docker-compose.yml
set ENV_FILE=.env

echo ============================================================
echo  1-Month Business Simulation Test
echo ============================================================
echo.

echo [1/5] Fix Backend first: ensure stack is up...
%COMPOSE% -f %COMPOSE_FILE% --env-file %ENV_FILE% up -d --build backend frontend
timeout /t 10 /nobreak >nul

echo [2/5] START browser and show Owner Registration (headed)...
cd yp_posf
set PLAYWRIGHT_BASE_URL=http://localhost:80
call node_modules\.bin\playwright.cmd test e2e/one_month_simulation.spec.js --project=chromium --headed
set EXIT=%errorlevel%
cd ..

echo [3/5] Phase 2: Run backend data (500+ products, 1000+ sales) manually:
echo   docker compose -f compose/docker-compose.yml --env-file .env exec backend python manage.py simulation_1month_data
echo [4/5] Then run Phase 3-4 with login env: PLAYWRIGHT_LOGIN_EMAIL=... PLAYWRIGHT_LOGIN_PASSWORD=...
echo.

echo [5/5] Recording docker stats to performance_audit.md...
mkdir demo_results 2>nul
echo # Performance Audit - 1-Month Simulation > demo_results\performance_audit.md
echo. >> demo_results\performance_audit.md
echo ## Peak RAM/CPU >> demo_results\performance_audit.md
docker stats --no-stream --format "table {{.Name}}    {{.CPUPerc}}    {{.MemUsage}}" >> demo_results\performance_audit.md 2>&1

echo Screenshots: demo_results\one_month_simulation\
if exist demo_results\one_month_simulation dir /b demo_results\one_month_simulation\*.png
exit /b %EXIT%
