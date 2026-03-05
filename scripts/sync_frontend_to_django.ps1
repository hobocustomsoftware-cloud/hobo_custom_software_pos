# Sync frontend build files to Django static_frontend directory
# This ensures localhost:8000/app/ uses the same design as localhost/

$FRONTEND_DIST = ".\yp_posf\dist"
$DJANGO_STATIC_FRONTEND = ".\WeldingProject\static_frontend"

Write-Host "🔄 Syncing frontend build to Django static_frontend..." -ForegroundColor Cyan

# Check if frontend dist exists
if (-not (Test-Path $FRONTEND_DIST)) {
    Write-Host "❌ Frontend dist directory not found: $FRONTEND_DIST" -ForegroundColor Red
    Write-Host "   Please build frontend first: cd yp_posf && npm run build" -ForegroundColor Yellow
    exit 1
}

# Create Django static_frontend directory if it doesn't exist
if (-not (Test-Path $DJANGO_STATIC_FRONTEND)) {
    New-Item -ItemType Directory -Path $DJANGO_STATIC_FRONTEND -Force | Out-Null
}

# Remove old files
Write-Host "🧹 Cleaning old files..." -ForegroundColor Yellow
Remove-Item -Path "$DJANGO_STATIC_FRONTEND\*" -Recurse -Force -ErrorAction SilentlyContinue

# Copy new build files
Write-Host "📦 Copying frontend build files..." -ForegroundColor Yellow
Copy-Item -Path "$FRONTEND_DIST\*" -Destination $DJANGO_STATIC_FRONTEND -Recurse -Force

Write-Host "✅ Frontend build synced successfully!" -ForegroundColor Green
Write-Host "   Django will serve from: $DJANGO_STATIC_FRONTEND" -ForegroundColor Gray
Write-Host "   Access at: http://localhost:8000/app/" -ForegroundColor Gray
