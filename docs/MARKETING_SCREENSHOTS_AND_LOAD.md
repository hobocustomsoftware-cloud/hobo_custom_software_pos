# ကြော်ငြာ Screenshot နဲ့ Server/Load Sizing (တစ်နှစ်စာဒေတာစမ်းပြီး Marketing အတွက်)

Manual data မရှိလို့ CMD ကနေ ဒေတာထုတ် → စမ်းပြီး screenshot ယူကာ၊ တစ်နှစ်စာလောက် စမ်းပြီးမှ database / load balancing / server ဘယ်လောက်လိုမလဲ သိချင်တာကို ဒီစာမှာ ဖော်ပြထားပါတယ်။

---

## ၁။ CMD ကနေ လုပ်ရမှာ (အဆင့်လိုက်)

### ၁.၁ တစ်နှစ်စာ ဒေတာထုတ်ခြင်း (Django)

ပရောဂျက် root မှာ (ဥပမာ `F:\hobo_license_pos`) virtualenv activate လုပ်ပြီး:

```cmd
cd F:\hobo_license_pos
venv\Scripts\activate
python WeldingProject\manage.py seed_demo_users
python WeldingProject\manage.py seed_one_year
```

- `seed_demo_users` = owner, manager, staff အကောင့် (password: demo123)
- `seed_one_year` = တစ်နှစ်စာ sales, repairs, customers, products စသည့် fake data ထုတ်မည်

ရွေးချယ်စရာ:
- `--months 12` (default) = ၁၂ လ
- `--sales-per-month 50` = တစ်လ ရောင်းချမှု အကြမ်းဖျင်း ၅၀
- `--repairs-per-month 10` = တစ်လ ပြင်ဆင်မှု ၁၀
- `--customers 80` = ဖောက်သည် ၈၀
- `--products 30` = ပစ္စည်း ၃၀ (မရှိရင် ထုတ်မည်)

ဥပမာ:
```cmd
python WeldingProject\manage.py seed_one_year --months 12 --sales-per-month 80 --repairs-per-month 15
```

### ၁.၂ Backend + Frontend ဖွင့်ခြင်း

- Terminal ၁: Django run  
  `python WeldingProject\manage.py runserver`
- Terminal ၂: Vue dev  
  `cd yp_posf && npm run dev`  
  (Frontend က http://127.0.0.1:5173 မှာ ရမယ်၊ API proxy က 8000 ဆီ သွားမယ်)

### ၁.၃ CMD ကနေ Screenshot ထုတ်ခြင်း (Playwright)

Frontend နဲ့ Backend ဖွင့်ထားပြီးချိန်မှာ:

```cmd
cd F:\hobo_license_pos\yp_posf
npm install
npx playwright install chromium
npm run screenshots
```

သို့မဟုတ်:
```cmd
npx playwright test e2e/screenshots-for-marketing.spec.js --project=chromium
```

- Login က **owner** / **demo123** သုံးမယ် (seed_demo_users ကနေ)
- စာမျက်နှာတွေ: Dashboard, Inventory, Products, Sales History, Sales POS, Service, Reports (Sales), Settings
- Screenshot တွေက `yp_posf/screenshots_for_marketing/` အောက်မှာ သိမ်းမယ်:
  - `01-dashboard.png`
  - `02-inventory.png`
  - `03-products.png`
  - `04-sales-history.png`
  - `05-sales-pos.png`
  - `06-service.png`
  - `07-reports-sales.png`
  - `08-settings.png`

ဒီဖိုလ်ဒါကို ကြော်ငြာ / မာကကတ်တင်း အတွက် သုံးနိုင်ပါတယ်။

### ၁.၄ Backend က port အခြား run ထားရင်

Frontend က 5173 မဟုတ်ရင် (သို့) Backend က 8000 မဟုတ်ရင်:
- Screenshot script က Frontend URL ကိုပဲ သုံးတယ် (default: http://127.0.0.1:5173)
- Base URL ပြောင်းချင်ရင်:  
  `set PLAYWRIGHT_BASE_URL=http://localhost:3000` (ဥပမာ) ထားပြီး `npm run screenshots` run ပါ

---

## ၂။ တစ်နှစ်စာဒေတာစမ်းပြီး Server / Load Balancing ဘယ်လောက်လိုမလဲ (Marketing အတွက်)

စမ်းပြီးသား “တစ်နှစ်စာ ဒေတာပမာဏ” ကို အခြေခံပြီး:

1. **Database size** – တစ်နှစ်စာ sales/repairs/movements ပမာဏနဲ့ DB size ကြီးလာပုံကို ခန့်မှန်းနိုင်တယ် (ဥပမာ PostgreSQL `pg_database_size()` သို့မဟုတ် table row count စစ်ပြီး)
2. **Load test** – စက်မလေးအောင် လုပ်ထားပြီးသား (pagination, index) နဲ့ စမ်းပြီး:
   - ရိုးရိုး browser နဲ့ စာမျက်နှာတွေ ဖွင့်ကြည့်ပြီး မြန်မမြန် ခံစားချက်
   - လိုရင် **Apache Bench (ab)** သို့မဟုတ် **k6 / Locust** လို tool နဲ့ API ကို ဖိစစ်ပြီး “ဒီပမာဏ ဒေတာနဲ့ ဒီ request/s မှာ စက်မလေးဘူး” ဆိုတာ မှတ်ယူနိုင်တယ်
3. **Server sizing အကြမ်း** – မာကကတ်တင်း/ကြော်ငြာမှာ “တစ်နှစ်စာ ဒေတာနဲ့ စမ်းပြီး ဒီ spec မှာ အဆင်ပြေတယ်” လို့ ပြောနိုင်အောင်:
   - **သေးငယ်တဲ့ ဆိုင် (တစ်နှစ်စာ ရောင်းချမှု ရာဂဏန်း)**  
     → Server ၁ လုံး (App + DB တွဲ) သို့မဟုတ် 1 CPU, 2GB RAM စသည်ဖြင့် စမ်းပြီး screenshot + “ဒီ spec မှာ စမ်းပြီးပါပြီ” ပြနိုင်တယ်
   - **အလတ်စား / ဆိုင်များများ**  
     → App server နဲ့ DB ခွဲပြီး၊ load balancer ရှေ့မှာ app instance ၂ ခု စသည်ဖြင့် ထပ်စမ်းပြီး “load balancing နဲ့ ဒီလိုအပ်တယ်” ဆိုတာ ပြနိုင်တယ်

အကြံပြုချက်:
- စမ်းထားတဲ့ **ဒေတာပမာဏ** (တစ်နှစ်စာ sales/repairs count) ကို doc သို့မဟုတ် ကြော်ငြာမှာ အတိုချုပ် ဖော်ပြထားရင် ယုံကြည်မှု ပိုရမယ်
- “တစ်နှစ်စာ ဒေတာနဲ့ စမ်းပြီး screenshot ယူထားပြီး၊ server / load balancing အတွက် ဒီလိုအပ်တယ်” ဆိုတာ ပြောနိုင်အောင် ဒီ CMD flow နဲ့ screenshot တွေကို သုံးပါ

---

## ၃။ အတိုချုပ်

| လုပ်ချက် | ပြန်လည်အသုံးပြုနိုင်သော ရလဒ် |
|-----------|--------------------------------------|
| `seed_one_year` | တစ်နှစ်စာ ဒေတာ (sales, repairs, customers, products) |
| `npm run screenshots` | ကြော်ငြာ အတွက် စာမျက်နှာ screenshot များ |
| Load test + DB size စစ်ခြင်း | Server / load balancing ဘယ်လောက်လိုမလဲ ခန့်မှန်းချက် (marketing မှာ ပြောနိုင်ရန်) |

Manual data မရှိလို့ CMD ကနေ ဒေတာထုတ် → စမ်း → screenshot ယူပြီး marketing နဲ့ server sizing အတွက် သုံးနိုင်ပါတယ်။
