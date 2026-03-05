# Client Install နဲ့ သုံးစွဲမှု (Setup.exe တစ်ခါတည်း → Windows software လို)

Client တွေက **setup.exe** ကို run ပြီး install လုပ်မယ်။ Install မှာ **Desktop shortcut လုပ်မလား / Start Menu shortcut လုပ်မလား** မေးတဲ့အတိုင်း ရွေးပြီးရင် ပြီးသွားမယ်။ နောက်မှ **Desktop (သို့မဟုတ် Start Menu)** က **HoBo POS** shortcut ကို **double-click** ဖွင့်ပြီး သုံးကြမယ်။ စပြီး install မှာကတည်းက **error မတက်ရင်**၊ သုံးနေတဲ့နေရာမှာ **error မတက်ရင်**၊ **login ဝင်ရင်** ဖြစ်အောင် ဒီစာရွက်မှာ စီးဆင်းမှု နဲ့ EXE/Setup လိုအပ်ချက်တွေကို ရေးထားပါတယ်။

---

## ၁) Client စီးဆင်းမှု (အဆင့်အလိုက်)

| အဆင့် | လုပ်ရမယ့်အရာ |
|--------|------------------|
| **1. Install** | **setup.exe** (hobo_pos_setup.exe) ကို run ပြီး Next နှိပ်ကာ install လုပ်မယ်။ |
| **2. Shortcut ရွေးမယ်** | "Create a desktop shortcut" / "Create Start Menu shortcut" မေးရင် လိုသလို ရွေးပြီး install ဆက်လုပ်မယ်။ (Windows software တွေလို) |
| **3. ဖွင့်မယ်** | Install ပြီးသွားရင် **Desktop** (သို့မဟုတ် **Start Menu** > HoBo POS) က **HoBo POS** shortcut ကို **double-click** လုပ်မယ်။ ပထမဆုံး run မှာ migrate ပြေးပြီး browser က **http://127.0.0.1:8000/app/** ဖွင့်မယ်။ |
| **4. Register (ပထမဦး)** | အကောင့်မရှိသေးရင် **Login** စာမျက်နှာမှာ **"စာရင်းသွင်းရန်"** နှိပ်ပြီး **Register** လုပ်မယ်။ **ပထမဦး စာရင်းသွင်းသူသည် Owner** ဖြစ်မယ်။ |
| **5. Role တွေ ခွဲမယ်** | Owner နဲ့ login ဝင်ပြီး **Settings** သို့မဟုတ် **Users / Roles** မှာ Role တွေ ထည့်ပြီး ဝန်ထမ်းတွေကို Role အလိုက် ခွဲမယ်။ |
| **6. Role အလိုက် သုံးမယ်** | ဝန်ထမ်းတွေက ကိုယ့် username/password နဲ့ login ဝင်ပြီး ကိုယ့် role အလိုက် စာမျက်နှာတွေ သုံးမယ်။ |

---

## ၂) EXE မှာ လိုအပ်တာတွေ အကုန်လုံးရှိနေရမယ်

Client စက်မှာ **Python / Node / virtualenv မရှိဘူး**။ **EXE (သို့မဟုတ် install လုပ်ထားတဲ့ folder) ထဲမှာ လိုတာတွေ အကုန်ပါအောင်** build လုပ်ထားရမယ်။

| အချက် | ဖော်ပြချက် |
|--------|--------------|
| **Server + Frontend** | EXE run လိုက်ရင် Django (Waitress) စပြီး Vue build ကို `/app/` မှာ serve မယ်။ Browser က ဒီလိပ်စာကို ဖွင့်မယ်။ |
| **Database** | ပထမဆုံး run မှာ **migrate** ပြေးပြီး EXE folder ထဲမှာ **db.sqlite3** (သို့မဟုတ် encrypt လုပ်ထားရင် db.sqlite3.enc) ဖန်တီးမယ်။ |
| **Data folder** | EXE folder ထဲမှာ **data/** (machine_id), **media/**, **license.lic** (လိုရင်) သိမ်းမယ်။ |
| **လိုအပ်တာတွေ** | Python / Node / Redis စက်မှာ ထပ်ထည့်စရာ မလိုပါ။ EXE (သို့မဟုတ် onedir folder) ထဲမှာ ပါပြီးသား။ |

Build လုပ်တဲ့အခါ **build_exe.bat** က Vue build (base `/app/`) ကို copy လုပ်ပြီး PyInstaller နဲ့ pack လုပ်တာမို့၊ **HoBoPOS_Release** folder ထဲမှာ exe + DLL + static_frontend စသည်တို့ ပါပါတယ်။ ဒီ folder ကို ကူးယူပြီး shortcut လုပ်ပေးရင် client က တန်းသုံးလို့ရပါတယ်။

---

## ၃) Install မှာကတည်းက Error မတက်အောင်

| ပြဿနာ | ကာကွယ်နည်း |
|---------|----------------|
| **EXE run လိုက်ရင် “မတွေ့ပါ” / DLL ချို့** | Build မှာ onedir သုံးပြီး folder ထဲက file တွေ အကုန်ကူးယူပါ။ EXE တစ်ဖိုင်တည်း ပို့မယ်ဆိုရင် onefile build သေချာလုပ်ပါ။ |
| **ပထမဆုံး run မှာ migrate error** | run_server.py မှာ migrate --run-syncdb ပါပြီးသား။ EXE folder ကို **ရေးခွင့်** ရှိရပါမယ် (Program Files မှာ install လုပ်ရင် permission ပြဿနာ ဖြစ်နိုင်သလို၊ ဒါကြောင့် **LocalAppData** သို့မဟုတ် user ရွေးတဲ့ folder မှာ install လုပ်ပါ)။ |
| **Browser မဖွင့်ဘူး** | run_server.py က webbrowser.open() ခေါ်ထားပါတယ်။ Default browser ပွင့်မယ်။ မပွင့်ရင် client ကို **http://127.0.0.1:8000/app/** ကို ကိုယ်တိုင် ဖွင့်ခိုင်းပါ။ |
| **Login စာမျက်နှာ 404 / မပြ** | Frontend က `/app/` မှာ serve ဖြစ်ပြီး route က `/login`, `/register` ရှိပါတယ်။ Register/Login က license skip path မှာ ပါပြီးသား ဖြစ်ပါမယ်။ |

---

## ၄) သုံးနေတဲ့နေရာမှာ Error မတက်အောင် / Login ဝင်ရအောင်

| အချက် | ဖော်ပြချက် |
|--------|--------------|
| **Register ပထမဦး = Owner** | Backend မှာ ပထမဦး user က **owner** role နဲ့ ဖန်တီးပါတယ်။ နောက်ထပ် user တွေက **sale_staff** (သို့မဟုတ် သတ်မှတ်ထားတဲ့ default role) နဲ့ ဖန်တီးပါတယ်။ |
| **Role ခွဲခြင်း** | Owner/Admin က **Users** သို့မဟုတ် **Roles** စာမျက်နှာမှာ Role တွေ ထည့်ပြီး ဝန်ထမ်းတွေကို role အလိုက် သတ်မှတ်နိုင်ပါတယ်။ |
| **Login ဝင်မရ** | Username/Password မှန်မှန် ထည့်ပါ။ အကောင့်မရှိသေးရင် **စာရင်းသွင်းရန်** နှိပ်ပြီး Register လုပ်ပါ။ Backend (EXE) က run ထားရပါမယ် (shortcut နှိပ်ပြီး browser ပွင့်ထားရင် server ပြေးနေပြီး)။ |
| **License** | Trial သို့မဟုတ် license ထည့်ပြီးသား ဖြစ်ရပါမယ်။ License ကုန်ရင် 403 ပြီး License Activation စာမျက်နှာသို့ ညွှန်ပြမယ်။ |

---

## ၅) Developer: setup.exe ထုတ်ခြင်း

Client က **setup.exe တစ်ခုပဲ** ရပြီး install လုပ်ရင် **လိုအပ်တာတွေအကုန်** ပါအောင်၊ **Desktop / Start Menu shortcut မေးမယ်** (Windows software လို) ဖြစ်အောင်:

- **တစ်ခါ run နဲ့ ထုတ်မယ်:** Repo root မှာ **build_setup.bat** run ပါ။ ဒါက EXE (onedir) ကို build လုပ်ပြီး **deploy\\installer\\dist\\hobo_pos_setup.exe** ထုတ်ပေးမယ်။  
- **Client ကို ပေးမယ်:** **hobo_pos_setup.exe** ဖိုင်ကို ပေးပါ။ Client က run ပြီး install လုပ်မယ်၊ Desktop / Start Menu shortcut ရွေးမယ်၊ ပြီးရင် shortcut နဲ့ သုံးမယ်။  
- **Portable (setup မသုံးဘဲ):** HoBoPOS_Release folder ကို ကူးယူပြီး **Create_Desktop_Shortcut.bat** run လို့ရပါတယ် (scripts မှာ ပါပြီး build_exe က Release ထဲ ကူးထားပါတယ်)။  

---

## အတိုချုပ်

1. **Developer:** **build_setup.bat** run ပြီး **hobo_pos_setup.exe** ထုတ်မယ်။  
2. **Client:** **setup.exe** run ပြီး install လုပ်မယ် → Desktop / Start Menu shortcut မေးရင် ရွေးမယ်။  
3. **သုံးမယ်:** Desktop (သို့မဟုတ် Start Menu) က **HoBo POS** shortcut ကို **double-click** ဖွင့်မယ်။  
4. **Register** (ပထမဦး) → ပထမဦး စာရင်းသွင်းသူသည် **Owner**။  
5. **Role တွေ ခွဲမယ်** → Users/Roles မှာ role တွေ ထည့်ပြီး ဝန်ထမ်းတွေ ခွဲမယ်။  
6. **Role အလိုက် သုံးမယ်** → ဝန်ထမ်းတွေက login ဝင်ပြီး ကိုယ့် role အလိုက် သုံးမယ်။  

EXE မှာ server + frontend + DB (first run migrate) ပါအောင် build လုပ်ထားပြီး၊ setup.exe က တစ်ခါ install နဲ့ အကုန်ထည့်ပေးပြီး Windows software လို shortcut မေးအောင် လုပ်ထားပါတယ်။
