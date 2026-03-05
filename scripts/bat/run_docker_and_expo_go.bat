@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo.
echo ===== Docker + Expo Go စမ်းသပ်မှု စတင်နေပါတယ် =====
echo.

echo [1/4] Docker Compose စတင်နေပါတယ် (postgres, redis, backend - postgres ပါပြီးသား)...
docker compose version >nul 2>&1 && set COMPOSE=docker compose || set COMPOSE=docker-compose
%COMPOSE% up -d postgres redis backend
if errorlevel 1 (
  echo Docker စတင်မအောင်မြင်ပါ။ Docker Desktop ဖွင့်ထားပါ သို့ docker-compose ရှိပါစေ။
  pause
  exit /b 1
)
echo Docker စတင်ပြီး (PostgreSQL + Redis + Backend)။ Backend: http://localhost:8000
echo.

echo [2/4] app.json အတွက် လက်ရှိ IP သတ်မှတ်နေပါတယ်...
cd yp_posf
node scripts/set-expo-ip.js
if errorlevel 1 (
  echo set-expo-ip မအောင်မြင်ပါ။
  cd ..
  pause
  exit /b 1
)
cd ..
echo.

echo [3/4] Vite (Vue) dev server ဖွင့်နေပါတယ် - ဝင်းဒိုးအသစ်...
start "HoBo POS - Vite" cmd /k "cd /d "%~dp0yp_posf" && npm run dev"
timeout /t 3 /nobreak >nul
echo.

echo [4/4] Expo စတင်နေပါတယ် - QR code ကို ဖုန်း Expo Go app နဲ့ စကင်န်ပါ...
start "HoBo POS - Expo Go" cmd /k "cd /d "%~dp0yp_posf" && npm run expo:start"
echo.
echo ----- ပြီးပါပြီ -----
echo   - Docker Backend: http://localhost:8000
echo   - Vite (Vue): ဝင်းဒိုးအသစ်မှာ http://localhost:5173
echo   - Expo: ဝင်းဒိုးအသစ်မှာ QR code ပေါ်မယ် - ဖုန်း Expo Go နဲ့ စကင်န်ပါ
echo   - ဖုန်းနဲ့ ကွန်ပျူတာ တစ်ကွန်ရက်တည်း (Same WiFi) ဖြစ်ရပါမယ်
echo   - တစ်ကွန်ရက်တည်းမဟုတ်ရင်: Expo ဝင်းဒိုးမှာ Ctrl+C လုပ်ပြီး npm run expo:start:tunnel ပြေးပါ
echo.
pause
