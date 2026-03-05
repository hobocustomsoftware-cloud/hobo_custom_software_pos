# Docker နဲ့ စမ်းသပ်ခြင်း (Redis + Postgres + Backend + Frontend)

ဒီ stack မှာ **Redis**, **PostgreSQL**, **Backend (Django)**, **Frontend (Vue)** ပါပါတယ်။

---

## ၁။ လိုအပ်ချက်

- **Docker** နဲ့ **Docker Compose** ထည့်ထားရမယ်  
  - Windows/Mac: [Docker Desktop](https://www.docker.com/products/docker-desktop/)  
  - Linux: `docker` + `docker compose` (သို့) `docker-compose`

### Linux: "permission denied" ဖြစ်ရင်

Docker socket ကို သင့် user က မထိခွင့်ရှိလို့ ဖြစ်တတ်ပါတယ်။ အောက်က တစ်မျိုးသုံးပါ။

**နည်း ၁ – သင့် user ကို `docker` group ထည့်ပါ (တစ်ခါထည့်ရင် နောက်ထပ် sudo မလို):**

```bash
sudo usermod -aG docker $USER
```

ပြီးရင် **log out လုပ်ပြီး ပြန်ဝင်ပါ** (သို့) terminal အသစ်ဖွင့်ပြီး:

```bash
newgrp docker
```

အဲဒီနောက်:

```bash
docker compose -f compose/docker-compose.yml up -d --build
```

**နည်း ၂ – အခု တစ်ခါတည်း sudo နဲ့ ပဲ run မယ်:**

```bash
sudo docker compose -f compose/docker-compose.yml up -d --build
```

---

## ၂။ စတင်ရန် (တစ်ခါတည်း အားလုံးတင်မယ်)

**Repo root** မှာ ဖွင့်ပြီး အောက်က တစ်ခုသုံးပါ။

### Linux / Mac (terminal)

```bash
cd "/media/htoo-myat-eain/New Volume/hobo_license_pos"

# သို့မဟုတ် repo path ကို သင့် path နဲ့ ပြောင်းပါ
# cd /path/to/hobo_license_pos

# စတင်ရန် (build + run)
docker compose -f compose/docker-compose.yml up -d --build
```

**သို့မဟုတ်** script သုံးမယ်:

```bash
./scripts/docker_up.sh
```

### Windows (CMD / PowerShell)

```bat
cd C:\path\to\hobo_license_pos

docker compose -f compose/docker-compose.yml up -d --build
```

**သို့မဟုတ်:**

```bat
scripts\docker_up.bat
```

- ပထမအကြိမ် **build ကြာနိုင်ပါတယ်** (၂–၅ မိနစ်)။  
- Backend က **Postgres** နဲ့ **Redis** စတင်ပြီး migrate ပြီးမှ စပါတယ်။  

---

## ၃။ ဘာတွေ ပါလဲ

| Service   | Port  | ရည်ရွယ်ချက်                    |
|----------|-------|----------------------------------|
| **redis**    | 6379  | Cache / session / Celery (သုံးမယ်ဆိုရင်) |
| **postgres** | 5432  | Database                         |
| **backend**  | 8000  | Django API (`/api/`, `/health/`)  |
| **frontend** | 80    | Vue SPA (ဘရောက်ဆာဖွင့်မယ်)        |

---

## ၄။ စမ်းဖို့ ဖွင့်ရမယ့် URL

ဘရောက်ဆာမှာ ဖွင့်ပါ:

- **App (Vue):**  
  - **http://localhost/app/**  
  - သို့မဟုတ် **http://localhost/** (redirect ဖြစ်ပြီး `/app/` သို့ သွားမယ်)

- **Backend API တိုက်ရိုက်:**  
  - **http://localhost:8000/api/**  
  - Health: **http://localhost:8000/health/** (200 ပြန်ရမယ်)

---

## ၅။ Redis / Backend စစ်ဆေးခြင်း

### Redis စစ်မယ် (container ထဲက)

```bash
# Redis container နာမည် ကြည့်မယ်
docker compose -f compose/docker-compose.yml ps

# Redis ထဲ ping (password = hobo_redis)
docker compose -f compose/docker-compose.yml exec redis redis-cli -a hobo_redis ping
# ပြန်ရမယ်: PONG
```

### Backend health စစ်မယ်

```bash
curl -s http://localhost:8000/health/
# ပြန်ရမယ်: {"status":"ok","service":"hobopos"}
```

### Service အားလုံး အနေအထား ကြည့်မယ်

```bash
docker compose -f compose/docker-compose.yml ps
```

အားလုံး **Up** / **healthy** (သို့) **running** ဖြစ်နေရင် ကောင်းပါပြီ။  

---

## ၆။ ရပ်ရန် / ပြန်စရန်

**ရပ်ရန် (container ပဲ ရပ်):**

```bash
docker compose -f compose/docker-compose.yml down
```

**Data (Postgres / Redis volume) ပါ ဖျက်ပြီး ပြန်စမယ်:**

```bash
docker compose -f compose/docker-compose.yml down -v
docker compose -f compose/docker-compose.yml up -d --build
```

---

## ၇။ Log ကြည့်ချင်ရင်

```bash
# အားလုံး
docker compose -f compose/docker-compose.yml logs -f

# Backend ပဲ
docker compose -f compose/docker-compose.yml logs -f backend

# Redis ပဲ
docker compose -f compose/docker-compose.yml logs -f redis
```

---

## ၈။ အတိုချုပ်

1. **Repo root** မှာ: `docker compose -f compose/docker-compose.yml up -d --build` (သို့) `./scripts/docker_up.sh` / `scripts\docker_up.bat`  
2. ဘရောက်ဆာမှာ **http://localhost/app/** ဖွင့်ပါ။  
3. Redis စစ်ချင်ရင်: `docker compose -f compose/docker-compose.yml exec redis redis-cli -a hobo_redis ping` → `PONG`။  
4. ရပ်ချင်ရင်: `docker compose -f compose/docker-compose.yml down`။  

Redis လည်း ပါပြီးသား stack နဲ့ ဒီအတိုင်း စမ်းလို့ ရပါတယ်။  
