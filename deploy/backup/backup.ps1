# PostgreSQL Backup Script for HoBo POS (PowerShell)
# Run daily via Task Scheduler

$ErrorActionPreference = "Stop"

# Configuration
$BackupDir = "F:\hobo_license_pos\backups"
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$DbName = $env:POSTGRES_DB
if (-not $DbName) { $DbName = "hobo_pos" }
$DbUser = $env:POSTGRES_USER
if (-not $DbUser) { $DbUser = "hobo" }
$DbHost = $env:POSTGRES_HOST
if (-not $DbHost) { $DbHost = "localhost" }
$RetentionDays = 30

# Create backup directory
if (-not (Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
}

# Docker container name
$ContainerName = "hobo_license_pos-postgres-1"

Write-Host "[$(Get-Date)] Starting backup for $DbName..."

try {
    # Backup using docker exec
    docker exec $ContainerName pg_dump -U $DbUser -d $DbName -F c -f "/tmp/backup_$Timestamp.dump"
    
    # Copy backup from container
    docker cp "${ContainerName}:/tmp/backup_$Timestamp.dump" "$BackupDir\hobo_pos_$Timestamp.dump"
    
    # Remove from container
    docker exec $ContainerName rm "/tmp/backup_$Timestamp.dump"
    
    # Compress backup
    Compress-Archive -Path "$BackupDir\hobo_pos_$Timestamp.dump" -DestinationPath "$BackupDir\hobo_pos_$Timestamp.dump.zip" -Force
    Remove-Item "$BackupDir\hobo_pos_$Timestamp.dump"
    
    # Remove old backups (keep last 30 days)
    Get-ChildItem "$BackupDir\hobo_pos_*.dump.zip" | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$RetentionDays) } | Remove-Item
    
    Write-Host "[$(Get-Date)] Backup completed: hobo_pos_$Timestamp.dump.zip"
} catch {
    Write-Host "[ERROR] Backup failed: $_" -ForegroundColor Red
    exit 1
}
