# HoBo POS - စစ်ဆေးချက်များ နှင့် Simulation ရှင်းလင်းချက်

## ၁။ စစ်ဆေးမှု အဆင့်များ (ဘာစစ်တာလဲ၊ ဘာဖြစ်နေတာလဲ)

### ၁.၁ Package/Module စစ်ဆေးခြင်း (CMD)

- **ဘာလုပ်တာလဲ:** `deploy\installer\check_packages.cmd` က Python နဲ့ `import django`, `import rest_framework` စသဖြင့် တစ်ခုချင်း စစ်ပါတယ်။
- **ဘာကြောင့်လဲ:** EXE build မလုပ်ခင် package အားလုံး ရှိ/မရှိ သိရအောင်။
- **ဘာဖြစ်နေတာလဲ:** တစ်ခုချင်းစီမှာ `[OK]` ပြရင် ထို module ရှိပြီး၊ `[MISSING]` ပြရင် ထို package မရှိသေးလို့ `pip install -r WeldingProject\requirements.txt` လုပ်ရပါမယ်။
- **ဘယ်မှာစစ်မလဲ:** Project root ကနေ CMD ဖွင့်ပြီး `deploy\installer\check_packages.cmd` run ပါ။

---

### ၁.၂ EXE + Installer ထုတ်ခြင်း

- **ဘာလုပ်တာလဲ:** `deploy\installer\build.ps1` (သို့) `check_then_build.cmd` က Vue build, Django collectstatic, PyInstaller, Inno Setup တစ်ဆင့်ပြီးတစ်ဆင့် လုပ်ပါတယ်။
- **ဘာကြောင့်လဲ:** ထွက်လာတဲ့ `HoBoPOS.exe` နဲ့ `hobo_pos_setup.exe` ကို သုံးစွဲသူ install လုပ်နိုင်အောင်။
- **ဘာဖြစ်နေတာလဲ:**
  - **Logo:** `assets/logo.png` (သို့) `assets/logo.svg` ရှိရင် `make_icon.py` က `logo.ico` ထုတ်ပြီး EXE နဲ့ launcher မှာ သုံးပါတယ်။ မရှိရင် fallback လိမ္မယ့် အရောင်နဲ့ icon ထွက်ပါမယ်။
  - **Error တက်ရင်:** PyInstaller မတွေ့ရင် `pip install pyinstaller` လုပ်ပါ။ Inno Setup မတွေ့ရင် script က winget/download ကြိုးစားပါမယ်။
- **ထွက်လာတဲ့ဖိုင်:** `deploy\installer\dist\HoBoPOS.exe`, `deploy\installer\dist\hobo_pos_setup.exe`

---

### ၁.၃ CLI Simulation (Register → Login → Sales → Approve)

- **ဘာလုပ်တာလဲ:** `python manage.py run_simulation` က browser/UI မလိုပဲ API ကို တိုက်ရိုက်ခေါ်ပြီး စာရင်းသွင်း → ဝင်ရောက် → အရောင်းတင်ခြင်း → အတည်ပြုခြင်း စီးဆင်းမှု တစ်ခုလုံး စစ်ပါတယ်။
- **ဘာကြောင့်လဲ:** UI မဖွင့်ပဲ logic နဲ့ API မှ/မမှန် သိရအောင်။
- **ဘာဖြစ်နေတာလဲ:**
  - **Step 0:** Location, Category, Product မရှိရင် ဖန်တီးပြီး၊ လက်ကျန် မလောက်ရင် inbound ထည့်ပါတယ်။
  - **Step 1:** သုံးစွဲသူ မရှိရင် `POST /api/core/register/` နဲ့ စာရင်းသွင်းပြီး ပထမဦးဆုံး user ကို owner ဖြစ်အောင် လုပ်ပါတယ်။
  - **Step 2:** `POST /api/token/` နဲ့ JWT ယူပါတယ်။
  - **Step 3:** `POST /api/sales/request/` နဲ့ အရောင်း (pending) အများကြီး တင်ပါတယ် (ဥပမာ ၃၀ ရက် × ၃ ရောင်း = ၉၀ ခု)။
  - **Step 4:** `PATCH /api/admin/approve/<id>/` နဲ့ တစ်ခုချင်း approved လုပ်ပြီး stock နုတ်ပါတယ်။
  - **Step 5:** ရက်စွဲ ပြန့်ပြန့်ပြသဖို့ `created_at` ကို ပြင်ပါတယ် (တစ်လစာ simulation ပုံစံ)။
- **Error တက်ရင်:** Location/Product/Stock မလုံလောက်တာ၊ permission မကိုက်တာ စသဖြင့် response JSON မှာ အကြပြချက် ပါပါလိမ့်မယ်။
- **ဘယ်မှာစစ်မလဲ:** Project root မှာ `venv\Scripts\activate` (သို့) `venv\Scripts\python.exe` သုံးပြီး `python WeldingProject\manage.py run_simulation` run ပါ။

---

## ၂။ Server အတွက် စစ်လိုရပါသလား

- **ရပါတယ်။** Simulation က Django test client သုံးထားလို့ **server မလိုပဲ** `manage.py` နဲ့ run ရင် စစ်လို့ ရပါတယ်။
- **Server ဖွင့်ပြီး စစ်ချင်ရင်:** `run_lite.bat` (သို့) `python manage.py runserver` နဲ့ server ဖွင့်ပြီး၊ browser သို့မဟုတ် `curl` / Postman နဲ့ အောက်ပါ API တွေကို တိုက်ရိုက်ခေါ်ပြီး စစ်နိုင်ပါတယ်။
  - `POST /api/core/register/`
  - `POST /api/token/`
  - `POST /api/sales/request/` (Authorization: Bearer <token>)
  - `PATCH /api/admin/approve/<id>/`
- **ခြားနားချက်:** CLI simulation က **တစ်ခါ run ရင်** DB ထဲမှာ user/sales တွေ ထည့်သွင်းသွားပါတယ်။ Server run ထားပြီး browser/Postman နဲ့ စစ်ရင် လက်ရှိ server URL ကို base URL ထားပြီး ခေါ်ရပါမယ် (simulation script လို URL path ပဲ သတ်မှတ်ရင် ရပါတယ်)။

---

## ၃။ Logo နေရာများ (သတ်မှတ်ပြီးသား)

| နေရာ | ဖိုင် | ဘာအတွက် |
|--------|--------|------------|
| `assets/logo.png` သို့မဟုတ် `assets/logo.svg` | မူရင်း | make_icon.py က ဒီကနေ logo.ico / logo.png ထုတ်ပါတယ်။ |
| `assets/logo.ico` | make_icon ထုတ်ချက် | Central icon။ |
| `deploy/installer/logo.ico` | make_icon ကူးယူချက် | EXE icon နဲ့ Inno Setup (shortcut icon)။ |
| `yp_posf/public/logo.png` | make_icon ကူးယူချက် | Vue Register/Login စာမျက်နှာ။ |
| `deploy/portable/output/logo.ico` | setup_embedded.ps1 ကူးယူချက် | Portable launcher (HoBoPOS.exe) icon။ |

---

## ၄။ အတိုချုပ်

- **Package စစ်မယ်:** `deploy\installer\check_packages.cmd` → ကျန်တာ/error ကြည့်ပြီး `pip install -r WeldingProject\requirements.txt`။
- **Setup ထုတ်မယ်:** `deploy\installer\check_then_build.cmd` (သို့) `deploy\installer\build.ps1` → ထွက်လာတာက `hobo_pos_setup.exe`။
- **Logic/API စစ်မယ်:** `python WeldingProject\manage.py run_simulation` → Register ကနေ နောက်ဆုံး sale အတည်ပြုအထိ simulation။
- **Server နဲ့စစ်မယ်:** Server run ထားပြီး အထက်က API path တွေကို browser/curl/Postman နဲ့ ခေါ်ပြီး စစ်နိုင်ပါတယ်။
