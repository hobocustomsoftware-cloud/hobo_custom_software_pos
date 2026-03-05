@echo off
chcp 65001 >nul
echo ========================================
echo SOLAR POS - COMPLETE SIMULATION SYSTEM
echo ========================================
echo.

REM Check if virtual environment exists
if exist "venv\Scripts\activate.bat" (
    echo [1/4] Activating virtual environment...
    call venv\Scripts\activate.bat
) else if exist "welding_env\Scripts\activate.bat" (
    echo [1/4] Activating virtual environment...
    call welding_env\Scripts\activate.bat
) else (
    echo ⚠️  Warning: Virtual environment not found
    echo    Continuing without activation...
)

echo.
echo [2/4] Running simulation (Day 1-30)...
echo    This will create all data in the database...
python WeldingProject\manage.py simulate_month --skip-delay
if errorlevel 1 (
    echo ❌ Simulation failed!
    pause
    exit /b 1
)

echo.
echo ✅ Simulation completed!
echo.
echo ========================================
echo NEXT STEPS:
echo ========================================
echo.
echo 1. Make sure backend is running:
echo    python WeldingProject\manage.py runserver
echo.
echo 2. Make sure frontend is running (in another terminal):
echo    cd yp_posf
echo    npm run dev
echo.
echo 3. Then run screenshot capture:
echo    python screenshot_story.py
echo.
echo 4. Finally build slideshow:
echo    python build_slideshow.py
echo.
echo ========================================
pause
