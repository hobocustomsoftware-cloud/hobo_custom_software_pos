# HoBo POS — လုံခြုံရေး နဲ့ ကာကွယ်မှု (Cracker / ဖိုင် ခိုးသုံး / Source မပါအောင်)

Portable ထက် ပိုလုံခြုံပြီး — **cracker/hacker အန္တရာယ် လျော့စေ**၊ **ဖိုင်တွေကို ခိုးသုံးလို့မရအောင်**၊ **developer တွေ ဝင်ဖတ်လို့မရအောင် / source code မပါသွားအောင်** — ဘယ်လိုလုပ်လို့ရနိုင်မလဲ ဆိုတာ ဒီစာစောင်မှာ ချုံငုံဆွေးနွေးထားပါတယ်။

---

## ၁။ Source Code မပါသွားအောင် / ဖတ်လို့မရအောင်

### ၁.၁ လက်ရှိ PyInstaller build မှာ

- PyInstaller က **.py ဖိုင်တွေကို distribute မလုပ်ပါ**။ Python module တွေကို **bytecode** (.pyc) အဖြစ် bundle လုပ်ပါတယ်။  
- ဒါကြောင့် “source code ဖိုင်တွေ” က exe/folder ထဲမှာ **မပါပါဘူး**။  
- ဒါပေမယ့် Python **bytecode ကို decompile** လုပ်လို့ ရနိုင်ပါတယ် (uncompyle6, pycdc စသည့် tool တွေနဲ့)။ ဒါကြောင့် **အပြည့်အဝ ကာကွယ်ချက် မဟုတ်ပါ**။

### ၁.၂ ပိုကောင်းအောင် လုပ်ချင်ရင် (Source / logic ဖတ်မရအောင်)

| နည်း | ရှင်းလင်းချက် | အားသာချက် | အားနည်းချက် |
|------|------------------|--------------|------------------|
| **Nuitka** | Python ကို **C** သို့ compile ပြီး native binary ထုတ်မယ်။ .exe ထဲမှာ Python bytecode မပါဘူး။ | Reverse engineer လုပ်ရ ခက်တယ်။ Performance ကောင်းတယ်။ | Build ကြာတယ်။ Django/PyInstaller လို လမ်းကြောင်း အနည်းငယ် ပြင်ရနိုင်တယ်။ |
| **Cython** | Critical .py တွေကို .pyx ပြောင်းပြီး **C extension** (.pyd) ထုတ်မယ်။ Distribution မှာ .pyd ပဲ ပါမယ်။ | ထိမ်းချုပ် လွယ်တယ်။ အရမ်းအရေးကြီးတဲ့ module တွေပဲ လုပ်လို့ရတယ်။ | ပြင်ဆင်မှု လုပ်ရမယ်။ |
| **PyArmor** | Bytecode ကို **obfuscate** လုပ်ပြီး run မယ်။ Decompile လုပ်ရ ခက်သွားမယ်။ | PyInstaller နဲ့ အတူ သုံးလို့ရတယ်။ | ၁၀၀% မကာကွယ်နိုင်ပါ။ Paid version မှာ feature ပိုရတယ်။ |

**အကြံပြုချက်**  
- **အခု**: PyInstaller နဲ့ build လုပ်ထားရင် **source .py မပါပါ** (bytecode ပဲ ပါတယ်)။  
- **ပိုကာကွယ်ချင်ရင်**: **Nuitka** နဲ့ .exe ထုတ်ပြီး Python လုံးဝ မပါအောင် လုပ်မယ် (သို့) **PyArmor** နဲ့ bytecode ကို obfuscate လုပ်မယ်။  

---

## ၂။ Cracker / Hacker အန္တရာယ် လျော့စေခြင်း

- **Code ဖတ်မရအောင်**: ဒီအတွက် အပေါ်က ၁.၂ (Nuitka / Cython / PyArmor) ကို သုံးပါ။  
- **Tamper / crack မလုပ်နိုင်အောင်**:  
  - **Code signing** (Windows Authenticode): .exe ကို sign လုပ်ထားရင် ပြင်ထားတဲ့ copy က “signature invalid” ဖြစ်ပြီး user သတိထားမိနိုင်တယ်။  
  - **Integrity check**: App စတင်တိုင်း (သို့) ကြားချန် checksum / hash စစ်ပြီး ပြင်ထားရင် run မလုပ်အောင် လုပ်လို့ရတယ် (ဒါကို obfuscate နဲ့ အတူ သုံးရင် ပိုကောင်းတယ်)။  
- **Secret / key**: API key, license secret စသည်ကို code ထဲမှာ plain text မထားပါနဲ့။ Windows မှာ **DPAPI** သုံးပြီး encrypt သိမ်းပါ (သို့) server ဘက်မှာ validate လုပ်ပါ။  

---

## ၃။ ဖိုင်တွေကို လုံးဝ ခိုးသုံးလို့မရအောင် (Data / DB)

ဆိုလိုတာက: **App folder (သို့) DB/media ကို copy ယူပြီး အခြား PC မှာ သုံးလို့မရအောင်** လုပ်ချင်တာပါ။

### ၃.၁ လက်ရှိ (License + machine_id)

- သင်တို့ project မှာ **license** နဲ့ **machine_id** သတ်မှတ်ထားပြီးသား။  
- License က **machine_id** နဲ့ bind လို့ စက်တစ်လုံးမှာ သုံးရင် အခြားစက်မှာ (license မပါဘဲ) သုံးလို့မရအောင် လုပ်ထားလို့ရတယ်။  
- ဒါက **app သုံးခွင့်** ကို ကာကွယ်တာပါ။ ဖိုင် (DB/media) ကို copy ယူပြီး အခြား app နဲ့ ဖွင့်သုံးတာကို မတားနိုင်သေးပါ။  

### ၃.၂ DB / Media ကို စက်ချည်ပြီး encrypt လုပ်ခြင်း

**ရည်ရွယ်ချက်**: DB နဲ့ အရေးကြီး data ကို **machine_id (သို့) စက်နဲ့ ချည်ထားတဲ့ key** နဲ့ encrypt လုပ်ထားမယ်။  
ဒါဆို ဖိုင်တွေကို copy ယူပြီး အခြား PC မှာ သုံးရင် **key မကိုက်တာမို့ decrypt မရဘူး** → ခိုးသုံးလို့ မရအောင် လုပ်လို့ရတယ်။  

**ရွေးစရာများ**:

| နည်း | ရှင်းလင်းချက် |
|------|------------------|
| **SQLCipher** | SQLite DB ကို encrypt လုပ်တဲ့ format။ Key ကို `machine_id` ကနေ derive လုပ်ပြီး သတ်မှတ်မယ်။ Django မှာ `django-sqlcipher` (သို့) `pysqlcipher3` သုံးပြီး DB engine ပြောင်းမယ်။ |
| **Custom encryption** | `db.sqlite3` ဖိုင်ကို ဖတ်တဲ့/ရေးတဲ့ နေရာမှာ encrypt/decrypt လုပ်မယ်။ Key = `hash(machine_id + salt)`။ SQLite ကို file-based သုံးရင် startup မှာ decrypt to temp၊ shutdown မှာ encrypt back (သို့) in-memory DB + encrypt at rest လိုမျိုး ဒီဇိုင်းလုပ်မယ်။ |

**အကြံပြုချက်**  
- **SQLCipher** သုံးရင် Django DB backend ပြောင်းပြီး key ကို `machine_id` ကနေ derive လုပ်ထားရင် — DB ဖိုင်ကို copy ယူပြီး အခြား PC မှာ key မရှိရင် ဖွင့်လို့မရပါ။  
- Media ဖိုင်တွေကိုလည်း လိုရင် **အလားတူ key** နဲ့ encrypt သိမ်းပြီး app ကနေ ဖတ်တဲ့အခါ decrypt လုပ်လို့ရပါတယ်။  

---

## ၄။ Developer ဝင်ဖတ်လို့မရအောင်

- **Distribute လုပ်တဲ့ build ထဲမှာ** .py source မပါအောင် လုပ်ထားပြီးသား (PyInstaller က bytecode ပဲ ထည့်တယ်)။  
- **ပိုမကာကွယ်ချင်ရင်**:  
  - **Nuitka** သုံးပြီး native binary ထုတ်မယ် → Python structure ပါ မပါတော့ဘူး။  
  - **PyArmor** သုံးပြီး bytecode ကို obfuscate လုပ်မယ် → developer/cracker ဖတ်ရ ခက်သွားမယ်။  

ဒီနှစ်ခုထဲက တစ်ခု (သို့) နှစ်ခုလုံး လုပ်ထားရင် “developer ဝင်ဖတ်လို့မရအောင်” ပန်းတိုင်နဲ့ နီးစပ်သွားမယ်။  

---

## ၅။ အတိုချုပ်

| ပန်းတိုင် | လုပ်နည်း (ရွေးစရာ) |
|------------|------------------------|
| **Source code မပါသွားအောင်** | PyInstaller = bytecode ပဲ ပါတယ် (.py မပါ)။ ပိုကာကွယ်ချင်: **Nuitka** သို့မဟုတ် **PyArmor**။ |
| **Cracker / hacker အန္တရာယ် လျော့** | Nuitka/PyArmor + **code signing** + secret မထားပါနဲ့ (DPAPI သို့ server validate)။ |
| **ဖိုင်တွေ ခိုးသုံးလို့မရအောင်** | **License + machine_id** (လက်ရှိ) + **DB/media ကို machine-bound key နဲ့ encrypt** (SQLCipher သို့မဟုတ် custom encryption)။ |
| **Developer ဝင်ဖတ်လို့မရအောင်** | Build ထဲမှာ source မပါအောင် လုပ်ပြီး **Nuitka** သို့မဟုတ် **PyArmor** သုံးပါ။ |

ဒီအဆင့်တွေကို အစဉ်လိုက် (ဥပမာ PyArmor → build → code sign; DB encryption ကို Django settings + SQLCipher နဲ့) ထည့်သွင်းပြီး လက်တွေ့ လုပ်လို့ ရပါတယ်။

---

## ၆။ ကိုယ်တိုင် ပြန်ပြင်လို့ရနေရမယ် — ဘယ်ဟာ ကောင်းမလဲ

“ငါကိုယ်တိုင် ပြန်ပြင်လို့ရနေရမယ်” ဆိုရင် — **source code က သင့်ဆီမှာပဲ ရှိတယ်**၊ bug ပြင်ရင်/feature ထပ်ထည့်ရင် **ပြင်ပြီး ပြန် build** လုပ်ရုံပဲ ဖြစ်ရမယ်။ ဒီထဲက ဘယ်နည်းက ကိုယ်တိုင် ထိန်းလို့ အကောင်းဆုံးလဲ ယှဉ်ပြပါမယ်။

### ယှဉ်ကြည့်ချက် (ကိုယ်တိုင် ပြင်လို့ရမှု)

| နည်း | ပြင်လို့ရမှု | မှတ်ချက် |
|------|------------------|------------|
| **PyInstaller (လက်ရှိ)** | ✅ အကောင်းဆုံး | .py ပြင်ပြီး `build_exe.bat` ပြန် run ရုံ။ ဘာမှ ပိတ်မထားပါ။ |
| **PyArmor** | ✅ ကောင်းတယ် | Source က သင့်ဆီမှာပဲ။ Bug ပြင်ရင် .py ပြင်ပြီး pyarmor obfuscate ပြန်လုပ်ပြီး PyInstaller build ပြန်လုပ်ရုံ။ Script တစ်ခု ရေးထားရင် အဆင်ပြေတယ်။ |
| **Nuitka** | ⚠️ လုပ်လို့ရတယ်၊ build ပိုဂရုစိုက်ရတယ် | Source က သင့်ဆီမှာပဲ။ ပြင်ပြီး Nuitka ပြန် compile ရုံ။ ဒါပေမယ့် Nuitka + Django + ဖိုင်အများကြီး ဆိုရင် build script / path / dependency ပြဿနာ တက်တတ်တယ်။ ပြင်ပြီး run မရရင် debug က PyInstaller ထက် ခက်တယ်။ |
| **SQLCipher (DB encrypt)** | ✅ ကောင်းတယ် | Key ကို သင်က `machine_id` ကနေ derive လုပ်ထားတာမို့ logic က သင့်မှာပဲ။ DB schema / Django code ပြင်လို့ ရတယ်။ Dev မှာ encrypt ပိတ်ထားပြီး သာမာန် SQLite သုံးလို့ရတယ်။ |
| **Code signing** | ✅ ရိုးရှင်းတယ် | Certificate သင့်ဆီမှာပဲ။ Build ပြီးတိုင်း sign ထည့်ရုံ။ ပြင်စရာ code မဟုတ်ပါ။ |

### အကြံပြုချက် (ကိုယ်တိုင် ပြန်ပြင်လို့ရနေရမယ်ဆိုရင်)

1. **Source / logic ဖတ်မရအောင် (ပြင်လို့လွယ်ချင်)**  
   → **PyArmor** က အကောင်းဆုံးနီးပါး။  
   - Source မပြောင်းဘူး၊ build မှာ obfuscate → PyInstaller လုပ်ရုံ။  
   - ပြင်ချင်ရင် .py ပြင်ပြီး ဒီအဆင့်တွေပဲ ပြန် run ရုံ။ Nuitka လို C compiler / path ပြဿနာ နည်းတယ်။  

2. **ဖိုင်တွေ ခိုးသုံးမရအောင် (ကိုယ်တိုင် ထိန်းလို့ရမယ်)**  
   → **SQLCipher** (သို့) **machine_id နဲ့ key derive လုပ်ပြီး DB encrypt** က ကောင်းတယ်။  
   - Key logic က သင်ရေးထားတာမို့ ပြင်လို့ရတယ်၊ dev မှာ encrypt ပိတ်ထားပြီး သာမာန် SQLite သုံးလို့ရတယ်။  

3. **အပြည့်အဝ ကာကွယ်ချင်၊ build ဂရုစိုက်လို့ရမယ်**  
   → **Nuitka** သုံးလို့ရတယ်။ ဒါပေမယ့် ကိုယ်တိုင် ပြင်လို့ရနေရမယ်ဆိုရင် build script ကို သေသေချာချာ ထားပြီး (ဥပမာ CI မှာ run မယ်)၊ ပထမ Nuitka နဲ့ exe ထွက်အောင် လုပ်ပြီးမှ ရွေးသင့်တယ်။  

**အတိုချုပ်**: **ကိုယ်တိုင် ပြန်ပြင်လို့ရနေရမယ်** ဆိုရင် **PyArmor** (code ဖတ်မရအောင်) + **SQLCipher / machine-bound DB encrypt** (ဖိုင် ခိုးသုံးမရအောင်) က ထိန်းလို့ အကောင်းဆုံးနဲ့ နီးပါးပါ။ Nuitka က ကာကွယ်မှု အားကောင်းပေမယ့် build နဲ့ debug ပိုဂရုစိုက်ရပါတယ်။

---

## ၇။ လက်ရှိ ထည့်သွင်းပြီး (Implemented)

ဒီ project မှာ **ကောင်းတာနဲ့သာ** အောက်က နှစ်ခုကို ထည့်ပြီးသား။

| ကာကွယ်မှု | လုပ်ထားပုံ |
|-------------|----------------|
| **PyArmor** | `build_exe.bat` run လိုက်ရင် အဆင့် ၄ မှာ `run_server.py` နဲ့ package တွေ (WeldingProject, license, core, …) ကို obfuscate လုပ်ပြီး `build_obf/` ထဲ ထုတ်မယ်။ PyInstaller က `build_obf` ရှိရင် ဒီ code ကို သုံးပြီး exe ထုတ်မယ်။ |
| **DB encrypt (machine_id)** | EXE mode မှာ DB ကို **စက်ချည်ထားတဲ့ key** နဲ့ encrypt လုပ်မယ်။ `run_server.py` မှာ: စတင်တဲ့အခါ `db.sqlite3.enc` ရှိရင် decrypt လုပ်ပြီး `db.sqlite3` ဖန်တီးမယ်၊ server ပိတ်တဲ့အခါ `db.sqlite3` ကို encrypt ပြီး `db.sqlite3.enc` သိမ်းမယ်။ Key က `machine_id` ကနေ derive လုပ်တာမို့ ဖိုင်ကို copy ယူပြီး အခြား PC မှာ ဖွင့်လို့မရပါ။ |

PyArmor မလိုချင်ရင်: `WeldingProject\build_obf` folder ကို ဖျက်ပြီး `pyinstaller HoBoPOS.spec` run ရင် သာမာန် (မထိန်းချုပ်ထားတဲ့) code နဲ့ build ထုတ်မယ်။
