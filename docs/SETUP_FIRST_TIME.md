# ပထမဆုံး တစ်ခါတည်း Setup (စက်အသစ် / Python မရှိသေးတဲ့စက်)

စက်အသစ်မှာ (သို့မဟုတ် Python ကို ထပ်ခါထပ်ခါ download မလုပ်ချင်ရင်) **တစ်ခါတည်း setup** လုပ်ပြီး ဘာ error မှ မရှိဘဲ သုံးလို့ရအောင် လုပ်နည်း။ **virtualenv** package မလိုပါ - Python ရဲ့ built-in **venv** သုံးပါတယ်။

---

## ၁) Python ထည့်ခြင်း (တစ်ခါပဲ)

- https://www.python.org/downloads/ ကနေ **Python 3.10** သို့မဟုတ် **3.11** ဆွဲပါ။  
- Install လုပ်ရင် **"Add Python to PATH"** ကို ရွေးထားပါ။  
- ပြီးရင် CMD/PowerShell မှာ `python --version` သို့မဟုတ် `py -3 --version` ရရင် အောင်မြင်ပါပြီ။  

(စက်မှာ Python ရှိပြီးသား ဆိုရင် ဒီအဆင့် ကျော်ပါ။)

---

## ၂) တစ်ခါတည်း Setup (venv + dependencies + migrate)

**Repo root** မှာ ဒီဖိုင်ကို တစ်ခါ run ပါ:

```
setup_one_time.bat
```

**ဒီ script က ဘာလုပ်သလဲ:**

1. **Python ရှိမရှိ စစ်မယ်** (py -3, python, python3)  
2. **venv ဖန်တီးမယ်** – `python -m venv venv` (built-in venv သုံးတယ်၊ virtualenv package မလို)  
3. **pip နဲ့ dependencies တပ်မယ်** – `WeldingProject\requirements.txt`  
4. **migrate ပြေးမယ်** – DB ပြင်ဆင်ပြီး သုံးလို့ရမယ်  

Error ထွက်ရင် script က အဆင့်အလိုက် ပြမယ်။ များသောအားဖြင့် Python မရှိရင် ဒီ script က "Python not found"ြပြီး python.org ကနေ ထည့်ခိုင်းမယ်။  

---

## ၃) Setup ပြီးရင် သုံးနည်း

| လုပ်ချင် | ပြေးရမယ့် ဖိုင် |
|----------|---------------------|
| Server စပြီး app သုံးမယ် | **run_lite.bat** (browser က http://127.0.0.1:8000/app/ ဖွင့်ပေးမယ်) |
| CLI simulation စစ်မယ် | **scripts\run_cli_simulate_exe.bat** (သို့မဟုတ် `--start-server` ထည့်ပြီး) |
| EXE ထုတ်မယ် | **build_exe.bat** |

ဒီ batch တွေက **venv ရှိရင် အလိုအလျောက် venv သုံးပါတယ်**။ ထပ်ပြီး virtualenv ထည့်စရာ မလိုပါ။  

---

## အတိုချုပ်

1. **Python 3.10+** ထည့်ပါ (PATH ထဲ ပါအောင်)။  
2. Repo root မှာ **setup_one_time.bat** တစ်ခါ ပြေးပါ။  
3. ပြီးရင် **run_lite.bat** နဲ့ server စပြီး သုံးပါ (သို့မဟုတ် scripts\run_cli_simulate_exe.bat နဲ့ စစ်ပါ)။  

**virtualenv မလိုပါ** – Python ရဲ့ built-in `venv` ကို သုံးထားပါတယ်။
