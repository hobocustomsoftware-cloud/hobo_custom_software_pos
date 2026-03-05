# Solar POS System - Simulation & Demo Guide

## 📋 စာရင်းဇယား

ဤ guide သည် Solar POS System ၏ complete simulation system ကို အသုံးပြုနည်းကို ရှင်းလင်းပြထားပါသည်။

## 🎯 ရည်ရွယ်ချက်

ဤ simulation system သည်:
1. **simulate_month.py** - တစ်လစာ shop operations ကို simulate လုပ်သည်
2. **screenshot_story.py** - Vue.js pages အားလုံးကို screenshot ရိုက်သည်
3. **build_slideshow.py** - Professional HTML slideshow ဖန်တီးသည်

## 📦 Installation

### Requirements
```bash
# Python packages
pip install playwright

# Install Playwright browsers
playwright install chromium
```

## 🚀 Usage

### Step 1: Run Simulation
```bash
cd WeldingProject
python manage.py simulate_month
```

**Options:**
- `--delay 1.0` - Delay between days (default: 1 second)
- `--skip-delay` - Skip delays for faster execution

**What it does:**
- Day 1-2: Shop registration, license activation, staff setup (11 roles)
- Day 3-4: Inventory setup, products, bundles, stock inbound
- Day 5-7: First sales week (3 sales with serial tracking, bundles, accessories)
- Day 8: USD rate change (+2%) with auto-repricing
- Day 10-14: Installation jobs with status transitions
- Day 15: Expense recording
- Day 16: Warranty claims & repairs
- Day 18: USD rate drop with repricing
- Day 19-20: Stock transfers
- Day 21-25: More sales & repairs
- Day 26-28: Second installation
- Day 29-30: Month end reports, P&L, AI insights

**Output:**
- `simulation_log.json` - Complete log of all actions

### Step 2: Start Servers

**Terminal 1 - Backend:**
```bash
cd WeldingProject
python manage.py runserver
```

**Terminal 2 - Frontend:**
```bash
cd yp_posf
npm run dev
```

---

## 🏥 ဆေးဆိုင် အပြည့်အစုံ E2E Simulation (Pharmacy Full Flow)

Backend + Frontend ဖွင့်ပြီးနောက် ဆေးဆိုင်လုပ်ငန်းစဉ် တစ်ခုလုံးကို browser ဖြင့် စမ်းသပ်နိုင်သည်။

**အဆင့်များ:** Register → Login → Setup Wizard (Pharmacy) → Role ထည့်ခြင်း → License စာမျက်နှာ → Settings (ငွေပေးချေမှု ထည့်ရန်၊ ကုန်ကျစရိတ် အမျိုးအစား၊ ဒေါ်လာဈေးနှုန်း ချိန်ညှိရန်) → ဆိုင်ခွဲ/နေရာများ ထည့်ခြင်း → User Management (Manager နှင့် Staff ထည့်ခြင်း) → Items/Products ထည့်ခြင်း → ကုန်ကျစရိတ် ထည့်ခြင်း → Daily report (Sales Summary) နှင့် P&L စာမျက်နှာ → Excel/CSV Import (UI ရှိလျှင်) → POS မှ Barcode scan စမ်းခြင်း။

**ပြေးနည်း:**

```bash
# Script ဖြင့် (Backend + Frontend ဖွင့်ထားပါ)
./scripts/run_pharmacy_full_simulation.sh
```

သို့မဟုတ်

```bash
cd yp_posf
PLAYWRIGHT_BASE_URL=http://127.0.0.1:5173 npx playwright test e2e/pharmacy_full_flow.spec.js --project=chromium
```

**Screenshots:** `demo_results/simulation_screenshots/pharmacy_full_<timestamp>/` အောက်တွင် 01_register_filled.png, 02_setup_wizard.png, 03_roles.png, … 14_pos_scan_simulation.png အထိ သိမ်းမည်။

### Step 3: Capture Screenshots
```bash
python screenshot_story.py
```

**What it captures:**
- **Owner View**: Dashboard, P&L Report, User Management, Settings, License
- **Manager View**: Dashboard, Sales History, Inventory, Installation Dashboard, Reports
- **Sale Staff View**: POS page, Product search, Bundle selection, Cart, Invoice
- **Inventory Manager View**: Products list, Stock movement, Categories, Transfer, Low stock
- **Technician View**: Installation Management, Installation Detail, Service Management, Repair Calendar
- **Public Pages**: Repair Track, Warranty Check, License Activation
- **Special States**: USD rate changes, Approval flows, Serial assignments, Warranty creation, Barcode generator, AI insights, Notification bell, Mobile view

**Output:**
- `screenshots/` directory with organized folders

### Step 4: Build Slideshow
```bash
python build_slideshow.py
```

**Output:**
- `solar_pos_demo_YYYY-MM-DD.html` - Professional HTML slideshow

**Features:**
- Sidebar chapter navigation
- Prev/Next arrows + keyboard navigation (Arrow keys, Home, End)
- Myanmar captions under each screenshot
- Role badge (who is viewing)
- Day indicator (Day 1, Day 5, etc.)
- Mobile responsive design
- Progress bar
- Professional dark sidebar, white content

## 📁 File Structure

```
.
├── WeldingProject/
│   └── core/
│       └── management/
│           └── commands/
│               └── simulate_month.py    # Django management command
├── screenshot_story.py                  # Playwright screenshot script
├── build_slideshow.py                  # HTML slideshow generator
├── simulation_log.json                 # Generated simulation log
├── screenshots/                        # Generated screenshots
│   ├── owner/
│   ├── manager/
│   ├── sale_staff/
│   ├── inventory_manager/
│   ├── technician/
│   ├── public/
│   └── special/
└── solar_pos_demo_YYYY-MM-DD.html     # Generated slideshow
```

## 🎨 Slideshow Chapters

1. **ဆိုင်မှတ်ပုံတင်နှင့် Setup** (Day 1-2)
2. **ဝန်ထမ်းများ Role များ** (Day 2)
3. **ကုန်ပစ္စည်းများ ထည့်သွင်းခြင်း** (Day 3-4)
4. **ရောင်းချမှုများ** (Day 5-7)
5. **Dollar နှုန်းပြောင်းလဲမှု** (Day 8, 18)
6. **တပ်ဆင်ရေးလုပ်ငန်း** (Day 10-14)
7. **အာမခံနှင့် ပြင်ဆင်ရေး** (Day 16)
8. **စာရင်းချုပ် P&L Report** (Day 30)
9. **AI Insights & Special Features** (Day 30)
10. **Public Pages** (Public)

## 🔑 Test Accounts

All accounts use password: `demo123`

- `owner_solar` - Owner
- `manager` - Manager
- `sale_staff_1`, `sale_staff_2` - Sale Staff
- `technician_1`, `technician_2` - Technician
- `inventory_manager` - Inventory Manager
- `admin` - Admin
- `assistant_manager` - Assistant Manager
- `inventory_staff` - Inventory Staff
- `sale_supervisor` - Sale Supervisor
- `employee` - Employee

## 📊 Simulation Data

### Products Created:
- Monocrystalline Panel 400W ($120, serial tracked, 60 months warranty)
- Lithium Battery 100Ah ($180, serial tracked, 60 months warranty)
- Hybrid Inverter 3KW ($250, serial tracked, 24 months warranty)
- MPPT Controller 40A ($45, no serial, 12 months warranty)
- DC Cable 10m ($15, no serial, no warranty)
- Mounting Structure ($80, no serial, no warranty)
- WiFi Monitoring Module ($35, no serial, 12 months warranty)

### Bundle:
- "3KW Home Solar System" (8% discount)
  - Panel x6 + Battery x4 + Inverter x1 + Controller x1 + Cable x2 + Mounting x1

### Sales Created:
- Sale 1: Panel x2 + Battery x1 (KPay, serial tracked, warranty created)
- Sale 2: Bundle "3KW Home Solar System" (Bank Transfer, installation job created)
- Sale 3: Accessories - Cable x3 (Cash, no serial)
- Sale 4: Panel x4 (KPay, serial tracked)
- Sale 5: Inverter x1 + Controller x1 (WaveMoney, serial tracked)
- Sale 6: Monitoring Module (Cash, walk-in)
- Sales 7-10: Various products (random)
- Sale 11: Another bundle (Bank Transfer, installation job 2)

### Installations:
- Installation Job 1: From Sale 2 (pending → surveying → scheduled → in_progress → completed)
- Installation Job 2: From Sale 11 (completed within same month)

### Repairs:
- Repair 1: Warranty claim from Sale 1 (received → fixing → ready)
- Repair 2: Out of warranty walk-in repair

### Expenses:
- Shop rent: 800,000 MMK
- Electricity: 150,000 MMK
- Staff transport: 200,000 MMK
- Marketing: 100,000 MMK

### USD Rate Changes:
- Day 1: Initial rate 3450 MMK
- Day 8: Rate change to 3520 MMK (+2%)
- Day 18: Rate change to 3490 MMK (-0.85%)

## 🐛 Troubleshooting

### Simulation fails:
- Check database migrations: `python manage.py migrate`
- Ensure all models are properly imported
- Check for missing dependencies

### Screenshots fail:
- Ensure both backend and frontend servers are running
- Check FRONTEND_URL and BACKEND_URL environment variables
- Verify Playwright is installed: `playwright --version`
- Check browser installation: `playwright install chromium`

### Slideshow images not showing:
- Ensure screenshots are captured first
- Check file paths in screenshots/ directory
- Verify image filenames match CHAPTERS definition

## 📝 Notes

- Simulation uses direct Django ORM (not API calls) for speed
- All dates are relative to current time (30 days ago to now)
- Serial numbers follow pattern: SN-PNL-2024-001, SN-BAT-2024-001, etc.
- Invoice numbers auto-generated: INV-YYMMDD-XXXX
- Installation numbers: INST-YYMMDD-XXXX
- Repair numbers: REP-YYMMDD-XXX

## 🎉 Success!

After running all three scripts, you will have:
1. ✅ Complete simulation data in database
2. ✅ Screenshots of all pages and features
3. ✅ Professional HTML slideshow for presentation

Open `solar_pos_demo_YYYY-MM-DD.html` in your browser to view the complete feature demonstration!
