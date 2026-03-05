@echo off
REM Browser ဖွင့်ပြီး အစအဆုံး demo စမ်းသပ်ချက်
REM - Backend: cd WeldingProject ^& python manage.py runserver 127.0.0.1:8000
REM - Frontend: cd yp_posf ^& npm run dev   (သို့) Django က /app/ serve လုပ်ထားရင် ဒီ bat ပဲ run ပါ
setlocal
cd /d "%~dp0\.."

REM Base URL: Django က port 8000 မှာ frontend + API serve လုပ်ရင်
set PLAYWRIGHT_BASE_URL=http://127.0.0.1:8000/app
REM Browser ပေါ်ပြမယ် (မြင်ရအောင်)
set PLAYWRIGHT_HEADED=1
REM Login သုံးမယ့် user (ပြင်နိုင်သည်). DO_REGISTER=1 ဆိုရင် စာရင်းသွင်းပြီး ဆိုင်လည်ပတ်မှု စမ်းမယ်
if "%PLAYWRIGHT_DO_REGISTER%"=="" set PLAYWRIGHT_DO_REGISTER=1
if "%PLAYWRIGHT_LOGIN_USER%"=="" set PLAYWRIGHT_LOGIN_USER=09123456789
if "%PLAYWRIGHT_LOGIN_PASS%"=="" set PLAYWRIGHT_LOGIN_PASS=demo1234

echo [1] Running browser demo (headed). Report will be in demo_results\browser_demo\
echo     Base URL: %PLAYWRIGHT_BASE_URL%
echo     Login: %PLAYWRIGHT_LOGIN_USER%
echo.
cd yp_posf
npx playwright test e2e/browser_demo_report.spec.js --project=chromium --headed
set EXIT=%errorlevel%
cd ..
if %EXIT% neq 0 (
  echo.
  echo Demo had failures. Check demo_results\browser_demo\report.txt and screenshots.
)
exit /b %EXIT%
