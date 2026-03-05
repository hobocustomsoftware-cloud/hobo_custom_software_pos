# Docker Test Guide - Backend + Frontend

## စစ်ဆေးရမည့်အရာများ

### 1. Prerequisites
- ✅ Docker Desktop installed
- ✅ `.env` file configured (`deploy/server/.env`)
- ✅ Port 80 and 8000 available

### 2. Environment Setup

#### Create `.env` file:
```bash
cd deploy/server
cp .env.example .env
```

#### Edit `.env` and set:
```env
DJANGO_SECRET_KEY=your-secret-key-here-min-50-chars
POSTGRES_PASSWORD=secure-password-here
POSTGRES_USER=hobo
POSTGRES_DB=hobo_pos
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1
VITE_API_URL=/api
```

### 3. Quick Test (Windows)

```batch
deploy\server\test_docker.bat
```

### 4. Manual Test Steps

#### Step 1: Build Backend
```bash
docker-compose -f deploy/server/docker-compose.yml build backend
```

**Expected:** Build succeeds, installs Python dependencies

#### Step 2: Build Frontend
```bash
docker-compose -f deploy/server/docker-compose.yml build frontend
```

**Expected:** Build succeeds, compiles Vue app with Tailwind v4

#### Step 3: Start All Services
```bash
docker-compose -f deploy/server/docker-compose.yml up -d
```

**Expected:** 
- PostgreSQL starts
- Redis starts
- Backend starts (migrations run, static files collected)
- Frontend starts (Nginx serves Vue app)

#### Step 4: Check Backend Health
```bash
curl http://localhost:8000/health/
```

**Expected:** `{"status": "ok"}`

#### Step 5: Check Frontend
```bash
curl http://localhost/
```

**Expected:** HTML content (Vue app)

#### Step 6: Check API Proxy
```bash
curl http://localhost/api/health/
```

**Expected:** `{"status": "ok"}` (proxied through Nginx to backend)

### 5. View Logs

```bash
# All services
docker-compose -f deploy/server/docker-compose.yml logs -f

# Backend only
docker-compose -f deploy/server/docker-compose.yml logs -f backend

# Frontend only
docker-compose -f deploy/server/docker-compose.yml logs -f frontend
```

### 6. Stop Services

```bash
docker-compose -f deploy/server/docker-compose.yml down
```

### 7. Clean Rebuild (if issues)

```bash
# Stop and remove containers, volumes
docker-compose -f deploy/server/docker-compose.yml down -v

# Rebuild without cache
docker-compose -f deploy/server/docker-compose.yml build --no-cache

# Start again
docker-compose -f deploy/server/docker-compose.yml up -d
```

## Common Issues

### Issue 1: Backend Build Fails
**Error:** `ModuleNotFoundError` or `pip install` fails

**Fix:** 
- Check `WeldingProject/requirements.txt` exists
- Verify Python version in Dockerfile (3.11-slim)

### Issue 2: Frontend Build Fails
**Error:** Tailwind CSS v4 errors or `npm install` fails

**Fix:**
- Check `yp_posf/package.json` has Tailwind v4 dependencies
- Verify `yp_posf/src/assets/main.css` uses `@layer utilities` syntax

### Issue 3: Backend Health Check Fails
**Error:** `curl http://localhost:8000/health/` returns error

**Fix:**
- Check backend logs: `docker-compose logs backend`
- Verify migrations completed: `docker-compose exec backend python manage.py migrate`
- Check database connection: `docker-compose exec backend python manage.py dbshell`

### Issue 4: Frontend Shows 502 Bad Gateway
**Error:** Browser shows 502 when accessing `http://localhost/`

**Fix:**
- Check backend is healthy: `curl http://localhost:8000/health/`
- Check Nginx logs: `docker-compose logs frontend`
- Verify `nginx.conf` proxy_pass points to `http://backend:8000`

### Issue 5: API Calls Fail (CORS)
**Error:** Browser console shows CORS errors

**Fix:**
- Check `DJANGO_ALLOWED_HOSTS` includes your domain
- Verify `CORS_ALLOW_ALL=False` in docker-compose.yml (should be False for production)
- Check `CORS_ALLOWED_ORIGINS` in `settings.py` includes `http://localhost`

## Testing Checklist

- [ ] Backend builds successfully
- [ ] Frontend builds successfully
- [ ] All services start without errors
- [ ] Backend health endpoint responds (`/health/`)
- [ ] Frontend loads at `http://localhost/`
- [ ] API proxy works (`http://localhost/api/health/`)
- [ ] Login page loads
- [ ] Can register new user
- [ ] Can login with credentials
- [ ] Dashboard loads after login
- [ ] API calls work (no CORS errors)
- [ ] Static files served correctly
- [ ] WebSocket connections work (if using Channels)

## Production Notes

- Set strong `DJANGO_SECRET_KEY` (use `python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"`)
- Set strong `POSTGRES_PASSWORD`
- Update `DJANGO_ALLOWED_HOSTS` with your domain
- Consider SSL/TLS (HTTPS) with reverse proxy
- Set up volume backups for `postgres_data`, `backend_media`, `license_data`
