@echo off
REM HoBo POS - Demo ကို Docker နဲ့ စတင်ပြီး Browser ဖွင့်ရန်
REM Run from repo root: scripts\run_docker_demo.bat
setlocal
cd /d "%~dp0\.."

echo [Docker Demo] Starting stack (compose/docker-compose.server.yml)...
docker compose -f compose/docker-compose.server.yml up -d --build
if errorlevel 1 (
  echo [Docker Demo] Failed to start. Check Docker is running and .env if needed.
  exit /b 1
)

echo.
echo [Docker Demo] Backend may take 1-2 minutes to migrate and become ready.
echo [Docker Demo] Open in browser: http://localhost:8000/app/
echo.
echo Opening browser in 10 seconds (or press Ctrl+C and open manually)...
timeout /t 10 /nobreak >nul
start http://localhost:8000/app/

echo.
echo To stop: docker compose -f compose/docker-compose.server.yml down
echo Step-by-step test guide: DEMO_DOCKER.md
exit /b 0
