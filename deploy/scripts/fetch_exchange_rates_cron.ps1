# PowerShell script to fetch exchange rates daily at 10:00 AM
# Add to Task Scheduler: Daily at 10:00 AM
# Action: powershell.exe -File "F:\hobo_license_pos\deploy\scripts\fetch_exchange_rates_cron.ps1"

$ErrorActionPreference = "Stop"
$ProjectRoot = "F:\hobo_license_pos"
$LogFile = Join-Path $ProjectRoot "logs\exchange-rate-fetch.log"

# Create logs directory if not exists
$LogDir = Split-Path $LogFile -Parent
if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

# Change to project directory
Set-Location $ProjectRoot

# Activate virtual environment if exists
$VenvPath = Join-Path $ProjectRoot "venv\Scripts\Activate.ps1"
if (Test-Path $VenvPath) {
    & $VenvPath
}

# Run Django management command
try {
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "[$Timestamp] Starting exchange rate fetch..."
    
    Set-Location (Join-Path $ProjectRoot "WeldingProject")
    python manage.py fetch_exchange_rates
    
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "[$Timestamp] Exchange rate fetch completed successfully"
} catch {
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "[$Timestamp] ERROR: $_"
    exit 1
}
