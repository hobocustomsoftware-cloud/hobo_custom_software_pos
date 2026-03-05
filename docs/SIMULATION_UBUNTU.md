# Ubuntu 25.10 – venv နဲ့ Full Simulation စမ်းနည်း

Register ကနေ ဆိုင်စတင်၊ feature list အဆင့်ဆင့်၊ daily report အထိ စမ်းပြီး screenshot များ folder ထဲ သိမ်းမယ်။

---

## ၁။ လိုအပ်ချက်

- **Ubuntu 25.10** (သို့) Python 3.12+ ရှိသော Linux
- **Node.js 20+** နဲ့ **npm** (frontend + Playwright အတွက်)
- **Git** (repo ရယူပြီးသား ဖြစ်ရမယ်)

---

## ၂။ Venv လုပ်ပြီး လိုတာတွေ ဖြည့်ခြင်း (တစ်ခါပဲ)

Repo root မှာ:

```bash
chmod +x scripts/setup_venv_ubuntu2510.sh
./scripts/setup_venv_ubuntu2510.sh
```

ဒီ script က:

- `venv` folder ထုတ်မယ် (Python 3.12 / 3.13 သုံးမယ်)
- `WeldingProject/requirements.txt` ထဲက package တွေ အကုန် install လုပ်မယ်
- လိုရင် `scripts/requirements-e2e.txt` လည်း install လုပ်မယ်

ပြီးရင် Backend ကို sqlite နဲ့ ပဲ run လို့ ရပါတယ် (DATABASE_URL မထည့်ရင် default က sqlite)။

---

## ၃။ Full Simulation တစ်ခါတည်း စမ်းခြင်း

Repo root မှာ:

```bash
chmod +x scripts/run_full_simulation_ubuntu.sh
./scripts/run_full_simulation_ubuntu.sh
```

ဒီ script က:

1. **Backend** (Django) ကို port **8000** မှာ စတင်မယ်
2. **Frontend** (Vite) ကို port **5173** မှာ စတင်မယ်
3. နှစ်ခုလုံး ပြန်စပြီးမှ **Playwright** နဲ့ full simulation ပြေးမယ်:
   - **Login** စာမျက်နှာ screenshot
   - **Register** (ဖုန်းနံပါတ်၊ ဆိုင်အမည်၊ စကားဝှက်) ဖြည့်ပြီး စာရင်းသွင်းမယ်
   - **Setup Wizard** ပြီးမယ် (လုပ်ငန်းအမျိုးအစား၊ ငွေကြေး)
   - **Dashboard, POS, Sales History, Approve, Reports (daily/sales/summary, sale-by-item, …), Inventory, Items, Service, Users, Accounting, Settings** စတဲ့ feature စာမျက်နှာတိုင်း သွားပြီး screenshot ယူမယ်
   - **Daily report** (Sales Summary) ကို ထပ်ယူမယ်
4. ပြီးရင် Backend / Frontend process တွေ ရပ်မယ်
5. Screenshot folder လမ်းကြောင်း ပြမယ်

---

## ၄။ Screenshot များ သိမ်းရာ folder

Screenshot တွေက အောက်က folder အောက်မှာ **အချိန်နဲ့ subfolder** ဖြစ်အောင် သိမ်းပါတယ်:

```
demo_results/simulation_screenshots/YYYY-MM-DD_HH-MM-SS/
```

ဥပမာ:

```
demo_results/simulation_screenshots/2025-03-03_14-30-00/
  00_login.png
  00_register_filled.png
  00_setup_wizard.png
  01_dashboard.png
  02_pos.png
  03_sales_history.png
  ...
  25_settings.png
  26_daily_report_sales_summary.png
```

---

## ၅။ ကိုယ်တို့ လက်စစမ်းချင်ရင်

**Backend ပဲ စမ်းမယ်:**

```bash
source venv/bin/activate
cd WeldingProject
python manage.py migrate --noinput
python manage.py runserver 0.0.0.0:8000
```

ဘရောက်ဆာမှာ **http://127.0.0.1:8000/app/** ဖွင့်ပါ (frontend build ကို Django က serve မလုပ်ရင် မမြင်ရနိုင်ပါ။ ဒါကြောင့် full simulation မှာ Vite dev server သုံးထားပါတယ်)။

**Frontend ပဲ စမ်းမယ်:**

```bash
cd yp_posf
npm install --legacy-peer-deps
npm run dev
```

ပြီးရင် **http://127.0.0.1:5173** ဖွင့်ပါ။ Backend က 8000 မှာ run ထားရပါမယ်။

**E2E ပဲ ပြေးမယ် (Backend စတင်ထားပြီးသား):**

Backend က Vue build ကို `/app/` မှာ serve လုပ်ထားရင် (static_frontend ရှိရင်):

```bash
./scripts/run_simulation_screenshots.sh
```

သို့မဟုတ် Frontend ကို Vite dev (5173) နဲ့ စတင်ထားရင်:

```bash
cd yp_posf
PLAYWRIGHT_BASE_URL=http://127.0.0.1:5173 npx playwright test e2e/full_simulation_spec.js --project=chromium
```

Screenshot တွေက `demo_results/simulation_screenshots/<timestamp>/` ထဲမှာ သွားကြည့်ပါ။

---

## ၆။ အတိုချုပ်

| အဆင့် | Command |
|--------|--------|
| ၁. Venv + လိုတာဖြည့် | `./scripts/setup_venv_ubuntu2510.sh` |
| ၂. Full simulation စမ်း | `./scripts/run_full_simulation_ubuntu.sh` |
| ၃. Screenshot ကြည့် | `demo_results/simulation_screenshots/<timestamp>/` |

Ubuntu 25.10 နဲ့ ကိုက်ညီအောင် venv လုပ်ထားပြီး၊ Register ကနေ ဆိုင်စတင်၊ feature list နဲ့ daily report အထိ စမ်းပြီး screenshot အားလုံး folder နဲ့ သိမ်းထားပါတယ်။
