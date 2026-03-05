# Docker Setup Fix - Project Name Configuration

## Problem
Docker run လုပ်တဲ့အခါ project အမှန်မဟုတ်ဘဲ တစ်ခြား project ပြနေတယ်။

## Solution
Docker Compose file မှာ project name ကို explicitly သတ်မှတ်ထားပြီးပါပြီ။

## Changes Made

### 1. docker-compose.yml
- ✅ Added `version: '3.8'` at the top
- ✅ Added comment: `# HoBo POS - Production Docker Compose`
- ✅ Project name: `hobo_license_pos` (from directory name)

### 2. Project Name Configuration
Docker Compose automatically uses the directory name as project name. To explicitly set it:

**Option 1**: Use `-p` flag
```bash
docker-compose -p hobo_license_pos up -d --build
```

**Option 2**: Set `COMPOSE_PROJECT_NAME` environment variable
```bash
$env:COMPOSE_PROJECT_NAME="hobo_license_pos"
docker-compose up -d --build
```

**Option 3**: Create `.env` file in project root
```
COMPOSE_PROJECT_NAME=hobo_license_pos
```

## Verification

After running Docker, verify project name:
```bash
docker-compose ps
```

Should show services prefixed with `hobo_license_pos_`:
- `hobo_license_pos_backend_1`
- `hobo_license_pos_frontend_1`
- `hobo_license_pos_postgres_1`
- `hobo_license_pos_redis_1`

## Migration Commands

Before running Docker, ensure migrations are applied:

```bash
# Option 1: Run migrations in Docker
docker-compose exec backend python manage.py migrate

# Option 2: Run migrations locally first
cd WeldingProject
python manage.py makemigrations
python manage.py migrate
```

## Docker Run Command

```bash
# Build and start all services
docker-compose up -d --build

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Stop and remove volumes (⚠️ deletes data)
docker-compose down -v
```

## Troubleshooting

### Issue: Wrong project showing
**Solution**: Use `-p` flag to specify project name
```bash
docker-compose -p hobo_license_pos up -d --build
```

### Issue: Port conflicts
**Solution**: Check if ports 80, 8000, 5432, 6379 are already in use
```bash
# Windows
netstat -ano | findstr :8000

# Linux/Mac
lsof -i :8000
```

### Issue: Migration errors
**Solution**: Ensure database is accessible and migrations are up to date
```bash
docker-compose exec backend python manage.py migrate --noinput
```

---

**Status**: ✅ **FIXED** - Docker configuration updated
