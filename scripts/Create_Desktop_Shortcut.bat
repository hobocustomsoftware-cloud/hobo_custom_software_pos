@echo off
setlocal
title Create HoBo POS Desktop Shortcut

set "SCRIPT_DIR=%~dp0"
set "ROOT=%SCRIPT_DIR%.."
set "EXE="

if exist "%SCRIPT_DIR%HoBoPOS.exe" (
  set "EXE=%SCRIPT_DIR%HoBoPOS.exe"
  set "WORKDIR=%SCRIPT_DIR%"
) else if exist "%ROOT%\HoBoPOS_Release\HoBoPOS.exe" (
  set "EXE=%ROOT%\HoBoPOS_Release\HoBoPOS.exe"
  set "WORKDIR=%ROOT%\HoBoPOS_Release\"
) else if exist "%ROOT%\HoBoPOS.exe" (
  set "EXE=%ROOT%\HoBoPOS.exe"
  set "WORKDIR=%ROOT%\"
) else (
  echo HoBoPOS.exe not found.
  echo Place this batch in the same folder as HoBoPOS.exe, or run from project root.
  pause
  exit /b 1
)

set "DESKTOP=%USERPROFILE%\Desktop"
set "LINK=%DESKTOP%\HoBo POS.lnk"

echo Creating shortcut: "%LINK%"
echo Target: "%EXE%"
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ws = New-Object -ComObject WScript.Shell;" ^
  "$s = $ws.CreateShortcut('%LINK%');" ^
  "$s.TargetPath = '%EXE%';" ^
  "$s.WorkingDirectory = '%WORKDIR%';" ^
  "$s.Description = 'HoBo POS';" ^
  "$s.Save();" ^
  "Write-Host 'Done. Shortcut created on Desktop.'"

if errorlevel 1 (
  echo Failed to create shortcut.
  pause
  exit /b 1
)

echo.
echo You can now double-click "HoBo POS" on your Desktop to start.
pause
