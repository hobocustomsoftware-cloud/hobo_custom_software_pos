@echo off
REM HoBo POS - Package/Module check (CMD)
REM Run from project root: deploy\installer\check_packages.cmd
REM Each line: try "python -c "import X"" then echo OK or MISSING

cd /d "%~dp0..\.."
set PY=
if exist "venv\Scripts\python.exe" set PY=venv\Scripts\python.exe
if not defined PY if exist "welding_env\Scripts\python.exe" set PY=welding_env\Scripts\python.exe
if not defined PY set PY=python

echo ========================================
echo HoBo POS - Package check (venv preferred)
echo ========================================
echo Using: %PY%
echo.

set MISSING=0
call :try_import django "Django"
call :try_import rest_framework "Django REST Framework"
call :try_import django_filters "django-filter"
call :try_import djangorestframework_simplejwt "JWT"
call :try_import drf_spectacular "drf-spectacular"
call :try_import corsheaders "django-cors-headers"
call :try_import channels "Channels"
call :try_import daphne "Daphne"
call :try_import requests "requests"
call :try_import PIL "Pillow"
call :try_import reportlab "reportlab"
call :try_import dj_database_url "dj-database-url"
call :try_import yaml "PyYAML"
call :try_import uvicorn "uvicorn"
REM PyInstaller: run "pip install pyinstaller" for EXE build; not imported as module

echo.
if %MISSING% gtr 0 (
    echo Result: %MISSING% package(s) MISSING. Run: pip install -r WeldingProject\requirements.txt
    exit /b 1
)
echo Result: All required packages OK.
exit /b 0

:try_import
set mod=%~1
set name=%~2
"%PY%" -c "import %mod%" 2>nul
if errorlevel 1 (
    echo [MISSING] %name% ^(import %mod%^)
    set /a MISSING+=1
) else (
    echo [OK] %name%
)
goto :eof
