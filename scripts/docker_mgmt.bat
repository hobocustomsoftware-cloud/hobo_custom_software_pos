@echo off
REM Run Django management commands inside Docker backend (avoids "postgres host not found" and /app I/O errors).
REM Usage: scripts\docker_mgmt.bat seed_demo_users
REM        scripts\docker_mgmt.bat seed_demo_data
REM Prerequisite: docker compose up -d (at least postgres + backend running).
setlocal
cd /d "%~dp0\.."

set COMPOSE=docker compose
docker compose version >nul 2>&1 || set COMPOSE=docker-compose

if "%~1"=="" (
  echo Usage: %~nx0 ^<command^> [args...]
  echo Example: %~nx0 seed_demo_users
  echo          %~nx0 seed_demo_data
  echo.
  echo Ensure backend is running first: %COMPOSE% up -d
  exit /b 1
)

%COMPOSE% exec backend python manage.py %*
exit /b %errorlevel%
