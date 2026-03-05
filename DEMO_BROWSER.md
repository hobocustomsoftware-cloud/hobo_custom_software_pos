# Browser Demo – အစအဆုံး စမ်းသပ်ချက်

**Demo စမ်းတာက Docker နဲ့ စမ်းရမယ်။** အသေးစိတ် လမ်းညွှန် (Register → ဆိုင်လည်ပတ်ပုံ အဆင့်ဆင့်) အတွက် **DEMO_DOCKER.md** ဖတ်ပါ။  
အောက်က စာသားက **Docker မသုံးဘဲ** local runserver + Playwright report စမ်းချက်အတွက် ဖြစ်ပါတယ်။

## ချက်ချင်း run မယ် (local runserver + Playwright)

1. **Backend စတင်ပါ** (terminal ၁)
   ```bat
   cd WeldingProject
   python manage.py runserver 127.0.0.1:8000
   ```

2. **Browser demo run ပါ** (terminal ၂ – repo root ကနေ)
   ```bat
   scripts\run_browser_demo.bat
   ```

Chrome ပေါ်ပြီး Login → Setup Wizard (ရှိရင်) → Dashboard → POS → Settings → Reports သွားမယ်။ ပြီးရင် **demo_results\browser_demo\** မှာ report နဲ့ screenshots ထွက်မယ်။

## Report ကြည့်မယ်

- **demo_results\browser_demo\report.txt** – ခြေလှမ်း၊ ကြာချိန်၊ console errors၊ failed requests၊ layout checks
- **demo_results\browser_demo\report.json** – အသေးစိတ် data
- **demo_results\browser_demo\01_login_page.png** … **08_reports_sales_summary.png** – ခြေလှမ်းတိုင်း screenshot

အသေးစိတ်: **demo_results\browser_demo\README.md** ဖတ်ပါ။
