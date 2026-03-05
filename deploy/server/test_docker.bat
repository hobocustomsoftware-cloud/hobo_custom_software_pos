@echo off
REM Docker Test Script - Backend + Frontend (Windows)
REM Run: deploy\server\test_docker.bat

cd /d "%~dp0\..\.."

echo === Docker Test: Backend + Frontend ===
echo.

REM Check .env exists
if not exist "deploy\server\.env" (
  echo ⚠️  deploy\server\.env not found. Copying from .env.example...
  copy deploy\server\.env.example deploy\server\.env
  echo ⚠️  Please edit deploy\server\.env and set DJANGO_SECRET_KEY and POSTGRES_PASSWORD
  pause
  exit /b 1
)

echo 1) Building Backend...
docker-compose -f deploy\server\docker-compose.yml build backend
if errorlevel 1 (
  echo Backend build failed
  pause
  exit /b 1
)

echo.
echo 2) Building Frontend...
docker-compose -f deploy\server\docker-compose.yml build frontend
if errorlevel 1 (
  echo Frontend build failed
  pause
  exit /b 1
)

echo.
echo 3) Starting all services...
docker-compose -f deploy\server\docker-compose.yml up -d
if errorlevel 1 (
  echo Docker compose up failed
  pause
  exit /b 1
)

echo.
echo 4) Waiting for services...
timeout /t 15 /nobreak >nul

echo.
echo 5) Checking Backend health...
curl -f http://localhost:8000/health/ 2>nul || echo ⚠️  Backend health check failed (or curl not installed)

echo.
echo 6) Checking Frontend...
curl -f http://localhost/ 2>nul || echo ⚠️  Frontend check failed (or curl not installed)

echo.
echo === Test Complete ===
echo Backend: http://localhost:8000
echo Frontend: http://localhost
echo.
echo Logs: docker-compose -f deploy\server\docker-compose.yml logs -f
pause
