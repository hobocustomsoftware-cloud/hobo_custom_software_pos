@echo off
setlocal enabledelayedexpansion
REM Create Shop1, Shop2, Shop3, ... from HoBoPOS_Release for multi-shop simulation.
REM Run from repo root. Then run Shop1\HoBoPOS.exe, test, close; run Shop2\HoBoPOS.exe, etc.
cd /d "%~dp0\.."

set "RELEASE=HoBoPOS_Release"
set "COUNT=3"

if not exist "%RELEASE%\HoBoPOS.exe" (
  echo %RELEASE%\HoBoPOS.exe not found. Run build_exe.bat first.
  pause
  exit /b 1
)

if not "%~1"=="" set "COUNT=%~1"
echo Creating %COUNT% shop folders from %RELEASE%...
echo.

for /L %%i in (1,1,%COUNT%) do (
  set "SHOP=Shop%%i"
  if exist "!SHOP!" rmdir /S /Q "!SHOP!"
  mkdir "!SHOP!"
  xcopy /E /I /Y "%RELEASE%\*" "!SHOP!\" >nul
  echo   Created !SHOP!\
)
echo.
echo Done. To simulate different shops:
echo   - Run Shop1\HoBoPOS.exe, register and test, then close.
echo   - Run Shop2\HoBoPOS.exe, register and test, then close.
echo   - Only one EXE at a time (same port 8000).
echo.
pause
