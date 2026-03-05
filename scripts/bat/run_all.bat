@echo off
REM One-command script to run everything: Docker + Simulation + Screenshots + Slideshow
REM Usage: run_all.bat

echo ============================================================
echo SOLAR POS SYSTEM - COMPLETE AUTOMATION
echo ============================================================
echo.
echo This will:
echo   1. Start Docker services (PostgreSQL, Redis, Backend, Frontend)
echo   2. Run complete simulation (Day 1-30)
echo   3. Capture all screenshots
echo   4. Build HTML slideshow
echo.
echo Estimated time: 5-10 minutes
echo.

REM Check if Python is available
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    pause
    exit /b 1
)

REM Check if run_simulation_docker.py exists
if not exist "run_simulation_docker.py" (
    echo ERROR: run_simulation_docker.py not found!
    echo Please make sure you're in the project root directory.
    pause
    exit /b 1
)

REM Run the Python script with --all flag
python run_simulation_docker.py --all

if errorlevel 1 (
    echo.
    echo ============================================================
    echo ERROR: Process failed!
    echo ============================================================
    pause
    exit /b 1
)

echo.
echo ============================================================
echo SUCCESS! All tasks completed!
echo ============================================================
echo.
echo Output files:
echo   - simulation_log.json
echo   - screenshots/ directory
echo   - solar_pos_demo_YYYY-MM-DD.html
echo.
echo Services are running:
echo   - Frontend: http://localhost:80
echo   - Backend: http://localhost:8000
echo.
echo To stop services: docker-compose stop
echo.
pause
