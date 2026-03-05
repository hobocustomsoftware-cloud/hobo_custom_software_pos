@echo off
chcp 65001 >nul
echo ========================================
echo SCREENSHOT CAPTURE
echo ========================================
echo.
echo ⚠️  Make sure both backend and frontend are running!
echo    Backend: python WeldingProject\manage.py runserver
echo    Frontend: cd yp_posf ^&^& npm run dev
echo.
pause

REM Check if virtual environment exists
if exist "venv\Scripts\activate.bat" (
    call venv\Scripts\activate.bat
) else if exist "welding_env\Scripts\activate.bat" (
    call welding_env\Scripts\activate.bat
)

echo.
echo [1/2] Capturing screenshots...
python screenshot_story.py
if errorlevel 1 (
    echo ❌ Screenshot capture failed!
    pause
    exit /b 1
)

echo.
echo [2/2] Building slideshow...
python build_slideshow.py
if errorlevel 1 (
    echo ❌ Slideshow build failed!
    pause
    exit /b 1
)

echo.
echo ✅ All done! Check screenshots/ folder and HTML slideshow file.
echo.
pause
