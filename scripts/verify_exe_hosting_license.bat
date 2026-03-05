@echo off
REM One-go verification: EXE build readiness, Docker hosting, License key flow
REM Run from repo root: scripts\verify_exe_hosting_license.bat
setlocal
cd /d "%~dp0\.."

echo.
echo ===== EXE + Hosting + License Verification =====
echo.

set OK=0
set FAIL=0

REM ---- 1) EXE ----
echo [1] EXE build readiness
if exist "build_exe.bat" (echo   [OK] build_exe.bat & set /a OK+=1) else (echo   [FAIL] build_exe.bat missing & set /a FAIL+=1)
if exist "WeldingProject\run_server.py" (echo   [OK] run_server.py & set /a OK+=1) else (echo   [FAIL] run_server.py missing & set /a FAIL+=1)
if exist "WeldingProject\HoBoPOS.spec" (echo   [OK] HoBoPOS.spec & set /a OK+=1) else (echo   [FAIL] HoBoPOS.spec missing & set /a FAIL+=1)
findstr /C:"VITE_BASE" build_exe.bat >nul 2>&1
if errorlevel 1 (echo   [FAIL] VITE_BASE not found & set /a FAIL+=1) else (echo   [OK] VITE_BASE in build_exe.bat & set /a OK+=1)
findstr /C:"static_frontend" build_exe.bat >nul 2>&1
if errorlevel 1 (echo   [FAIL] static_frontend copy not in build & set /a FAIL+=1) else (echo   [OK] static_frontend copy in build & set /a OK+=1)
echo.

REM ---- 2) Docker hosting ----
echo [2] Docker hosting
if exist "docker-compose.yml" (echo   [OK] docker-compose.yml & set /a OK+=1) else (echo   [FAIL] docker-compose.yml missing & set /a FAIL+=1)
if exist "WeldingProject\Dockerfile" (echo   [OK] WeldingProject Dockerfile & set /a OK+=1) else (echo   [FAIL] WeldingProject Dockerfile missing & set /a FAIL+=1)
findstr /C:"DEPLOYMENT_MODE" docker-compose.yml >nul 2>&1
if errorlevel 1 (echo   [FAIL] DEPLOYMENT_MODE not in compose & set /a FAIL+=1) else (echo   [OK] DEPLOYMENT_MODE in compose & set /a OK+=1)
findstr /C:"license_data" docker-compose.yml >nul 2>&1
if errorlevel 1 (echo   [FAIL] license_data volume not found & set /a FAIL+=1) else (echo   [OK] license_data volume & set /a OK+=1)
echo.

REM ---- 3) License ----
echo [3] License key flow
findstr /C:"/api/core/register" WeldingProject\license\middleware.py >nul 2>&1
if errorlevel 1 (echo   [FAIL] Skip register missing & set /a FAIL+=1) else (echo   [OK] Skip: register & set /a OK+=1)
findstr /C:"/api/token" WeldingProject\license\middleware.py >nul 2>&1
if errorlevel 1 (echo   [FAIL] Skip token missing & set /a FAIL+=1) else (echo   [OK] Skip: token & set /a OK+=1)
findstr /C:"shop-settings" WeldingProject\license\middleware.py >nul 2>&1
if errorlevel 1 (echo   [FAIL] Skip shop-settings missing & set /a FAIL+=1) else (echo   [OK] Skip: shop-settings & set /a OK+=1)
findstr /C:"remote-activate" WeldingProject\license\middleware.py >nul 2>&1
if errorlevel 1 (echo   [FAIL] Skip remote-activate missing & set /a FAIL+=1) else (echo   [OK] Skip: remote-activate & set /a OK+=1)
findstr /C:"LicenseStatusView" WeldingProject\license\views.py >nul 2>&1
if errorlevel 1 (echo   [FAIL] status view missing & set /a FAIL+=1) else (echo   [OK] License status view & set /a OK+=1)
findstr /C:"LicenseActivateView" WeldingProject\license\views.py >nul 2>&1
if errorlevel 1 (echo   [FAIL] activate view missing & set /a FAIL+=1) else (echo   [OK] License activate view & set /a OK+=1)
findstr /C:"RemoteLicenseActivateView" WeldingProject\license\views.py >nul 2>&1
if errorlevel 1 (echo   [FAIL] remote view missing & set /a FAIL+=1) else (echo   [OK] Remote activate view & set /a OK+=1)
findstr /C:"check_license_status" WeldingProject\license\services.py >nul 2>&1
if errorlevel 1 (echo   [FAIL] check_license_status & set /a FAIL+=1) else (echo   [OK] check_license_status & set /a OK+=1)
findstr /C:"load_license_from_file" WeldingProject\license\utils.py >nul 2>&1
if errorlevel 1 (echo   [FAIL] load_license_from_file & set /a FAIL+=1) else (echo   [OK] load_license_from_file & set /a OK+=1)
findstr /C:"save_license_to_file" WeldingProject\license\utils.py >nul 2>&1
if errorlevel 1 (echo   [FAIL] save_license_to_file & set /a FAIL+=1) else (echo   [OK] save_license_to_file & set /a OK+=1)
echo.

echo ===== Summary =====
echo   Checks passed: %OK%  -  Failed: %FAIL%
echo.
echo Next steps:
echo   - EXE:    run build_exe.bat then HoBoPOS_Release\HoBoPOS.exe
echo   - Hosting: npm run build in yp_posf, then docker-compose up -d
echo   - License: GET /api/license/status/ and Settings - License Activation
echo   - Full doc: docs\STATUS_EXE_HOSTING_LICENSE.md
echo.
endlocal
exit /b 0
