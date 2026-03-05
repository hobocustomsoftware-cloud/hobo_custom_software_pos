@echo off
REM HoBo POS - Lightweight run (no EXE, 2GB RAM / Celeron friendly)
REM Uses uvicorn (lighter than Daphne)
REM Run install_deps.bat first if uvicorn missing

cd /d "%~dp0"

REM Activate venv (venv first, then welding_env, yang_power)
if exist "venv\Scripts\activate.bat" (
    call venv\Scripts\activate.bat
) else if exist "welding_env\Scripts\activate.bat" (
    call welding_env\Scripts\activate.bat
) else if exist "F:\yang_power\welding_env\Scripts\activate.bat" (
    call F:\yang_power\welding_env\Scripts\activate.bat
)

REM DB + media in project folder
set HOBOPOS_DB_DIR=%~dp0
set DEPLOYMENT_MODE=on_premise

REM Build Vue if static_frontend missing
if not exist "WeldingProject\static_frontend\index.html" (
    echo Building Vue...
    cd yp_posf
    set VITE_BASE=/app/
    call npm run build
    cd ..
    if not exist "WeldingProject\static_frontend" mkdir WeldingProject\static_frontend
    xcopy /E /Y yp_posf\dist\* WeldingProject\static_frontend\ /I
)

cd WeldingProject

echo Starting HoBo POS (lite)...
echo Open: http://127.0.0.1:8000/app/
echo.
start http://127.0.0.1:8000/app/

python -m uvicorn WeldingProject.asgi:application --host 127.0.0.1 --port 8000
pause
