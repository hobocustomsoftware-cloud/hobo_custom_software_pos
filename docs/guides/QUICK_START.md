# Quick Start - တစ်ခါတည်း Run လုပ်ရန်

## 🚀 One Command to Rule Them All

### Windows:
```bash
run_all.bat
```

### Linux/Mac:
```bash
chmod +x run_all.sh
./run_all.sh
```

### Python (Cross-platform):
```bash
python run_all.py
```

## ✨ ဘာတွေ လုပ်ပေးလဲ?

1. ✅ **Docker Services Start**
   - PostgreSQL database
   - Redis cache
   - Backend (Django API)
   - Frontend (Vue.js SPA)

2. ✅ **Simulation Run**
   - Day 1-30 complete simulation
   - All 11 user roles
   - Products, Sales, Installations, Repairs
   - USD rate changes
   - Expenses & Transactions

3. ✅ **Screenshots Capture**
   - All role views (Owner, Manager, Sale Staff, etc.)
   - Public pages
   - Special states (approval flows, serial assignments, etc.)
   - Mobile responsive views

4. ✅ **Slideshow Build**
   - Professional HTML presentation
   - Myanmar captions
   - Chapter navigation

## ⏱️ Estimated Time

- **First run:** 10-15 minutes (Docker images build)
- **Subsequent runs:** 5-8 minutes

## 📋 Prerequisites

1. **Docker Desktop** installed and running
2. **Python 3.11+** installed
3. **Playwright** installed:
   ```bash
   pip install playwright
   playwright install chromium
   ```

## 📁 Output Files

After completion, you'll have:

- `simulation_log.json` - Complete simulation log
- `screenshots/` - All captured screenshots
- `solar_pos_demo_YYYY-MM-DD.html` - HTML slideshow

## 🌐 Access Services

After script completes:

- **Frontend:** http://localhost:80
- **Backend API:** http://localhost:8000/api/
- **Health Check:** http://localhost:8000/health/

## 🔑 Test Accounts

All accounts use password: `demo123`

- `owner_solar` - Owner
- `manager` - Manager  
- `sale_staff_1` - Sale Staff
- `technician_1` - Technician
- `inventory_manager` - Inventory Manager

## 🛑 Stop Services

After you're done:

```bash
docker-compose stop
```

Or:

```bash
docker-compose down
```

## 🐛 Troubleshooting

### Docker not running:
- Install Docker Desktop
- Start Docker Desktop
- Wait for it to be ready

### Port already in use:
- Stop other services using ports 80, 8000, 5432, 6379
- Or modify `docker-compose.yml` to use different ports

### Script fails:
- Check Docker logs: `docker-compose logs`
- Check services status: `docker-compose ps`
- Read full guide: `DOCKER_SIMULATION_GUIDE.md`

## 📚 More Information

- Full Docker guide: `DOCKER_SIMULATION_GUIDE.md`
- Simulation details: `SIMULATION_GUIDE.md`
- Manual commands: See `DOCKER_SIMULATION_GUIDE.md`
