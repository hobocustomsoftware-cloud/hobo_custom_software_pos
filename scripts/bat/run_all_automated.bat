@echo off
chcp 65001 >nul
echo ========================================
echo FULLY AUTOMATED SIMULATION SYSTEM
echo ========================================
echo.
echo This script will:
echo   1. Run simulation (creates database data)
echo   2. Start backend server (background)
echo   3. Start frontend server (background)
echo   4. Wait for servers to be ready
echo   5. Capture screenshots
echo   6. Build slideshow
echo   7. Stop servers
echo.
echo ⚠️  Note: This requires both Django and Vue.js to be properly set up
echo.
pause

REM Activate virtual environment
if exist "venv\Scripts\activate.bat" (
    call venv\Scripts\activate.bat
) else if exist "welding_env\Scripts\activate.bat" (
    call welding_env\Scripts\activate.bat
)

echo.
echo [Step 1/7] Running simulation...
set HOBOPOS_DB_DIR=%~dp0
set DEPLOYMENT_MODE=on_premise
python WeldingProject\manage.py simulate_month --skip-delay
if errorlevel 1 (
    echo ❌ Simulation failed!
    pause
    exit /b 1
)

echo.
echo [Step 2/7] Starting backend server...
start "Backend Server" cmd /k "python WeldingProject\manage.py runserver"
timeout /t 5 /nobreak >nul

echo.
echo [Step 3/7] Starting frontend server...
cd yp_posf
start "Frontend Server" cmd /k "npm run dev"
cd ..
timeout /t 10 /nobreak >nul

echo.
echo [Step 4/7] Waiting for servers to be ready...
echo    (Backend :8000, Frontend Vite :5173)
timeout /t 20 /nobreak >nul

echo.
echo [Step 5/7] Capturing screenshots...
set FRONTEND_URL=http://localhost:5173
python screenshot_story.py
if errorlevel 1 (
    echo ❌ Screenshot capture failed!
    echo    Servers are still running - you can try manually
    pause
    exit /b 1
)

echo.
echo [Step 6/7] Building slideshow...
python build_slideshow.py
if errorlevel 1 (
    echo ❌ Slideshow build failed!
    pause
    exit /b 1
)

echo.
echo [Step 7/7] Stopping servers...
taskkill /FI "WindowTitle eq Backend Server*" /T >nul 2>&1
taskkill /FI "WindowTitle eq Frontend Server*" /T >nul 2>&1

echo.
echo ========================================
echo ✅ ALL DONE!
echo ========================================
echo.
echo Check:
echo   - screenshots/ folder for all images
echo   - solar_pos_demo_[DATE].html for slideshow
echo.
pause
