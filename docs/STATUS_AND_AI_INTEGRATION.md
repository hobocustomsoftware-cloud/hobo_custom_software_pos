# အခြေအနေ စစ်ဆေးချက် + Host Server + AI ထည့်သွင်းနည်း

---

## ၁။ မနေ့က ပြင်ခိုင်းထားတာတွေ — ပြီးပြီလား / ဘာကျန်သေးလဲ

### ပြီးပြီးသား (Done)

| လုပ်ချက် | ဖိုင် / နေရာ |
|-----------|-----------------|
| **Windows .exe တစ်ခါ run ရင် အကုန်အဆင်ပြေ** | `WeldingProject/run_server.py`, waitress, browser open `/app/` |
| **Folder တစ်ခုထဲ ထုတ်ပြီး ပေးမယ်** | PyInstaller **onedir**, `build_exe.bat` → **HoBoPOS_Release** |
| **Install လုပ်ပြီးမှ သုံးရတဲ့ ပုံစံ ဆွေးနွေးချက်** | `BUILDING_EXE_WINDOWS.md` ထဲ စာပိုဒ် ၆ |
| **Portable ထက် လုံခြုံအောင် + source မပါအောင်** | `docs/SECURITY_AND_PROTECTION.md` |
| **Cracker / ဖိုင် ခိုးသုံး / developer ဖတ်လို့မရ** | PyArmor (build မှာ), DB encrypt (machine_id), Section ၆ ကိုယ်တိုင် ပြင်လို့ရမှု |
| **ကောင်းတာနဲ့သာ လုပ်လိုက်** | PyArmor + DB encrypt ထည့်ပြီး, `build_exe.bat` [4/5] [5/5], spec က build_obf သုံး |
| **License key — main website မတင်ရသေးချိန်** | `issue_license_file` management command, `docs/LICENSE_KEY_WHEN_NO_MAIN_WEBSITE.md` |

### ကျန်နေသေးနိုင်တာ (Optional / လိုမှ လုပ်)

- **Installer (Setup.exe)**: `deploy/installer/` မှာ Inno Setup စာတမ်းရှိပြီး။ “Install လုပ်ပြီးမှ သုံးရတာ” လိုချင်ရင် `build_exe.bat` ပြီးရင် `deploy/installer/` script နဲ့ Setup.exe ထပ်လုပ်လို့ရတယ်။
- **Code signing**: .exe ကို Windows Authenticode နဲ့ sign မလုပ်ရသေးပါ။ လိုရင် certificate ဝယ်ပြီး build ပြီးတိုင်း sign ထည့်ရမယ်။
- **PyArmor မသုံးချင်**: `WeldingProject\build_obf` ဖျက်ပြီး `pyinstaller HoBoPOS.spec` run ရင် သာမာန် build ထုတ်မယ်။

---

## ၂။ Host Server တွေအတွက် — အဆင်သင့်ဖြစ်ပြီးလား

**ဖြစ်ပြီးသား:**

- **Docker**: `WeldingProject/Dockerfile`, `deploy/server/docker-compose.yml` — Backend (Django + Daphne), Nginx, PostgreSQL, Redis ပါပြီး။
- **Deploy စာစောင်**: `deploy/README.md`, `deploy/server/README.md` — Server hosting လုပ်နည်း, env, health checks, security ရှင်းထားပြီး။
- **License server**: Main website ကို server မှာ run ထားရင် `POST /api/license/remote-activate/` က EXE မှ ခေါ်လို့ရပြီး။ EXE ဘက်မှာ **LICENSE_SERVER_URL** သတ်မှတ်ထားရင် ဒီ server နဲ့ ချိတ်မယ်။
- **create_license**: Server (သို့) local မှာ `python manage.py create_license --type on_premise_perpetual` လုပ်ပြီး key ဖန်တီးထားလို့ရတယ်။

**Server တင်တဲ့အခါ လုပ်ရမယ်:**

1. `deploy/server/.env` ပြင်မယ် (DJANGO_SECRET_KEY, POSTGRES_PASSWORD, DJANGO_ALLOWED_HOSTS စသည်)။
2. `docker-compose -f deploy/server/docker-compose.yml up -d --build` run မယ်။
3. (လိုရင်) Domain/HTTPS စီမံမယ်။
4. EXE သုံးစွဲသူတွေကို **License Server URL** ပြောပေးမယ် (ဥပမာ `https://your-domain.com`)၊ EXE config/env မှာ **LICENSE_SERVER_URL** ထည့်မယ် (သို့) app ထဲမှာ server URL ထည့်သတ်မှတ်မယ်။

အတိုချုပ်: **Host server တွေအတွက် လုပ်ထားတာတွေ အဆင်သင့်ဖြစ်ပြီး** — Docker + deploy doc + license remote-activate ပါပြီး။ Server တင်ပြီး env နဲ့ LICENSE_SERVER_URL သတ်မှတ်ရင် သုံးလို့ရပါတယ်။

---

## ၃။ AI ကို ဘယ်လို ထည့်သွင်းလို့ရမလဲ

### ၃.၁ ဘယ်နေရာမှာ သုံးမလဲ (ဥပမာ)

| သုံးနေရာ | ဥပမာ |
|------------|--------|
| **POS / ရောင်းချမှု** | ပစ္စည်းအကြံပြု (recommendation), ဈေးနှုန်း/ပရိုမိုးရှင်းအကြံပြု |
| **စာရင်းစစ် / Report** | ရောင်းချမှု/လက်ကျန် မေးခွန်းမေးရင် ဖြေခြင်း, summary ထုတ်ခြင်း |
| **ဖောက်သည် / ပြန်ကြားချက်** | Chatbot, မေးခွန်းဖြေခြင်း |
| **Admin / စီမံခန့်ခွဲမှု** | ပစ္စည်းအမည်/ဖော်ပြချက် ပြင်ခြင်း, ကုဒ်ထုတ်ခြင်း |

### ၃.၂ ထည့်သွင်းနည်း (အဆင့်ချင်း)

**A. API-based (Cloud LLM — OpenAI / Claude / အခြား)**

1. **Backend (Django)** မှာ service တစ်ခု လုပ်မယ်:
   - API key ကို env (ဥပမာ `OPENAI_API_KEY`) မှာ ထားမယ်။
   - View (သို့) service ကနေ HTTP client နဲ့ OpenAI/Claude API ကို ခေါ်မယ် (prompt + context ပေးပြီး response ယူမယ်)။
2. **API endpoint** ထားမယ်: ဥပမာ `POST /api/ai/chat/` သို့မဟုတ် `POST /api/ai/suggest/` — request body မှာ prompt, context (ပစ္စည်းစာရင်း, ရောင်းချမှု စသည်) ထည့်မယ်။
3. **Frontend (Vue)** မှာ စာမျက်နှာ/component (ဥပမာ “AI အကြံပြု” ခလုတ်, chat box) ထည့်ပြီး ဒီ API ကို ခေါ်မယ်။

**B. Local LLM (ဒေတာ server မပို့ချင်ရင်)**

- Backend မှာ **Ollama** (သို့) **llama.cpp** လို local server ကို HTTP နဲ့ ခေါ်မယ် (localhost)။
- EXE / server ဘက်မှာ Ollama install ထားပြီး model run ထားရမယ်။
- ကျန်လမ်းကြောင်းက A နဲ့ အတူ — Django service က local URL ကို ခေါ်မယ်၊ Vue က Django API ပဲ သုံးမယ်။

**C. လက်တွေ့ စလုပ်ရင် (အနည်းဆုံး)**

1. **Django**: `core` (သို့) app အသစ် `ai` ထဲမှာ `ai/services.py` — `openai` (သို့) `requests` နဲ့ LLM API ခေါ်မယ်။  
2. **Django**: `ai/views.py` — `POST /api/ai/chat/` (body: `{"prompt": "...", "context": "..."}`) → service ခေါ်ပြီး response ပြန်မယ်။  
3. **Vue**: စာမျက်နှာ/component တစ်ခုမှာ input + “Send” ခလုတ် ထည့်ပြီး `/api/ai/chat/` ကို ခေါ်မယ်။  
4. **Env**: `OPENAI_API_KEY` (သို့) `AI_API_URL` (local Ollama ဆိုရင် `http://localhost:11434/api/generate`) သတ်မှတ်မယ်။  

ဒါဆို **AI ကို Backend API ကနေ ထည့်သွင်းပြီး** Frontend က ဒီ API ကိုပဲ သုံးအောင် လုပ်ထားလို့ရပါတယ်။ နောက်မှ recommendation, report, chatbot စသည်ဖြင့် feature တိုးချဲ့လို့ရပါတယ်။

---

## ၄။ အတိုချုပ်

- **မနေ့က ပြင်ခိုင်းထားတာတွေ**: Windows exe (folder ထုတ်), လုံခြုံရေး (PyArmor + DB encrypt), License (offline license.lic + issue_license_file) **အကုန်ပြီးပြီ**။ Installer/Code signing က လိုမှ ထပ်လုပ်ရမယ်။  
- **Host server**: Docker + deploy doc + license server **အဆင်သင့်ဖြစ်ပြီး** — server တင်ပြီး env နဲ့ LICENSE_SERVER_URL သတ်မှတ်ရင် သုံးလို့ရပါတယ်။  
- **AI ထည့်သွင်းချင်**: Backend မှာ AI service + `POST /api/ai/...` endpoint ထားပြီး Vue က ဒီ API ကို ခေါ်အောင် လုပ်ရင် ရပါတယ် (Cloud API သို့မဟုတ် Local Ollama နဲ့)။  

AI အတွက် endpoint design သို့မဟုတ် prompt structure လိုချင်ရင် ပြောပါ။
