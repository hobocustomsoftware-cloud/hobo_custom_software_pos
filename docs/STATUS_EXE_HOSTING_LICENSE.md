# လက်ရှိအခြေအနေ – EXE, Hosting (Docker), License Key

ဒီစာရွက်မှာ **EXE ထုတ်ပြီးအခြေအနေ**၊ **Hosting ပေါ်တင်ရင် Docker နဲ့ အဆင်ပြေမပြေ**၊ **License key အဆင်ပြေမပြေ** ကို စုစည်းထားပါတယ်။ တစ်ခါတည်း စစ်လို့ရအောင် **`scripts/verify_exe_hosting_license.bat`** ကို သုံးပါ။

---

## ၁) EXE လက်ရှိအခြေအနေ

| အချက် | အခြေအနေ |
|--------|-----------|
| **Build script** | `build_exe.bat` (root) – Vue base `/app/` → copy to `WeldingProject/static_frontend` → PyArmor → PyInstaller → `HoBoPOS_Release/` |
| **Entry** | `WeldingProject/run_server.py` – migrate, waitress 127.0.0.1:8000, browser open `http://127.0.0.1:8000/app/` |
| **DB** | EXE folder မှာ `db.sqlite3` (run ချိန်မှာ decrypt; ပိတ်ချိန်မှာ encrypt) |
| **Output** | `HoBoPOS_Release/HoBoPOS.exe` + dependencies; DB/media က exe ရဲ့ folder မှာ သိမ်းမယ် |

**အဆင်ပြေပြီးသား:** run_server, spec, Vue base `/app/`, static_frontend copy, DB encrypt/decrypt, license file (`license.lic`) + machine_id (`data/machine_id`) exe folder မှာ သုံးခြင်း။

**စစ်ရန်:** `build_exe.bat` run ပြီး `HoBoPOS_Release\HoBoPOS.exe` ဖွင့်ကာ Register/Login နဲ့ POS သုံးကြည့်ပါ။

---

## ၂) Hosting ပေါ်တင်ရင် Docker နဲ့ အဆင်ပြေမပြေ

| အချက် | အခြေအနေ |
|--------|-----------|
| **docker-compose.yml** (root) | postgres, redis, backend (Daphne), frontend (nginx) – backend က `/frontend_dist` မှ ရှိရင် `static_frontend` ကို sync လုပ်ပြီး `/app/` serve မယ်။ |
| **Backend env** | `DEPLOYMENT_MODE=hosted`, `DATABASE_URL`, `REDIS_URL`, `MACHINE_ID` (optional), `license_data` volume ဖြင့် `data/machine_id` + license.lic လိုရင် သိမ်းမယ်။ |
| **License (Hosting)** | Backend က DB မှာ license စစ်မယ် (AppLicense); trial က AppInstallation နဲ့ machine_id (volume)။ license.lic က hosting မှာ မလိုပါ (DB-only သုံးလို့ရ)။ |
| **deploy/server/docker-compose.yml** | Production-style – backend only (no frontend container လိုရင် nginx သပ်သပ် ထပ်ထည့်နိုင်သည်)။ |

**အဆင်ပြေပြီးသား:** Migrate, collectstatic, health check, CORS, license middleware (register/login/shop-settings skip)။

**စစ်ရန်:**  
1. `yp_posf` မှာ `npm run build` (သို့မဟုတ် VITE_BASE သတ်မှတ်ပြီး build)။  
2. Root မှာ `docker-compose up -d`။  
3. `http://localhost:8000/app/` (သို့မဟုတ် backend port) ဖွင့်ပြီး Register/Login စစ်ပါ။  

---

## ၃) License Key အဆင်ပြေမပြေ

| အချက် | ဖော်ပြချက် |
|--------|--------------|
| **Status** | `GET /api/license/status/` – can_use, status, machine_id, message (login မလို)။ |
| **Activate (Local)** | `POST /api/license/activate/` – license_key ပို့; DB မှာ key ရှိပြီး machine_id ကိုက်ရင် bind လုပ်ပြီး `license.lic` (EXE folder သို့မဟုတ် data dir) သိမ်းမယ်။ |
| **Activate (EXE → Server)** | EXE မှာ `LICENSE_SERVER_URL` set ထားရင် activate က server ကို `POST /api/license/remote-activate/` ခေါ်မယ် (license_key + machine_id); server က validate + bind ပြီး success/expires_at ပြန်မယ်။ EXE က ပြန်ရတာနဲ့ license.lic သိမ်းမယ်။ |
| **Middleware** | Register, Login (token), shop-settings, license status/activate/remote-activate က license မစစ်ပါ (skip paths)။ ကျ API က can_use=False ဖြစ်ရင် 403။ |
| **Trial** | License မရှိရင် AppInstallation နဲ့ ၃၀ ရက် trial + ၅ ရက် grace။ |
| **File vs DB** | EXE: license.lic ရှိရင် ဖတ်ပြီး machine_id ကိုက်ရင် can_use။ Hosting: DB မှာ machine_id နဲ့ bind ထားသော license ရှိရင် can_use။ |

**အဆင်ပြေပြီးသား:** status, activate, remote-activate, skip paths (register, token, shop-settings), trial/grace, file + DB နှစ်မျိုးလုံး။

**စစ်ရန်:**  
- Status: `curl http://localhost:8000/api/license/status/`  
- Activate: Settings မှ License Activation စာမျက်နှာမှာ key ထည့်ပြီး Activate နှိပ်ပါ။  
- EXE + License Server: Hosting မှာ backend run ထားပြီး EXE မှာ `LICENSE_SERVER_URL=https://your-domain/api` set ထားကာ activate လုပ်ကြည့်ပါ။  

---

## ၄) တစ်ခါတည်း စစ်လို့ရအောင်

**တစ်ခါတည်း စစ်ရန် (အကြံပြု):**  
`scripts\run_all_checks.bat`  

ဒီ script က (၁) EXE/Hosting/License verification နဲ့ (၂) Frontend build (Vite) ကို တစ်ခါတည်း ပြေးစစ်ပေးပါတယ်။ Bug/error ရှိရင် build မအောင်မြင်ပါ။  

**ဖိုင်စစ်ချက် သက်သက်:**  
`scripts\verify_exe_hosting_license.bat`  

- EXE build အတွက်: build_exe.bat, run_server.py, spec, Vue base /app/, static_frontend  
- Docker hosting အတွက်: docker-compose.yml, WeldingProject Dockerfile, env (DEPLOYMENT_MODE, DATABASE_URL)  
- License အတွက်: license middleware skip paths (register, token, shop-settings), status/activate/remote-activate, services (check_license_status, file/DB)  

**ပြေးရန်:** Repo root မှာ  
- တစ်ခါတည်း: `scripts\run_all_checks.bat`  
- ဖိုင်စစ်ချက်သက်သက်: `scripts\verify_exe_hosting_license.bat`  

အပြီးမှာ EXE ကို ကိုယ်တိုင် run ပြီး Register/Login နဲ့ License Activation စစ်ပါ။ Docker စစ်ချင်ရင် `docker-compose up -d` ပြီး browser နဲ့ စစ်ပါ။  

---

## အတိုချုပ်

| ခေါင်းစဉ် | အခြေအနေ |
|------------|-----------|
| **EXE** | ✅ build_exe.bat, run_server, /app/, DB encrypt, license.lic/machine_id exe folder။ စစ်ရန်: build ပြီး HoBoPOS.exe run။ |
| **Hosting (Docker)** | ✅ docker-compose, migrate, static_frontend sync, DEPLOYMENT_MODE=hosted, license DB။ စစ်ရန်: build frontend → docker-compose up → /app/ + Register/Login။ |
| **License Key** | ✅ status, activate (local + remote), skip paths (register, token, shop-settings), trial/grace, file + DB။ စစ်ရန်: /api/license/status/ နဲ့ Settings → License Activation။ |

**တစ်ခါတည်း စစ်ရန်:** `scripts\verify_exe_hosting_license.bat` ပြေးပြီး ထွက်လာတဲ့ အချက်တွေကို ကြည့်ကာ လိုရင် EXE run / Docker run နဲ့ ထပ်စစ်ပါ။  
