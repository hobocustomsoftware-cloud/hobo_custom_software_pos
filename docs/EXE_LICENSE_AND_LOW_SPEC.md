# EXE အဆင်ပြေမပြေ၊ License Key ထည့်ခြင်း၊ စက်အားနည်း (2GB RAM / Celeron)

EXE သုံးမည့်သူတွေအတွက် – EXE အဆင်ပြေလား၊ License key ဘယ်လိုထည့်မလဲ၊ RAM 2GB / Celeron စက်တွေမှာ သုံးလို့ရမလဲ စစ်ဆေးချက် နဲ့ အကြံပြုချက်များ။

---

## ၁) EXE အဆင်ပြေလား

**အဆင်ပြေပါတယ်။** လက်ရှိ စနစ်မှာ:

- **Build:** `build_exe.bat` ပြေးပြီး `HoBoPOS_Release\` folder ထွက်မယ်။ ထဲမှာ `HoBoPOS.exe` နဲ့ လိုအပ်တဲ့ DLL/python files တွေ ပါပါတယ်။
- **Run:** `HoBoPOS.exe` ကို double-click လုပ်ရင်:
  - Migrate (ပထမဆုံး run မှာ)
  - Waitress server စပြီး `http://127.0.0.1:8000` မှာ listen မယ်
  - Browser ကို `http://127.0.0.1:8000/app/` ဖွင့်ပေးမယ်
- **Data:** DB နဲ့ media က **EXE ရဲ့ folder** မှာ သိမ်းမယ် (ဥပမာ `db.sqlite3`, `media/`, `data/`, `license.lic`)။ ဒီ folder ကို backup လုပ်ထားရင် ပြန်သုံးလို့ရပါတယ်။

ပြဿနာရှိရင်: EXE ကို **Run as administrator** တစ်ခါ စမ်းပါ။ Antivirus က exe ကို block လုပ်မလား စစ်ပါ။

---

## ၂) License key ထည့်မယ်ဆိုရင် အဆင်ပြေလား

**အဆင်ပြေပါတယ်။** EXE မှာ License ထည့်နည်း နှစ်မျိုးရှိပါတယ်။

### (က) EXE ထဲက Settings ကနေ ထည့်ခြင်း

1. HoBoPOS.exe run ပြီး browser မှာ app ပွင့်ပါမယ်။
2. **Login** ဝင်ပါ (သို့မဟုတ် ပထမဆုံး **Register** လုပ်ပြီး owner အကောင့်ဖန်တီးပါ)။
3. **Settings** (သို့မဟုတ် **License Activation** စာမျက်နှာ) သို့ သွားပါ။
4. **License key** ထည့်ပြီး **Activate** နှိပ်ပါ။
5. အောင်မြင်ရင် license က **EXE ရဲ့ folder** ထဲက `license.lic` မှာ သိမ်းမယ်။ နောက်တစ်ကြိမ် run ရင် ဒီ key ကို ဖတ်ပြီး စစ်မယ်။

### (ခ) License Server နဲ့ ချိတ်ပြီး ထည့်ခြင်း

- သင့်မှာ **License Server** (Hosting backend) ရှိရင်၊ EXE run ထားတဲ့ စက်မှာ **License key** ထည့်တဲ့အခါ EXE က server ကို ခေါ်ပြီး validate + bind လုပ်မယ်။  
- ဒီအတွက် EXE ကို **License Server URL** သတ်မှတ်ပေးရမယ်။ လက်ရှိ EXE build မှာ URL ကို **environment variable** ကနေ ဖတ်နိုင်အောင် လုပ်ထားရင် သုံးစွဲသူ စက်မှာ သတ်မှတ်ပေးနိုင်ပါတယ် (ဥပမာ shortcut မှာ `set LICENSE_SERVER_URL=https://your-domain.com/api` ထည့်ပြီး run)။  
- Server မှာ `POST /api/license/remote-activate/` (license_key + machine_id) ရှိပြီးသား ဖြစ်ပါတယ်။

### (ဂ) license.lic ဖိုင် ကိုယ်တိုင် ထည့်ခြင်း (Offline)

- License ထုတ်ပေးသူက **license.lic** ဖိုင် ထုတ်ပေးပါက၊ ဒီ ဖိုင်ကို **HoBoPOS.exe ရဲ့ folder** ထဲ ထည့်ပါ (exe နဲ့ တစ်ခုတည်း directory)။  
- ဖိုင်ထဲမှာ `license_key`, `machine_id`, `license_type`, `expires_at` စသည်တို့ ပါအောင် ထုတ်ပေးရပါမယ်။ ဒီ ပုံစံကို `docs/LICENSE_KEY_WHEN_NO_MAIN_WEBSITE.md` မှာ ဖော်ပြထားနိုင်ပါတယ်။  

အတိုချုပ်: **EXE မှာ License key ကို Settings / License Activation ကနေ ထည့်လို့ရပါတယ်။** Server ချိတ်ထားရင် remote activate လုပ်မယ်၊ မချိတ်ထားရင် local DB (သို့မဟုတ် license.lic) နဲ့ စစ်မယ်။

---

## ၃) RAM 2GB, CPU Celeron လောက်ပဲ ရှိတဲ့ စက်တွေမှာ အဆင်ပြေနိုင်မလား

**အခြေခံအားဖြင့် သုံးလို့ရပါတယ်။** ဒါပေမယ့် စက်အားနည်းတာမို့ အောက်ပါအတိုင်း ချိန်ညှိပြီး သုံးရင် ပိုအဆင်ပြေပါတယ်။

### ဘာကြောင့် သုံးလို့ရနိုင်သလဲ

- **Backend:** Waitress သုံးထားတယ် (Django ထက် ပေါ့ပါးတယ်)။
- **Database:** SQLite သုံးထားတယ် (server သပ်သပ် မလိုပါ)။
- **Frontend:** Browser တစ်ခုထဲမှာ tab တစ်ခု ဖွင့်ပြီး သုံးရုံပဲ လိုတယ်။

### သုံးစွဲသူတွေအတွက် အကြံပြုချက်များ

| အချက် | အကြံပြုချက် |
|--------|------------------|
| **RAM 2GB** | ဖြစ်နိုင်ရင် browser မှာ **tab တစ်ခုပဲ** ဖွင့်ပြီး HoBo POS သုံးပါ။ အခြား program တွေ (Chrome tab အများကြီး၊ video) ပိတ်ထားရင် ပိုအဆင်ပြေပါတယ်။ |
| **Celeron** | ပထမဆုံး run မှာ migrate ကြာနိုင်ပါတယ်။ တစ်ခါ run ပြီးရင် နောက်တစ်ကြိမ် စချိန်မှာ ပိုမြန်ပါမယ်။ |
| **Low-memory mode** | EXE က **memory နည်းနည်းနဲ့ ပြေးစေချင်**ရင် စက်မှာ environment variable တစ်ခု သတ်မှတ်ပါ: `HOBOPOS_LOW_RAM=1`။ ဒီအခါ server က thread ၂ ခုပဲ သုံးမယ် (ပုံမှန် ၄ ခု)။ RAM နည်းတဲ့ စက်တွေအတွက် ထည့်သုံးနိုင်ပါတယ်။ |

### HOBOPOS_LOW_RAM=1 ဘယ်လို သတ်မှတ်မလဲ (EXE သုံးမည့်သူ)

**နည်း ၁ – Shortcut ကနေ**

1. HoBoPOS.exe ကို right-click → **Create shortcut**။  
2. Shortcut ကို right-click → **Properties**။  
3. **Target** မှာ ဒီလို ပြင်ပါ (path က ကိုယ့်စက်အလိုက် ပြင်ပါ):  
   `C:\Windows\System32\cmd.exe /c "set HOBOPOS_LOW_RAM=1 && cd /d D:\HoBoPOS_Release && HoBoPOS.exe"`  
   (ဥပမာ EXE folder က `D:\HoBoPOS_Release` ဆိုပါစို့။)  
4. **OK** နှိပ်ပါ။ ဒီ shortcut ကို နှိပ်ပြီး run ပါ။  

**နည်း ၂ – Batch ဖိုင်နဲ့ run**

- Repo မှာ `scripts\Start_HoBo_LowRAM.bat` ပါပြီးသား။ ဒီ ဖိုင်ကို **HoBoPOS_Release** folder ထဲ ကူးထည့်ပြီး ဒီ .bat ကို double-click လုပ်ပြီး run ပါ။  
- သို့မဟုတ် EXE folder ထဲမှာ ကိုယ်တိုင် `Start_HoBo_LowRAM.bat` လုပ်ပြီး အတွင်းမှာ `set HOBOPOS_LOW_RAM=1` နဲ့ `start "" HoBoPOS.exe` ထည့်ပြီး run ပါ။  

အတိုချုပ်: **RAM 2GB / Celeron စက်တွေမှာ EXE သုံးလို့ရပါတယ်။** Browser tab တစ်ခုပဲ ဖွင့်ပြီး သုံးပါ။ စက်က RAM အရမ်းနည်းရင် `HOBOPOS_LOW_RAM=1` သတ်မှတ်ပြီး run ပါ။

---

## အတိုချုပ်

| မေးခွန်း | ဖြေရှင်း |
|-----------|------------|
| **EXE အဆင်ပြေလား** | ပြေပါတယ်။ build_exe.bat → HoBoPOS_Release\HoBoPOS.exe run ပြီး browser မှာ /app/ သုံးရပါတယ်။ |
| **License key ထည့်မယ်ဆိုရင်** | Settings / License Activation ကနေ key ထည့်ပြီး Activate နှိပ်ရင် အဆင်ပြေပါတယ်။ Server ချိတ်ထားရင် remote activate လုပ်မယ်။ license.lic ဖိုင် ထည့်ချင်ရင် EXE folder ထဲ ထည့်ပါ။ |
| **RAM 2GB, Celeron စက်တွေ** | သုံးလို့ရပါတယ်။ tab တစ်ခုပဲ ဖွင့်ပြီး သုံးပါ။ လိုရင် HOBOPOS_LOW_RAM=1 သတ်မှတ်ပြီး run ပါ။ |

EXE သုံးမည့်သူတွေကို ဒီစာရွက်လေးပဲ ပေးပြီး ညွှန်ပြထားလို့ရပါတယ်။
