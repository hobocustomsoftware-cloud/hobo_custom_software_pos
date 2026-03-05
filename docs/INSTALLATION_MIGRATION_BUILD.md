# Installation Module - Migration & Build Configuration

## ✅ Migration Created

### Migration File:
- **`WeldingProject/installation/migrations/0001_initial.py`**
  - Creates `InstallationJob` model
  - Creates `InstallationStatusHistory` model
  - Adds indexes for performance
  - Dependencies: `inventory.0011_add_payment_method_and_payment_fields`, `customer.0001_initial`

### Migration Commands:
```bash
cd WeldingProject
python manage.py makemigrations installation
python manage.py migrate installation
```

**Note**: `run_server.py` already includes `migrate --run-syncdb` which will automatically run all migrations including installation module when EXE starts.

## ✅ EXE Build Configuration Updated

### PyInstaller Spec (`WeldingProject/HoBoPOS.spec`):
- ✅ Added `'installation'` to `hiddenimports` list
- ✅ Installation app will be bundled in EXE build

**Updated line 42:**
```python
'core', 'inventory', 'customer', 'license', 'notification', 'service', 'ai', 'accounting', 'installation',
```

## ✅ Docker Configuration

### Backend Dockerfile (`WeldingProject/Dockerfile`):
- ✅ No changes needed - copies all code including installation app
- ✅ `migrate --noinput` in docker-compose will run all migrations

### Docker Compose (`deploy/server/docker-compose.yml`):
- ✅ No changes needed - `migrate --noinput` runs all migrations automatically
- ✅ Installation app migrations will be applied on container startup

**Backend command (line 28-30):**
```yaml
command: >
  sh -c "python manage.py migrate --noinput &&
         python manage.py collectstatic --noinput --clear &&
         daphne -b 0.0.0.0 -p 8000 WeldingProject.asgi:application"
```

## ✅ Settings Configuration

### Django Settings (`WeldingProject/settings.py`):
- ✅ `installation.apps.InstallationConfig` already added to `INSTALLED_APPS`
- ✅ Signals will auto-register on app startup

### URLs (`WeldingProject/urls.py`):
- ✅ `/api/installation/` routes already added

## 📋 Build Steps

### 1. Run Migrations (Development):
```bash
cd WeldingProject
python manage.py makemigrations installation
python manage.py migrate installation
```

### 2. Docker Build & Test:
```bash
# Build and start
cd deploy/server
docker-compose up -d --build

# Migrations run automatically on startup
# Check logs:
docker-compose logs backend
```

### 3. EXE Build:
```bash
# 1. Build Vue frontend
cd yp_posf
set VITE_BASE=/app/
npm run build
xcopy /E /I /Y dist ..\WeldingProject\static_frontend

# 2. Build EXE (installation app included in hiddenimports)
cd ..\WeldingProject
pyinstaller HoBoPOS.spec

# Output: dist/HoBoPOS/HoBoPOS.exe
# Migrations run automatically on first startup
```

## ✅ Verification Checklist

- [x] Migration file created (`installation/migrations/0001_initial.py`)
- [x] Migration dependencies correct
- [x] EXE spec updated (`HoBoPOS.spec` - installation added to hiddenimports)
- [x] Docker compose uses `migrate --noinput` (auto-runs all migrations)
- [x] Settings.py includes installation app
- [x] URLs configured
- [x] run_server.py already handles migrations (`migrate --run-syncdb`)

## Status: ✅ READY FOR BUILD

All configurations updated. Installation module will be included in:
- ✅ Docker builds (migrations auto-run)
- ✅ EXE builds (app bundled, migrations auto-run)
- ✅ Development (run migrations manually)
