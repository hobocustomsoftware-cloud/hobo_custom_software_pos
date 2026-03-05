# Error ဖြစ်နိုင်ခြေများ နဲ့ Simulation လုပ်နည်း

ဖြစ်နိုင်တဲ့ error တွေ စာရင်း နဲ့ စစ်ဆေးဖို့ simulation လုပ်နည်းတွေကို အောက်မှာ စုစည်းထားပါတယ်။

---

## ၁) ဖြစ်နိုင်တဲ့ Error များ

| Error | ဖြစ်ခြင်း | Frontend မှာ ဘာပြမလဲ |
|-------|-------------|---------------------------|
| **403 – license_expired** | License သက်တမ်းကုန် / Trial+Grace ကုန် | API interceptor က `/license-activate` သို့ ပြောင်းပေးမယ်။ |
| **401 Unauthorized** | Token မရှိ / သက်တမ်းကုန် / မမှန် | Login စာမျက်နှာသို့ ညွှန်ပြ (သို့) "ပြန်ဝင်ရောက်ပါ" စသည်။ |
| **404 Not Found** | API path မှား / resource မရှိ | များသောအားဖြင့် alert သို့မဟုတ် "ရှာမတွေ့ပါ" ပြမယ်။ shop-settings 404 ဆိုရင် Backend စတင်ရန် သတိပေးချက်။ |
| **500 Server Error** | Backend exception | များသောအားဖြင့် message ပြမယ်။ |
| **Network / Offline** | Backend မရှိ / အင်တာနက်ပြတ် | catch ထဲမှာ "Backend ချိတ်ဆက်မရပါ" သို့မဟုတ် offline message ပြမယ်။ |

---

## ၂) Simulation လုပ်နည်း

### (က) License Expired (403) စစ်ဆေးခြင်း

**ရည်ရွယ်ချက်:** Frontend မှာ 403 license_expired ရရင် License Activation စာမျက်နှာသို့ ပြောင်းသွားမလား စစ်ချင်ရင်။

**နည်း ၁ – Management command (အကြံပြု)**

```bash
# License ကုန်ပြီးသလို ဖန်တီးမယ် (trial+grace ကုန်အောင် လုပ်မယ်)
python manage.py simulate_errors --license-expired

# Browser မှာ app ဖွင့်ပြီး မည်သည့် API ခေါ်ခြင်း (ဥပမာ Dashboard) လုပ်ပါ။ 403 ရပြီး /license-activate သို့ ပြောင်းသွားရမယ်။

# ပြီးရင် ပြန်ပြန်လည်သတ်မှတ်မယ်
python manage.py simulate_errors --reset-license
```

**နည်း ၂ – ကိုယ်တိုင်**

- **EXE / Local:** `license.lic` ကို EXE folder ထဲက ယာယီ ရွှေ့ပါ (သို့မဟုတ် ဖျက်ပါ)။ ပြီးတော့ Trial ကုန်အောင် လုပ်ချင်ရင် DB မှာ `license_app_installation` ထဲက ကိုယ့် machine ရဲ့ `first_run_at` ကို ၄၀ ရက်အရင် လုပ်ထားပါ။ နောက်တစ်ကြိမ် request မှာ 403 ရမယ်။
- **Skip license (dev only):** Backend မှာ `SKIP_LICENSE=true` သို့မဟုတ် `DEBUG=True` ထားရင် license မစစ်ပါ။

### (ခ) 401 Unauthorized စစ်ဆေးခြင်း

- Browser DevTools → Application → Local Storage မှာ `access_token` ဖျက်ပါ (သို့မဟုတ် မမှန်တဲ့ value ထည့်ပါ)။ ပြီးမှ မည်သည့် API ခေါ်တဲ့ စာမျက်နှာ သွားပါ။ 401 ရပြီး login ညွှန်မလား စစ်ပါ။

### (ဂ) 404 / Backend မရှိ စစ်ဆေးခြင်း

- Backend ကို ပိတ်ပြီး Frontend ပဲ ဖွင့်ထားပါ။ Login စာမျက်နှာ သို့မဟုတ် shop-settings load လုပ်တဲ့ နေရာမှာ "Backend စတင်ရန်" သို့မဟုတ် ချိတ်ဆက်မရ ပြမလား စစ်ပါ။

### (ဃ) ပုံမှန် စီးဆင်းမှု (Error မဟုတ်) Simulation

- **Register → Login → Sales → Approve:**  
  `python manage.py run_simulation`  
  ဒါက error မဟုတ်ပါ။ စာရင်းသွင်း၊ ဝင်ရောက်၊ အရောင်းတင်၊ အတည်ပြု စီးဆင်းမှု တစ်ခုလုံး စစ်ဖို့ပါ။

---

## ၃) အတိုချုပ်

| စစ်ချင်တာ | လုပ်နည်း |
|-------------|-----------|
| **403 License expired** | `python manage.py simulate_errors --license-expired` ပြေးပြီး app မှာ ခေါ်မှုလုပ်ပါ။ ပြန်ပြန်လည်သတ်မှတ်ရန် `--reset-license`။ |
| **401** | Local Storage မှာ token ဖျက်ပြီး API ခေါ်တဲ့ စာမျက်နှာ စစ်ပါ။ |
| **404 / Offline** | Backend ပိတ်ပြီး Frontend ဖွင့်ကာ စစ်ပါ။ |
| **Happy path** | `python manage.py run_simulation`။ |

Simulation ပြီးရင် production / EXE မှာ `simulate_errors` မပြေးပါနဲ့။ စမ်းသပ်မှုအတွက်သာ သုံးပါ။

---

## ၄) EXE flow CLI simulation (Customer PC = EXE ပဲ ရှိသလို စစ်ခြင်း)

Customer PC မှာ Python/repo မရှိ - EXE နဲ့ data folder ပဲ ရှိတာကို ထည့်စဉ်းစားပြီး **ဒီ flow အတိုင်း အဆင်ပြေမပြေ** CLI ကနေ HTTP နဲ့ စစ်ပါတယ် (browser မလို)။

**ပြေးနည်း:**

```bash
# Server ပြေးနေပြီးသား (သို့မဟုတ် EXE run ထားပြီးသား) ဆိုရင်
cd WeldingProject
python manage.py simulate_exe_flow

# Server မပြေးရင် - runserver စပြီး စစ်မယ်
python manage.py simulate_exe_flow --start-server

# EXE နဲ့ စစ်ချင် (build_exe.bat ပြီးမှ)
python manage.py simulate_exe_flow --start-exe

# 403 license expired စစ်ချင် (same DB ဖြစ်ရမယ် - --start-server သို့မဟုတ် server ပြေးနေမှ)
python manage.py simulate_exe_flow --start-server --test-403
```

**Batch (repo root မှာ):** `scripts\run_cli_simulate_exe.bat` သို့မဟုတ် `scripts\run_cli_simulate_exe.bat --start-server`

**စစ်တဲ့အဆင့်များ:** (1) GET /health/ (2) GET /api/license/status/ (3) POST /api/core/register/ (4) POST /api/token/ (5) GET /api/core/shop-settings/ (6) GET /api/staff/items/ (license လိုအပ်သော API)။ Error ရှိရင် step အလိုက် FAIL ပြမယ်။

---

## ၅) စီးဆင်းမှု Simulation (Error မဟုတ်)

| Command | ရည်ရွယ်ချက် |
|---------|----------------|
| `python manage.py run_simulation` | Register → Login → Sales (request) → Approve စီးဆင်းမှု တစ်ခုလုံး API ကနေ စစ်ပါတယ်။ Browser မလိုပါ။ (Django test client - in-process) |
| `python manage.py run_simulation --days 7 --sales-per-day 5` | ၇ ရက်အတွင်း တစ်နေ့ ၅ ခု ရောင်းချမှု ဖန်တီးပြီး စစ်ပါတယ်။ |

---

## ၆) Docker မှာ DB / manage.py Error များ

**Docker မှာ Postgres ပါအောင်:** မူရင်း `docker-compose.yml` မှာ **postgres, redis, backend, frontend** ပါပြီးသား။ Setting မှာ ပြင်စရာမလို။ စတင်ရန် `scripts\docker_up.bat` သို့မဟုတ် `docker compose up -d` သုံးပါ။ (dev-only SQLite လိုချင်ရင် သာ `docker-compose.dev.yml` သုံးပါ။)

### `could not translate host name "postgres" to address`

**အကြောင်းရင်း:** `python manage.py ...` ကို **host မှာ** (Docker ပြင်ပမှာ) ပြေးတဲ့အခါ `DATABASE_URL` ထဲက `postgres` ဆိုတဲ့ hostname က Docker network ထဲမှာပဲ ရှိတာကြောင့် မရှာနိုင်ဘူး။

**ဖြေရှင်း:**

1. **Management command တွေကို backend container ထဲမှာ ပြေးပါ (အကြံပြု)**  
   ```bash
   scripts\docker_up.bat
   scripts\docker_mgmt.bat seed_demo_users
   scripts\docker_mgmt.bat seed_demo_data
   ```
   သို့မဟုတ် ရိုးရိုး:  
   `docker compose exec backend python manage.py seed_demo_users`

2. **Host မှာပဲ ပြေးချင်ရင်**  
   Postgres ကို port 5432 ဖွင့်ထားပြီး (`docker compose up -d postgres`) အောက်ပါအတိုင်း သတ်မှတ်ပြီး run ပါ။  
   ```bash
   set DATABASE_HOST=localhost
   set DATABASE_URL=postgres://hobo:hobo_secret@postgres:5432/hobo_pos
   python WeldingProject\manage.py seed_demo_users
   ```
   Settings က `DATABASE_HOST` ရှိရင် URL ထဲက host ကို ဒီ value နဲ့ အစားထိုးပေးပါတယ်။

### `python: can't open file '/app/manage.py': [Errno 5] Input/output error`

**အကြောင်းရင်း:** Container ထဲက `/app` volume mount ပြဿနာ (ဥပမာ Windows မှာ drive share မထားလို့) သို့မဟုတ် `docker compose run` နဲ့ container အသစ် ဖွင့်တဲ့အခါ mount မှာ I/O error။

**ဖြေရှင်း:**

1. **ပြေးနေတဲ့ backend container ထဲမှာ command ပြေးပါ**  
   `docker compose up -d` လုပ်ထားပြီး  
   `docker compose exec backend python manage.py <command>`  
   သို့မဟုတ် `scripts\docker_mgmt.bat <command>` သုံးပါ။ `exec` က ပြေးနေတဲ့ container ထဲမှာ ပြေးတာမို့ volume ပြဿနာ နည်းတယ်။

2. **Docker Desktop မှာ** File Sharing ထဲမှာ project ရှိတဲ့ drive (ဥပမာ `F:\`) ပါအောင် ထည့်ပါ။

3. **Host မှာပဲ ပြေးချင်ရင်**  
   ဒီအတိုင်း SQLite သုံးပါ (DATABASE_URL မထားပါ):  
   `python WeldingProject\manage.py migrate`  
   သို့မဟုတ် Postgres ကို localhost မှာ ဖွင့်ပြီး `DATABASE_HOST=localhost` ထားကာ run ပါ။
