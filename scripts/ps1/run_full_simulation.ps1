# =============================================================================
# HoBo POS - Full simulation and E2E stress test (Windows PowerShell, 100% automated)
# =============================================================================

$ErrorActionPreference = 'Stop'
$ROOT_DIR = $PSScriptRoot
Set-Location $ROOT_DIR

# Clear console and print header
Clear-Host
Write-Host ''
Write-Host '=============================================================================' -ForegroundColor Cyan
Write-Host '  Starting HoBo POS Full Business Simulation...' -ForegroundColor White
Write-Host '=============================================================================' -ForegroundColor Cyan
Write-Host ''

$VENV_DIR = if ($env:VENV_DIR) { $env:VENV_DIR } else { Join-Path $ROOT_DIR '.venv' }
$VENV_ACTIVATE = Join-Path $VENV_DIR 'Scripts\Activate.ps1'
$REQUIREMENTS_FILE = Join-Path $ROOT_DIR 'WeldingProject\requirements.txt'
$FRONTEND_DIR = Join-Path $ROOT_DIR 'yp_posf'
$BACKEND_URL = if ($env:BACKEND_URL) { $env:BACKEND_URL } else { 'http://127.0.0.1:8000' }
$BACKEND_HEALTH = "$BACKEND_URL/health/"
$MAX_WAIT = if ($env:MAX_WAIT) { [int]$env:MAX_WAIT } else { 120 }
$FRONTEND_PORTS = @(5173, 5174)

$BackendProcess = $null
$FrontendProcess = $null

function Stop-BackgroundServers {
  Write-Host ''
  Write-Host '[Cleanup] Stopping background servers...'
  if ($BackendProcess -and -not $BackendProcess.HasExited) {
    Stop-Process -Id $BackendProcess.Id -Force -ErrorAction SilentlyContinue
    Write-Host "  Backend (PID $($BackendProcess.Id)) stopped."
  }
  if ($FrontendProcess -and -not $FrontendProcess.HasExited) {
    Stop-Process -Id $FrontendProcess.Id -Force -ErrorAction SilentlyContinue
    Write-Host "  Frontend (PID $($FrontendProcess.Id)) stopped."
  }
  try {
    foreach ($port in @(8000, 5173, 5174)) {
      $conn = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue | Select-Object -First 1
      if ($conn -and $conn.OwningProcess) {
        Stop-Process -Id $conn.OwningProcess -Force -ErrorAction SilentlyContinue
        Write-Host "  Stopped process on port $port."
      }
    }
  } catch {
    # Ignored
  }
}

function Test-UrlReady {
  param([string]$Url, [int]$TimeoutSec = 2)
  try {
    $r = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec $TimeoutSec -ErrorAction Stop
    return $r.StatusCode -ge 200 -and $r.StatusCode -lt 400
  } catch {
    return $false
  }
}

try {
  # ----- 0. Auto-setup -----
  Write-Host '[0/6] Auto-setup (venv + backend + frontend)...'

  if (-not (Test-Path $VENV_ACTIVATE)) {
    Write-Host "  Creating virtualenv at $VENV_DIR..."
    python -m venv $VENV_DIR
  }
  & $VENV_ACTIVATE

  $djangoOk = $false
  try {
    $null = python -c 'import django' 2>&1
    if ($LASTEXITCODE -eq 0) { $djangoOk = $true }
  } catch { $djangoOk = $false }
  if (-not $djangoOk) {
    Write-Host '  Installing backend dependencies...'
    if (Test-Path $REQUIREMENTS_FILE) {
      pip install -q -r $REQUIREMENTS_FILE
    } else {
      pip install -q django djangorestframework djangorestframework-simplejwt django-cors-headers
    }
  }
  Write-Host '  Backend deps OK.'

  $nodeModules = Join-Path $FRONTEND_DIR 'node_modules'
  if (-not (Test-Path $nodeModules)) {
    Write-Host '  Installing frontend dependencies (npm install)...'
    Push-Location $FRONTEND_DIR
    npm install
    Pop-Location
  } else {
    Write-Host '  Frontend deps OK (node_modules present).'
  }

  Push-Location $FRONTEND_DIR
  npx playwright install chromium 2>$null
  Pop-Location
  Write-Host '  Auto-setup done.'
  Write-Host ''

  # ----- 1. Start backend -----
  Write-Host "[1/6] Starting Django backend on $BACKEND_URL..."
  $pythonExe = Join-Path $VENV_DIR 'Scripts\python.exe'
  $backendArgs = 'manage.py', 'runserver', '0.0.0.0:8000'
  $BackendProcess = Start-Process -FilePath $pythonExe -ArgumentList $backendArgs -WorkingDirectory (Join-Path $ROOT_DIR 'WeldingProject') -PassThru
  Write-Host "  Backend PID: $($BackendProcess.Id)"

  # ----- 2. Start frontend -----
  Write-Host '[2/6] Starting Vue frontend...'
  $FrontendProcess = Start-Process -FilePath 'cmd.exe' -ArgumentList '/c', 'npm run dev' -WorkingDirectory $FRONTEND_DIR -PassThru -WindowStyle Hidden
  Write-Host "  Frontend PID: $($FrontendProcess.Id)"

  # ----- 3. Wait for servers -----
  Write-Host "[3/6] Waiting for servers to be ready (max ${MAX_WAIT}s)..."

  $elapsed = 0
  while ($elapsed -lt $MAX_WAIT) {
    if (Test-UrlReady $BACKEND_HEALTH) {
      Write-Host '  Backend is ready.'
      break
    }
    Start-Sleep -Seconds 2
    $elapsed += 2
    Write-Host "  Waiting for Backend... ${elapsed}s"
  }
  if ($elapsed -ge $MAX_WAIT) {
    throw 'Backend did not become ready in time.'
  }

  $FRONTEND_URL = $null
  $elapsed = 0
  while ($elapsed -lt $MAX_WAIT) {
    foreach ($port in $FRONTEND_PORTS) {
      $url = "http://localhost:${port}/"
      if (Test-UrlReady $url) {
        $FRONTEND_URL = "http://localhost:$port"
        Write-Host "  Frontend is ready at $FRONTEND_URL"
        break
      }
    }
    if ($FRONTEND_URL) { break }
    Start-Sleep -Seconds 2
    $elapsed += 2
    Write-Host "  Waiting for Frontend... ${elapsed}s"
  }
  if (-not $FRONTEND_URL) {
    throw 'Frontend did not become ready in time.'
  }

  # ----- 4. Run migrations then simulation data -----
  Write-Host '[4/6] Applying migrations and running MINIMAL simulation data (to prevent Memory Crash)...'
  & $VENV_ACTIVATE
  Push-Location (Join-Path $ROOT_DIR 'WeldingProject')
  python manage.py migrate --noinput
  # 30 days of data to reduce Docker memory usage
  python manage.py run_simulation_data --days 30
  Pop-Location
  Write-Host '  Simulation data done.'

  # ----- 5. Manual testing -----
  Write-Host '[5/6] Servers and Data are READY! Open http://localhost:5173 to test manually.' -ForegroundColor Green
  Write-Host ''
  Write-Host "Press Ctrl+C to stop the servers and exit..." -ForegroundColor Yellow
  while ($true) { Start-Sleep -Seconds 1 }
} finally {
  Stop-BackgroundServers
}