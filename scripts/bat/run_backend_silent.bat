@echo off
REM Backend only, no browser, no pause – for run_all_machinery
cd /d "%~dp0"
if exist "venv\Scripts\activate.bat" (call venv\Scripts\activate.bat)
if exist "welding_env\Scripts\activate.bat" (call welding_env\Scripts\activate.bat)
set HOBOPOS_DB_DIR=%~dp0
set DEPLOYMENT_MODE=on_premise
cd WeldingProject
python manage.py migrate --run-syncdb >nul 2>&1
python -m uvicorn WeldingProject.asgi:application --host 127.0.0.1 --port 8000
if errorlevel 1 python manage.py runserver 127.0.0.1:8000 --noreload
