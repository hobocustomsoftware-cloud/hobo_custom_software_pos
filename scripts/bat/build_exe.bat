@echo off
REM HoBo POS - Build Windows .exe (PyInstaller)
REM Run from repo root: F:\hobo_license_pos
setlocal
cd /d "%~dp0"

echo [1/5] Building Vue (base /app/)...
cd yp_posf
set VITE_BASE=/app/
call npm run build
if errorlevel 1 ( echo Vue build failed. & exit /b 1 )
cd ..

echo [2/5] Copying dist to WeldingProject/static_frontend...
if not exist "WeldingProject\static_frontend" mkdir "WeldingProject\static_frontend"
xcopy /E /I /Y "yp_posf\dist\*" "WeldingProject\static_frontend\"
if errorlevel 1 ( echo Copy failed. & exit /b 1 )

echo [3/5] Installing Python deps (waitress, pyinstaller, pyarmor)...
cd WeldingProject
pip install waitress pyinstaller pyarmor -q
cd ..

echo [4/5] Obfuscating with PyArmor (code protection)...
cd WeldingProject
if exist build_obf rmdir /S /Q build_obf
pyarmor gen -O build_obf run_server.py
pyarmor gen -O build_obf WeldingProject
pyarmor gen -O build_obf license
pyarmor gen -O build_obf core
pyarmor gen -O build_obf inventory
pyarmor gen -O build_obf customer
pyarmor gen -O build_obf notification
pyarmor gen -O build_obf service
pyarmor gen -O build_obf ai
cd ..

echo [5/5] Building with PyInstaller (onedir)...
cd WeldingProject
pyinstaller HoBoPOS.spec
cd ..

REM Release folder ကို repo root မှာ တစ်ခါတည်း ထုတ်ပေးမယ်
set "OUT=WeldingProject\dist\HoBoPOS"
set "RELEASE=HoBoPOS_Release"
if exist "%RELEASE%" rmdir /S /Q "%RELEASE%"
xcopy /E /I /Y "%OUT%" "%RELEASE%\"

if exist "%RELEASE%\HoBoPOS.exe" (
  copy /Y "scripts\Create_Desktop_Shortcut.bat" "%RELEASE%\Create_Desktop_Shortcut.bat" >nul 2>&1
  echo.
  echo Done. Ready folder: %RELEASE%\
  echo   - Run: %RELEASE%\HoBoPOS.exe
  echo   - Or run Create_Desktop_Shortcut.bat then double-click Desktop shortcut.
  echo   - DB + media will be saved in this folder.
  echo   - Zip "%RELEASE%" to share.
) else (
  echo Build failed - HoBoPOS.exe not found.
  exit /b 1
)
