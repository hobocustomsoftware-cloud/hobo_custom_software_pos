@echo off
REM HoBo POS - Portable launcher (Embedded Python + Waitress)
cd /d "%~dp0"

set HOBOPOS_DB_DIR=%~dp0
set DEPLOYMENT_MODE=on_premise

if exist "python\python.exe" (
    set PYTHON=python\python.exe
) else if exist "..\..\venv\Scripts\python.exe" (
    set PYTHON=..\..\venv\Scripts\python.exe
) else (
    echo Python not found. Run deploy\portable\setup_embedded.ps1 first.
    pause
    exit /b 1
)

echo Starting HoBo POS...
echo Open: http://127.0.0.1:8000/app/
echo.
start "" "http://127.0.0.1:8000/app/"
"%PYTHON%" run_waitress.py
pause
