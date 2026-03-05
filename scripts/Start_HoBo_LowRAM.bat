@echo off
REM RAM 2GB / Celeron စက်တွေအတွက် - memory နည်းနည်းနဲ့ EXE run မယ်
REM ဒီ ဖိုင်ကို HoBoPOS_Release folder ထဲ ကူးထည့်ပြီး ဒီ batch ကို run ပါ (သို့မဟုတ် shortcut လုပ်ပါ)
set HOBOPOS_LOW_RAM=1
cd /d "%~dp0"
if not exist HoBoPOS.exe (
  echo HoBoPOS.exe not found in this folder. Put this batch next to HoBoPOS.exe.
  pause
  exit /b 1
)
start "" HoBoPOS.exe
