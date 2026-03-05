@echo off
setlocal
cd /d "%~dp0\.."
set COMPOSE=docker compose
docker compose version >nul 2>&1 || set COMPOSE=docker-compose
set COMPOSE_FILE=compose\docker-compose.yml
set ENV_FILE=.env

echo ============================================================
echo  Docker up + Verify /app/ (no 404) + Phone Register/Login
echo ============================================================
echo.

echo [1] docker-compose up -d --build...
%COMPOSE% -f %COMPOSE_FILE% --env-file %ENV_FILE% up -d --build
timeout /t 15 /nobreak >nul

echo [2] Open in browser: http://localhost/app/register (Phone Number field)
echo [3] Running Playwright: no 404, phone register + login...
cd yp_posf
set PLAYWRIGHT_BASE_URL=http://localhost/app
call node_modules\.bin\playwright.cmd test e2e/docker_phone_register_login.spec.js --project=chromium
set EXIT=%errorlevel%
cd ..

echo Done. App: http://localhost/app/
exit /b %EXIT%
