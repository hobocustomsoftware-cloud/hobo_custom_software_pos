@echo off
REM ဆေးဆိုင် Demo: Docker စတင် -> Browser Register+Setup+POS -> တစ်လစာ sales ထည့် -> Reports စမ်း
REM Run from repo root: scripts\run_pharmacy_demo.bat
setlocal
cd /d "%~dp0\.."

set COMPOSE_FILE=compose/docker-compose.server.yml
set BASE_URL=http://localhost:8000/app
set HEADED=1

echo [Pharmacy Demo] 1. Starting Docker stack...
docker compose -f %COMPOSE_FILE% up -d --build
if errorlevel 1 (
  echo [Pharmacy Demo] Docker failed. Check Docker is running.
  exit /b 1
)

echo [Pharmacy Demo] 2. Waiting for backend (up to 2 min)...
set /a count=0
:wait_health
docker compose -f %COMPOSE_FILE% exec -T backend python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/health/')" 2>nul
if errorlevel 1 (
  set /a count+=1
  if %count% geq 24 (
    echo [Pharmacy Demo] Backend did not become healthy. Check: docker compose -f %COMPOSE_FILE% logs backend
    exit /b 1
  )
  timeout /t 5 /nobreak >nul
  goto wait_health
)
echo [Pharmacy Demo] Backend is ready.

echo [Pharmacy Demo] 3. Browser: Register (pharmacy) + Setup + Dashboard + POS...
set PLAYWRIGHT_BASE_URL=%BASE_URL%
set PLAYWRIGHT_HEADED=%HEADED%
cd yp_posf
npx playwright test e2e/pharmacy_demo.spec.js --grep "Full flow" --project=chromium
set R1=%errorlevel%
cd ..
if %R1% neq 0 (
  echo [Pharmacy Demo] First run (register/setup) had failures. Check demo_results\pharmacy_demo\
  exit /b %R1%
)

echo [Pharmacy Demo] 4. Seeding one month of pharmacy sales...
docker compose -f %COMPOSE_FILE% exec -T backend python manage.py seed_pharmacy_month --days 30 --sales-per-day 4
if errorlevel 1 (
  echo [Pharmacy Demo] seed_pharmacy_month failed.
  exit /b 1
)

echo [Pharmacy Demo] 5. Browser: Login + Reports (Sales Summary)...
cd yp_posf
npx playwright test e2e/pharmacy_demo.spec.js --grep "Reports after seed" --project=chromium
set R2=%errorlevel%
cd ..
if %R2% neq 0 (
  echo [Pharmacy Demo] Reports run had failures.
  exit /b %R2%
)

echo.
echo [Pharmacy Demo] Done. Screenshots and report: demo_results\pharmacy_demo\
echo To stop: docker compose -f %COMPOSE_FILE% down
exit /b 0
