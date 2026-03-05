@echo off
REM HoBo POS - Dependency Check (Django + Vue)
REM Run from project root or deploy\installer

cd /d "%~dp0..\.."

echo ========================================
echo 1. Python / Django packages (pip list)
echo ========================================
if exist "venv\Scripts\activate.bat" (
    call venv\Scripts\activate.bat
) else if exist "welding_env\Scripts\activate.bat" (
    call welding_env\Scripts\activate.bat
)
pip list | findstr /i "django rest_framework djangorestframework channels daphne uvicorn corsheaders django-filter drf-spectacular simplejwt"
echo.
echo Full pip list:
pip list

echo.
echo ========================================
echo 2. Vue / Node packages (npm list)
echo ========================================
cd yp_posf
if exist "package.json" (
    echo Vue project: yp_posf
    npm list --depth=0
    echo.
    echo Vue version:
    npm list vue
) else (
    echo yp_posf\package.json not found. Run: cd yp_posf ^&^& npm install
)
cd ..

echo.
echo Done.
pause
