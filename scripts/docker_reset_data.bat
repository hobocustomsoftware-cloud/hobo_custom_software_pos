@echo off
chcp 65001 >nul
REM Reset Docker data (postgres, media, license_data) then start fresh.
REM After run: Register at /app/ or run docker_mgmt.bat seed_demo_users then login owner/demo123
setlocal
cd /d "%~dp0\.."

set COMPOSE=docker compose
docker compose version >nul 2>&1 || set COMPOSE=docker-compose

echo ===== Docker data reset =====
echo.
echo This will DELETE all DB, media, license data. Continue?
set /p confirm=Type y then Enter:
if /i not "%confirm%"=="y" ( echo Cancelled. & exit /b 0 )

echo.
echo [1/4] Stopping containers...
%COMPOSE% down
echo [2/4] Removing volumes...
%COMPOSE% down -v
echo.

echo [3/4] Check frontend build...
if not exist "yp_posf\dist\index.html" (
  echo Building frontend (VITE_BASE=/app/)...
  cd yp_posf
  set VITE_API_URL=/api
  set VITE_BASE=/app/
  call npm run build
  if errorlevel 1 ( cd .. & exit /b 1 )
  cd ..
)
echo [4/4] Starting Docker...
%COMPOSE% up -d
if errorlevel 1 ( echo Failed to start. & exit /b 1 )

echo.
echo Done. DB is fresh. Open http://localhost:8000/app/ and Register, or run:
echo   scripts\docker_mgmt.bat seed_demo_users
echo then login with owner / demo123
echo For /app/ and routes: build with VITE_BASE=/app/ in yp_posf then restart backend.
pause
