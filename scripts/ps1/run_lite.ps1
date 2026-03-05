# HoBo POS - Lightweight run (no EXE, 2GB RAM / Celeron friendly)
# Uses uvicorn (lighter than Daphne)

$ProjectRoot = Split-Path $MyInvocation.MyCommand.Path
Set-Location $ProjectRoot

# Activate venv
$venv = $null
foreach ($v in @("venv", "welding_env")) {
    $act = Join-Path $ProjectRoot "$v\Scripts\Activate.ps1"
    if (Test-Path $act) { & $act; break }
}

$env:HOBOPOS_DB_DIR = $ProjectRoot
$env:DEPLOYMENT_MODE = "on_premise"

# Build Vue if needed
$staticFrontend = Join-Path $ProjectRoot "WeldingProject\static_frontend\index.html"
if (-not (Test-Path $staticFrontend)) {
    Write-Host "Building Vue..." -ForegroundColor Cyan
    Set-Location (Join-Path $ProjectRoot "yp_posf")
    $env:VITE_BASE = "/app/"
    npm run build
    Set-Location $ProjectRoot
    $sf = Join-Path $ProjectRoot "WeldingProject\static_frontend"
    if (-not (Test-Path $sf)) { New-Item -ItemType Directory -Path $sf -Force }
    Copy-Item (Join-Path $ProjectRoot "yp_posf\dist\*") $sf -Recurse -Force
    Set-Location $ProjectRoot
}

Set-Location (Join-Path $ProjectRoot "WeldingProject")
Write-Host "Starting HoBo POS (lite)..." -ForegroundColor Green
Write-Host "Open: http://127.0.0.1:8000/app/" -ForegroundColor Cyan
Start-Process "http://127.0.0.1:8000/app/"
python -m uvicorn WeldingProject.asgi:application --host 127.0.0.1 --port 8000
