# Screenshot ကိုယ်ဘာသာ မလုပ်ဘဲ လုပ်နည်း

ကိုယ်ဘာသာ terminal မဖွင့်ပဲ (သို့) ကိုယ်မနှိပ်ပဲ အလိုအလျောက် လုပ်လို့ရနိုင်တဲ့ နည်းလမ်းများ။

---

## ၁။ IDE မှာ Task တစ်ချက်နဲ့ ပြေးခြင်း (အကြံပြု)

**Cursor / VS Code** ဖွင့်ထားပြီး project ကို ဖွင့်ထားရင်:

1. **Terminal** menu → **Run Task...** (သို့) `Ctrl+Shift+P` → ရိုက်ပါ **Tasks: Run Task**
2. စာရင်းကနေ **`Machinery Screenshots (တစ်ခါတည်း)`** ကို ရွေးပါ
3. Enter နှိပ်ပါ

ဒီတစ်ခါ နှိပ်ရုံနဲ့ Backend + Frontend စတင်ပြီး ၇ ရက် screenshot ရိုက်မယ်။ Terminal ကိုယ်တိုင် မဖွင့်ရပါ။

---

## ၂။ Windows Task Scheduler နဲ့ အချိန်သတ်မှတ် ပြေးခြင်း

ကိုယ်လုံးဝ မနှိပ်ပဲ **အချိန်တစ်ခု ရောက်ရင်** (သို့) **ကွန်ပျူတာ ဖွင့်တိုင်း** ပြေးစေချင်ရင်:

1. **Task Scheduler** ဖွင့်ပါ (Win + R → `taskschd.msc` → Enter)
2. **Create Basic Task** ရွေးပါ
3. Name: `HoBo Machinery Screenshots` (အမည် ရွေးချယ်)
4. Trigger: **Daily** သို့ **At log on** (ကိုယ်လိုသလို ရွေးပါ)
5. Action: **Start a program**
6. Program: `cmd.exe`  
   Add arguments: `/c "cd /d F:\hobo_license_pos && run_machinery_screenshots.bat"`
   (သို့) Program: `F:\hobo_license_pos\run_machinery_screenshots.bat`  
   Start in: `F:\hobo_license_pos`
7. Finish လုပ်ပါ

ဒီအတိုင်း သတ်မှတ်ထားရင် အချိန်ရောက်ရင် (သို့) log on လုပ်တိုင်း script က အလိုအလျောက် ပြေးမယ်။ (Backend/Frontend လိုအပ်တာမို့ PC ဖွင့်ပြီး အင်တာနက်ရှိမှ ကောင်းပါမယ်။)

---

## ၃။ Desktop Shortcut ထားပြီး တစ်ချက်နှိပ်ခြင်း

ကိုယ်ဘာသာ မလုပ်ဘဲ မဟုတ်သေးပေမယ့် **တစ်ချက်နှိပ်ရုံ** နဲ့ လုပ်ချင်ရင်:

1. Desktop မှာ Right-click → **New** → **Shortcut**
2. Location: `F:\hobo_license_pos\run_machinery_screenshots.bat`
3. Name: `Machinery Screenshots` (သို့ ကြိုက်တာ) → Finish
4. နောက်တစ်ကြိမ် shortcut ကို double-click လုပ်ရင် script ပြေးမယ်

---

## အတိုချုပ်

| နည်း | ကိုယ်လုပ်ရမှု |
|------|------------------|
| **Run Task** (IDE) | IDE ဖွင့်ပြီး Run Task → Machinery Screenshots ရွေးရုံ |
| **Task Scheduler** | တစ်ကြိမ် သတ်မှတ်ပြီးရင် အချိန်ရောက် / log on မှာ အလိုအလျောက် ပြေးမယ် |
| **Desktop Shortcut** | Shortcut တစ်ချက်နှိပ်ရုံ |

အဆင်ပြေတဲ့ နည်းကို ရွေးသုံးပါ။
