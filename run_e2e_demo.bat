@echo off
setlocal
cd /d "%~dp0"
set COMPOSE=docker compose
docker compose version >nul 2>&1 || set COMPOSE=docker-compose
echo [1/4] Checking Docker...
docker info >nul 2>&1 || (echo Docker not running. & exit /b 1)
echo [2/4] Starting backend and frontend...
%COMPOSE% -f compose\docker-compose.yml up -d --build backend frontend
timeout /t 5 /nobreak >nul
echo [3/4] Running E2E demo (headed)...
cd yp_posf
set PLAYWRIGHT_BASE_URL=http://localhost:80
set PLAYWRIGHT_DEMO_FLOW=1
set PLAYWRIGHT_HEADED=1
npx playwright test e2e/feature_verification.spec.js --project=chromium
set EXIT=%errorlevel%
cd ..
echo [4/4] Screenshots:
if exist demo_results\feature_verification (
  dir /b demo_results\feature_verification\*.png
  echo Total: 31 expected
)
exit /b %EXIT%
