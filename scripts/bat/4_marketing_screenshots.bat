@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo.
echo ===== အဆင့် ၄: ကြော်ငြာ / Marketing Screenshots =====
echo Backend + Frontend စတင်ပြီး စာမျက်နှာအလိုက် screenshot များ ရိုက်မယ်။
echo ရလဒ်များ: yp_posf\screenshots_for_marketing\run_*
echo.
call run_marketing_screenshots.bat
