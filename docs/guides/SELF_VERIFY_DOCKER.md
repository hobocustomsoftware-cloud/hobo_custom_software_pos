# ကိုယ်တိုင် စစ်ဆေးနည်း (Docker Compose မှ စပြီး)

## ၁။ Docker Compose စတင်ခြင်း

**ပရိုဂျက် root** မှာ terminal ဖွင့်ပြီး အောက်က တစ်ခုသုံးပါ။

### Linux / macOS
```bash
cd "/media/htoo-myat-eain/New Volume/hobo_license_pos"
docker compose -f compose/docker-compose.yml up -d --build
```

### Windows (PowerShell / CMD)
```bash
cd "C:\path\to\hobo_license_pos"
scripts\docker_up.bat
```
သို့မဟုတ်
```bash
docker compose -f compose/docker-compose.yml up -d --build
```

- **ပထမအကြိမ်:** image တွေ build လုပ်တာကြာနိုင်ပါတယ် (၁၀–၁၅ မိနစ်ခန့်)။  
- **နောက်အကြိမ်များ:** ပိုမြန်ပါတယ်။  

---

## ၂။ Service တွေ အလုပ်လုပ်မလုပ် စစ်ခြင်း

### (က) Container များ status
```bash
docker compose -f compose/docker-compose.yml ps
```
အားလုံး `running` (healthy) ဖြစ်နေရပါမယ်။

### (ခ) Backend (API) စစ်ခြင်း
Browser သို့မဟုတ် curl:
```bash
curl http://localhost:8000/health/
```
ပြန်လာတာမှာ `"status":"ok"` လိုမျိုး ပါရပါမယ်။

### (ဂ) Frontend စစ်ခြင်း
Browser ဖွင့်ပြီး:
- **App:** http://localhost သို့မဟုတ် http://localhost/app/
- **API base:** http://localhost:8000/api/

---

## ၃။ ကိုယ်တိုင် စစ်ကြည့်မယ့် အချက်များ

1. **Login** – အကောင့်နဲ့ ဝင်ပြီး Dashboard ပေါ်မှာစာသားတွေ ဖတ်လို့ရ/မရ။  
2. **Settings** – ဆက်တင်စာမျက်နှာ စာသား ရှင်းမရှင်း။  
3. **Location (ဆိုင်နေရာ)** – Location စာမျက်နှာ စာသား ဖတ်လို့ရမရ။  
4. **ကုန်ကျစရိတ် / P&L** – Expense Management, P&L Report စာသား ရှင်းမရှင်း။  
5. **User / Role** – ဝန်ထမ်း၊ Role စာမျက်နှာများ စာသား ဖတ်လို့ရမရ။  
6. **အရောင်း / Installation / Service / Reports** – ဆိုင်ရာစာမျက်နှာတွေ စာသား ဖတ်လို့ရမရ။  

အထက်ပါ စာမျက်နှာတွေမှာ **အဖြူ/အမဲ contrast ကောင်းပြီး စာဖတ်လို့ရတယ်** ဆိုရင် စစ်ဆေးပြီးသား ဖြစ်ပါတယ်။  

---

## ၄။ Log ကြည့်ခြင်း

```bash
# အားလုံး
docker compose -f compose/docker-compose.yml logs -f

# Backend သီးသန့်
docker compose -f compose/docker-compose.yml logs -f backend

# Frontend သီးသန့်
docker compose -f compose/docker-compose.yml logs -f frontend
```
`Ctrl+C` နဲ့ ရပ်ပါ။  

---

## ၅။ ရပ်ခြင်း / ပြန်စခြင်း

### ရပ်ရန်
```bash
docker compose -f compose/docker-compose.yml down
```

### Database အပါအဝင် အားလုံး ဖျက်ပြီး ပြန်စရန် (password / DB ပြဿနာရှိရင်)
```bash
docker compose -f compose/docker-compose.yml down -v
docker compose -f compose/docker-compose.yml up -d --build
```

---

## ၆။ E2E Test (အလိုအလျောက် စစ်ချင်ရင်)

Docker stack ပြီးသား ဖြစ်နေရပါမယ်။  

```bash
./scripts/run_e2e_docker.sh
```
ဒီ script က `e2e-tester` service ကို profile နဲ့ run ပြီး Playwright test လုပ်ပေးပါတယ်။  

---

## အတိုချုပ်

| လုပ်ချက် | Command |
|-----------|---------|
| စတင် | `docker compose -f compose/docker-compose.yml up -d --build` |
| Status | `docker compose -f compose/docker-compose.yml ps` |
| Backend စစ် | `curl http://localhost:8000/health/` |
| App ဖွင့် | http://localhost သို့မဟုတ် http://localhost/app/ |
| ရပ် | `docker compose -f compose/docker-compose.yml down` |
| ဖျက်ပြီး ပြန် up | `docker compose -f compose/docker-compose.yml down -v` then `up -d --build` |

**မှတ်ချက်:** Command အားလုံးကို **project root** (`hobo_license_pos`) မှာ run ပါ။  
