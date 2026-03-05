@echo off
REM တစ်ခါတည်း စစ်ဆေးခြင်း: EXE/Hosting/License + Frontend build
REM Run from repo root: scripts\run_all_checks.bat
setlocal
cd /d "%~dp0\.."

set ERR=0

echo.
echo ===== 1) EXE + Hosting + License verification =====
call scripts\verify_exe_hosting_license.bat
if errorlevel 1 set ERR=1
echo.

echo ===== 2) Frontend build (Vite) =====
cd yp_posf
call npm run build
if errorlevel 1 (
  echo [FAIL] Frontend build failed.
  set ERR=1
) else (
  echo [OK] Frontend build succeeded.
)
cd ..
echo.

if %ERR%==0 (
  echo ===== All checks passed =====
  echo   - EXE/Hosting/License: see summary above
  echo   - Frontend: yp_posf\dist ready for copy to static_frontend
  echo.
  echo Next: build_exe.bat for EXE, or docker-compose up for hosting.
) else (
  echo ===== Some checks failed - fix errors above =====
  exit /b 1
)
endlocal
exit /b 0
