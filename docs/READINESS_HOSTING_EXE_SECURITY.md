# Hosting / EXE / လုံခြုံရေး — အဆင်သင့်ဖြစ်မှု စစ်ဆေးချက်

UI ပြင်ခိုင်းထားတာတွေ အပြင်၊ **hosting**၊ **EXE** နဲ့ **လုံခြုံရေး** အတွက် အဆင်သင့်ဖြစ်ပြီလား စစ်ဆေးထားတဲ့ စာရင်း။

---

## ၁။ လုံခြုံရေး (Security)

### ပြီးပြီးသား

| အချက် | လက်ရှိ |
|--------|----------|
| **SECRET_KEY** | `DJANGO_SECRET_KEY` env မှ ယူသည်။ Hosting မှာ သတ်မှတ်ထားရမယ်။ |
| **DEBUG** | `DJANGO_DEBUG` env (Hosting: `False`)။ Default က `True`။ |
| **ALLOWED_HOSTS** | DEBUG=False မှာ `DJANGO_ALLOWED_HOSTS` သတ်မှတ်ရမယ်။ |
| **Security headers (Production)** | DEBUG=False မှာ: XSS filter, Content-Type nosniff, X-FRAME_OPTIONS=DENY, HSTS, SESSION_COOKIE_SECURE, CSRF_COOKIE_SECURE။ |
| **Rate limiting** | License activate 10/min, Remote license 30/min, Auth 20/min။ |
| **License middleware** | App သုံးခွင့် စစ်ဆေးသည်။ DEBUG မှာ skip။ |
| **EXE ကာကွယ်မှု** | PyArmor (code obfuscation), DB encrypt (machine_id key) — ဖိုင်ခိုးသုံးမရ၊ source မပါ။ |

### Hosting တင်တဲ့အခါ လုပ်ရမယ်

- `.env` မှာ **DJANGO_SECRET_KEY** အားကောင်းတဲ့ random key ထည့်ပါ။
- **DJANGO_DEBUG=False** ထားပါ (docker-compose မှာ ထားပြီး)။
- **DJANGO_ALLOWED_HOSTS** မှာ domain ထည့်ပါ (ဥပမာ `your-domain.com`)။
- HTTPS သုံးမယ်ဆိုရင် **SECURE_SSL_REDIRECT=true** ထားပါ (optional)။

### လိုမှ ထပ်လုပ်မယ်

- **Code signing** (Windows .exe): Certificate နဲ့ sign မလုပ်ရသေးပါ။ လိုရင် build ပြီးတိုင်း sign ထည့်ပါ။
- **API key / Secret**: AI, ပြင်ပဝန်ဆောင်မှု key တွေကို env မှာပဲ ထားပါ၊ code ထဲ hardcode မလုပ်ပါနဲ့။

---

## ၂။ Hosting (Server) အဆင်သင့်ဖြစ်မှု

### ပြီးပြီးသား

| အချက် | လက်ရှိ |
|--------|----------|
| **Docker** | `deploy/server/docker-compose.yml` — backend (Daphne), frontend (Nginx), PostgreSQL, Redis။ |
| **Backend Dockerfile** | `WeldingProject/Dockerfile`။ |
| **Frontend build** | `yp_posf` context, VITE_API_URL arg။ |
| **Env (Production)** | docker-compose မှာ DJANGO_DEBUG=False, CORS_ALLOW_ALL=False, DATABASE_URL, REDIS_URL သတ်မှတ်ထားပြီး။ |
| **Health checks** | `GET /health/`, `GET /health/ready/`။ Docker healthcheck 30s။ |
| **Static/Media** | collectstatic, volumes: staticfiles, media, license_data။ |
| **License server** | `POST /api/license/remote-activate/` — EXE မှ ခေါ်လို့ရပြီး။ |

### Hosting တင်တဲ့အခါ အဆင့်

1. **`deploy/server/.env`** ပြင်ပါ: `DJANGO_SECRET_KEY`, `POSTGRES_PASSWORD`, `DJANGO_ALLOWED_HOSTS=your-domain.com`။
2. **`docker-compose -f deploy/server/docker-compose.yml up -d --build`** run ပါ။
3. (လိုရင်) Domain DNS + HTTPS (Nginx/reverse proxy သို့မဟုတ် load balancer) စီမံပါ။
4. EXE သုံးစွဲသူတွေကို **License Server URL** ပြောပေးပြီး EXE/config မှာ **LICENSE_SERVER_URL** သတ်မှတ်ပါ။

### မှတ်ချက်

- UI ပြင်ခိုင်းထားတာတွေ (ဥပမာ Dashboard Smart Insight, Sales AI) က Vue build ထဲ ပါသွားမယ်။ Hosting မှာ frontend image ပြန် build လုပ်ရင် အားလုံး update ဖြစ်မယ်။

---

## ၃။ EXE (Windows) အဆင်သင့်ဖြစ်မှု

### ပြီးပြီးသား

| အချက် | လက်ရှိ |
|--------|----------|
| **Entry** | `WeldingProject/run_server.py` — migrate, waitress 127.0.0.1:8000, browser open /app/။ |
| **DB + Media** | EXE folder မှာ သိမ်းသည် (HOBOPOS_DB_DIR)။ |
| **DB encrypt** | EXE mode မှာ machine_id key နဲ့ db.sqlite3.enc သိမ်းသည်။ |
| **PyInstaller spec** | `HoBoPOS.spec` — onedir, static_frontend, hiddenimports (core, inventory, …, ai)။ |
| **PyArmor** | build_exe.bat အဆင့် ၄ မှာ run_server, WeldingProject, license, core, inventory, customer, notification, service, **ai** obfuscate။ |
| **Build script** | `build_exe.bat` — Vue build (VITE_BASE=/app/) → copy → deps → PyArmor → PyInstaller → HoBoPOS_Release copy။ |
| **License (offline)** | `issue_license_file` နဲ့ license.lic ထုတ်ပြီး EXE folder ထဲ ထည့်လို့ရပါတယ်။ |

### EXE build လုပ်တဲ့အခါ

1. **Repo root** မှာ **`build_exe.bat`** run ပါ။
2. ပြီးရင် **`HoBoPOS_Release`** folder ထွက်မယ်။ ဒီ folder ကို zip/copy ပြီး ပို့လို့ရပါတယ်။
3. PyArmor မလိုချင်ရင် `WeldingProject\build_obf` ဖျက်ပြီး `pyinstaller HoBoPOS.spec` run ရင် သာမာန် build ထုတ်မယ်။

### မှတ်ချက်

- UI ပြင်ခိုင်းထားတာတွေ ပါအောင် **Vue ကို ပြန် build** ပြီးမှ **build_exe.bat** run ပါ။ ဒါမှ နောက်ဆုံး UI က EXE ထဲ ပါမယ်။

---

## ၄။ အတိုချုပ်

| ကဏ္ဍ | အဆင်သင့်ဖြစ်မှု | လုပ်ရမယ် |
|--------|---------------------|------------|
| **လုံခြုံရေး** | ✅ Settings နဲ့ rate limit ပါပြီး။ EXE မှာ PyArmor + DB encrypt ပါပြီး။ | Hosting မှာ SECRET_KEY, DEBUG=False, ALLOWED_HOSTS သတ်မှတ်ပါ။ လိုရင် code signing။ |
| **Hosting** | ✅ Docker + deploy doc + health + license server ပါပြီး။ | .env ပြင် → docker-compose up → (optional) domain/HTTPS။ |
| **EXE** | ✅ run_server, spec, build_exe, PyArmor, ai ထည့်ပြီး။ | UI update ရှိရင် Vue build ပြန်လုပ်ပြီး build_exe.bat run ပါ။ |

အကျဉ်း: **လုံခြုံရေး**၊ **hosting**၊ **EXE** အတွက် လိုအပ်တာတွေ **အဆင်သင့်ဖြစ်ပြီး**။ Hosting/EXE တင်တဲ့အခါ ဒီစာစောင်နဲ့ .env / build အဆင့်တွေကို လိုက်နာရင် ရပါတယ်။

---

## ၅။ AI ကို Hosting မှာ သုံးလို့ရလား

**ရပါတယ်။** AI feature တွေ (ဒါလေးရောမလိုဘူးလား၊ မေးမြန်းရန်၊ Smart Business Insight) က Django backend မှာပဲ ရှိတာမို့ **hosting** မှာ run ထားရင် အတူတူ အလုပ်လုပ်ပါတယ်။

- **Env မထည့်ထားရင်**: best-sellers / reorder insight စသည့် **ဒေတာအခြေခံ** ပဲ ပြမယ်။ suggest က အရောင်းရဆုံးစာရင်းကနေ ရွေးပြမယ်။ ask က "အရောင်းရဆုံးစာရင်းပြပါ" မေးရင် စာရင်းပဲ ပြမယ်။
- **Hosting မှာ AI ပြည့်အလုပ်လုပ်ချင်ရင်**: `deploy/server/.env` မှာ **OPENAI_API_KEY** (သို့) **AI_API_URL** (Gemini/Ollama endpoint ဆိုရင်) ထည့်ပါ။ docker-compose က ဒီ env တွေကို backend container ကို ပေးပြီးသား ဖြစ်ပါတယ်။

အကျဉ်း: **Hosting မှာလည်း AI သုံးလို့ရပါတယ်။** Key/URL ထည့်ရင် suggest / ask / Smart Insight က LLM နဲ့ ပြည့်ပြည့်အလုပ်လုပ်မယ်။

---

## ၆။ UI Design — ပြင်ပြီးသား / ကျန်နေသေးတာ

ဒီ project မှာ **ထည့်ပြီးသား UI** များ:

| နေရာ | လုပ်ထားချက် |
|--------|------------------|
| **Dashboard** | Bento grid, Total Revenue, USD Rate, Revenue Growth, Sales Analytics (sparkline), Low Stock, Active Services, **Smart Business Insight** (glassmorphism card), Recent Transactions။ |
| **Sales (POS)** | Sales Terminal, cart, **ဒါလေးရောမလိုဘူးလား** (suggestions), **AI မေးမြန်းရန်** (input + answer), customer select, discount, confirm/print။ |
| **အပြင်အဆင်** | Glassmorphism (bg-white/10, backdrop-blur, border-white/20), dashboard gradient, Inter font, shadow-glow။ |

**ပြင်ပြီးပြီလား** ဆိုတာက သင်တို့ ခိုင်းထားတဲ့ **UI design list** အလိုက် ကွာပါတယ်။ ဒီစာစောင်မှာ ဖော်ပြထားတာတွေက **ဒီ chat မှာ လုပ်ထားတဲ့** ပြင်ဆင်ချက်တွေ ဖြစ်ပါတယ်။ တခြား စာမျက်နှာ (ဥပမာ Inventory, Reports, Settings, Product Management) မှာ သင်တို့ ပြင်ခိုင်းထားတဲ့ design တွေ ရှိရင် ဒီစာရင်းနဲ့ တိုက်ကြည့်ပြီး ဘာကျန်သေးလဲ စစ်ဆေးလို့ ရပါတယ်။
