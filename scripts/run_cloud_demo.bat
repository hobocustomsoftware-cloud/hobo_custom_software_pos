@echo off
setlocal
cd /d "%~dp0\.."
set COMPOSE=docker compose
docker compose version >nul 2>&1 || set COMPOSE=docker-compose
set COMPOSE_FILE=compose\docker-compose.yml
set ENV_FILE=.env

echo [1] Starting stack with .env (fixes Postgres auth)...
%COMPOSE% -f %COMPOSE_FILE% --env-file %ENV_FILE% up -d --build
timeout /t 15 /nobreak >nul

echo [2] Logging docker stats to demo_results\performance_metrics.txt (during demo)...
mkdir demo_results 2>nul
echo === docker stats at %date% %time% === > demo_results\performance_metrics.txt
start /b cmd /c "for /L %i in (1,1,36) do @(docker stats --no-stream --format "table {{.Name}}    {{.CPUPerc}}    {{.MemUsage}}" >> demo_results\performance_metrics.txt 2>&1 & timeout /t 5 /nobreak >nul)"
timeout /t 3 /nobreak >nul

echo [3] Running Cloud Readiness Demo (headed browser)...
cd yp_posf
set PLAYWRIGHT_BASE_URL=http://localhost:80/app
set PLAYWRIGHT_HEADED=1
call node_modules\.bin\playwright.cmd test e2e/cloud_readiness_demo.spec.js --project=chromium --headed
cd ..
if exist demo_results\cloud_readiness (
  echo Cloud readiness screenshots:
  dir /b demo_results\cloud_readiness\*.png
)
echo Done. Check demo_results\performance_metrics.txt and demo_results\cloud_readiness\
exit /b 0
