# မင်း လုပ်ရမယ့် အပိုင်း (Machinery Screenshots)

ဒီ environment မှာ browser က localhost မရောက်လို့ screenshot မထွက်ဘူး။ **မင်းစက်မှာ** ဒီအတိုင်း လုပ်ရင် ပုံတွေ ထွက်မယ်။

---

## လုပ်ရမယ့် အဆင့်များ

### ၁။ Playwright သင့်သေးရင် (တစ်ကြိမ်ပဲ)

```bash
cd F:\hobo_license_pos\yp_posf
npm install playwright
npx playwright install chromium
```

ဒါကို **တစ်ကြိမ်ပဲ** လုပ်ရမယ်။ ပြီးသား ဆိုရင် ဒီအဆင့် ကျော်လို့ ရပါတယ်။

---

### ၂။ Screenshot ရိုက်ရန် (တစ်ခါ run)

**နည်း ၁ – IDE Task (အလွယ်ဆုံး):**

1. **Cursor / VS Code** ဖွင့်ပြီး project (`F:\hobo_license_pos`) ကို ဖွင့်ပါ
2. **`Ctrl+Shift+P`** နှိပ်ပါ
3. **`Tasks: Run Task`** ရိုက်ပြီး Enter
4. **`Machinery Screenshots (တစ်ခါတည်း)`** ကို ရွေးပြီး Enter

ဒီတစ်ခါ ရွေးရုံနဲ့ Backend + Frontend စတင်ပြီး ၇ ရက် screenshot ရိုက်မယ်။ Terminal ကိုယ်တိုင် မဖွင့်ရပါ။

---

**နည်း ၂ – Batch ဖိုင်နဲ့:**

```bash
cd F:\hobo_license_pos
run_machinery_screenshots.bat
```

သို့မဟုတ် **Windows Explorer** မှာ `F:\hobo_license_pos` သွားပြီး **`run_machinery_screenshots.bat`** ကို **double-click** လုပ်ပါ။

---

**နည်း ၃ – Node တိုက်ရိုက်:**

```bash
cd F:\hobo_license_pos
node run_all_machinery.mjs
```

---

### ၃။ ပုံတွေ ဘယ်မှာ ထွက်မလဲ

- **Folder:** `F:\hobo_license_pos\yp_posf\simulations\machinery_shop\`
- **ဖိုင်များ:** 
  - `1.png`, `2.png`, `3.png`, `4.png`, `5.png`, `6.png`, `7.png` (Dashboard after each day)
  - `3_insight.png`, `7_insight.png` (AI Insight on day 3 and 7)

---

## ဘာလုပ်သွားလဲ

Script က:

1. **Backend (Django)** ကို `:8000` မှာ စတင်မယ်
2. **Frontend (Vite)** ကို `:5173` မှာ စတင်မယ်
3. နှစ်ခုလုံး စောင့်မယ်
4. **၇ ရက်** simulation ပြေးမယ်:
   - နေ့စဉ်: POS မှာ order ၂–၄ ခု လုပ်မယ်
   - USD rate: ၃၉၀၀–၄၂၀၀ ကျပန်း
   - Dashboard သွားပြီး screenshot ရိုက်မယ်
   - ရက် ၃ နဲ့ ၇ မှာ AI Insight ရိုက်မယ်
5. Screenshot တွေက `yp_posf\simulations\machinery_shop\` မှာ သိမ်းမယ်

---

## ပြဿနာ ရှိရင်

- **Backend မစတင်ဘူး** → Python / Django / uvicorn မရှိလို့ ဖြစ်နိုင်တယ်။ `run_lite.bat` ကို သပ်သပ် run ပြီး စစ်ပါ။
- **Frontend မစတင်ဘူး** → `cd yp_posf` ပြီး `npm run dev` ကို သပ်သပ် run ပြီး စစ်ပါ။
- **Screenshot မထွက်ဘူး** → `yp_posf\simulations\machinery_shop\` folder ကို စစ်ပါ။ Script က folder ကို ကိုယ်တိုင် ဖန်တီးမယ်။
- **Playwright error** → `npm install playwright` နဲ့ `npx playwright install chromium` ပြန်ပြေးပါ။

---

## အတိုချုပ်

**မင်း လုပ်ရမယ့် အပိုင်း:**

1. ✅ Playwright install (တစ်ကြိမ်ပဲ) – ပြီးသား ဆိုရင် ကျော်လို့ ရပါတယ်
2. ✅ IDE Task run (သို့) batch double-click (သို့) `node run_all_machinery.mjs` – Screenshot ရိုက်ချင်တိုင်း run ပါ
3. ✅ Screenshot folder စစ်ပါ – `yp_posf\simulations\machinery_shop\` မှာ ပုံတွေ ရှိမရှိ

ဒီအတိုင်း လုပ်ရင် ပုံတွေ ထွက်ပါမယ်။
