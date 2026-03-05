@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo.
echo ===== အဆင့် ၁: Expo Go စမ်းသပ်မှု =====
echo.
echo ၁) app.json အတွက် လက်ရှိ IP သတ်မှတ်မယ်...
cd yp_posf
node scripts/set-expo-ip.js
if errorlevel 1 ( echo set-expo-ip မအောင်မြင်ပါ။ & cd .. & pause & exit /b 1 )
cd ..
echo.
echo ၂) လုပ်ရမည့်အချက်များ:
echo    - Backend စတင်ပါ: WeldingProject\manage.py runserver 0.0.0.0:8000
echo      သို့ Docker: docker-compose up -d postgres redis backend
echo    - Frontend စတင်ပါ: cd yp_posf ^&^& npm run dev
echo    - Expo စတင်ပါ: cd yp_posf ^&^& npm run expo:start
echo      (တစ်ကွန်ရက်တည်းမဟုတ်ရင်: npm run expo:start:tunnel)
echo    - ဖုန်းမှာ Expo Go app ဖွင့်ပြီး QR code စကင်န်ပါ
echo.
echo အသေးစိတ်: docs\ROADMAP_EXPO_DOCKER_EXE_MARKETING.md
echo.
pause
