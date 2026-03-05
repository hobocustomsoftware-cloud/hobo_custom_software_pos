# Docker Compose files

All compose files live in `compose/`. Run from **repo root**.

## ပုံမှန် (Standard) – Main stack

**အသုံးများဆုံး:** Postgres + Redis + Backend + Frontend (Nginx port 80). **.env မလိုပါ။**

| နည်း | ပြီးပြည့်စုံသော command |
|------|---------------------------|
| Windows | `scripts\docker_up.bat` |
| သို့မဟုတ် | `docker compose -f compose/docker-compose.yml up -d --build` |
| ရပ်ရန် | `docker compose -f compose/docker-compose.yml down` |

- **App:** http://localhost သို့မဟုတ် http://localhost/app/
- **API:** http://localhost:8000/api/
- Default password: `POSTGRES_PASSWORD=hobo_secret`, `REDIS_PASSWORD=hobo_redis` (compose ထဲမှာ သတ်မှတ်ပြီးသား)

**စကားဝှက်အမှား (password authentication failed for user hobo) ဆိုရင်:**  
volume က အရင် .env နဲ့ init လုပ်ထားလို့ ဖြစ်နိုင်ပါတယ်။ အောက်က လုပ်ပြီး ပြန် up ပါ။  
`docker compose -f compose/docker-compose.yml down -v`  
ပြီး `docker compose -f compose/docker-compose.yml up -d --build`

---

## အခြား compose ဖိုင်များ

| File | Use |
|------|-----|
| `docker-compose.yml` | **Main stack** (အထက်ပါ ပုံမှန်) |
| `docker-compose.server.yml` | Standalone server (Nginx + Gunicorn; run.bat / run.sh သုံး) |
| `docker-compose.prod.yml` | Production overrides (no DB/Redis ports) |
| `docker-compose.dev.yml` | Development overrides |
| `docker-compose.hardware.yml` | Hardware-related services |
| `docker-compose.monitoring.yml` | Monitoring stack |
| `docker-compose.mount-code.yml` | Mount local code for dev |

**Server stack (run.bat / run.sh):** uses `compose/docker-compose.server.yml` and optional root `.env`.
