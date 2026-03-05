@echo off
chcp 65001 >nul
cd /d "%~dp0\..\.."
echo.
echo ===== အဆင့် ၂: Docker စမ်းသပ်မှု =====
echo.
echo ၁) Frontend build ထုတ်နေပါတယ် (VITE_API_URL=/api, VITE_BASE=/app/)...
cd yp_posf
set VITE_API_URL=/api
set VITE_BASE=/app/
call npm run build
if errorlevel 1 ( echo Vue build မအောင်မြင်ပါ။ & cd .. & pause & exit /b 1 )
cd ..
echo.
echo ၂) Docker Compose စတင်နေပါတယ် (postgres, redis, backend, frontend ပါပြီးသား)...
docker compose version >nul 2>&1 && set COMPOSE=docker compose || set COMPOSE=docker-compose
%COMPOSE% -f compose/docker-compose.yml up -d --build
if errorlevel 1 ( echo docker compose မအောင်မြင်ပါ။ & pause & exit /b 1 )
echo.
echo ၃) စစ်ဆေးရန်:
echo    - Frontend: http://localhost
echo    - Backend API: http://localhost:8000/api/
echo    - ရပ်ရန်: %COMPOSE% -f compose/docker-compose.yml down
echo.
echo အသေးစိတ်: docs\ROADMAP_EXPO_DOCKER_EXE_MARKETING.md
echo.
pause
