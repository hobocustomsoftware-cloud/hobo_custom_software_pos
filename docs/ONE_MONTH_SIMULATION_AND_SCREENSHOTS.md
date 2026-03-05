# တစ်လစာ Simulation + Screenshot လုပ်လို့ရမရ ဆွေးနွေးချက်

## လိုချင်တာက

- **တစ်လစာ** လောက် ဒေတာရှိပြီး ဆိုင်တစ်ဆိုင်လယ်ပတ်ပုံ (workflow) စတင်
- **Screenshot ပုံတွေ** ရိုက်ထားပေး
- **Flow**: Register စလုပ် → Login ဝင် → **Owner** က **role အလိုက် permission** ပေး → ဆိုင်လယ်ပတ်ပုံ + တစ်လစာလောက် လုပ်ထားတာတွေကို screenshot တွေနဲ့ ပြမယ်
- **စက်မလေးအောင်** လုပ်ရမယ်

---

## လုပ်လို့ ရနိုင်မရနိုင်

### ✅ လုပ်လို့ ရပါတယ်

အကြမ်းဖျင်းနည်းလမ်းက ဒီလို ခွဲထားရင် ရပါတယ်:

1. **တစ်လစာ ဒေတာ** → **Backend မှာ တစ်ခါတည်း** ထုတ်မယ် (browser မဖွင့်ဘူး)
2. **Screenshot တွေ** → **Playwright** က စာမျက်နှာတွေကို သွားပြီး **အမှတ်တံဆိပ် တစ်ခုချင်း** ရိုက်မယ် (လုပ်ဆောင်ချက် များများ မလုပ်ရဘူး)

ဒါဆို စက်လေးတာ မဖြစ်အောင် ထိန်းလို့ ရပါတယ်။

---

## ၁။ တစ်လစာ ဒေတာ (စက်မလေးအောင်)

လက်ရှိ ပြီးသား command တွေ ရှိပြီးသား:

| Command | ဘာလုပ်လဲ |
|--------|-------------|
| `python manage.py run_simulation [--days 30]` | Register (သို့) ရှိပြီးသား user နဲ့ Login → ရက်စဉ် ရောင်းချမှု ဖန်တီး → Approve လုပ် → `created_at` ကို ၃၀ ရက်အတွင်း ဖြန့်ပေး |
| `python manage.py seed_one_year --months 1 --sales-per-month 50` | တစ်လစာ ရောင်းချမှု / ပြင်ဆင်မှု / ဖောက်သည် စသည်တို့ ဒေတာ ထုတ်ပေး |

- ဒီတွေက **Django management command** ပဲ ဖြစ်တယ်၊ **browser / Playwright မလိုပါ**။
- DB မှာ ဒေတာ ထည့်တာပဲ လုပ်တာမို့ **၁–၂ မိနစ်အတွင်း** ပြီးနိုင်ပြီး **စက်မလေးပါ**။
- တစ်လစာ “လုပ်ထားတာလေးတွေ” ဆိုတာ ဒီ ဒေတာနဲ့ Dashboard / Reports စသည့် စာမျက်နှာတွေမှာ **ပြသသွားမယ်**။ Screenshot ရိုက်ရင် “တစ်လစာလောက် လုပ်ထားတဲ့ ပုံ” ရမယ်။

ဒါကြောင့် **တစ်လစာ ဒေတာကို Backend မှာ တစ်ခါတည်း လုပ်ပြီး**၊ စက်မလေးအောင် **UI မှာ ဒေတာထုတ်တဲ့ loop မလုပ်ဘူး** ဆိုတဲ့ နည်းက **ရပါတယ်**။

---

## ၂။ Register → Login → Screenshot

- **Register** စာမျက်နှာ ဖွင့် → screenshot (ဥပမာ `step1_register.png`)  
- Form ဖြည့် (username, full_name, email, password, password_confirm) → စာရင်းသွင်း → ပြီးရင် **Login** စာမျက်နှာ (သို့) Dashboard ကို ရောက်မယ်  
- **Login** စာမျက်နှာ မြင်ရင် form ဖြည့် → Sign In → Dashboard ရောက် → screenshot (ဥပမာ `step2_after_login.png`)  

Vue မှာ Register / Login စာမျက်နှာတွေ ရှိပြီးသား၊ API လည်း ရှိပြီးသား (`/api/core/register/`, `/api/token/`)။ Playwright က ဒီ flow အတိုင်း လုပ်ပြီး screenshot ရိုက်လို့ **ရပါတယ်**။

---

## ၃။ Owner က role အလိုက် permission ပေးပြီး Screenshot

- **Owner** ဆိုတာ ပထမဆုံး စာရင်းသွင်းသူ (သို့) `seed_demo_users` က `owner` role ပေးထားသူ။
- **Role များ** စာမျက်နှာ ရှိပြီး path က `/users/roles` (RoleManagement.vue)။
- Owner ဝင်ပြီး ဒီစာမျက်နှာ သွားပြီး:
  - Role list ပြသနေတဲ့ ပုံ → screenshot (ဥပမာ `step3_roles.png`)
  - လိုရင် Role တစ်ခု **Edit** ဖွင့်ပြီး (role အလိုက် permission ပြင်တဲ့ UI ရှိရင်) ဒါကို screenshot

လက်ရှိ Role edit မှာ **name / description** ပဲ ပါပြီး၊ permission checkboxes စသည့် “permission ပေးတဲ့ UI” မပါသေးရင် **Role list + Edit modal** ကို screenshot ရိုက်တာပဲ လုပ်လို့ ရပါတယ်။ နောက်မှ permission UI ထည့်ရင် script မှာ ဒီစာမျက်နှာ ထပ်ရိုက်အောင် ထည့်လို့ ရပါတယ်။

ဒါကြောင့် **Owner က role အလိုက် permission ပေးတဲ့ ပုံစံ** ကို screenshot နဲ့ ပြလို့ **ရပါတယ်** (လက်ရှိ UI အတိုင်း)။

---

## ၄။ ဆိုင်တစ်ဆိုင်လယ်ပတ်ပုံ + တစ်လစာလောက် Screenshot

“ဆိုင်တစ်ဆိုင်လယ်ပတ်ပုံ” ဆိုတာက စနစ်ကို သုံးတဲ့ workflow ကို ဆိုလိုတာမို့၊ စာမျက်နှာတွေ သွားပြီး တစ်စာမျက်နှာ တစ်ပုံ ရိုက်ရင် ရပါတယ်။

ဥပမာ စာရင်း:

1. **Dashboard** (Bento grid, Total Revenue, USD Rate, Smart Insight စသည်) → screenshot  
2. **Sales POS** (`/sales/pos`) → screenshot  
3. **Sale History** (`/sales/history`) → screenshot  
4. **Admin Approve** (`/sales/approve`) – လိုရင် → screenshot  
5. **Inventory / Products** (`/products`) → screenshot  
6. **Reports** (Sales, Inventory, Service, Customer စသည်ထဲက ရွေးချယ်) → screenshot  
7. **Smart Business Insight** (Dashboard မှာ ပါပြီးသား – သို့မဟုတ် သီးသန့် သွားပြီး ရိုက်) → screenshot  
8. **Settings** → screenshot  

ဒီလို **အမှတ်တံဆိပ် တစ်ခုချင်း** သွားပြီး ရိုက်တာပဲ လုပ်မယ်ဆိုရင်:

- **လုပ်ဆောင်ချက်** = စာမျက်နှာ ဖွင့်ပြီး စောင့်ပြီး screenshot ရိုက်တာ ပဲ ရှိတယ်  
- **Loop / ဒေတာထုတ်ခြင်း** ကို UI မှာ မလုပ်ဘူး → **စက်မလေးပါ**  
- စုစုပေါင်း **၁၀–၁၅ ပုံ** လောက်ပဲ ရိုက်ရင် ပြီးမယ်၊ ကြာချိန် **၁–၂ မိနစ်** လောက်ပဲ ရှိမယ်  

တစ်လစာ “လုပ်ထားတာလေးတွေ” ဆိုတာက **ဒေတာကို Backend မှာ တစ်လစာဖြစ်အောင် ထုတ်ထားပြီးသား** ဖြစ်တာမို့၊ ဒီစာမျက်နှာတွေမှာ ရောင်းချမှု / စာရင်း / report တွေ **တစ်လစာလောက် ပြသွားမယ်**။ Screenshot တွေက “တစ်လစာလောက် လုပ်ထားတဲ့ ပုံ” ကို ပြမယ်။

ဒါကြောင့် **ဆိုင်တစ်ဆိုင်လယ်ပတ်ပုံ + တစ်လစာလောက် screenshot** ကို ဒီနည်းနဲ့ လုပ်လို့ **ရပါတယ်**။

---

## ၅။ စက်မလေးအောင် လုပ်နည်း (အတိုချုပ်)

| အပိုင်း | လုပ်နည်း | စက်အပေါ် သက်ရောက်မှု |
|---------|------------|---------------------------|
| တစ်လစာ ဒေတာ | Backend မှာ `run_simulation` သို့ `seed_one_year --months 1` တစ်ခါ run | DB ထည့်တာပဲ၊ ၁–၂ မိနစ်၊ browser မလိုပါ |
| Register / Login / Role / ဆိုင်လယ်ပတ် | Playwright က စာမျက်နှာတွေ **သွားပြီး screenshot ပဲ ရိုက်**၊ ဒေတာထုတ်တဲ့ loop မလုပ် | ၁–၂ မိနစ်၊ စက်မလေးပါ |

ပေါင်းရင် **၃–၅ မိနစ်** လောက်ပဲ ကြာမယ်၊ စက်လေးတာ သိပ်မရှိပါ။

---

## ၆။ လုပ်မယ်ဆိုရင် လမ်းကြောင်း (Flow)

1. **Backend (တစ်ခါ)**  
   - DB ကို သန့်စင်ပြီး (သို့) test DB သုံးပြီး  
   - `python manage.py run_simulation --days 30` သို့  
   - `python manage.py seed_one_year --months 1 --sales-per-month 50` run ပါ။  
   - (ပထမဆုံး user မရှိရင် `run_simulation` က register + login + sales + approve ပါ လုပ်ပေးပြီးသား။)

2. **Playwright (တစ်ခါ)**  
   - Option A: **Register ကနေ စ** မယ်ဆိုရင် → Register စာမျက်နှာ ဖွင့် → screenshot → စာရင်းသွင်း → Login (သို့) Dashboard ရောက် → screenshot။  
   - Option B: **ရှိပြီးသား owner** သုံးမယ်ဆိုရင် → Login စာမျက်နှာ → screenshot → login → Dashboard → screenshot။  
   - ပြီးရင် **Role များ** (`/users/roles`) သွား → screenshot။  
   - နောက် **ဆိုင်လယ်ပတ်** စာမျက်နှာတွေ သွား: Dashboard, Sales POS, Sale History, Products, Reports, Settings စသည် → တစ်စာမျက်နှာ တစ်ပုံ။  
   - Screenshot အားလုံးကို `simulations/run_[timestamp]/` အောက်မှာ `step1_register.png`, `step2_after_login.png`, … စသည်နဲ့ သိမ်းမယ်။

3. **တစ်ခါတည်း run ချင်ရင်**  
   - Script တစ်ခု (ဥပမာ `simulate-month.js`) ထဲမှာ:  
     - လိုရင် Backend API ခေါ်ပြီး ဒေတာ ထုတ်မယ် (သို့)  
     - “Backend က run_simulation / seed_one_year ကို သပ်သပ် run ပြီးသား” လို့ ယူဆပြီး  
     - Playwright က Register → Login → Role → ဆိုင်လယ်ပတ် စာမျက်နှာတွေ သွားပြီး screenshot ရိုက်မယ်။  
   - ဒါကို `node simulate-month.js` (သို့) `npm run simulate:month` တစ်ခါ run ရင် **တစ်ခါတည်း** ပြီးအောင် လုပ်လို့ ရပါတယ်။

---

## ဆိုင်တစ်ဆိုင်ရဲ့ တစ်လစာ data မရှိရင် ဘယ်လိုလုပ်မလဲ

တစ်လစာ ဒေတာ **မရှိသေးရင်** ပထမ **ဒေတာထုတ်ပေးရမယ်**၊ ပြီးမှ Screenshot script ပြေးမယ်။

### နည်းလမ်း ၁: Script တစ်ခါ run (အကြံပြု)

Repo root မှာ **`seed_one_month.bat`** run ပါ။ ဒီ script က:

- Backend project (WeldingProject) မှာ `python manage.py run_simulation --days 30` ကို run မယ်
- ပထမဆုံး user မရှိရင် **Register** လုပ်ပြီး **Owner** ဖြစ်အောင် လုပ်မယ်
- ရက်စဉ် ရောင်းချမှု ဖန်တီးပြီး **Approve** လုပ်မယ်
- ရက်စဉ် ဒေတာကို ၃၀ ရက်အတွင်း ဖြန့်ပေးမယ်

**အသုံးပြုနည်း:**

```text
1) Repo root မှာ seed_one_month.bat ကို double-click (သို့) cmd မှာ run ပါ။
2) ပြီးရင် Backend + Frontend စတင်ပါ (run_lite.bat နဲ့ backend၊ yp_posf မှာ npm run dev စသည်)။
3) yp_posf မှာ Screenshot script run ပါ (ဥပမာ node simulate-month.js သို့ npm run simulate:month)။
```

ဒေတာ ရှိပြီးသား ဆိုင်မှာ `seed_one_month.bat` ထ run ရင် ရောင်းချမှု ထပ်ထည့်သွားမယ် (user/location က ရှိပြီးသား သုံးမယ်)။

### နည်းလမ်း ၂: Command ကိုယ်တိုင် run

Backend folder မှာ (venv စတင်ပြီး):

```bash
cd WeldingProject
python manage.py run_simulation --days 30
```

သို့ တစ်လထက် ဒေတာ ပိုလိုရင်:

```bash
python manage.py seed_one_year --months 1 --sales-per-month 50
```

ပြီးရင် Screenshot script ကို ပြေးပါ။

### နည်းလမ်း ၃: တစ်ခါတည်း (Seed + Screenshot) run ချင်ရင်

- **ပထမ:** `seed_one_month.bat` run ပါ (ဒေတာမရှိရင် ဒေတာထုတ်မယ်)။  
- **နောက်:** Backend + Frontend ဖွင့်ပြီး `npm run simulate:full` (သို့) `simulate-month.js` run ပါ။  

နောက်မှ “တစ်ခါတည်း” script (seed + backend start + frontend start + Playwright) ထပ်ထည့်ချင်ရင် ဒီ flow အတိုင်း ပေါင်းထည့်လို့ ရပါတယ်။

---

## ၇။ အတိုချုပ်

- **လုပ်လို့ ရနိုင်မရနိုင်** → **ရပါတယ်**။  
- **တစ်လစာ ဒေတာ** → Backend မှာ တစ်ခါတည်း ထုတ်မယ် (run_simulation / seed_one_year)။  
- **Register → Login → Owner role/permission → ဆိုင်လယ်ပတ်** → Playwright က စာမျက်နှာတွေ သွားပြီး **screenshot ပဲ ရိုက်မယ်**။  
- **စက်မလေးအောင်** → ဒေတာထုတ်ခြင်းက Backend မှာပဲ၊ UI မှာ လုပ်ဆောင်ချက် အနည်းငယ်ပဲ လုပ်မယ်။  

နောက်တစ်ဆင့် အနေနဲ့ `simulate-month.js` (သို့) `run-simulation-month.js` လို script ထည့်ပြီး ဒီ flow အတိုင်း တစ်ခါ run ရင် screenshot အားလုံး ထွက်အောင် လုပ်ပေးလို့ ရပါတယ်။
