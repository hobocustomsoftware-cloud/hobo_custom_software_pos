# ဆေးဆိုင် Demo – Register ကနေ တစ်လစာ Report အထိ

## လုပ်ထားချက်

1. **create_sales_for_date** – ရက်စွဲအလိုက် report မှန်အောင် `approved_at` ကို ထိုရက်နဲ့ သတ်မှတ်ပြီး ပြင်ထားပါတယ်။
2. **seed_pharmacy_month** – ဆေးဆိုင် တစ်လစာ demo data:
   - Location/Outlet မရှိရင် Main Branch + Shopfloor ဖန်တီးမယ်။
   - Pharmacy category + ဆေးပစ္စည်း ၃ မျိုး (Paracetamol, Vitamin C, Omeprazole) ထည့်မယ်။
   - နောက်ဆုံး ၃၀ ရက်အတွက် ရက်လိုက် အရောင်း ၂–၄ ခု ထည့်မယ်။
3. **E2E pharmacy_demo.spec.js** – နှစ်ပိုင်း:
   - **Full flow:** Register (ဆေးဆိုင်) → Setup (pharmacy, MMK) → Dashboard → POS → creds သိမ်း။
   - **Reports after seed:** creds နဲ့ login → Sales Summary report စစ်ဆေး + screenshot။
4. **scripts/run_pharmacy_demo.bat** – အစဉ်လိုက်:
   - Docker stack စတင်၊ backend ကျန်းမာမှု စောင့်။
   - Browser (headed): Register + Setup + POS run။
   - `seed_pharmacy_month` (တစ်လစာ sales) run။
   - Browser: Login + Reports run။

## စမ်းနည်း

Repo root ကနေ:

```bat
scripts\run_pharmacy_demo.bat
```

- ပထမအကြိမ် Docker build ကြာနိုင်ပါတယ် (၅–၁၀ မိနစ်)။
- Browser ပေါ်ပြီး Register → Setup → POS သွားမယ်၊ ပြီးရင် တစ်လစာ sales ထည့်ပြီး Reports စမ်းမယ်။
- Screenshot နဲ့ report များ: `demo_results/pharmacy_demo/` မှာ ရမယ်။

## Error / Layout ပြဿနာရင်

- `pharmacy_demo_report.json` ထဲမှာ `stepErrors`, `consoleErrors`, `failedRequests`, `layoutChecks` ကြည့်ပါ။
- ပြင်လိုရင် ပြင်ပြီး `scripts\run_pharmacy_demo.bat` ပြန် run ပါ (Docker ရပ်မထားရင် ချက်ချင်း Playwright ပဲ ပြန်စမ်းလို့ ရပါတယ်)။
