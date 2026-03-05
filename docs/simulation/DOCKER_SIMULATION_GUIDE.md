# Docker Simulation Guide - မြန်မာလို

Docker သုံးပြီး Frontend & Backend ကို တစ်ခါတည်း ဖွင့်ပြီး Simulation လုပ်နည်း

## 🎯 ရည်ရွယ်ချက်

ဤ guide သည် Docker Compose သုံးပြီး:
1. PostgreSQL, Redis, Backend, Frontend services အားလုံးကို တစ်ခါတည်း ဖွင့်ခြင်း
2. Simulation command ကို Docker container ထဲမှာ run လုပ်ခြင်း
3. Screenshots capture လုပ်ခြင်း (optional)
4. HTML slideshow build လုပ်ခြင်း (optional)

## 📋 Prerequisites

1. **Docker Desktop** installed and running
2. **Python 3.11+** installed (screenshots အတွက်)
3. **Playwright** installed (screenshots အတွက်):
   ```bash
   pip install playwright
   playwright install chromium
   ```
4. **Ports available**:
   - 80 (frontend)
   - 8000 (backend)
   - 5432 (postgres)
   - 6379 (redis)

## 🚀 Quick Start (အလွယ်ဆုံး)

### Windows:
```bash
# Simulation သာ run လုပ်ရန်
run_simulation_docker.bat

# Simulation + Screenshots
run_simulation_docker.bat --screenshots

# Simulation + Screenshots + Slideshow (အားလုံး)
run_simulation_docker.bat --all

# ပြီးရင် Docker services ကို stop လုပ်ရန်
run_simulation_docker.bat --all --stop
```

### Linux/Mac:
```bash
# Script ကို executable လုပ်ရန် (တစ်ခါသာ)
chmod +x run_simulation_docker.sh

# Simulation သာ run လုပ်ရန်
./run_simulation_docker.sh

# Simulation + Screenshots
./run_simulation_docker.sh --screenshots

# Simulation + Screenshots + Slideshow (အားလုံး)
./run_simulation_docker.sh --all

# ပြီးရင် Docker services ကို stop လုပ်ရန်
./run_simulation_docker.sh --all --stop
```

### Python Script (Cross-platform):
```bash
# Simulation သာ
python run_simulation_docker.py

# Simulation + Screenshots
python run_simulation_docker.py --screenshots

# Simulation + Screenshots + Slideshow
python run_simulation_docker.py --all

# Docker services ကို skip (ဖွင့်ပြီးသား)
python run_simulation_docker.py --no-start

# ပြီးရင် stop
python run_simulation_docker.py --all --stop
```

## 📝 Step-by-Step Process

### 1. Docker Services Start
Script က automatically:
- ✅ PostgreSQL နှင့် Redis ကို စတင်သည်
- ✅ PostgreSQL health check ကို စောင့်သည်
- ✅ Backend service ကို start လုပ်သည်
- ✅ Backend health check (`/health/`) ကို စောင့်သည်
- ✅ Frontend service ကို start လုပ်သည်

### 2. Simulation Run
- ✅ Docker backend container ထဲမှာ `simulate_month` command ကို run လုပ်သည်
- ✅ `--skip-delay` flag သုံးပြီး မြန်မြန် run လုပ်သည်
- ✅ Output ကို real-time ပြသည်

### 3. Screenshots (Optional)
- ✅ Host machine မှာ `screenshot_story.py` ကို run လုပ်သည်
- ✅ `FRONTEND_URL=http://localhost:80` သတ်မှတ်သည်
- ✅ `BACKEND_URL=http://localhost:8000` သတ်မှတ်သည်
- ✅ Playwright သုံးပြီး screenshots ရိုက်သည်

### 4. Slideshow Build (Optional)
- ✅ `build_slideshow.py` ကို run လုပ်သည်
- ✅ HTML slideshow file ကို generate လုပ်သည်

## 🔧 Manual Commands (Script မသုံးဘဲ)

### Start Services:
```bash
docker-compose up -d postgres redis backend frontend
```

### Check Status:
```bash
docker-compose ps
```

### View Logs:
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
```

### Run Simulation:
```bash
docker-compose exec backend python manage.py simulate_month --skip-delay
```

### Stop Services:
```bash
docker-compose stop
```

### Stop and Remove:
```bash
docker-compose down
```

## 📊 Port Configuration

| Service | Port | URL | Description |
|---------|------|-----|-------------|
| Frontend | 80 | http://localhost:80 | Vue.js SPA |
| Backend | 8000 | http://localhost:8000 | Django API |
| PostgreSQL | 5432 | localhost:5432 | Database |
| Redis | 6379 | localhost:6379 | Cache |

## 🐛 Troubleshooting

### Docker is not running:
```
❌ Docker is not installed or not running!
```
**Solution:** Docker Desktop ကို install လုပ်ပြီး start လုပ်ပါ

### Port already in use:
```
Error: bind: address already in use
```
**Solution:** 
- Port 80, 8000, 5432, 6379 ကို အသုံးပြုနေသော services များကို stop လုပ်ပါ
- သို့မဟုတ် `docker-compose.yml` မှာ ports ကို ပြောင်းပါ

### Backend not ready:
```
⚠️ Backend may not be fully ready, but continuing...
```
**Solution:** 
- Logs ကို check လုပ်ပါ: `docker-compose logs backend`
- Database migrations ကို check လုပ်ပါ
- Health endpoint ကို test လုပ်ပါ: `curl http://localhost:8000/health/`

### Screenshots fail:
```
❌ Screenshot capture failed
```
**Solution:**
- Playwright installed လုပ်ထားပါ: `pip install playwright && playwright install chromium`
- Frontend က running ဖြစ်နေပါစေ: `curl http://localhost:80/`
- Browser က headless mode မှာ run နိုင်ပါစေ

### Database connection error:
```
django.db.utils.OperationalError: could not connect to server
```
**Solution:**
- PostgreSQL container က running ဖြစ်နေပါစေ: `docker-compose ps postgres`
- Database credentials ကို check လုပ်ပါ (`.env` file)
- Volume mount ကို check လုပ်ပါ

## 📁 Output Files

Simulation run ပြီးရင်:
- ✅ `simulation_log.json` - Complete simulation log
- ✅ `screenshots/` - Screenshots directory (if `--screenshots` used)
- ✅ `solar_pos_demo_YYYY-MM-DD.html` - Slideshow (if `--slideshow` or `--all` used)

## 🎨 Access Services

Services များ running ဖြစ်နေရင်:

### Frontend:
```
http://localhost:80
```

### Backend API:
```
http://localhost:8000/api/
http://localhost:8000/health/
```

### Admin Panel:
```
http://localhost:8000/admin/
```

## 🔑 Test Accounts

Simulation run ပြီးရင် အောက်ပါ accounts များကို သုံးနိုင်ပါသည်:

- Username: `owner_solar` / Password: `demo123` - Owner
- Username: `manager` / Password: `demo123` - Manager
- Username: `sale_staff_1` / Password: `demo123` - Sale Staff
- Username: `technician_1` / Password: `demo123` - Technician
- Username: `inventory_manager` / Password: `demo123` - Inventory Manager

## 📋 Environment Variables

`.env` file ထဲမှာ သတ်မှတ်နိုင်သော variables:

```env
# Database
POSTGRES_DB=hobo_pos
POSTGRES_USER=hobo
POSTGRES_PASSWORD=hobo_secret

# Django
DJANGO_SECRET_KEY=your-secret-key-here
DJANGO_DEBUG=False
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1

# Frontend API URL
VITE_API_URL=/api

# AI (Optional)
OPENAI_API_KEY=your-openai-key
AI_API_URL=
AI_MODEL=
```

## 🎉 Success!

Script run ပြီးရင်:

1. ✅ Docker services အားလုံး running
2. ✅ Simulation data database ထဲမှာ ready
3. ✅ Screenshots captured (if requested)
4. ✅ Slideshow generated (if requested)

**Next Steps:**
- Frontend ကို browser မှာ ဖွင့်ပြီး test လုပ်ပါ
- Slideshow HTML file ကို browser မှာ ဖွင့်ပြီး presentation လုပ်ပါ
- API endpoints များကို test လုပ်ပါ

## 💡 Tips

1. **First time run:** Docker images build လုပ်ရန် အချိန်ယူနိုင်ပါသည် (5-10 minutes)
2. **Subsequent runs:** Services start လုပ်ရန် 30-60 seconds သာ ကြာနိုင်ပါသည်
3. **Database persistence:** `postgres_data` volume ကြောင့် data များ persist ဖြစ်နေပါသည်
4. **Clean start:** Database ကို fresh start လုပ်လိုပါက:
   ```bash
   docker-compose down -v  # Remove volumes
   docker-compose up -d     # Start fresh
   ```

## 📞 Support

Issues ရှိပါက:
1. Logs ကို check လုပ်ပါ: `docker-compose logs`
2. Services status ကို check လုပ်ပါ: `docker-compose ps`
3. Health endpoints ကို test လုပ်ပါ
4. Documentation ကို ဖတ်ပါ: `SIMULATION_GUIDE.md`
