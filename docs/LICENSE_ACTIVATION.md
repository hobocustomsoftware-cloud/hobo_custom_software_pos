# License Key ဖြည့်သွင်းခြင်း (Activation)

## ၁။ License key တစ်ခု ထုတ်ယူခြင်း (run_lite / local DB အတွက်)

Project root မှာ အောက်ပါအတိုင်း run ပါ။

```bash
cd F:\hobo_license_pos
.\venv\Scripts\Activate.ps1
cd WeldingProject
$env:HOBOPOS_DB_DIR = "F:\hobo_license_pos"
python manage.py create_license --type on_premise_perpetual
```

ထွက်လာတဲ့ **Key** ကို ကူးထားပါ။ ဥပမာ: `WLD-A1B2C3D4E5F6G7H8-I9J0K1L2`

- `--type on_premise_perpetual` = သက်တမ်းမကုန် (perpetual)
- `--type hosted_annual --years 1` = ၁ နှစ်သက်တမ်း
- `--type trial` = trial

---

## ၂။ App မှာ License ဖြည့်ခြင်း

1. Server ဖွင့်ထားပါ: `.\run_lite.bat`
2. Browser ဖွင့်ပြီး သွားပါ: **http://127.0.0.1:8000/app/license-activate**
3. **License Key** ကွက်ထဲမှာ ထုတ်ထားတဲ့ key ကို ထည့်ပါ (ဥပမာ `WLD-A1B2C3D4E5F6G7H8-I9J0K1L2`)
4. **Activate** ခလုတ် နှိပ်ပါ။
5. အောင်မြင်ရင် "License Activate အောင်မြင်ပါပြီ။"ြပြီး Login စာမျက်နှာကို ပြောင်းသွားမယ်။

---

## ၃။ License မရှိလို့ ပြနေတဲ့အခါ

App က license မရှိရင် (သို့) သက်တမ်းကုန်ရင် **License Activation** စာမျက်နှာကို ညွှန်ပြတတ်ပါတယ်။  
Settings မှာ "License သို့ သွားရန်" လင့်ကိုလည်း သုံးနိုင်ပါတယ်။

---

## ၄။ EXE / License Server သုံးမယ်ဆိုရင်

EXE က **License Server** (အပြင်ဆာဗာ) နဲ့ ချိတ်မယ်ဆိုရင်:

- EXE ရဲ့ folder မှာ `HoBoPOS.ini` ဖွင့်ပြီး အောက်ပါအတိုင်း ထည့်ပါ:
  ```ini
  [hobopos]
  LICENSE_SERVER_URL=https://your-license-server.com
  ```
- Server ဘက်မှာ `remote-activate` API ကို ဖွင့်ထားရပါမယ်။ (အသေးစိတ်: `G:\hobo_website\docs\LICENSE_INTEGRATION.md`)

Local (run_lite) မှာတော့ **LICENSE_SERVER_URL မထားပါနဲ့**။ ထားရင် key ကို local DB မစစ်ပဲ server ကိုပဲ ခေါ်မယ်။
