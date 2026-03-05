@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo.
echo Marketing Screenshots: Backend + Frontend စတင် ပြီး စာမျက်နှာတိုင်း ဓာတ်ပုံ သိမ်းမယ်
echo (အရင် screenshot တွေကို မဖျက်ပစ်ဘဲ screenshots_for_marketing အတွင်းမှာ run_ တစ်ခုချင်း ထပ်ထည့်မယ်)
echo.
node run_marketing_screenshots.mjs
echo.
pause
