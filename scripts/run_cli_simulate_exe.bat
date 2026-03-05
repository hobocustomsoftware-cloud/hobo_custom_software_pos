@echo off
REM CLI simulation: EXE flow (Customer PC မှာ EXE ပဲ ရှိသလို စစ်မယ်)
REM Run from repo root. Run setup_one_time.bat first if venv not set up.
setlocal
cd /d "%~dp0\.."

REM Use venv if present (no need for virtualenv package or Python in PATH)
set "PY=python"
if exist "venv\Scripts\python.exe" set "PY=venv\Scripts\python.exe"
if exist "welding_env\Scripts\python.exe" set "PY=welding_env\Scripts\python.exe"

if "%~1"=="" (
  echo Running EXE flow simulation (server must be running at http://127.0.0.1:8000)...
  cd WeldingProject
  "%PY%" manage.py simulate_exe_flow
  set EXIT=%errorlevel%
  cd ..
  exit /b %EXIT%
)

cd WeldingProject
"%PY%" manage.py simulate_exe_flow %*
set EXIT=%errorlevel%
cd ..
exit /b %EXIT%
