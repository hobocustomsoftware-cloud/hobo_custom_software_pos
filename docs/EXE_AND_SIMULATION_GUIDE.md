# EXE အဆင်ပြေပြီးလား နဲ့ User / ဆိုင်အလိုက် Simulation လုပ်နည်း

---

## ၁) EXE အဆင်ပြေပြီးလား

**အခြေအနေ:** EXE build နဲ့ setup installer ပြီးပြီ။ Client က setup.exe run ပြီး install လုပ်လို့ရပါပြီ။

| အချက် | ရှိ/မရှိ |
|--------|-----------|
| **Build** | `build_exe.bat` → **HoBoPOS_Release** folder (onedir) ထွက်မယ်။ |
| **Setup installer** | `build_setup.bat` → **deploy\installer\dist\hobo_pos_setup.exe** ထွက်မယ်။ |
| **EXE ထဲမှာ** | Django + Waitress + Vue frontend + migrate (first run) ပါပြီးသား။ |
| **လိုအပ်ချက်** | Client စက်မှာ Python/Node မလိုပါ။ |

**စစ်ဆေးနည်း (EXE အဆင်ပြေမပြေ):**

1. **CLI နဲ့ စစ်မယ် (browser မလို)**  
   - Server (သို့မဟုတ် EXE) စပြီးသား ဆိုရင်:  
     `cd WeldingProject` → `python manage.py simulate_exe_flow`  
   - Server မစသေးရင်:  
     `python manage.py simulate_exe_flow --start-server`  
   - EXE နဲ့ စစ်ချင် (build ပြီးမှ):  
     `python manage.py simulate_exe_flow --start-exe`  
   - Repo root မှာ: **scripts\run_cli_simulate_exe.bat** (သို့မဟုတ် `--start-server` ထည့်ပြီး) run လို့ရပါတယ်။  

2. **EXE ကို ကိုယ်တိုင် run ပြီး စစ်မယ်**  
   - **HoBoPOS_Release\HoBoPOS.exe** double-click လုပ်မယ်။  
   - Browser ပွင့်ပြီး `http://127.0.0.1:8000/app/` ရမယ်။  
   - Login စာမျက်နှာမှာ **စာရင်းသွင်းရန်** နှိပ်ပြီး Register လုပ်မယ်။ ပထမဦး = Owner။  
   - ဒါပြီးရင် EXE အဆင်ပြေပြီ။  

---

## ၂) User Simulation စမ်းဖို့ (ဘယ်လို စမ်းလို့ရမလဲ)

မတူတဲ့ ရည်ရွယ်ချက်အတွက် အောက်က command တွေ သုံးပါ။

| စစ်ချင်တာ | လုပ်နည်း |
|-------------|-----------|
| **EXE flow (health, register, login, shop-settings, API)** | `python manage.py simulate_exe_flow` (server/EXE ပြေးနေရင်)။ သို့မဟုတ် `simulate_exe_flow --start-server` သို့မဟုတ် `--start-exe`။ Batch: **scripts\run_cli_simulate_exe.bat** |
| **Register → Login → Sales → Approve (စီးဆင်းမှု တစ်ခုလုံး)** | `python manage.py run_simulation`။ Browser မလိုပါ။ (Django test client) |
| **တစ်လစာ ရောင်းချမှု / စာရင်းတွေ simulate** | `python manage.py simulate_month` (သို့မဟုတ် `--skip-delay`)။ |
| **License ကုန်ပြီး 403 ပြမလား စစ်မယ်** | `python manage.py simulate_errors --license-expired` ပြေးပြီး app မှာ ခေါ်မှုလုပ်ပါ။ ပြန်ပြန်လည်သတ်မှတ်ရန် `simulate_errors --reset-license`။ |
| **401 / 404 / Offline စစ်မယ်** | docs/ERRORS_AND_SIMULATION.md ကြည့်ပါ။ |

**အတိုချုပ်:**

- **EXE စီးဆင်းမှု စစ်မယ်** → `simulate_exe_flow` (သို့မဟုတ် run_cli_simulate_exe.bat)  
- **User ဝင်ပြီး ရောင်းချမှု စီးဆင်းမှု စစ်မယ်** → `run_simulation`  
- **Error (license/401/404) စစ်မယ်** → `simulate_errors` + docs/ERRORS_AND_SIMULATION.md  

---

## ၃) မတူညီတဲ့ ဆိုင်တွေနဲ့ ခွဲပြီး simulation လုပ်ချင်တာ

ဆိုင်တစ်ဆိုင်ချင်းစီက **ကိုယ်ပိုင် DB** နဲ့ **ကိုယ်ပိုင် install** လို စစ်ချင်ရင် အောက်က နည်းတွေ သုံးပါ။

### နည်း ၁ – ဆိုင်အလိုက် folder ခွဲပြီး EXE run (အကြံပြု)

တစ်ဆိုင်ကို folder တစ်ခုစီ ထားပြီး ဒီ folder ထဲက EXE ကို run မယ်။ ဒီ folder ထဲမှာ **db.sqlite3** (နဲ့ data/) က ဒီဆိုင်အတွက်ပဲ ဖြစ်တယ်။

1. **Build ပြီးသား HoBoPOS_Release** ကို ဆိုင်အလိုက် copy ပါ။  
   - ဥပမာ: **ShopA**, **ShopB**, **ShopC** (သို့မဟုတ် ဆိုင်အမည်နဲ့ folder များ)။  
2. **တစ်ဆိုင်ချင်းစီ** အတွက် ဒီ folder ထဲက **HoBoPOS.exe** ကို run ပါ။  
   - ShopA စစ်မယ် → ShopA\HoBoPOS.exe run ပါ။ ပထမဆုံး run မှာ migrate ပြေးမယ်။ Register လုပ်ပြီး သုံးပါ။ ပိတ်ပါ။  
   - ShopB စစ်မယ် → ShopB\HoBoPOS.exe run ပါ။ ဒီမှာ ဆိုင်သစ် (DB သစ်) ဖြစ်တာမို့ ပထမဦး Register ထပ်လုပ်ပါ။  
   - ShopC လည်း အလားတူ။  

**သတိပြုရန်:** EXE က port **8000** သုံးတာမို့ တစ်ချိန်တည်း EXE နှစ်ခု မဖွင့်ပါနဲ့။ တစ်ဆိုင်ပြီး တစ်ဆိုင်ပိတ်ပြီး စစ်ပါ။  

**အဆင်ပြေအောင်:** Repo root မှာ **scripts\prepare_multiple_shops.bat** run ပြီး ဆိုင်အရေအတွက် (ဥပမာ ၃) ထည့်ရင် **Shop1, Shop2, Shop3** folder တွေ ဖန်တီးပေးမယ်။ ဒီ folder တွေထဲက EXE ကို တစ်ခုချင်း run ပြီး စစ်လို့ရပါတယ်။  

### နည်း ၂ – တစ်ခုတည်းသော DB မှာ ဆိုင်အမည်ပဲ ပြောင်းပြီး demo

တစ်ခုတည်းသော install (သို့မဟုတ် runserver) မှာပဲ **ဆိုင်အမည် (shop_name)** ကို ပြောင်းပြီး demo လုပ်ချင်ရင်:

- **Settings** (သို့မဟုတ် Shop Settings) မှာ **ဆိုင်အမည်** ကို ပြောင်းပါ (ဥပမာ "ဆိုလာဆိုင်"၊ "အီလက်ထရွန်းနစ်ဆိုင်")။  
- ပြီးရင် **run_simulation** သို့မဟုတ် **simulate_month** run ပါ။  
- ဒါက **multi-tenant ဆိုင်ခွဲ** မဟုတ်ပါ။ ဆိုင်အမည် ပြောင်းပြီး စီးဆင်းမှု စစ်တာပဲ ဖြစ်ပါတယ်။  

---

## ၄) အတိုချုပ်

| မေးခွန်း | ဖြေချက် |
|-----------|-----------|
| **EXE အဆင်ပြေပြီးလား** | ပြီးပြီ။ build_setup.bat နဲ့ setup.exe ထုတ်ပြီး install လုပ်လို့ရပါတယ်။ |
| **User simulation စမ်းဖို့** | `simulate_exe_flow` (EXE flow), `run_simulation` (Register→Login→Sales), `simulate_errors` (license/error)။ |
| **မတူညီတဲ့ ဆိုင်တွေနဲ့ ခွဲပြီး simulation** | HoBoPOS_Release ကို ဆိုင်အလိုက် folder (ShopA, ShopB, ShopC) copy ပြီး ဒီ folder ထဲက EXE ကို တစ်ခုချင်း run ပါ။ **scripts\prepare_multiple_shops.bat** က Shop1, Shop2, Shop3 ဖန်တီးပေးမယ်။ |

အသေးစိတ် error/simulation အတွက် **docs/ERRORS_AND_SIMULATION.md** ကြည့်ပါ။
