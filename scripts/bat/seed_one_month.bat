@echo off
REM ဆိုင်တစ်ဆိုင်ရဲ့ တစ်လစာ data မရှိရင် ဒီ script ကို run ပါ။
REM Run: seed_one_month.bat (repo root မှာ)
REM ပြီးရင် Backend + Frontend စတင်ပြီး Screenshot script (simulate-month.js / simulate:full) run ပါ။

cd /d "%~dp0"

REM Activate venv
if exist "venv\Scripts\activate.bat" (
    call venv\Scripts\activate.bat
) else if exist "welding_env\Scripts\activate.bat" (
    call welding_env\Scripts\activate.bat
)

set HOBOPOS_DB_DIR=%~dp0
cd WeldingProject

echo.
echo [Seed one month] Running: python manage.py run_simulation --days 30
echo   (First user becomes Owner; creates ~30 days of sales and approves them.)
echo.
python manage.py run_simulation --days 30
set EXIT=%ERRORLEVEL%
cd ..
if %EXIT% neq 0 (
    echo.
    echo Seed failed. Check Django/DB.
    pause
    exit /b %EXIT%
)
echo.
echo [OK] One month data ready. Start backend + frontend, then run screenshot script in yp_posf.
pause
