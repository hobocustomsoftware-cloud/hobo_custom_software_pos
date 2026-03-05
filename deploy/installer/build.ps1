# HoBo POS - EXE Build Script
# Run from project root: .\deploy\installer\build.ps1
# Venv: .\venv\Scripts\Activate.ps1 (activate before run if needed)

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$DeployInstaller = Join-Path $ProjectRoot "deploy\installer"
$WeldingProject = Join-Path $ProjectRoot "WeldingProject"
$VueProject = Join-Path $ProjectRoot "yp_posf"
$VenvPath = Join-Path $ProjectRoot "venv\Scripts\Activate.ps1"

Write-Host "1. Creating logo.png for frontend (Register, Login)..." -ForegroundColor Cyan
$AssetsDir = Join-Path $ProjectRoot "assets"
if (-not (Test-Path $AssetsDir)) { New-Item -ItemType Directory -Path $AssetsDir -Force | Out-Null }
$PythonExe = if (Test-Path (Join-Path $ProjectRoot "venv\Scripts\python.exe")) { Join-Path $ProjectRoot "venv\Scripts\python.exe" } else { "python" }
Set-Location $DeployInstaller
& $PythonExe make_icon.py

Write-Host "2. Building Vue (base /app/ for EXE)..." -ForegroundColor Cyan
Set-Location $VueProject
$env:VITE_BASE = "/app/"
npm run build

Write-Host "3. Copying Vue build to WeldingProject/static_frontend..." -ForegroundColor Cyan
$StaticFrontend = Join-Path $WeldingProject "static_frontend"
if (Test-Path $StaticFrontend) { Remove-Item $StaticFrontend -Recurse -Force }
New-Item -ItemType Directory -Path $StaticFrontend -Force
Copy-Item (Join-Path $VueProject "dist\*") $StaticFrontend -Recurse -Force

Write-Host "4. Collecting Django static..." -ForegroundColor Cyan
Set-Location $WeldingProject
if (Test-Path $VenvPath) {
    & $VenvPath
}
python manage.py collectstatic --noinput --clear 2>$null

Write-Host "5. PyInstaller..." -ForegroundColor Cyan
Set-Location $DeployInstaller
$pyinstaller = $null
if (Get-Command pyinstaller -ErrorAction SilentlyContinue) { $pyinstaller = "pyinstaller" }
elseif (Test-Path (Join-Path $ProjectRoot "venv\Scripts\pyinstaller.exe")) { $pyinstaller = (Join-Path $ProjectRoot "venv\Scripts\pyinstaller.exe") }
elseif (Test-Path "F:\yang_power\welding_env\Scripts\pyinstaller.exe") { $pyinstaller = "F:\yang_power\welding_env\Scripts\pyinstaller.exe" }
if ($pyinstaller) {
    if (Test-Path "dist\WeldingPOS.exe") { Remove-Item "dist\WeldingPOS.exe" -Force }
    & $pyinstaller welding_pos.spec
    if (Test-Path "dist\HoBoPOS.exe") {
        Write-Host "EXE created: deploy\installer\dist\HoBoPOS.exe" -ForegroundColor Green
        if (Test-Path "logo.ico") { Copy-Item "logo.ico" "dist\logo.ico" -Force }
        if (-not (Test-Path "dist\HoBoPOS.ini")) {
            Copy-Item "HoBoPOS.ini.example" "dist\HoBoPOS.ini"
            Write-Host "Config: dist\HoBoPOS.ini (License Server + DEBUG=false)" -ForegroundColor Gray
        }
    }
} else {
    Write-Host "PyInstaller not found. Install: pip install pyinstaller" -ForegroundColor Yellow
}

Write-Host "6. Inno Setup (Installer)..." -ForegroundColor Cyan
$iscc = $null
$innoUserDir = Join-Path $env:LOCALAPPDATA "InnoSetup6"
$isccUser = Join-Path $innoUserDir "ISCC.exe"
$userPaths = @(
    "C:\Users\Htoo\ISCC.exe",
    (Join-Path $env:USERPROFILE "Inno Setup 6\ISCC.exe"),
    (Join-Path $env:USERPROFILE "AppData\Local\Inno Setup 6\ISCC.exe"),
    (Join-Path $env:USERPROFILE "AppData\Local\Programs\Inno Setup 6\ISCC.exe"),
    (Join-Path $env:LOCALAPPDATA "Inno Setup 6\ISCC.exe"),
    $isccUser,
    "C:\Program Files (x86)\Inno Setup 6\ISCC.exe",
    "C:\Program Files\Inno Setup 6\ISCC.exe"
)
foreach ($p in $userPaths) {
    if (Test-Path $p) { $iscc = $p; break }
}
if (-not $iscc) {
    $found = Get-Command ISCC -ErrorAction SilentlyContinue
    if ($found) { $iscc = $found.Source }
}

if (-not $iscc) {
    Write-Host "Inno Setup မတွေ့ပါ။ winget ဖြင့် install လုပ်နေပါသည်..." -ForegroundColor Yellow
    try {
        winget install JRSoftware.InnoSetup --accept-package-agreements --accept-source-agreements 2>$null
        Start-Sleep -Seconds 3
        foreach ($p in @("C:\Program Files (x86)\Inno Setup 6\ISCC.exe", "C:\Program Files\Inno Setup 6\ISCC.exe", $isccUser)) {
            if (Test-Path $p) { $iscc = $p; break }
        }
    } catch { }
}

if (-not $iscc) {
    Write-Host "winget မအောင်မြင်ပါ။ ဒေါင်းပြီး install လုပ်နေပါသည် (Admin မလို)..." -ForegroundColor Yellow
    $innoUrl = "https://files.jrsoftware.org/is/6/innosetup-6.2.2.exe"
    $innoExe = Join-Path $env:TEMP "innosetup-install.exe"
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $innoUrl -OutFile $innoExe -UseBasicParsing -TimeoutSec 60
        New-Item -ItemType Directory -Path $innoUserDir -Force | Out-Null
        Start-Process -FilePath $innoExe -ArgumentList "/VERYSILENT", "/SUPPRESSMSGBOXES", "/NORESTART", "/DIR=$innoUserDir" -Wait
        Start-Sleep -Seconds 2
        Remove-Item $innoExe -Force -ErrorAction SilentlyContinue
    } catch {
        try {
            Invoke-WebRequest -Uri "https://jrsoftware.org/download.php/is.exe" -OutFile $innoExe -UseBasicParsing -TimeoutSec 90
            New-Item -ItemType Directory -Path $innoUserDir -Force | Out-Null
            Start-Process -FilePath $innoExe -ArgumentList "/VERYSILENT", "/SUPPRESSMSGBOXES", "/NORESTART", "/DIR=$innoUserDir" -Wait
            Start-Sleep -Seconds 2
            Remove-Item $innoExe -Force -ErrorAction SilentlyContinue
        } catch { }
    }
    if (Test-Path $isccUser) { $iscc = $isccUser }
    elseif (Test-Path "C:\Program Files (x86)\Inno Setup 6\ISCC.exe") { $iscc = "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" }
    elseif (Test-Path "C:\Program Files\Inno Setup 6\ISCC.exe") { $iscc = "C:\Program Files\Inno Setup 6\ISCC.exe" }
}

if ($iscc) {
    & $iscc "welding_pos.iss"
    if (Test-Path "dist\hobo_pos_setup.exe") {
        Write-Host "Installer: deploy\installer\dist\hobo_pos_setup.exe" -ForegroundColor Green
    }
} else {
    Write-Host "Inno Setup not found. Install from: https://jrsoftware.org/isinfo.php" -ForegroundColor Yellow
}

Write-Host "Done." -ForegroundColor Green
