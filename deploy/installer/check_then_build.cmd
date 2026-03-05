@echo off
REM HoBo POS - 1) Check packages  2) Build hobo_pos_setup.exe
REM Run from project root: deploy\installer\check_then_build.cmd

cd /d "%~dp0..\.."
echo ========================================
echo Step 1: Package/Module check
echo ========================================
call deploy\installer\check_packages.cmd
if errorlevel 1 (
    echo.
    echo Fix missing packages then run again. Example:
    echo   venv\Scripts\activate
    echo   pip install -r WeldingProject\requirements.txt
    pause
    exit /b 1
)
echo.
echo ========================================
echo Step 2: Build EXE + Installer (hobo_pos_setup.exe)
echo ========================================
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0build.ps1"
echo.
pause
