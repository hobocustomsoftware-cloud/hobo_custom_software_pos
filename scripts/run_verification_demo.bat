@echo off
setlocal
cd /d "%~dp0\.."
set COMPOSE=docker compose
docker compose version >nul 2>&1 || set COMPOSE=docker-compose
set COMPOSE_FILE=compose\docker-compose.yml
set ENV_FILE=.env

echo [1] Ensuring backend + frontend are up...
%COMPOSE% -f %COMPOSE_FILE% --env-file %ENV_FILE% up -d --build backend frontend
timeout /t 8 /nobreak >nul

echo [2] Running Backend-Frontend verification (Register -> Wizard -> Reports)...
cd yp_posf
set PLAYWRIGHT_BASE_URL=http://localhost:80
call node_modules\.bin\playwright.cmd test e2e/backend_frontend_verification.spec.js --project=chromium
set EXIT=%errorlevel%
cd ..

echo [3] Screenshots (favicon visible in tab):
if exist demo_results\backend_frontend_verification (
  dir /b demo_results\backend_frontend_verification\*.png
)
exit /b %EXIT%
