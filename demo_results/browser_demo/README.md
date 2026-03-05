# Browser Demo – အစအဆုံး စမ်းသပ်ချက်

Browser ဖွင့်ပြီး app ကို အစအဆုံး စမ်းပြီး **ဘာတွေဖြစ်နေလဲ၊ ဘယ်နေရာက error တက်နေလဲ၊ ဘယ်အပိုင်းက loading ကြာနေလဲ၊ layout အဆင်ပြေမပြေ** ကို report ထုတ်ပေးမယ်။

## လုပ်ဆောင်ချက်

1. **Browser ပေါ်ပြ** – Playwright က Chrome ဖွင့်ပြီး လုပ်ဆောင်ချက်တိုင်းကို မြင်ရမယ် (headed)
2. **ခြေလှမ်းစီ** – Login → Setup Wizard (ရှိရင်) → Dashboard → POS → Settings → Reports
3. **စုစည်းမယ်** – Console errors, ပျက်သွားတဲ့ network request (401/403/404), ခြေလှမ်းတိုင်းရဲ့ ကြာချိန်
4. **Screenshot** – ခြေလှမ်းတိုင်းမှာ ဓာတ်ပုံ သိမ်းမယ် (`01_login_page.png` … `08_reports_sales_summary.png`)
5. **Report ထုတ်မယ်** – `report.json` နဲ့ `report.txt` မှာ error တွေ၊ slow step တွေ၊ layout check တွေ ပါမယ်

## ဘယ်လို run မလဲ

### ၁။ Backend + Frontend စတင်ပါ

**ရွေးချယ်မှု (က)** – Django က frontend + API နှစ်မျိုးလုံး serve လုပ်မယ် (port 8000):

```bat
cd WeldingProject
python manage.py runserver 127.0.0.1:8000
```

**ရွေးချယ်မှု (ခ)** – Frontend က Vite (port 5173), Backend က port 8000:

```bat
cd yp_posf
npm run dev
```

အခြား terminal မှာ:

```bat
cd WeldingProject
python manage.py runserver 127.0.0.1:8000
```

### ၂။ Browser demo ကို run ပါ

**Django က /app/ serve လုပ်ထားရင် (port 8000):**

```bat
scripts\run_browser_demo.bat
```

**Vite dev (port 5173) သုံးထားရင်:**

```bat
cd yp_posf
set PLAYWRIGHT_BASE_URL=http://127.0.0.1:5173
set PLAYWRIGHT_HEADED=1
npx playwright test e2e/browser_demo_report.spec.js --project=chromium --headed
```

(သို့) npm script:

```bat
cd yp_posf
set PLAYWRIGHT_HEADED=1
npm run test:e2e:browser-demo:headed
```

### ၃။ Login user / password ပြင်ချင်ရင်

```bat
set PLAYWRIGHT_LOGIN_USER=09xxxxxxxx
set PLAYWRIGHT_LOGIN_PASS=yourpassword
scripts\run_browser_demo.bat
```

## Report ကြည့်နည်း

- **report.txt** – ခြေလှမ်းစာရင်း၊ ကြာချိန် (ms), slow step တွေ၊ console errors၊ failed requests၊ layout checks၊ screenshot လမ်းကြောင်းတွေ
- **report.json** – အချက်အလက် အတိအကျ (errors, failedRequests, stepTimings, layoutChecks, screenshots)
- **01_login_page.png … 08_reports_sales_summary.png** – ခြေလှမ်းတိုင်းရဲ့ ဓာတ်ပုံ

ဒီထဲကနေ ဘယ်နေရာက error တက်နေလဲ၊ ဘယ်အပိုင်းက loading ကြာနေလဲ၊ layout အဆင်ပြေမပြေ ဆိုတာ ကြည့်ပြီး ပြင်လို့ရပါတယ်။
