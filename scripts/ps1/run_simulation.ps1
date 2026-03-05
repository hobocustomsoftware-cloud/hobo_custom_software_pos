# Run One Month Simulation and Generate Screenshots
# This script runs the simulation, checks for errors, and generates screenshots

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "HoBo POS - One Month Simulation" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Check if Docker is running
Write-Host "`n[1/5] Checking Docker services..." -ForegroundColor Yellow
$dockerStatus = docker compose ps --format json | ConvertFrom-Json
$backendRunning = $dockerStatus | Where-Object { $_.Service -eq "backend" -and $_.State -eq "running" }
$frontendRunning = $dockerStatus | Where-Object { $_.Service -eq "frontend" -and $_.State -eq "running" }

if (-not $backendRunning) {
    Write-Host "[ERROR] Backend container is not running!" -ForegroundColor Red
    Write-Host "Starting Docker services..." -ForegroundColor Yellow
    docker compose up -d
    Start-Sleep -Seconds 10
}

if (-not $frontendRunning) {
    Write-Host "[ERROR] Frontend container is not running!" -ForegroundColor Red
    Write-Host "Starting Docker services..." -ForegroundColor Yellow
    docker compose up -d
    Start-Sleep -Seconds 10
}

Write-Host "[OK] Docker services running" -ForegroundColor Green

# Check backend health
Write-Host "`n[2/5] Checking backend health..." -ForegroundColor Yellow
try {
    $healthResponse = Invoke-WebRequest -Uri "http://localhost:8000/health/" -Method GET -TimeoutSec 5
    if ($healthResponse.StatusCode -eq 200) {
        Write-Host "[OK] Backend health check passed" -ForegroundColor Green
    } else {
        Write-Host "[WARNING] Backend health check returned status $($healthResponse.StatusCode)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "[ERROR] Backend health check failed: $_" -ForegroundColor Red
    exit 1
}

# Run database migrations
Write-Host "`n[3/5] Running database migrations..." -ForegroundColor Yellow
docker compose exec -T backend python manage.py migrate --noinput
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Migrations failed!" -ForegroundColor Red
    exit 1
}
Write-Host "[OK] Migrations completed" -ForegroundColor Green

# Run simulation
Write-Host "`n[4/5] Running one month simulation..." -ForegroundColor Yellow
Write-Host "This may take several minutes..." -ForegroundColor Yellow
docker compose exec -T backend python manage.py simulate_month --skip-delay
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Simulation failed!" -ForegroundColor Red
    exit 1
}
Write-Host "[OK] Simulation completed successfully" -ForegroundColor Green

# Generate screenshots
Write-Host "`n[5/5] Generating screenshots..." -ForegroundColor Yellow
python screenshot_story.py
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Screenshot generation failed!" -ForegroundColor Red
    exit 1
}
Write-Host "[OK] Screenshots generated" -ForegroundColor Green

# Build slideshow
Write-Host "`n[6/6] Building HTML slideshow..." -ForegroundColor Yellow
python build_slideshow.py
if ($LASTEXITCODE -ne 0) {
    Write-Host "[WARNING] Slideshow build failed, but screenshots are available" -ForegroundColor Yellow
} else {
    Write-Host "[OK] Slideshow built successfully" -ForegroundColor Green
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Simulation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Screenshots: ./screenshots/" -ForegroundColor White
Write-Host "Slideshow: ./solar_pos_demo_*.html" -ForegroundColor White
