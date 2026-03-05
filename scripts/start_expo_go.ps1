# Start Expo Go App - Complete Setup Script
# This script starts Vue dev server, Expo, and ensures backend is running

Write-Host "🚀 Starting Expo Go App Setup..." -ForegroundColor Cyan
Write-Host ""

# Check if Docker is running
$dockerRunning = docker ps 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Docker is not running. Please start Docker Desktop first." -ForegroundColor Red
    exit 1
}

# Check if backend is running
$backendRunning = docker-compose ps backend 2>&1 | Select-String "Up"
if (-not $backendRunning) {
    Write-Host "⚠️  Backend is not running. Starting backend..." -ForegroundColor Yellow
    docker-compose up -d backend
    Start-Sleep -Seconds 5
}

# Get local IP address
Write-Host "📡 Finding local IP address..." -ForegroundColor Cyan
$localIp = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {
    $_.IPAddress -like "192.168.*" -or 
    $_.IPAddress -like "172.16.*" -or 
    $_.IPAddress -like "172.17.*" -or
    $_.IPAddress -like "172.20.*" -or
    $_.IPAddress -like "172.21.*" -or
    $_.IPAddress -like "10.*"
} | Select-Object -First 1).IPAddress

if (-not $localIp) {
    Write-Host "⚠️  Could not detect local IP. Using tunnel mode (recommended)." -ForegroundColor Yellow
    $useTunnel = $true
} else {
    Write-Host "✅ Found local IP: $localIp" -ForegroundColor Green
    $useTunnel = $false
}

# Update app.json with local IP
if (-not $useTunnel -and $localIp) {
    Write-Host "📝 Updating app.json with local IP..." -ForegroundColor Cyan
    $appJsonPath = ".\yp_posf\app.json"
    if (Test-Path $appJsonPath) {
        $appJson = Get-Content $appJsonPath -Raw | ConvertFrom-Json
        $appJson.expo.extra.localIp = $localIp
        $appJson.expo.extra.apiUrl = "http://${localIp}:8000/api"
        $appJson | ConvertTo-Json -Depth 10 | Set-Content $appJsonPath
        Write-Host "✅ Updated app.json" -ForegroundColor Green
    }
}

# Check if node_modules exists
$nodeModulesPath = ".\yp_posf\node_modules"
if (-not (Test-Path $nodeModulesPath)) {
    Write-Host "📦 Installing dependencies..." -ForegroundColor Cyan
    Set-Location yp_posf
    npm install
    Set-Location ..
}

# Start Vue dev server in background
Write-Host ""
Write-Host "🌐 Starting Vue dev server (Terminal 1)..." -ForegroundColor Cyan
$vueProcess = Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD\yp_posf'; npm run dev" -PassThru
Write-Host "✅ Vue dev server started (PID: $($vueProcess.Id))" -ForegroundColor Green
Write-Host "   Access at: http://localhost:5173" -ForegroundColor Gray
if (-not $useTunnel) {
    Write-Host "   Access at: http://${localIp}:5173" -ForegroundColor Gray
}

# Wait for Vue dev server to start
Write-Host ""
Write-Host "⏳ Waiting for Vue dev server to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Start Expo
Write-Host ""
if ($useTunnel) {
    Write-Host "🚇 Starting Expo with tunnel mode (Terminal 2)..." -ForegroundColor Cyan
    Write-Host "   Tunnel mode works on any network - no IP config needed!" -ForegroundColor Gray
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD\yp_posf'; npm run expo:start:tunnel"
} else {
    Write-Host "📱 Starting Expo (Terminal 2)..." -ForegroundColor Cyan
    Write-Host "   Make sure your phone is on the same WiFi network!" -ForegroundColor Gray
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD\yp_posf'; npm run expo:start"
}

Write-Host ""
Write-Host "✅ Expo Go setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📱 Next steps:" -ForegroundColor Cyan
Write-Host "   1. Install Expo Go app on your phone:" -ForegroundColor White
Write-Host "      - iOS: https://apps.apple.com/app/expo-go/id982107779" -ForegroundColor Gray
Write-Host "      - Android: https://play.google.com/store/apps/details?id=host.exp.exponent" -ForegroundColor Gray
Write-Host ""
Write-Host "   2. Scan QR code from Terminal 2 (Expo window)" -ForegroundColor White
Write-Host ""
Write-Host "   3. App will load in Expo Go!" -ForegroundColor White
Write-Host ""
if (-not $useTunnel) {
    Write-Host "💡 Tip: If QR code doesn't work, use tunnel mode:" -ForegroundColor Yellow
    Write-Host "   cd yp_posf && npm run expo:start:tunnel" -ForegroundColor Gray
}
Write-Host ""
Write-Host "🔧 Backend API:" -ForegroundColor Cyan
if (-not $useTunnel) {
    Write-Host "   http://${localIp}:8000/api" -ForegroundColor Gray
} else {
    Write-Host "   http://localhost:8000/api (via tunnel)" -ForegroundColor Gray
}
Write-Host ""
