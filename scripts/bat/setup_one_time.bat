@echo off
REM HoBo POS - တစ်ခါတည်း setup (Python ရှိရင် venv ဖန်တီး + dependencies + migrate)
REM virtualenv package မလို - Python ရဲ့ built-in venv သုံးမယ်
REM Run: setup_one_time.bat  (repo root မှာ double-click သို့မဟုတ် cmd ကနေ)
setlocal EnableDelayedExpansion
cd /d "%~dp0"

set "VENV_DIR=venv"
set "REQUIREMENTS=WeldingProject\requirements.txt"
set "PYTHON="

echo.
echo ===== HoBo POS - One-time setup =====
echo.

REM 1) Find Python (py -3, python, python3) - no venv required
where py >nul 2>&1
if %errorlevel%==0 (
  for /f "delims=" %%i in ('py -3 -c "import sys; print(sys.executable)" 2^>nul') do set "PYTHON=%%i"
)
if not defined PYTHON (
  where python >nul 2>&1
  if %errorlevel%==0 (
    for /f "delims=" %%i in ('python -c "import sys; print(sys.executable)" 2^>nul') do set "PYTHON=%%i"
  )
)
if not defined PYTHON (
  where python3 >nul 2>&1
  if %errorlevel%==0 (
    for /f "delims=" %%i in ('python3 -c "import sys; print(sys.executable)" 2^>nul') do set "PYTHON=%%i"
  )
)

if not defined PYTHON (
  echo [ERROR] Python not found.
  echo.
  echo Install Python 3.10 or 3.11 from https://www.python.org/downloads/
  echo During install, check "Add Python to PATH".
  echo Then run this script again.
  echo.
  pause
  exit /b 1
)

echo [OK] Python: %PYTHON%
echo.

REM 2) Create venv with built-in venv (no virtualenv package needed)
if exist "%VENV_DIR%\Scripts\python.exe" (
  echo [OK] venv already exists: %VENV_DIR%
) else (
  echo Creating venv in %VENV_DIR% (this may take a moment)...
  "%PYTHON%" -m venv "%VENV_DIR%"
  if errorlevel 1 (
    echo [ERROR] Failed to create venv. Try: "%PYTHON%" -m venv %VENV_DIR%
    pause
    exit /b 1
  )
  echo [OK] venv created.
)
echo.

REM 3) Upgrade pip and install requirements
echo Installing dependencies (pip install -r requirements.txt)...
"%VENV_DIR%\Scripts\python.exe" -m pip install --upgrade pip -q
"%VENV_DIR%\Scripts\pip.exe" install -r "%REQUIREMENTS%" -q
if errorlevel 1 (
  echo [ERROR] pip install failed. Running without -q to see errors:
  "%VENV_DIR%\Scripts\pip.exe" install -r "%REQUIREMENTS%"
  pause
  exit /b 1
)
echo [OK] Dependencies installed.
echo.

REM 4) Migrate database
echo Running migrations...
cd WeldingProject
"..\%VENV_DIR%\Scripts\python.exe" manage.py migrate --noinput
if errorlevel 1 (
  echo [ERROR] migrate failed.
  cd ..
  pause
  exit /b 1
)
cd ..
echo [OK] Migrations done.
echo.

echo ===== Setup complete =====
echo.
echo Next steps:
echo   - Start server: run_lite.bat   (opens http://127.0.0.1:8000/app/)
echo   - CLI simulation: scripts\run_cli_simulate_exe.bat
echo   - Build EXE: build_exe.bat
echo.
echo (venv is used automatically - no need to install "virtualenv" package.)
pause
exit /b 0
