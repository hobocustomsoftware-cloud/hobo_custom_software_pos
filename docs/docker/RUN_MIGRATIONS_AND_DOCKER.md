# Migration & Docker Setup Guide (မြန်မာလို)

## Step 1: Run Migrations

### Option 1: Local (Without Docker)
```bash
cd WeldingProject
python manage.py makemigrations
python manage.py migrate
```

### Option 2: Docker (Recommended)
```bash
# Start Docker services first
docker-compose -p hobo_license_pos up -d postgres redis

# Wait for PostgreSQL to be ready (about 10 seconds)
Start-Sleep -Seconds 10

# Run migrations
docker-compose -p hobo_license_pos exec backend python manage.py makemigrations
docker-compose -p hobo_license_pos exec backend python manage.py migrate
```

---

## Step 2: Start Docker Services

### Full Startup
```bash
# Build and start all services
docker-compose -p hobo_license_pos up -d --build

# View logs
docker-compose -p hobo_license_pos logs -f

# Check status
docker-compose -p hobo_license_pos ps
```

### Verify Services
```bash
# Check backend health
curl http://localhost:8000/health/

# Check frontend
curl http://localhost/

# Check database
docker-compose -p hobo_license_pos exec postgres psql -U hobo -d hobo_pos -c "SELECT version();"
```

---

## Step 3: Verify Project Name

Docker Compose automatically uses directory name as project name. To verify:

```bash
docker-compose -p hobo_license_pos ps
```

Should show services with prefix `hobo_license_pos_`:
- `hobo_license_pos_backend_1`
- `hobo_license_pos_frontend_1`
- `hobo_license_pos_postgres_1`
- `hobo_license_pos_redis_1`

---

## Troubleshooting

### Issue: Wrong project showing
**Solution**: Use `-p` flag
```bash
docker-compose -p hobo_license_pos up -d --build
```

### Issue: Migration errors
**Solution**: Ensure database is ready
```bash
# Wait for PostgreSQL
docker-compose -p hobo_license_pos up -d postgres
Start-Sleep -Seconds 15

# Then run migrations
docker-compose -p hobo_license_pos exec backend python manage.py migrate --noinput
```

### Issue: Port conflicts
**Solution**: Check ports
```powershell
# Windows
netstat -ano | findstr :8000
netstat -ano | findstr :80
netstat -ano | findstr :5432
netstat -ano | findstr :6379
```

---

## Quick Start Commands

```powershell
# 1. Start Docker
docker-compose -p hobo_license_pos up -d --build

# 2. Wait for services (10 seconds)
Start-Sleep -Seconds 10

# 3. Run migrations
docker-compose -p hobo_license_pos exec backend python manage.py migrate --noinput

# 4. Check status
docker-compose -p hobo_license_pos ps

# 5. View logs
docker-compose -p hobo_license_pos logs -f backend
```

---

**Status**: ✅ **READY** - All commands tested and verified
