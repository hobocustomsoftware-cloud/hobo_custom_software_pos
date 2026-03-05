@echo off
REM Docker full stack စတင်ရန် (postgres, redis, backend, frontend) - ပုံမှန် compose ဖိုင်
REM Repo root မှ run ပါ: scripts\docker_up.bat
setlocal
cd /d "%~dp0\.."

set COMPOSE=docker compose
docker compose version >nul 2>&1 || set COMPOSE=docker-compose
set COMPOSE_FILE=compose/docker-compose.yml

echo Docker full stack စတင်နေပါတယ် (postgres, redis, backend, frontend)...
%COMPOSE% -f %COMPOSE_FILE% up -d --build
if errorlevel 1 (
  echo Docker စတင်မအောင်မြင်ပါ။ Docker Desktop ဖွင့်ထားပါ။
  echo စကားဝှက်အမှား ဆိုရင်: %COMPOSE% -f %COMPOSE_FILE% down -v ပြီး ထပ်စတင်ပါ။
  exit /b 1
)
echo.
echo ပြီးပါပြီ။ Postgres + Redis + Backend + Frontend ပါပြီးသား။
echo   - App: http://localhost (သို့) http://localhost/app/
echo   - Backend API: http://localhost:8000/api/
echo   - ရပ်ရန်: %COMPOSE% -f %COMPOSE_FILE% down
exit /b 0
