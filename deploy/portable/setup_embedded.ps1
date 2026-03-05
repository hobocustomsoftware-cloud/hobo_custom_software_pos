# HoBo POS - Setup Embedded Python + Waitress (portable package)
# Run from project root: .\deploy\portable\setup_embedded.ps1

$ErrorActionPreference = "Stop"
$PortableDir = Join-Path $PSScriptRoot "output"
$PythonDir = Join-Path $PortableDir "python"
$AppDir = Join-Path $PortableDir "app"
$ProjectRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$WeldingProject = Join-Path $ProjectRoot "WeldingProject"
$VueDist = Join-Path $WeldingProject "static_frontend"
$RequirementsMain = Join-Path $WeldingProject "requirements.txt"

# Python 3.11 embeddable (official)
$PyEmbedUrl = "https://www.python.org/ftp/python/3.11.9/python-3.11.9-embed-amd64.zip"
$PyZip = Join-Path $env:TEMP "python-embed.zip"
$GetPipUrl = "https://bootstrap.pypa.io/get-pip.py"
$GetPipPath = Join-Path $env:TEMP "get-pip.py"

Write-Host "1. Creating output folder..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path $PortableDir -Force | Out-Null
New-Item -ItemType Directory -Path $PythonDir -Force | Out-Null

Write-Host "2. Downloading Python embeddable..." -ForegroundColor Cyan
if (-not (Test-Path $PythonDir "\python.exe")) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $PyEmbedUrl -OutFile $PyZip -UseBasicParsing
    Expand-Archive -Path $PyZip -DestinationPath $PythonDir -Force
    Remove-Item $PyZip -Force -ErrorAction SilentlyContinue
}

# Enable pip in embedded: edit pythonXX._pth to add Lib\site-packages and import site
$PthFile = Get-ChildItem (Join-Path $PythonDir "*.pth") | Select-Object -First 1
if ($PthFile) {
    $content = Get-Content $PthFile.FullName -Raw
    if ($content -notmatch "site-packages") {
        $lines = Get-Content $PthFile.FullName
        $newLines = @()
        foreach ($line in $lines) {
            $newLines += $line -replace "#import site", "import site"
        }
        $newLines += "Lib\site-packages"
        $newLines | Set-Content $PthFile.FullName
    }
}

Write-Host "3. Installing pip into embedded Python..." -ForegroundColor Cyan
$PyExe = Join-Path $PythonDir "python.exe"
if (-not (Test-Path (Join-Path $PythonDir "Scripts\pip.exe"))) {
    Invoke-WebRequest -Uri $GetPipUrl -OutFile $GetPipPath -UseBasicParsing
    & $PyExe $GetPipPath --no-warn-script-location
}

Write-Host "4. Installing requirements + Waitress into python\Lib\site-packages..." -ForegroundColor Cyan
$PipExe = Join-Path $PythonDir "Scripts\pip.exe"
& $PipExe install --no-warn-script-location -r $RequirementsMain
& $PipExe install --no-warn-script-location waitress

Write-Host "5. Copying app (WeldingProject + static_frontend)..." -ForegroundColor Cyan
if (Test-Path $AppDir) { Remove-Item $AppDir -Recurse -Force }
Copy-Item $WeldingProject $AppDir -Recurse -Force
# Remove heavy/unneeded folders
@("staticfiles", "__pycache__") | ForEach-Object {
    $p = Join-Path $AppDir $_
    if (Test-Path $p) { Remove-Item $p -Recurse -Force }
}
Get-ChildItem $AppDir -Recurse -Filter "*.pyc" -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
if (Test-Path (Join-Path $AppDir "db.sqlite3")) { Remove-Item (Join-Path $AppDir "db.sqlite3") -Force }
# Ensure static_frontend exists (Vue dist)
if (-not (Test-Path (Join-Path $AppDir "static_frontend\index.html"))) {
    Write-Host "   Building Vue first..." -ForegroundColor Yellow
    Set-Location (Join-Path $ProjectRoot "yp_posf")
    $env:VITE_BASE = "/app/"
    npm run build
    Set-Location $ProjectRoot
    New-Item -ItemType Directory -Path (Join-Path $AppDir "static_frontend") -Force | Out-Null
    Copy-Item (Join-Path $ProjectRoot "yp_posf\dist\*") (Join-Path $AppDir "static_frontend") -Recurse -Force
}

Write-Host "6. Copying launch.bat, run_waitress.py, run_hidden.vbs, logo..." -ForegroundColor Cyan
Copy-Item (Join-Path $PSScriptRoot "launch.bat") $PortableDir -Force
Copy-Item (Join-Path $PSScriptRoot "run_waitress.py") $PortableDir -Force
Copy-Item (Join-Path $PSScriptRoot "run_hidden.vbs") $PortableDir -Force
# logo.ico for launcher (WinSW icon) - from assets or deploy/installer
$LogoIco = Join-Path $ProjectRoot "assets\logo.ico"
if (-not (Test-Path $LogoIco)) { $LogoIco = Join-Path $ProjectRoot "deploy\installer\logo.ico" }
if (Test-Path $LogoIco) { Copy-Item $LogoIco (Join-Path $PortableDir "logo.ico") -Force; Write-Host "   logo.ico copied for launcher." -ForegroundColor Gray }
# HoBoPOS.xml (WinSW config – same base name as .exe)
Copy-Item (Join-Path $PSScriptRoot "HoBoPOS.WinSW.xml") (Join-Path $PortableDir "HoBoPOS.xml") -Force

Write-Host "7. Downloading WinSW -> HoBoPOS.exe (launcher)..." -ForegroundColor Cyan
$WinSwUrl = "https://github.com/winsw/winsw/releases/download/v2.12.0/WinSW-x64.exe"
$WinSwExe = Join-Path $PortableDir "HoBoPOS.exe"
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $WinSwUrl -OutFile $WinSwExe -UseBasicParsing -TimeoutSec 60
    Write-Host "   HoBoPOS.exe launcher created." -ForegroundColor Green
} catch {
    Write-Host "   WinSW download failed. Run launch.bat to start, or download WinSW manually." -ForegroundColor Yellow
}
# Start_HoBoPOS.bat: run exe in run-once mode (not as service)
@"
@echo off
cd /d "%~dp0"
HoBoPOS.exe run
"@ | Set-Content (Join-Path $PortableDir "Start_HoBoPOS.bat") -Encoding ASCII

Write-Host "Done. Portable package: deploy\portable\output\" -ForegroundColor Green
Write-Host "Run: .\launch.bat  or  .\Start_HoBoPOS.bat  or  .\HoBoPOS.exe run" -ForegroundColor Cyan
