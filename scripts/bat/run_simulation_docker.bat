@echo off
REM Windows batch script to run simulation with Docker
REM Usage: run_simulation_docker.bat [--screenshots] [--all] [--stop]

echo ============================================================
echo SOLAR POS SYSTEM - DOCKER SIMULATION RUNNER (Windows)
echo ============================================================

REM Check if Python is available
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    pause
    exit /b 1
)

REM Run Python script with all arguments passed through
python run_simulation_docker.py %*

if errorlevel 1 (
    echo.
    echo ERROR: Script failed
    pause
    exit /b 1
)

pause
