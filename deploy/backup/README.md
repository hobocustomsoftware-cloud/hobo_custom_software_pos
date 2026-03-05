# Database Backup Strategy for HoBo POS

## Overview
Automated backup scripts for:
- **PostgreSQL** – Docker deployment (`backup.ps1` / `backup.sh`)
- **SQLite** – Dev or non-Docker (`backup-sqlite.ps1`)

## Backup Scripts

### PostgreSQL (Docker)

### Linux/Mac (`backup.sh`)
```bash
chmod +x deploy/backup/backup.sh
./deploy/backup/backup.sh
```

### Windows – PostgreSQL (`backup.ps1`)
```powershell
.\deploy\backup\backup.ps1
```

### Windows – SQLite (`backup-sqlite.ps1`)
Use when running with `db.sqlite3` (no Docker). Same `backups/` folder, 30-day retention.
```powershell
.\deploy\backup\backup-sqlite.ps1
```
Restore: stop app, copy `backups\hobo_sqlite_YYYYMMDD_HHMMSS.db` over `db.sqlite3`, then start app.

## Automated Scheduling

### Linux/Mac (Cron)
```bash
# Edit crontab
crontab -e

# Add daily backup at 2 AM
0 2 * * * /path/to/deploy/backup/backup.sh >> /var/log/hobopos-backup.log 2>&1
```

### Windows (Task Scheduler)
1. Open Task Scheduler
2. Create Basic Task
3. Name: "HoBo POS Daily Backup"
4. Trigger: Daily at 2:00 AM
5. Action: Start a program
   - Program: `powershell.exe`
   - Arguments: `-File "F:\hobo_license_pos\deploy\backup\backup.ps1"`
6. Save

## Backup Retention
- **Retention Period**: 30 days
- **Location**: `./backups/` directory
- **Format**: `hobo_pos_YYYYMMDD_HHMMSS.dump.gz`

## Restore Procedure

### From Backup File
```bash
# Extract backup
gunzip hobo_pos_20250217_020000.dump.gz

# Restore to database
docker compose exec -T postgres pg_restore -U hobo -d hobo_pos -c < hobo_pos_20250217_020000.dump
```

### PowerShell Restore
```powershell
# Extract backup
Expand-Archive -Path "backups\hobo_pos_20250217_020000.dump.zip" -DestinationPath "backups\"

# Restore
docker compose exec -T postgres pg_restore -U hobo -d hobo_pos -c < backups\hobo_pos_20250217_020000.dump
```

## Cloud Backup (Optional)

### AWS S3
Add to backup script:
```bash
aws s3 cp "$BACKUP_DIR/hobo_pos_$TIMESTAMP.dump.gz" s3://your-bucket/backups/
```

### Google Cloud Storage
```bash
gsutil cp "$BACKUP_DIR/hobo_pos_$TIMESTAMP.dump.gz" gs://your-bucket/backups/
```

## Monitoring
- Check backup logs regularly
- Verify backup file sizes (should be > 0)
- Test restore procedure monthly
- Monitor disk space for backup directory

## Best Practices
1. **3-2-1 Rule**: 3 copies, 2 different media, 1 offsite
2. **Test Restores**: Monthly restore tests
3. **Encryption**: Encrypt backups if containing sensitive data
4. **Monitoring**: Alert on backup failures
5. **Documentation**: Keep restore procedures documented
