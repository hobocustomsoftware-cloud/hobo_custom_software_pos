# API ချိတ်ဆက်မှု၊ CRUD နှင့် Marketing (Google Sheet + Telegram) စစ်ဆေးချက်

အောက်ပါ သုံးမျိုးကို အသေးစိတ် စစ်ဆေးထားချက် နှင့် လိုအပ်ချက်များ ဖြစ်သည်။

- **၁။ API error နှင့် ချိတ်ဆက်မှု**
- **၂။ CRUD တွေ အလုပ်လုပ်မလုပ်**
- **၃။ Marketing — Register လုပ်ရင် Google Sheet နဲ့ Telegram Bot ဆီ ပို့ခြင်း**

---

## ၁။ API Error နှင့် ချိတ်ဆက်မှု

### ၁.၁ လက်ရှိ အဆင်ပြေသည့်အရာများ

| အချက် | လက်ရှိ |
|--------|----------|
| **Global interceptor** | `yp_posf/src/services/api.js` — 403 `license_expired` → `/license-activate`, 403 `trial_expired` → `/trial-expired`, 401 → logout + login redirect, 500/503 → toast (ဆာဗာအမှား / ယာယီမရပါ) |
| **Backend မရှိ / ချိတ်မရ** | Login.vue: `!err.response \|\| status === 0 \|\| status >= 502` → "Backend ချိတ်ဆက်မှု မရပါ။ Backend (Django) စတင်ထားပါ။" |
| **Register error** | Register.vue: `ERR_NETWORK` / no response → "Cannot reach server. Start the backend."; 400 → field errors (email, phone_number, shop_name, password) ပြသည်။ |
| **License Activate** | LicenseActivation.vue: catch မှာ `err.response?.data?.error \|\| message` ပြသည်။ |
| **401 on login** | Login မှ 401 ရရင် "ဤအကောင့်မရှိပါ သို့မဟုတ် စကားဝှက်မှားနေပါသည်" (သို့) "ဖုန်းနံပါတ်/အီးမေးလ် သို့မဟုတ် စကားဝှက် မှားယွင်းနေပါသည်" |

### ၁.၂ စစ်ရန် / သတိထားရန်

- **CORS:** Production မှာ `CORS_EXTRA_ORIGINS` မှာ frontend domain ထည့်ပါ။
- **Base URL:** Frontend က `config.js` / `VITE_API_URL` နဲ့ API ခေါ်သည်။ Docker မှာ proxy `/api` → backend ဆိုရင် ပြဿနာမရှိပါ။
- **Timeout:** လိုရင် axios timeout ထပ်သတ်မှတ်နိုင်သည် (ယခု default ပဲ သုံးထား)။

**အတိုချုပ်:** API error နဲ့ ချိတ်ဆက်မှု အတွက် လက်ရှိ လိုအပ်တာတွေ ပြီးပြီ။ Backend စတင်ထားရင် 502/503/network error ကို UI မှာ မှန်ကန်စွာ ပြသည်။

---

## ၂။ CRUD တွေ အလုပ်လုပ်မလုပ်

### ၂.၁ Backend CRUD လမ်းကြောင်းများ (အတိုချုပ်)

| ကဏ္ဍ | API လမ်းကြောင်း | CRUD များ |
|--------|---------------------|------------|
| **Core** | `/api/core/` | Register (Create), ShopSettings (GET/PUT), Roles, Employees (User+Outlet), Outlets, Locations, Auth (login, me) |
| **Inventory** | `/api/` | Products (list/create/update/delete), Categories, Units, Stock, Sales (request, history), Invoices, Movements, Purchases, Payment methods |
| **Customer** | `/api/customers/` | List, Create, Detail (GET/PUT/DELETE) |
| **Accounting** | `/api/accounting/` | Expense categories, Transactions, PnL |
| **Service** | `/api/service/` | Repair orders, Track |
| **License** | `/api/license/` | status, activate |

### ၂.၂ ပြင်ပြီးသား / သတိထားရန်

- **Employees (User Management):** သိမ်းဆည်းမရ / 500 — ပြင်ပြီး။ `EmployeeSerializer` မှာ `primary_outlet` ကို Outlet instance ပေးပြီး၊ `role_name` က SerializerMethodField ဖြစ်သည်။
- **Shop-settings PUT 500:** ပြင်ပြီး။ `get_logo_url` try/except၊ `validate_logo` empty file ကိုင်သည်။
- **Sales request POST 500:** ပြင်ပြီး။ SaleItem create မှာ key များလွန်းခြင်း ဖယ်ပြီး၊ payment_method ID ကိုင်သည်။
- **Frontend ref error (SalesRequest):** `isMounted` check နဲ့ ref update လုပ်ပြီး။

### ၂.၃ CRUD စစ်ဆေးရန် (Manual / E2E)

အောက်ပါတို့ကို စစ်နိုင်သည်:

1. **Products:** ပစ္စည်းအသစ်ထည့်၊ ပြင်မှတ်၊ ဖျက်။
2. **Categories:** CRUD။
3. **User Management:** ဝန်ထမ်းအသစ်ထည့် (username, role, primary location, password)၊ သိမ်းဆည်း။
4. **Shop Settings:** Logo + ဆိုင်အမည် ပြင်ပြီး Save။
5. **Sales:** POS မှ ရောင်းချပြီး request submit၊ အောင်မြင်ပြီး receipt/invoice ကြည့်ခြင်း။
6. **Customers:** ဖောက်သည်အသစ်ထည့်၊ ပြင်မှတ်။

E2E: `scripts/run_e2e_docker.sh` (Docker stack ဖွင့်ထားပြီး run ပါ)။

**အတိုချုပ်:** CRUD အတွက် လမ်းကြောင်းများ ရှိပြီး၊ ယခင်ပြောထားသော 500 / ref error တွေ ပြင်ပြီး။ စစ်ချင်ရင် အကောင်းဆုံးက အောက်က flow တွေ လက်ဖြင့် စစ်ပါ။

---

## ၃။ Marketing — Register လုပ်ရင် Google Sheet နဲ့ Telegram Bot ပို့ခြင်း

Register လုပ်တိုင်း **Telegram** ကို စာတိုပို့ပြီး **Google Sheet** မှာ အတန်းအသစ် append လုပ်သည်။ လုပ်ဆောင်ချက်က **အဆင်ပြေပြီး** ဖြစ်ပြီး၊ အောက်က ဆက်တင်များ လိုအပ်သည်။

### ၃.၁ လုပ်ဆောင်ချက်

- **Backend:** `WeldingProject/core/views.py` — Register success ပြီးချိန်မှာ `sync_new_registration(user, shop_name)` ကို **တိုက်ရိုက်ခေါ်သည်**။ Celery worker မလိုပါ (ခေါ်ပြီးသား ဖြစ်သည်)။
- **Sync လုပ်သည့်အရာ:** `WeldingProject/core/external_sync.py`
  - **Telegram:** `TELEGRAM_BOT_TOKEN` + `TELEGRAM_CHAT_ID` ရှိရင် message ပို့သည်။ စာသား: `"New Signup: {name}, Phone: {phone}, Shop: {shop_name}"`။
  - **Google Sheet:** `GOOGLE_SHEETS_SPREADSHEET_ID` + `GOOGLE_SHEETS_CREDENTIALS_JSON` (သို့) `GOOGLE_SHEETS_JSON` (service account JSON ဖိုင်လမ်းပြသော env) ရှိရင် Sheet မှာ အတန်းအသစ် append လုပ်သည်။ ကော်လံ: ရက်စွဲ, အမည်, ဖုန်း, အီးမေးလ်, ဆိုင်အမည်, username။

### ၃.၂ လိုအပ်သည့် ဆက်တင်များ (အသေးစိတ်)

#### Telegram

| လိုအပ်ချက် | ရှင်းလင်းချက် |
|---------------|------------------|
| **TELEGRAM_BOT_TOKEN** | BotFather မှ ရသော bot token (ဥပမာ `123456:ABC-xxx`)။ |
| **TELEGRAM_CHAT_ID** | စာပို့မည့် chat ID (ပုဂ္ဂိုလ်ရေး chat သို့မဟုတ် group)။ မထည့်ရင် Telegram မပို့ပါ။ |

**Chat ID ရနည်း:**  
Bot ကို group ထဲ ထည့်ပြီး စာတစ်ခုပို့ပါ။ Browser မှာ ဖွင့်ပါ:  
`https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates`  
Response ထဲက `"chat":{"id": -123456789}` က chat_id ဖြစ်သည်။ (Private chat ဆိုရင် user ရဲ့ id ပါ။)

#### Google Sheet

| လိုအပ်ချက် | ရှင်းလင်းချက် |
|---------------|------------------|
| **GOOGLE_SHEETS_SPREADSHEET_ID** | Sheet URL ထဲက ID။ ဥပမာ `https://docs.google.com/spreadsheets/d/ **1iFLn3H2AhjdyNgxJRbXTHiYAviX_mcOdXmdbRFtjGDI** /edit` → `1iFLn3H2AhjdyNgxJRbXTHiYAviX_mcOdXmdbRFtjGDI`။ |
| **GOOGLE_SHEETS_SHEET_NAME** | အတန်းထည့်မည့် sheet အမည် (default: `Registrations`)။ |
| **GOOGLE_SHEETS_CREDENTIALS_JSON** သို့မဟုတ် **GOOGLE_SHEETS_JSON** | Service Account JSON ဖိုင်ရဲ့ **လမ်းကြောင်း** (backend/container ထဲမှာ မြင်ရသော path)။ ဥပမာ `/app/credentials.json`။ |

**Google Service Account ပြင်ဆင်နည်း (အသေးစိတ်):**

1. **Google Cloud Console** → APIs & Services → Credentials → Create Credentials → Service Account။
2. Service account ဖန်တီးပြီး **JSON key** ထုတ်ပါ။
3. ဒီ JSON ဖိုင်ကို server/container မှာ ထားပြီး env မှာ **လမ်းကြောင်း** ပေးပါ (ဥပမာ `GOOGLE_SHEETS_JSON=/app/credentials.json`)။
4. **Google Sheet** ကို ဖွင့်ပြီး Share မှာ ဒီ service account ရဲ့ **အီးမေးလ်** (ဥပမာ `xxx@project.iam.gserviceaccount.com`) ကို **Editor** အနေနဲ့ ထည့်ပါ။
5. Sheet ထဲမှာ ပထမအတန်း header ထားနိုင်သည်: `Date`, `Name`, `Phone`, `Email`, `Shop`, `Username`။ (မထားလည်း code က A:Z ကို append လုပ်သည်။)

**Python packages (Google Sheet အတွက်):**  
Backend image မှာ `google-auth` နဲ့ `google-api-python-client` ထည့်ထားရမည်။ မထည့်ထားရင် external_sync မှာ "Google Sheets sync skipped" လို့ log ထွက်ပြီး Sheet မှာ မထည့်ပါ။

### ၃.၃ Docker Compose မှာ သတ်မှတ်နည်း

**compose/docker-compose.yml** မှာ backend service က အောက်ပါ env တွေကို **ယူပြီးသား** (repo root က `.env` မှ ဖတ်သည်):

```env
TELEGRAM_BOT_TOKEN=your-bot-token
TELEGRAM_CHAT_ID=your-chat-id
GOOGLE_SHEETS_SPREADSHEET_ID=your-spreadsheet-id
GOOGLE_SHEETS_SHEET_NAME=Registrations
GOOGLE_SHEETS_JSON=/app/credentials.json
```

**Credentials ဖိုင် ထည့်နည်း (Docker):**  
Backend container ထဲမှာ JSON ဖိုင်ရှိရမည်။ နည်းလမ်း:

- **Bind mount:** compose မှာ backend အတွက် volume ထည့်ပါ။ ဥပမာ `./my-credentials.json:/app/credentials.json:ro`။ ပြီးတော့ `GOOGLE_SHEETS_JSON=/app/credentials.json` ထားပါ။
- သို့မဟုတ် image build မှာ credentials မထည့်ပါနဲ့ (လုံခြုံရေး)။ production မှာ secret/volume နဲ့ mount ပါ။

**ဥပမာ .env (repo root):**

```env
TELEGRAM_BOT_TOKEN=8201714017:AAF...
TELEGRAM_CHAT_ID=-1001234567890
GOOGLE_SHEETS_SPREADSHEET_ID=1iFLn3H2AhjdyNgxJRbXTHiYAviX_mcOdXmdbRFtjGDI
GOOGLE_SHEETS_SHEET_NAME=Registrations
GOOGLE_SHEETS_JSON=/app/credentials.json
```

Backend container ကို credentials ဖိုင် mount လုပ်ရန် (docker-compose override သို့မဟုတ် custom compose):

```yaml
backend:
  volumes:
    - ./path/to/your-service-account.json:/app/credentials.json:ro
```

### ၃.၄ အဆင်ပြေမပြေ စစ်ဆေးနည်း

1. **Telegram:** env ထည့်ပြီး Register လုပ်ပါ။ Bot ထည့်ထားသော chat / group မှာ "New Signup: ..." စာတိုရောက်ရမည်။
2. **Google Sheet:** env + credentials mount ပြီး Register လုပ်ပါ။ Sheet ထဲက "Registrations" (သို့မဟုတ် သတ်မှတ်ထားသော sheet) မှာ အတန်းအသစ် ထပ်တိုးရမည်။
3. **Log:** Backend log မှာ `Registration marketing sync failed` ပါရင် token/chat_id/sheet ID/credentials path စစ်ပါ။

**မှတ်ချက်:** Sync မအောင်မြင်လည်း **Register က အောင်မြင်ပါတယ်**။ User ကို DB မှာ ဖန်တီးပြီးသား။ Telegram/Sheet က ထပ်ပြီး marketing အတွက်သာ ဖြစ်သည်။

---

## ၄။ အတိုချုပ်

| မေးခွန်း | ဖြေ |
|------------|------|
| **API error / ချိတ်ဆက်မှု အဆင်ပြေမပြေ?** | **အဆင်ပြေပါတယ်။** Interceptor မှာ 401/403/500/503 နဲ့ backend မရှိ/ချိတ်မရ ကို ကိုင်ထားပြီး။ |
| **CRUD တွေ အလုပ်လုပ်မလုပ်?** | **လုပ်ပါတယ်။** Core, Inventory, Customer စသည့် CRUD API များ ရှိပြီး၊ ယခင်ပြောထားသော 500 / ref error တွေ ပြင်ပြီး။ စစ်ချင်ရင် အောက်က flow တွေ လက်ဖြင့် စစ်ပါ။ |
| **Register လုပ်ရင် Google Sheet / Telegram ပို့အောင် လုပ်ထားတာ အဆင်ပြေမပြေ?** | **အဆင်ပြေပါတယ်။** Register success ပြီးချိန်မှာ sync ကို တိုက်ရိုက်ခေါ်သည်။ **လိုအပ်တာက** TELEGRAM_BOT_TOKEN + TELEGRAM_CHAT_ID၊ GOOGLE_SHEETS_SPREADSHEET_ID + GOOGLE_SHEETS_JSON (သို့မဟုတ် GOOGLE_SHEETS_CREDENTIALS_JSON) နဲ့ Service Account JSON ဖိုင်ကို backend မှာ မြင်ရအောင် mount လုပ်ပါ။ |

အသေးစိတ် code များ: `yp_posf/src/services/api.js`, `WeldingProject/core/views.py` (Register), `WeldingProject/core/external_sync.py`, `compose/docker-compose.yml` (backend env)။
