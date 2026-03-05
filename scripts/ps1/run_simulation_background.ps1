# တစ်လစာ Simulation ကို background မှာ run မယ်
#   .\run_simulation_background.ps1         = window အသစ်ဖွင့်ပြီး run (ပ်ကြည့်လို့ရမယ်)
#   .\run_simulation_background.ps1 -Silent = ဒီ terminal မှာပဲ background job, log က simulation_log.txt

param([switch]$Silent)

$ProjectRoot = if ($PSScriptRoot) { $PSScriptRoot } else { "F:\hobo_license_pos" }
$LogFile = Join-Path $ProjectRoot "simulation_log.txt"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "HoBo POS - Background Simulation" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

if ($Silent) {
    Write-Host "Starting in background. Log: simulation_log.txt" -ForegroundColor Yellow
    Start-Job -ScriptBlock {
        Set-Location $using:ProjectRoot
        $logPath = $using:LogFile
        "=== Started $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ===" | Out-File $logPath -Encoding utf8
        docker compose exec -T backend python manage.py migrate --noinput 2>&1 | Out-File $logPath -Append -Encoding utf8
        docker compose exec -T backend python manage.py simulate_month --skip-delay 2>&1 | Out-File $logPath -Append -Encoding utf8
        "=== Finished $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ===" | Out-File $logPath -Append -Encoding utf8
    } | Out-Null
    Write-Host "[OK] Running in background. To watch: Get-Content simulation_log.txt -Tail 20 -Wait" -ForegroundColor Green
} else {
    Write-Host "Opening new window..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$ProjectRoot'; docker compose exec -T backend python manage.py migrate --noinput; docker compose exec -T backend python manage.py simulate_month --skip-delay; Write-Host 'Done!' -ForegroundColor Green; Read-Host 'Press Enter to close'"
    Write-Host "[OK] Simulation running in new window. You can continue here." -ForegroundColor Green
}
