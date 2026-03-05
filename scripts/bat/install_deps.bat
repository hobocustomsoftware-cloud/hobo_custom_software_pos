@echo off
REM HoBo POS - Install all pip dependencies (run once)

cd /d "%~dp0"

echo Installing dependencies...

if exist "venv\Scripts\pip.exe" (
    venv\Scripts\pip.exe install -r WeldingProject\requirements.txt
    venv\Scripts\pip.exe install pyinstaller
) else if exist "welding_env\Scripts\pip.exe" (
    welding_env\Scripts\pip.exe install -r WeldingProject\requirements.txt
    welding_env\Scripts\pip.exe install pyinstaller
) else if exist "F:\yang_power\welding_env\Scripts\pip.exe" (
    F:\yang_power\welding_env\Scripts\pip.exe install -r WeldingProject\requirements.txt
    echo.
    echo Using F:\yang_power\welding_env
    echo Create venv in project: python -m venv venv
) else (
    python -m pip install -r WeldingProject\requirements.txt
)

echo.
echo Done. Run run_lite.bat to start.
pause
