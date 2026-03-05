@echo off
REM HoBo POS - One command: build EXE (onedir) then build setup.exe (Windows installer)
REM Client: run setup.exe -> choose desktop + start menu shortcuts -> use shortcut.
setlocal
cd /d "%~dp0"

echo [1/2] Building EXE (onedir) to HoBoPOS_Release...
call build_exe.bat
if errorlevel 1 ( echo build_exe.bat failed. & pause & exit /b 1 )

echo.
echo [2/2] Building Windows installer (setup.exe)...

set "INSTALLER_DIR=deploy\installer"
set "DIST=%INSTALLER_DIR%\dist"
set "RELEASE=HoBoPOS_Release"

if not exist "%RELEASE%\HoBoPOS.exe" (
  echo HoBoPOS_Release\HoBoPOS.exe not found.
  pause
  exit /b 1
)

REM Prepare dist: full onedir so setup installs everything
if exist "%DIST%" rmdir /S /Q "%DIST%"
mkdir "%DIST%"
xcopy /E /I /Y "%RELEASE%\*" "%DIST%\" >nul
if exist "%INSTALLER_DIR%\logo.ico" copy /Y "%INSTALLER_DIR%\logo.ico" "%DIST%\" >nul
if exist "%INSTALLER_DIR%\HoBoPOS.ini.example" copy /Y "%INSTALLER_DIR%\HoBoPOS.ini.example" "%DIST%\HoBoPOS.ini" >nul

REM Find ISCC (Inno Setup)
set "ISCC="
for %%P in (
  "%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe"
  "%ProgramFiles%\Inno Setup 6\ISCC.exe"
  "%LOCALAPPDATA%\Programs\Inno Setup 6\ISCC.exe"
  "%USERPROFILE%\AppData\Local\Inno Setup 6\ISCC.exe"
) do if exist %%P ( set "ISCC=%%~P" & goto :found_iscc )
where ISCC.exe >nul 2>&1 && set "ISCC=ISCC.exe"
:found_iscc

if not defined ISCC (
  echo Inno Setup not found. Install from https://jrsoftware.org/isinfo.php
  echo Or run: deploy\installer\build.ps1  (it can install Inno via winget)
  pause
  exit /b 1
)

cd "%INSTALLER_DIR%"
"%ISCC%" welding_pos.iss
cd /d "%~dp0"

if exist "%INSTALLER_DIR%\dist\hobo_pos_setup.exe" (
  echo.
  echo Done. Installer: %INSTALLER_DIR%\dist\hobo_pos_setup.exe
  echo Give this file to client. They run it -> choose shortcuts -> use HoBo POS.
) else (
  echo Inno Setup compile failed.
  exit /b 1
)
pause
