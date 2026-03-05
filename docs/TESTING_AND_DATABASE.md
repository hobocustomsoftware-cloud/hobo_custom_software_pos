# စမ်းသပ်ခြင်း (Testing) နဲ့ Database ကြီးထွားမှု

## ၁။ Database တစ်နှစ်လောက်ကြာလာရင် ကြီးလာခြင်း

တစ်နှစ်လောက် သုံးလာရင် sales, repairs, inventory movements, logs တွေ များလာနိုင်ပါတယ်။ အောက်က အကြံပြုချက်တွေ လိုက်နာနိုင်ပါတယ်။

### ၁.၁ Index ထည့်ခြင်း
- **အရေးကြီးဆုံး** – စစ်တိုင်းသုံးတဲ့ column တွေမှာ DB index ထည့်ပါ။  
  ဥပမာ: `created_at`, `shop_id`, `user_id`, `status`, `invoice_no`  
- Django models မှာ `Meta.indexes` သို့မဟုတ် `db_index=True` သုံးပါ။  
- လိုရင် migration ထပ်ထုတ်ပြီး `CREATE INDEX` ထည့်ပါ။

### ၁.၂ ရက်လွန်ဒေတာ Archive / ဖျက်ခြင်း
- **Policy သတ်မှတ်ပါ** – ဥပမာ: ရောင်းချပြီး ၂ နှစ်/၃ နှစ် ကျော်သွားတဲ့ record တွေကို:
  - စာရင်းအင်း/အစီရင်ခံစာအတွက် **archive table** (သို့) **backup file** ကို ရွှေ့ပြီး
  - ပင်မဇယားကနေ ဖျက်ပစ်ခြင်း (သို့) သီးသန့် “archive” DB တစ်ခုဆီ ရွှေ့ခြင်း
- ဒါမှ ပင်မ DB size နဲ့ query မြန်ဆန်မှု ထိန်းနိုင်မယ်။

### ၁.၃ Backup နဲ့ Maintenance
- **Backup** – နေ့စဉ်/အပတ်စဉ် PostgreSQL backup (pg_dump) လုပ်ပါ။  
  Docker သုံးရင် `deploy/` ထဲက script တွေနဲ့ ချိတ်နိုင်ပါတယ်။
- **Vacuum / Analyze** – PostgreSQL မှာ ပုံမှန် `VACUUM ANALYZE` လုပ်ပါ။  
  ဒေတာဖျက်ပြီး နေရာပြန်မယူတာတွေ၊ stat မှားတာတွေ ကောင်းသွားစေတယ်။
- **Monitoring** – table size ကြီးလာတာ၊ slow query တွေကို စောင့်ကြည့်ပါ။  
  လိုရင် Django Debug Toolbar / PostgreSQL `pg_stat_statements` သုံးနိုင်ပါတယ်။

### ၁.၄ Pagination နဲ့ List API
- List API တိုင်းမှာ **pagination** (page size ကန့်သတ်) သုံးပါ။  
  ဒါမှ တစ်နှစ်လောက်ဒေတာများလာရင်လည်း စာမျက်နှာ တစ်ခါ load လုပ်တာ မကြီးလာစေဘူး။

---

## ၂။ Client စမ်းသပ်ခြင်း Workflow နဲ့ Screenshot

ပြောထားတဲ့ flow အတိုင်း စမ်းလို့ **ရပါတယ်**။

### ၂.၁ စမ်းသပ်အဆင့်တွေ (အကြံပြု)

| အဆင့် | လုပ်ရမှာ | ရည်ရွယ်ချက် |
|--------|------------|----------------|
| ၁ | ဆိုင်တစ်ခု **Register** လုပ် | Tenant/shop တစ်ခု ဖန်တီးပြီး စမ်းမယ့်နေရာ ရအောင် |
| ၂ | **Page တိုင်း ဝင်ကြည့် / နှိပ်ကြည့်** | Menu, route, layout မပျက်/မကျန်စေရန် |
| ၃ | **စမ်းရောင်းကြည့်** (POS) | Cart, discount, payment, invoice စစ်ရန် |
| ၄ | **ဝန်ထမ်းထည့်** (User management) | Role ပေးပြီး စမ်းမယ့်သူ ဖန်တီးရန် |
| ၅ | **ထပ်စမ်း** – ခုနလို page တွေ + ရောင်းချခြင်း | Staff account နဲ့ ပုံမှန်အလုပ် စစ်ရန် |
| ၆ | **User role မတူဘဲ စမ်းကြည့်** | Manager, Staff, Admin စသဖြင့် permission မတူတာ စစ်ရန် |

ဒီ flow ကို **manual** စမ်းလို့ရသလို၊ **automated (E2E)** နဲ့လည်း စမ်းလို့ ရပါတယ်။

### ၂.၂ Screenshot ထုတ်ခြင်း – ရမရ

- **ရပါတယ်။** နည်းနှစ်မျိုး သုံးနိုင်ပါတယ်။

#### (က) Manual စမ်းပြီး Screenshot ယူခြင်း
- စမ်းသပ်သူက လိုတဲ့ page / လိုတဲ့ role နဲ့ ဝင်ပြီး စမ်းကာ:
  - **Windows:** `Win + Shift + S` သို့မဟုတ် Snipping Tool
  - **Browser:** DevTools (F12) → More tools → Capture screenshot (Chrome)
- လိုတဲ့အဆင့်တိုင်းမှာ screenshot ယူပြီး ဖိုလ်ဒါတစ်ခုမှာ သိမ်းထားနိုင်ပါတယ်။  
  ဥပမာ: `screenshots/01-register/`, `02-pages/`, `03-sales/`, `04-staff/`, `05-roles/` စသဖြင့်။

#### (ခ) Automated E2E နဲ့ Screenshot ထုတ်ခြင်း
- **Playwright** သို့မဟုတ် **Cypress** လို E2E tool သုံးပြီး:
  - Register → Login → စာမျက်နှာတွေ သွား → POS စမ်း → Role ပြောင်းစမ်း စတဲ့ flow ကို script နဲ့ လုပ်ခိုင်းပြီး
  - **အဆင့်တိုင်းမှာ (သို့) fail ဖြစ်တဲ့အခါ)** screenshot ယူခိုင်းလို့ ရပါတယ်။
- Playwright မှာ `page.screenshot({ path: 'screenshots/step-01-register.png' })` လိုမျိုး ထည့်နိုင်ပါတယ်။  
  ဒါမှ တစ်ခါ run တိုင်း screenshot တွေ အလိုအလျောက် ထွက်ပြီး “စမ်းလို့ရလာတာကို screenshot နဲ့ ထုတ်ပေး” လိုချင်တာ ပြည့်စုံနိုင်ပါတယ်။

### ၂.၃ ဆွေးနွေးချက် (အတိုချုပ်)

| မေးခွန်း | အဖြေ |
|-----------|--------|
| အဲ့လို flow စမ်းလို့ **ရမလား**? | **ရပါတယ်** – manual သို့မဟုတ် E2E နဲ့ လုပ်နိုင်ပါတယ်။ |
| **Screenshot ထုတ်ပေးစေချင်**ရမရ? | **ရပါတယ်** – manual ယူနိုင်သလို E2E မှာ step တိုင်း/ fail မှာ auto screenshot ယူအောင် လုပ်နိုင်ပါတယ်။ |

နောက်တစ်ဆင့်အနေနဲ့:
- Manual နဲ့ စမ်းမယ်ဆိုရင် – စာမျက်နှာအလိုက် checklist နဲ့ screenshot ဖိုလ်ဒါ structure သတ်မှတ်ထားရင် ပြန်စစ်ရ လွယ်ပါတယ်။
- E2E နဲ့ screenshot အလိုအလျောက် လိုချင်ရင် – Playwright (သို့) Cypress project ထည့်ပြီး flow နဲ့ screenshot path တွေ သတ်မှတ်ပေးရင် ရပါပြီ။

---

*ဒီစာကို ပရောဂျက် `docs/` အောက်မှာ ထားပြီး စမ်းသပ်မှု နဲ့ DB ထိန်းသိမ်းမှု ဆွေးနွေးတဲ့အခါ ကိုးကားနိုင်ပါတယ်။*
