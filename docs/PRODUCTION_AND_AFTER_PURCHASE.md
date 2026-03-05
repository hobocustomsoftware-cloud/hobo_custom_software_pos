# တစ်ကယ်သုံးမယ် / ဝယ်သုံးပြီး လိုအပ်ချက်များ

လက်ရှိအနေအထားနဲ့ **demo တစ်လအပြင်** တစ်ကယ်သုံးလို့ အဆင်ပြေမပြေ၊ ကြိုက်လို့ **ဝယ်သုံးပြီးဆိုရင် ဘာတွေလိုအပ်နိုင်မလဲ** ကို အတိုချုပ် ဖြေထားသည့် စာရွက်စာတမ်း။

---

## ၁။ လက်ရှိအနေအထားနဲ့ တစ်ကယ်သုံးလို့ အဆင်ပြေမပြေ

**အဆင်ပြေပါတယ်။** လက်ရှိ codebase မှာ အောက်ပါအချက်တွေ ပါပြီးသား:

| အချက် | လက်ရှိ |
|--------|----------|
| **POS / ရောင်းချခြင်း** | Cart, unit (လုံး/တစ်ကတ်/ဗူး), ပြန်အမ်းငွေ, Walk-in customer, checkout, receipt |
| **ပစ္စည်းစာရင်း / လုံးချင်း** | Products, categories, units, stock, multi-outlet |
| **ဝန်ထမ်း / ခွင့်ပြုချက်** | User management, roles, primary outlet, assignment |
| **License စနစ်** | Trial ၃၀ ရက် + grace ၅ ရက်၊ key ထည့်ပြီး Activate၊ On-Premise (တစ်ခါဝယ် အမြဲ) / Hosted (တစ်နှစ်တစ်ခါ renewal) |
| **Hosting** | Docker Compose, PostgreSQL, Redis, health check, static/media volumes |
| **လုံခြုံရေး** | SECRET_KEY, DEBUG=False, ALLOWED_HOSTS, rate limiting (license/auth) |

**Demo နဲ့ တစ်ကယ်သုံးခြင်း ကွာခြားချက်:**

- **Demo (လက်ရှိ Docker):** `SKIP_LICENSE=true` ထားထားလို့ license/trial မစစ်ဘူး → ကန့်သတ်မဲ့ သုံးလို့ရတယ် (တစ်လထက် ပိုပြီး သုံးချင်ရင် ဒီအတိုင်းပဲ သုံးလို့ရပါတယ်)။
- **တစ်ကယ်သုံး (ဝယ်ပြီး):** `SKIP_LICENSE=false` ထားပြီး **License key ထည့်ပြီး Activate** လုပ်ရမယ်။ ဒီအခါ trial ၃၀ ရက် ကုန်ရင် (သို့) license ကုန်ရင် app က **License Activation** စာမျက်နှာကို ပြမယ်။

ဒါကြောင့် **လက်ရှိအနေအထားနဲ့ တစ်ကယ်သုံးလို့ အဆင်ပြေပါတယ်** — ဝယ်ပြီးရင် env ပြင်ပြီး license activate လုပ်ရင် ဖြစ်ပါတယ်။

---

## ၂။ ဝယ်သုံးပြီးဆိုရင် ကနဦး လိုအပ်ချက်များ

ကြိုက်လို့ ဝယ်သုံးပြီးဆိုရင် အောက်က အဆင့်တွေ လိုအပ်နိုင်ပါတယ်။

### ၂.၁ စက်ပစ္စည်း / Hosting

| လိုအပ်ချက် | ရှင်းလင်းချက် |
|---------------|------------------|
| **Server သို့မဟုတ် VPS** | Linux (Ubuntu/CentOS စသည်) — Docker + Docker Compose run နိုင်ရင် ရပါတယ်။ |
| **RAM** | အနည်းဆုံး 1–2 GB (တစ်ဆိုင်တည်း)။ Multi-client ဆိုရင် client တစ်ခုချင်းစီ အတွက် ထပ်တွက်ပါ။ |
| **Disk** | Database + media (ဓာတ်ပုံ၊ receipt) အတွက် လုံလောက်သော နေရာ။ |
| **Domain (optional)** | လိုရင် domain နဲ့ HTTPS သတ်မှတ်ပြီး သုံးနိုင်ပါတယ်။ |

### ၂.၂ Environment / ဆက်တင်များ

တစ်ကယ်သုံးမယ် (license စစ်မယ်) ဆိုရင်:

| Variable | သတ်မှတ်ရမည် |
|----------|-----------------|
| **SKIP_LICENSE** | `false` (license စစ်မယ်) |
| **DJANGO_SECRET_KEY** | အားကောင်းတဲ့ random key (production မှာ မထားမဖြစ်) |
| **DJANGO_DEBUG** | `False` |
| **DJANGO_ALLOWED_HOSTS** | သင့် domain / IP (ဥပမာ `pos.myshop.com,localhost`) |
| **POSTGRES_PASSWORD** | အားကောင်းတဲ့ password |

**ဥပမာ — Production Compose သုံးမယ်:**

```bash
# compose/.env.prod.example ကို copy ပြီး .env.prod လုပ်ပါ
cp compose/.env.prod.example .env.prod
# .env.prod ထဲမှာ SKIP_LICENSE=false, DJANGO_SECRET_KEY, DJANGO_ALLOWED_HOSTS ပြင်ပါ

docker compose -f compose/docker-compose.yml -f compose/docker-compose.prod.yml --env-file .env.prod up -d --build
```

သို့မဟုတ် လက်ရှိ `compose/docker-compose.yml` သုံးနေရင် repo root မှာ `.env` ဖန်တီးပြီး အောက်ကို ထည့်ပါ:

```env
SKIP_LICENSE=false
DJANGO_SECRET_KEY=your-strong-secret-key-here
DJANGO_ALLOWED_HOSTS=your-domain.com,localhost,127.0.0.1
POSTGRES_PASSWORD=strong-password
```

### ၂.၃ License ပေးခြင်း (ဝယ်ပြီး သုံးစွဲသူအတွက်)

ဝယ်သူက **Docker/Server** မှာ သုံးမယ်ဆိုရင် ရွေးစရာ နည်းလမ်း နှစ်မျိုး:

**ရွေးစရာ A — Key ထည့်ပြီး Activate (အကြံပြု)**

1. သင် (developer/vendor) က **license key** ဖန်တီးပါ:  
   `python manage.py create_license --type on_premise_perpetual` (သို့) `--type hosted_annual --years 1`
2. ထွက်လာတဲ့ key (ဥပမာ `WLD-XXX-YYYY`) ကို ဝယ်သူကို ပေးပါ။
3. ဝယ်သူက app ထဲမှာ **License Activation** (`/app/license-activate`) သွားပြီး key ထည့်ကာ **Activate** နှိပ်ပါ။
4. Backend က DB မှာ စစ်ပြီး (သို့) license server ရှိရင် ချိတ်ပြီး **licensed** ဖြစ်သွားမယ်။

**ရွေးစရာ B — Offline license.lic ဖိုင် (Server/Website မတင်ရသေးချိန်)**

- ဝယ်သူ server ရဲ့ **Machine ID** ယူပါ (`GET /api/license/status/` response ထဲမှာ ပါမယ်)။
- သင့်ဘက်မှာ:  
  `python manage.py issue_license_file --machine-id <customer_machine_id> --type on_premise_perpetual --output license.lic`
- ထွက်လာတဲ့ **license.lic** ကို ဝယ်သူကို ပေးပြီး server ရဲ့ `license_data` volume ထဲ (သို့) backend က ဖတ်တဲ့ နေရာမှာ ထည့်ခိုင်းပါ။  
အသေးစိတ်: `docs/LICENSE_KEY_WHEN_NO_MAIN_WEBSITE.md` ကြည့်ပါ။

### ၂.၄ လုံခြုံရေး / ထပ်လုပ်ရန် (အကြံပြု)

| အချက် | လုပ်ရန် |
|--------|----------|
| **HTTPS** | Domain သုံးရင် SSL certificate ထားပြီး HTTPS ဖွင့်ပါ။ |
| **Backup** | PostgreSQL data + media ကို ပုံမှန် backup လုပ်ပါ (`deploy/backup` ကြည့်ပါ)။ |
| **Firewall** | လိုအပ်တဲ့ port (ဥပမာ 80, 443) ပဲ ဖွင့်ပါ။ |

### ၂.၅ စာရင်းသွင်း / ပထမဆုံး သုံးခြင်း

1. App ကို ဖွင့်ပါ (`http://your-server:8888/app/` သို့မဟုတ် domain)။
2. **Register** လုပ်ပြီး ပထမဆုံး user (owner) ဖန်တီးပါ။
3. **License Activation** သွားပြီး key ထည့်ကာ Activate လုပ်ပါ (တစ်ကယ်သုံးမယ်ဆိုရင်)။
4. **Setup Wizard** / Shop Settings မှာ ဆိုင်အမည်၊ logo၊ outlet စသည်ထည့်ပါ။
5. ဝန်ထမ်း၊ ပစ္စည်းစာရင်း၊ categories ထည့်ပြီး POS သုံးနိုင်ပါပြီ။

---

## ၃။ အတိုချုပ်

| မေးခွန်း | ဖြေ |
|------------|------|
| **လက်ရှိအနေအထားနဲ့ တစ်ကယ်သုံးလို့ အဆင်ပြေမပြေ?** | **အဆင်ပြေပါတယ်။** POS, inventory, users, license flow ပါပြီးသား။ |
| **ဝယ်သုံးပြီးဆိုရင် ကနဦး ဘာတွေလိုအပ်မလဲ?** | Server/VPS၊ env မှာ `SKIP_LICENSE=false` + SECRET_KEY, ALLOWED_HOSTS, DB password၊ **License key ထည့်ပြီး Activate** (သို့) license.lic ဖိုင်။ လိုရင် domain + HTTPS + backup။ |

အသေးစိတ် လမ်းညွှန်:

- **License:** `WeldingProject/LICENSE_SYSTEM.md`, `docs/LICENSE_KEY_WHEN_NO_MAIN_WEBSITE.md`
- **Hosting / လုံခြုံရေး:** `docs/READINESS_HOSTING_EXE_SECURITY.md`
- **Multi-client (ဆိုင်အများကြီး):** `deploy/multi-instance/README.md`
