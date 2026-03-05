@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo.
echo ===== အဆင့် ၃: Windows EXE ထုတ်ခြင်း =====
echo Expo Go နဲ့ Docker စမ်းပြီး အကုန်အဆင်ပြေမှ ဤ script ကို ပြေးပါ။
echo.
call build_exe.bat
echo.
pause
