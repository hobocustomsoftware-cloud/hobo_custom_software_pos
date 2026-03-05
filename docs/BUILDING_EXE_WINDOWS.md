# Windows .exe ထုတ်ခြင်း ဆွေးနွေးချက်

ဒီ project မှာ **Vue 3 (frontend)** နဲ့ **Django (backend API)** နှစ်ခုပါတယ်။ .exe တစ်ခု (သို့) installer တစ်ခု လုပ်ချင်ရင် အောက်က နည်းတွေထဲက ရွေးနိုင်ပါတယ်။  

**လုံခြုံရေး**: Build ထုတ်တဲ့အခါ **source code (.py)** မပါပါ (PyInstaller က bytecode ပဲ ထည့်တယ်)။ Cracker/hacker အန္တရာယ် လျော့စေခြင်း၊ ဖိုင်တွေ ခိုးသုံးလို့မရအောင်၊ developer ဝင်ဖတ်လို့မရအောင် စသည့် ကာကွယ်မှု ရွေးစရာများကို **`docs/SECURITY_AND_PROTECTION.md`** မှာ ဆွေးနွေးထားပါတယ်။  

**License key (main website မတင်ရသေးချိန်)**: Offline license.lic ထုတ်ပြီး customer ပေးလို့ရအောင် **`docs/LICENSE_KEY_WHEN_NO_MAIN_WEBSITE.md`** နဲ့ management command **`issue_license_file`** ထည့်ထားပါတယ်။

---

## ၁။ ဘာကို .exe လုပ်မလဲ

| ရွေးချယ်မှု | ရှင်းလင်းချက် |
|----------------|-----------------|
| **A. Backend + Frontend တစ်ခါတည်း** | .exe တစ်ခု run လိုက်ရင် Django server စပြီး၊ Vue (built) ကို serve ပြီး browser (သို့) embedded window ဖွင့်မယ်။ သုံးစွဲသူက .exe တစ်ခုပဲ run ရမယ်။ |
| **B. Client .exe သက်သက်** | .exe က Vue app (Electron/Tauri) ပဲ။ API URL ကို config မှာ ထည့်မယ် (localhost သို့မဟုတ် server လိပ်စာ)။ Backend ကို သပ်သပ် run ရမယ် (သို့) server မှာ deploy ထားမယ်။ |
| **C. Server .exe + Browser** | .exe တစ်ခုက Django ကို PyInstaller နဲ့ pack လုပ်ပြီး run မယ်။ Vue build ကို Django static အဖြစ် ထည့်မယ်။ Run လိုက်ရင် server စပြီး default browser ဖွင့်ပေးမယ်။ |

---

## ၂။ နည်းလမ်းများ အသေးစိတ်

### ၂.၁ PyInstaller နဲ့ Django ကို .exe လုပ်ပြီး Vue ကို static ထည့်ခြင်း (တစ်ခုတည်း အဆင်ပြေစေ)

**အလုပ်လုပ်ပုံ**  
- Django project ကို PyInstaller နဲ့ pack လုပ်ပါတယ် (Python interpreter + Django code ပါတယ်)။  
- Vue ကို `npm run build` လုပ်ပြီး `dist/` ထွက်လာတာကို Django ရဲ့ static/files အနေနဲ့ ထည့်ပါတယ်။  
- .exe run လိုက်ရင် Django development server (သို့) waitress/gunicorn လို WSGI server စပြီး၊ `http://127.0.0.1:8000` မှာ app ပြမယ်။  
- လိုရင် system tray icon ထားပြီး “Open in browser” ခလုတ် ထည့်လို့ရပါတယ်။  

**အားသာချက်**  
- သုံးစွဲသူက .exe တစ်ခုပဲ double‑click လုပ်ရပြီး backend + frontend အတူ အလုပ်လုပ်မယ်။  
- Server လိပ်စာ စီမံခန့်ခွဲစရာ မလို။  

**အားနည်းချက်**  
- PyInstaller နဲ့ Django ကို pack လုပ်တာ ဂရုစိုက်ရပါတယ် (static files, migrations, templates, env စသည်)။  
- Database (SQLite) path, `SECRET_KEY`, `ALLOWED_HOSTS` စသည်ကို config file (သို့) first-run setup နဲ့ သတ်မှတ်ပေးရပါမယ်။  

**အဆင့်အတိုချုပ်**  
1. Vue: `npm run build` → `dist/` ထွက်အောင် လုပ်ပါ။  
2. Django: `dist/` ကို copy ကူးပြီး `STATIC_ROOT` / template path မှာ serve အောင် စီမံပါ (သို့) WhiteNoise သုံးပြီး Vue SPA ကို serve ပါ။  
3. Django ကို run မယ့် entry script (ဥပမာ `run_server.py`) ရေးပါ — `os.environ.setdefault`, `django.setup()`, ပြီးတော့ `manage.py runserver` (သို့) waitress serve။  
4. PyInstaller spec file မှာ Django project, Vue `dist/`, migrations, SQLite (လိုရင်) စသည်ကို `datas` ထဲ ထည့်ပါ။  
5. `pyinstaller run_server.spec` လုပ်ပြီး .exe ထုတ်ပါ။  

---

### ၂.၂ Electron နဲ့ Vue ကို .exe လုပ်ခြင်း (Client app သက်သက်)

**အလုပ်လုပ်ပုံ**  
- Vue app ကို Electron နဲ့ wrap လုပ်ပါတယ်။ .exe က window တစ်ခု ဖွင့်ပြီး Vue app ကို ပြမယ်။  
- API URL ကို config (သို့) env မှာ ထည့်မယ် (ဥပမာ `http://127.0.0.1:8000/api/` သို့မဟုတ် company server)။  
- Backend ကို သပ်သပ် run ရမယ် — ဒီ .exe က “POS client” သက်သက်ပဲ။  

**အားသာချက်**  
- Vue project မှာ Electron ထည့်ပြီး build လုပ်ရင် .exe ထွက်တာ လွယ်ပါတယ်။  
- Backend ကို server မှာ deploy ထားပြီး client တွေက .exe ပဲ install လုပ်သုံးနိုင်ပါတယ်။  

**အားနည်းချက်**  
- Django ကို သုံးစွဲသူက ကိုယ်တိုင် run ရမယ် (သို့) server တစ်ခုခုမှာ ထားရမယ်။  
- “.exe တစ်ခုပဲ run ရင် အကုန်ပါ” ဆိုတဲ့ ပုံစံ မဟုတ်ပါ။  

**အဆင့်အတိုချုပ်**  
1. Vue project မှာ `electron` + `electron-builder` (သို့) `vite-plugin-electron` ထည့်ပါ။  
2. API base URL ကို env (ဥပမာ `VITE_API_URL`) နဲ့ သတ်မှတ်ပါ။  
3. `npm run build` (သို့) electron-builder script နဲ့ Windows .exe ထုတ်ပါ။  

---

### ၂.၃ Tauri နဲ့ Vue ကို .exe လုပ်ခြင်း (Client app သက်သက်၊ ပေါ့ပါးတယ်)

**အလုပ်လုပ်ပုံ**  
- Electron လိုပဲ “client app” သက်သက်။ Tauri က Rust သုံးပြီး binary သေးတယ်၊ memory လည်း နည်းတယ်။  
- Vue ကို Tauri ရဲ့ frontend အဖြစ် သတ်မှတ်ပြီး Windows .exe ထုတ်လို့ရပါတယ်။  
- API URL က config/env မှာ ထည့်ပြီး Django backend နဲ့ ချိတ်မယ်။  

**အားသာချက်**  
- Binary သေးတယ်၊ အလုပ်လုပ်မြန်တယ်။  
**အားနည်းချက်**  
- Rust / Tauri setup လုပ်ရပါမယ်။ Backend က သပ်သပ် run (သို့) deploy လုပ်ရပါမယ်။  

---

### ၂.၄ Launcher .exe (Batch + Python embedded)

**အလုပ်လုပ်ပုံ**  
- “Portable” Python (ဥပမာ python-embed) + Django project + Vue `dist/` ကို folder တစ်ခုထဲ ထည့်ပါတယ်။  
- Launcher .exe (သို့) .bat က (၁) Django server စမယ် (၂) browser ဖွင့်မယ်။  
- .exe ဆိုရင် batch ကို .exe ပြောင်းတဲ့ tool (ဥပမာ bat to exe) သုံးလို့ရပါတယ်။  

**အားသာချက်**  
- PyInstaller လို pack လုပ်စရာ မလို၊ စီမံခန့်ခွဲမှု လွယ်တယ်။  
**အားနည်းချက်**  
- Python folder + project folder အတူ ပို့ပေးရမယ်။ “Single file .exe” မဟုတ်ပါ။  

---

## ၃။ အကြံပြုချက် (အခြေအနေအလိုက်)

| လိုချင်တာ | အကြံပြုနည်း |
|-------------|-----------------|
| **သုံးစွဲသူက .exe တစ်ခုပဲ run ပြီး အကုန်အလုပ်လုပ်စေချင်** | **PyInstaller + Django** နည်း (၂.၁)။ Django က Vue build ကို serve ပြီး၊ .exe run လိုက်ရင် server စပြီး browser (သို့) embedded window) ဖွင့်ပေးမယ်။ |
| **POS client .exe ပဲ ပို့ချင်၊ backend က server မှာ ထားမယ်** | **Electron** (သို့) **Tauri** နဲ့ Vue ကို .exe လုပ်ပါ (၂.၂ / ၂.၃)။ API URL ကို config မှာ ထည့်ပါ။ |
| **အမြန်စမ်းချင် / portable ပဲ လိုချင်** | **Launcher + embedded Python + Vue dist** (၂.၄) နဲ့ folder တစ်ခု (သို့) zip ပို့ပြီး “Run HoBo POS.exe” လို လုပ်လို့ရပါတယ်။ |

---

## ၄။ အတိုချုပ်

- **.exe တစ်ခုပဲ run ရင် backend + frontend အတူ အလုပ်လုပ်စေချင်** → Django ကို **PyInstaller** နဲ့ pack လုပ်ပြီး Vue build ကို Django က serve အောင် စီမံပါ။ .exe run လိုက်ရင် server စပြီး browser ဖွင့်ပေးမယ်။  
- **Client .exe သက်သက် (backend က သပ်သပ်)** → **Electron** သို့မဟုတ် **Tauri** နဲ့ Vue ကို .exe လုပ်ပါ။ API URL ကို config ထဲ ထည့်ပါ။  
- **အဆင်ပြေပြေ စမ်းချင် / portable** → Embedded Python + Django + Vue `dist/` + **Launcher .exe** (သို့) .bat နဲ့ folder တစ်ခုအနေနဲ့ ဖြန့်ပါ။  

လိုရင် PyInstaller spec ဥပမာ (သို့) Electron အတွက် config ဥပမာ ထပ်ရေးပေးလို့ ရပါတယ်။

---

## ၅။ HoBo POS အတွက် လက်တွေ့ Build လုပ်နည်း (PyInstaller)

ဒီ project မှာ **၂.၁** နည်းကို သုံးထားပြီး အောက်က ဖိုင်တွေ ပါပြီးသား။

### ဖိုင်များ

| ဖိုင် | ရည်ရွယ်ချက် |
|--------|----------------|
| `WeldingProject/run_server.py` | .exe entry: migrate, waitress 127.0.0.1:8000, browser ဖွင့် `/app/` |
| `WeldingProject/HoBoPOS.spec` | PyInstaller spec (run_server + static_frontend) |
| `build_exe.bat` (repo root) | Vue build (base `/app/`) → copy dist → PyInstaller |

### Build အဆင့် (အလိုအလျောက်)

**Repo root မှာ** `build_exe.bat` run ပါ:

```bat
cd F:\hobo_license_pos
build_exe.bat
```

ဒီ batch က (၁) Vue ကို `VITE_BASE=/app/` နဲ့ build လုပ်၊ (၂) `yp_posf/dist` ကို `WeldingProject/static_frontend` ကို copy၊ (၃) waitress + pyinstaller install၊ (၄) PyInstaller နဲ့ **folder mode (onedir)** build လုပ်ပါတယ်။ ပြီးရင် repo root မှာ **`HoBoPOS_Release`** folder တစ်ခု ထွက်မယ် — ဒီ folder သက်သက်ကို copy (သို့) zip လုပ်ပြီး ပို့သုံးလို့ရပါတယ်။

### ကိုယ်တိုင် အဆင့်ချင်း လုပ်ချင်ရင်

1. **Vue build** (base `/app/` ဖြစ်ရမယ်၊ Django က `/app/` မှာ SPA serve လို့):
   ```bat
   cd yp_posf
   set VITE_BASE=/app/
   npm run build
   ```
2. **Copy** Vue output ကို Django static_frontend ထဲ:
   ```bat
   xcopy /E /I /Y yp_posf\dist\* WeldingProject\static_frontend\
   ```
3. **Python deps**: `pip install waitress pyinstaller`
4. **EXE build** (onedir — folder တစ်ခုထဲ ထွက်မယ်):
   ```bat
   cd WeldingProject
   pyinstaller HoBoPOS.spec
   ```
   ထွက်လာတာက `WeldingProject/dist/HoBoPOS/` folder ဖြစ်မယ်။ `build_exe.bat` က ဒီ folder ကို repo root မှာ **`HoBoPOS_Release`** အဖြစ် copy ထားပေးမယ်။

### .exe run လိုက်ရင်

- Console window ပွင့်ပြီး "Running migrations…" / "HoBo POS starting at …" ပြမယ်။
- Browser အလိုအလျောက် ဖွင့်ပြီး `http://127.0.0.1:8000/app/` သွားမယ်။
- DB နဲ့ media က **.exe ရဲ့ folder** မှာ သိမ်းမယ် (ဥပမာ `HoBoPOS.exe` နဲ့ တစ်ခုတည်း folder ထဲ ထားရင် အဲဒီ folder မှာ `db.sqlite3`, `media/` စသည် ထွက်မယ်)။
- Server ရပ်ချင်ရင် console window ကို ပိတ်ပါ။

---

## ၆။ Windows Install လုပ်ပြီးမှ သုံးရတဲ့ ပုံစံ ဆွေးနွေးချက်

ပုံမှန် Windows software တွေမှာ “PC မှာ install လုပ်ပြီးမှ သုံးရတာ” ဆိုတဲ့ ပုံစံ ရှိပါတယ်။ ဒီအတွက် ဘယ်လို ပုံစံတွေ ရှိလဲ၊ HoBo POS အတွက် ဘာရွေးသင့်လဲ ဆိုတာ အောက်မှာ ချုံငုံဆွေးနွေးထားပါတယ်။

### ၆.၁ ပုံမှန် “Install လုပ်ပြီးမှ သုံးရတဲ့” ပုံစံ

အများစု သိကြတဲ့ ပုံစံက ဒီလိုပါ။

| အဆင့် | ဖြစ်လေ့ရှိတာ |
|--------|------------------|
| ၁ | User က **Setup.exe** (သို့) **HoBoPOS_Setup.msi** လို installer ကို run မယ်။ |
| ၂ | Installer က ဖိုင်တွေကို **Program Files** (သို့) ရွေးထားတဲ့ folder မှာ copy မယ်။ |
| ၃ | **Desktop shortcut** နဲ့/သို့မဟုတ် **Start Menu** မှာ “HoBo POS” လို shortcut ထည့်ပေးမယ်။ |
| ၄ | လိုရင် **Add or Remove Programs** (Settings → Apps) မှာ “HoBo POS” ပါပြီး **Uninstall** လုပ်လို့ရမယ်။ |

ဒါကို “အပြည့်အဝ install ပုံစံ” လို့ ပြောလို့ ရပါတယ်။ User က shortcut ကနေ ဖွင့်သုံးပြီး၊ uninstall လုပ်ချင်ရင် Control Panel / Settings ကနေ ဖယ်လို့ရတယ်။

### ၆.၂ လက်ရှိ HoBo POS ရဲ့ ပုံစံ (Portable folder)

အခု build လုပ်ထားတာက **folder တစ်ခုထဲ ထုတ်ပြီး ပေးတဲ့ ပုံစံ** ဖြစ်ပါတယ်။

- **HoBoPOS_Release** folder ကို copy ယူပြီး ဘယ်နေရာမှာမဆို ထားလို့ရတယ်။  
- ဒီ folder ထဲက **HoBoPOS.exe** ကို double‑click လုပ်ရင် app စမယ်။  
- Installer မလို၊ Program Files မှာ မထည့်ရပါဘူး။  
- Uninstall ဆိုတာက folder ကို ဖျက်လိုက်ရင် ပြီးပါတယ်။  

ဒါကို **portable** (သို့) **no-install** ပုံစံ လို့ ခေါ်ပါတယ်။ USB / network share ကနေ run လို့လည်း ရပါတယ်။

### ၆.၃ “Install လုပ်ပြီးမှ သုံးရအောင်” လုပ်ချင်ရင် ရွေးစရာများ

“PC မှာ install လုပ်ပြီးမှ သုံးရတာ” လို ဖြစ်စေချင်ရင် အောက်က နည်းတွေထဲက ရွေးနိုင်ပါတယ်။

| နည်း | ရှင်းလင်းချက် | အားသာချက် | အားနည်းချက် |
|------|------------------|--------------|------------------|
| **A. Installer လုပ်ပေးတဲ့ tool သုံးခြင်း** | **Inno Setup**, **NSIS**, **WiX** စတဲ့ tool တွေနဲ့ Setup.exe (သို့) .msi ထုတ်မယ်။ Install လုပ်ရင် Program Files မှာ copy၊ Desktop/Start Menu shortcut ထည့်၊ Uninstall entry ထည့်မယ်။ | ပုံမှန် Windows software လို ခံစားရတယ်။ Uninstall စနစ်ကျတယ်။ | Script/config ရေးရမယ်။ HoBo POS က DB/media ကို exe folder မှာ သိမ်းတာမို့ Program Files မှာ install လုပ်ရင် **write permission** ပြဿနာ ဖြစ်နိုင်တယ် — ဒါကြောင့် **user folder** (ဥပမာ `%LOCALAPPDATA%\HoBoPOS`) မှာ data သိမ်းအောင် လုပ်ထားရင် ပိုကောင်းတယ်။ |
| **B. “Light install” — shortcut ပဲ ထည့်ခြင်း** | Installer မလုပ်။ script (သို့) small helper က **HoBoPOS_Release** folder ကို user ရွေးတဲ့ နေရာမှာ copy ပြီး Desktop/Start Menu မှာ **HoBoPOS.exe** ကို shortcut ထည့်ပေးမယ်။ | လွယ်တယ်။ Program Files မထိတာမို့ permission ပြဿနာ နည်းတယ်။ | Add/Remove Programs မှာ မပါဘူး။ Uninstall က folder ကို ကိုယ်တိုင် ဖျက်ရမယ်။ |
| **C. MSIX / Store package** | Windows ရဲ့ MSIX package လုပ်ပြီး Store (သို့) side-load ဖြန့်မယ်။ | ခေတ်မီ Windows app ပုံစံ၊ update စနစ်ကောင်းတယ်။ | Packaging နဲ့ certificate စီမံရမယ်။ Desktop app အတွက် လိုအပ်ချက်တွေ ရှိတယ်။ |

### ၆.၄ HoBo POS အတွက် အကြံပြုချက်

- **အခု လက်ရှိ**: **Portable folder (HoBoPOS_Release)** ကို ဆက်သုံးပြီး ဖြန့်လို့ ရပါတယ်။ “Install” မလိုဘဲ folder ကို copy ယူပြီး HoBoPOS.exe run ရင် ရပါတယ်။  
- **“Install လုပ်ပြီးမှ သုံးရအောင်”** လိုချင်ရင်:  
  - **အရင်ဆုံး** **B. Light install** လို shortcut-only (သို့) “folder copy + shortcut” နည်းက လွယ်ပြီး DB/media က exe folder မှာပဲ ရှိတာမို့ permission ပြဿနာ နည်းတယ်။  
  - **Program Files + Add/Remove** လို အပြည့်အဝ install လိုချင်ရင် **A** နည်းသုံးပြီး Installer လုပ်နိုင်ပါတယ်။ ဒီအခါ **data (DB, media)** ကို `%LOCALAPPDATA%\HoBoPOS` (သို့) user ရွေးတဲ့ folder မှာ သိမ်းအောင် app ဘက်က ပြင်ထားရင် အန္တရာယ်နည်းပါတယ်။  

အတိုချုပ်: Windows software တွေမှာ “install လုပ်ပြီးမှ သုံးရတာ” ဆိုတာ Setup/Uninstall + shortcut ပါတဲ့ ပုံစံ ဖြစ်ပါတယ်။ HoBo POS က အခု portable folder ပုံစံ ရှိပြီးသား； လိုရင် installer (Inno/NSIS) သို့မဟုတ် shortcut-only “light install” ထပ်ထည့်ပြီး ဒီပုံစံနဲ့ နီးစပ်အောင် လုပ်လို့ ရပါတယ်။
