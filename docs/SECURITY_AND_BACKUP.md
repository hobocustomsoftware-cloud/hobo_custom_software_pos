# Security, Data Optimization & Backup Plan – HoBo POS

## 1. Security (Hacker / Cracker ကာကွယ်ခြင်း)

### 1.1 Authentication & Authorization
- **JWT**: Backend က Simple JWT သုံးထားပြီး token expiry သတ်မှတ်ထားရမယ်။ Frontend က `api` service ကနေ token ထည့်ပေးပြီး 403/license_expired ဆိုရင် `/license-activate` ကို redirect လုပ်ထားတယ်။
- **Role-based access**: Admin / Staff ခွဲပြီး API မှာ permission စစ်ထားရမယ် (Django `IsAdminUser`, `IsAuthenticated` စသည်)။
- **Password**: Strong password policy နဲ့ hashing (Django default PBKDF2) သုံးထားရမယ်။

### 1.2 License & Tampering
- **License activation**: Server-side validation လုပ်ပြီး expiry / machine binding စစ်ထားရမယ်။ Frontend က license expired 403 ရရင် activate page ကို ပြန်ပို့ထားတယ်။
- **Cracker ကာကွယ်ခြင်း**: Critical logic (license check, pricing, approval) အားလုံး backend မှာသာ လုပ်ပါ။ Frontend က UI ပဲ ဖြစ်ပြီး sensitive decision မှာ မှီခိုခြင်း မရှိစေရန်။

### 1.3 API & Network
- **HTTPS**: Production မှာ HTTPS သုံးပါ။
- **CORS**: Backend မှာ allowed origins သတ်မှတ်ပါ (wildcard မသုံးပါနဲ့)။
- **Rate limiting**: Login / API endpoints မှာ rate limit ထည့်ပါ (e.g. django-ratelimit, DRF throttling)။
- **Headers**: Security headers (X-Content-Type-Options, CSP, HSTS) ထည့်ပါ။

### 1.4 Data & Storage
- **Secrets**: `.env` / environment variables မှာသာ ထားပါ။ Repo ထဲ secret မထည့်ပါနဲ့။
- **Sensitive data**: PII / financial data ကို log မှာ မထုတ်ပါနဲ့။ Backup များကို encryption လုပ်ပါ (optional but recommended)။

---

## 2. Data Optimization

### 2.1 Database
- **Indexes**: Frequently queried columns (e.g. `created_at`, `user_id`, `sku`, `status`) မှာ index ထည့်ပါ။ Django migrations နဲ့ `db_index=True` / `Index` သုံးနိုင်တယ်။
- **Archiving**: သက်တမ်းကြာသော data များကို archive table သို့ ရွှေ့ပြီး main table သန့်ရှင်းပါ (e.g. old notifications, old movements)။
- **Pagination**: List API များမှာ page size limit ထားပါ (e.g. 100) နဲ့ cursor/page number သုံးပါ။

### 2.2 Frontend / Offline
- **IndexedDB**: Offline cache (products, pending_sales) က Dexie နဲ့ သိမ်းထားပြီး sync လုပ်တဲ့အခါ failed row များကို retry လုပ်ထားတယ်။ Cache read fail ဆိုရင် user ကို “Go online to refresh” ပြထားတယ်။
- **API usage**: အားလုံး `api` service ကနေ ခေါ်ပါ (baseURL, token, 403 handling တစ်ပြေးညီ)။

---

## 3. Backup Plan (အသေးစိပ်)

### 3.1 ဘာတွေ Backup လုပ်မလဲ
- **PostgreSQL (Docker)**: `pg_dump` နဲ့ full DB backup။ Script: `deploy/backup/backup.ps1` (Windows), `deploy/backup/backup.sh` (Linux/Mac)။
- **SQLite**: `db.sqlite3` file copy။ Script: `deploy/backup/backup-sqlite.ps1`။

### 3.2 ဘယ်မှာ သိမ်းမလဲ
- **Local**: Project အောက် `backups/` (သို့) သတ်မှတ်ထားသော path။
- **Retention**: 30 ရက် (script များမှာ ဖျက်ထားပြီး)။
- **Offsite**: Optional – AWS S3 / Google Cloud / NAS ကို script ထဲမှာ copy ထပ်ထည့်နိုင်တယ်။

### 3.3 အချိန်ဇယား
- **Daily**: Task Scheduler (Windows) / cron (Linux) နဲ့ ညဉ့် 2 နာရီခန့် run ပါ။
- **Before major release**: Manual full backup + restore test လုပ်ပါ။

### 3.4 Restore လုပ်နည်း
- **PostgreSQL**: `pg_restore` သုံးပြီး backup file ကနေ restore။ (README ထဲ ရှိပြီး။)
- **SQLite**: App ရပ်၊ backup file ကို `db.sqlite3` အဖြစ် copy လဲ၊ app ပြန် start။

### 3.5 စစ်ဆေးခြင်း
- Backup ပြီးတိုင်း file size > 0 စစ်ပါ။
- လစဉ် restore test လုပ်ပြီး log မှတ်ပါ။
- Backup fail ဆိုရင် alert (email / log) ထည့်နိုင်တယ်။

---

## 4. Summary Checklist

| Area | Action |
|------|--------|
| API | Frontend အားလုံး `api` service သုံး၊ backend path `/api/...` နဲ့ ကိုက်ညီစစ်ပါ။ |
| Offline | Cache read/sync error မှာ `syncError` set ပြီး user ကို message ပြပါ (လုပ်ပြီး)။ |
| Backup | PostgreSQL + SQLite script များ ရှိပြီး၊ README မှာ SQLite ထည့်ပြီး။ |
| Security | HTTPS, CORS, rate limit, JWT expiry, license server-side only။ |
| Data | Index, archive, pagination; backup retention နဲ့ restore test။ |

ဒီ document ကို နောက် security hardening နဲ့ backup automation တိုးတဲ့အခါ update လုပ်နိုင်တယ်။
