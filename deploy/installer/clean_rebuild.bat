@echo off
REM HoBo POS - မလိုတဲ့ EXE/build တွေ ဖျက်ပြီး အသစ်ပြန် build
REM Run: deploy\installer\clean_rebuild.bat

cd /d "%~dp0"

echo ========================================
echo 1. မလိုတဲ့ ဖိုင်တွေ ဖျက်နေပါသည်...
echo ========================================
if exist "dist" (
    rmdir /s /q dist
    echo   - dist\ ဖျက်ပြီး
)
if exist "build" (
    rmdir /s /q build
    echo   - build\ ဖျက်ပြီး
)
echo   Done.
echo.

echo ========================================
echo 2. အသစ်ပြန် build လုပ်နေပါသည်...
echo ========================================
cd /d "%~dp0..\.."
powershell -ExecutionPolicy Bypass -File "%~dp0build.ps1"

echo.
echo ========================================
echo 3. ပြီးပါပြီ
echo ========================================
echo.
echo EXE စမ်းရန်: deploy\installer\dist\HoBoPOS.exe
echo Installer: deploy\installer\dist\setup.exe
echo.
echo "Already exist account" ဖြစ်ရင်:
echo   - HoBoPOS.exe နဲ့ အတူ db.sqlite3 ဖိုင်ကို ဖျက်ပြီး ပြန်စမ်းပါ (အသစ်စာရင်းသွင်းနိုင်မည်)
echo.
pause
