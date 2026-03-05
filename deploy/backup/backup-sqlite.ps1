# SQLite Backup Script for HoBo POS (when not using Docker/PostgreSQL)
# Run daily via Task Scheduler if you use db.sqlite3

$ErrorActionPreference = "Stop"

$ProjectRoot = "F:\hobo_license_pos"
$DbPath = Join-Path $ProjectRoot "db.sqlite3"
$BackupDir = Join-Path $ProjectRoot "backups"
$RetentionDays = 30

if (-not (Test-Path $DbPath)) {
    Write-Host "[SKIP] db.sqlite3 not found at $DbPath"
    exit 0
}

if (-not (Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
}

$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$BackupFile = Join-Path $BackupDir "hobo_sqlite_$Timestamp.db"

Write-Host "[$(Get-Date)] Backing up SQLite to $BackupFile..."
try {
    Copy-Item -Path $DbPath -Destination $BackupFile -Force
    Write-Host "[$(Get-Date)] Backup completed: $BackupFile"
    Get-ChildItem $BackupDir -Filter "hobo_sqlite_*.db" | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$RetentionDays) } | Remove-Item
} catch {
    Write-Host "[ERROR] Backup failed: $_" -ForegroundColor Red
    exit 1
}
