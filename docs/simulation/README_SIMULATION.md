# Complete POS System Simulation

This directory contains a comprehensive simulation system that tests and demonstrates EVERY feature of the Solar POS system.

## 📋 Overview

The simulation system consists of three main components:

1. **simulate_month.py** - Django management command that simulates one complete month
2. **screenshot_story.py** - Playwright script to capture all Vue.js pages
3. **build_slideshow.py** - HTML slideshow generator from screenshots

## 🚀 Quick Start

### Prerequisites

1. **Backend running**: `python WeldingProject/manage.py runserver` (http://localhost:8000)
2. **Frontend running**: `cd yp_posf && npm run dev` (http://localhost:5173)
3. **Playwright installed**: `pip install playwright && playwright install chromium`

### Easy Way (Automated Scripts)

**Option 1: Step-by-step (Recommended)**
```bash
# Step 1: Run simulation only
run_full_simulation.bat

# Step 2: After starting backend + frontend manually, run:
run_screenshots.bat
```

**Option 2: Fully Automated (All-in-one)**
```bash
# Runs everything automatically (starts servers, captures, builds)
run_all_automated.bat
```

### Manual Way

```bash
# Step 1: Run simulation (creates all data)
python WeldingProject/manage.py simulate_month

# Step 2: Capture screenshots (requires frontend/backend running)
python screenshot_story.py

# Step 3: Build slideshow
python build_slideshow.py
```

## 📝 Detailed Instructions

### 1. simulate_month.py

**Location**: `WeldingProject/core/management/commands/simulate_month.py`

**What it does**:
- Simulates Day 1-30 of a Solar shop's operations
- Creates owner, all 11 staff roles
- Sets up inventory (products, bundles, categories)
- Creates sales with serial tracking
- Handles USD rate changes and auto-repricing
- Creates installation jobs and warranty claims
- Records expenses and generates P&L reports
- Saves full log to `simulation_log.json`

**Usage**:
```bash
cd WeldingProject
python manage.py simulate_month

# Options:
python manage.py simulate_month --delay 0.5  # Faster (0.5s between days)
python manage.py simulate_month --skip-delay  # No delays
```

**Output**:
- Database populated with realistic one-month data
- `simulation_log.json` with all actions

### 2. screenshot_story.py

**Location**: `screenshot_story.py` (root directory)

**What it does**:
- Logs in as each role (owner, manager, sale_staff, technician, etc.)
- Captures screenshots of every Vue.js page
- Captures special states (approval flow, USD rate changes, etc.)
- Saves to `screenshots/[role]/` folders

**Usage**:
```bash
# Make sure frontend and backend are running first!
python screenshot_story.py
```

**Output Structure**:
```
screenshots/
├── owner/
│   ├── 01_dashboard.png
│   ├── 02_pl_report.png
│   └── ...
├── manager/
│   ├── 01_dashboard.png
│   └── ...
├── sale_staff/
│   ├── 01_pos_sales_request.png
│   └── ...
├── inventory_manager/
├── technician/
├── public/
└── special/
```

**Configuration**:
Edit the script to change:
- `FRONTEND_URL` (default: http://localhost:5173, or http://localhost for screenshot_story.py)
- `BACKEND_URL` (default: http://localhost:8000)
- `SCREENSHOT_DIR` (default: screenshots/)
- `headless=False` to `headless=True` for headless mode

### 3. build_slideshow.py

**Location**: `build_slideshow.py` (root directory)

**What it does**:
- Reads all screenshots from `screenshots/` directory
- Generates professional HTML slideshow
- Includes chapter navigation, progress bar, keyboard controls
- Myanmar language captions

**Usage**:
```bash
python build_slideshow.py
```

**Output**:
- `solar_pos_demo_[YYYY-MM-DD].html`
- Open in any browser to view

**Features**:
- Sidebar chapter navigation
- Prev/Next buttons + keyboard arrows
- Progress bar
- Role badges and day indicators
- Mobile responsive design

## 📊 Simulation Timeline

The simulation covers:

- **Day 1-2**: Shop registration, license activation, staff setup (11 roles)
- **Day 3-4**: Inventory setup (7 products, 1 bundle), stock inbound with serial numbers
- **Day 5-7**: First sales week (3 sales with different payment methods)
- **Day 8**: USD rate change (+2%), auto-repricing
- **Day 10-14**: Installation week (job creation, completion, warranty sync)
- **Day 15**: Expense recording (rent, utilities, staff, marketing)
- **Day 16**: Warranty claim and repair service
- **Day 18**: USD rate drop, repricing again
- **Day 19-20**: Stock transfer (warehouse → shop floor)
- **Day 21-25**: More sales and repairs
- **Day 26-28**: Second installation job
- **Day 29-30**: Month-end reports (P&L, sales, inventory, service)

## 🎯 Features Demonstrated

### Models Created
- ✅ User (11 roles: owner, admin, manager, assistant_manager, inventory_manager, inventory_staff, sale_supervisor, sale_staff x2, technician x2, employee)
- ✅ Product (7 solar products with USD pricing)
- ✅ Bundle ("3KW Home Solar System")
- ✅ SaleTransaction (11+ sales)
- ✅ InstallationJob (2 jobs)
- ✅ RepairService (2 repairs)
- ✅ Expense (4 expenses)
- ✅ Transaction (auto-created from sales and expenses)
- ✅ WarrantyRecord (auto-created for serial-tracked products)
- ✅ ExchangeRateLog (USD rate changes)

### Pages Screenshot
- ✅ Owner: Dashboard, P&L, User Management, Settings, License
- ✅ Manager: Dashboard, Sales History, Inventory, Installation Dashboard, Reports
- ✅ Sale Staff: POS, Product Search, Bundle Selection, Cart, Invoice
- ✅ Inventory Manager: Products, Stock Movement, Categories, Transfer, Low Stock
- ✅ Technician: Installation Management, Detail, Signature, Service, Calendar
- ✅ Public: Repair Track, Warranty Check, License Activation
- ✅ Special: USD Rate Changes, Approval Flow, Serial Assignment, Warranty, Barcode, AI Insights, Notifications, Mobile View

## 🔧 Troubleshooting

### simulate_month.py errors

**Issue**: `ModuleNotFoundError: No module named 'django'`
- **Solution**: Activate virtual environment first
```bash
venv\Scripts\activate  # Windows
source venv/bin/activate  # Linux/Mac
```

**Issue**: `IntegrityError` or duplicate key errors
- **Solution**: Clear database and run migrations
```bash
python WeldingProject/manage.py flush
python WeldingProject/manage.py migrate
```

### screenshot_story.py errors

**Issue**: `Playwright not installed`
- **Solution**: 
```bash
pip install playwright
playwright install chromium
```

**Issue**: `Connection refused` or `Cannot connect to frontend`
- **Solution**: Make sure both backend and frontend are running
```bash
# Terminal 1: Backend
python WeldingProject/manage.py runserver

# Terminal 2: Frontend
cd yp_posf
npm run dev
```

**Issue**: Screenshots are blank or wrong pages
- **Solution**: Check Vue.js routes match the script's URLs. Adjust `FRONTEND_URL` paths if needed.

### build_slideshow.py errors

**Issue**: `screenshots/ directory not found`
- **Solution**: Run `screenshot_story.py` first

**Issue**: Images not showing in HTML
- **Solution**: Make sure screenshots are in correct folders matching the script's expectations

## 📁 File Structure

```
hobo_license_pos/
├── WeldingProject/
│   └── core/
│       └── management/
│           └── commands/
│               └── simulate_month.py  # Django command
├── screenshot_story.py                 # Playwright script
├── build_slideshow.py                  # HTML generator
├── simulation_log.json                 # Generated log
├── screenshots/                        # Generated screenshots
│   ├── owner/
│   ├── manager/
│   ├── sale_staff/
│   ├── inventory_manager/
│   ├── technician/
│   ├── public/
│   └── special/
└── solar_pos_demo_[DATE].html          # Generated slideshow
```

## 🎨 Customization

### Add More Screenshots

Edit `screenshot_story.py` to add new capture functions:

```python
async def capture_custom_view(page):
    await login(page, 'username', 'password')
    await page.goto(f'{FRONTEND_URL}/custom/page')
    await take_screenshot(page, 'screenshots/custom/page.png')
```

### Modify Chapters

Edit `CHAPTERS` in `build_slideshow.py`:

```python
CHAPTERS = [
    {
        'title': 'Your Chapter Title',
        'subtitle': 'Subtitle',
        'folder': 'folder_name',
        'images': [
            ('image.png', 'Caption', 'Day X'),
        ]
    },
]
```

### Change Styling

Edit the `<style>` section in `build_slideshow.py` to customize colors, fonts, layout.

## 📞 Support

If you encounter issues:
1. Check that all prerequisites are installed
2. Verify backend and frontend are running
3. Check `simulation_log.json` for simulation errors
4. Review browser console for screenshot errors

---

**Created**: 2024
**Last Updated**: 2024
