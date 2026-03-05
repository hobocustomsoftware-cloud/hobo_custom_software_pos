# HoBo POS - Error Report

**Date:** 2026-02-15  
**Status:** ပြဿနာများ ပြင်ဆင်ပြီး။ venv သုံးပြီး EXE build အောင်မြင်ပြီး။ Portable exe launcher ထည့်ပြီး။

---

## ၁။ ရှာတွေ့ထားသော Error များ

### 1.1 ModuleNotFoundError: No module named 'requests'

**Location:** `license/views.py`  
**Cause:** `welding_env` မှာ `requests` မထည့်ထားခြင်း  

**Fix:** venv အသစ် ဖန်တီးပြီး install လုပ်ပါ။ ✅ (venv သုံးပြီး)

---

### 1.2 PyInstaller: Spec file "welding_pos.spec" not found

**Location:** `deploy/installer/build.ps1`  
**Cause:** Step 5 မတိုင်မီ `Set-Location $DeployInstaller` မလုပ်ထားခြင်း။ PyInstaller က `WeldingProject` folder မှာ run သွားပြီး spec မတွေ့ခြင်း။  

**Fix:** `build.ps1` မှာ Step 5 မတိုင်မီ `Set-Location $DeployInstaller` ထည့်ပြီး။ ✅ (ပြင်ပြီး)

---

### 1.3 make_icon.py PermissionError: [WinError 32]

**Location:** `deploy/installer/make_icon.py`  
**Cause:** `logo_png_public` (yp_posf/public/logo.png) ကို copy လုပ်တဲ့အခါ ဖိုင်ကို အခြား process (ဥပမာ Vite) က သုံးနေခြင်း။  

**Fix:** `try/except OSError` ထည့်ပြီး file in use ဖြစ်ရင် skip လုပ်မယ်။ ✅ (ပြင်ပြီး)

---

### 1.4 PyInstaller / venv ပြဿနာ

**Fix:** venv အသစ် ဖန်တီးပြီး (venv နာမည်) PyInstaller ထည့်ပါ။ ✅ (ပြင်ပြီး)

---

### 1.5 Inno Setup: The system cannot find the file specified

**Fix:** venv + PyInstaller ပြင်ပြီး build အောင်မြင်ပြီး။ ✅

---

### 1.6 Unapplied migrations (customer, service)

**Location:** Django  
**Cause:** Model ပြောင်းပြီး migration မလုပ်ထားခြင်း။  

**Fix:** `makemigrations` + `migrate` လုပ်ပြီး။ ✅

---

## ၂။ CLI User Simulation (အောင်မြင်ခဲ့သော)

| Endpoint | Method | Result |
|----------|--------|--------|
| `/health/` | GET | ✅ 200 OK |
| `/health/ready/` | GET | ✅ 200 OK |
| `/api/license/status/` | GET | ✅ trial, can_use |
| `/api/core/register/` | POST | ✅ 201 (new user) |
| `/api/token/` | POST | ✅ (login) |

---

## ၃။ လက်ရှိ အသုံးပြုရန်

- **Venv:** `venv` (project root) – `install_deps.bat` သို့မဟုတ် `venv\Scripts\pip install -r WeldingProject\requirements.txt`
- **EXE build:** `.\deploy\installer\build.ps1` သို့မဟုတ် `.\deploy\installer\clean_rebuild.bat`
- **Portable:** `.\deploy\portable\setup_embedded.ps1` → `deploy\portable\output\` မှာ `launch.bat` သို့မဟုတ် `Start_HoBoPOS.bat` / `HoBoPOS.exe run`

---

## ၄။ ပြင်ဆင်ပြီးသား ဖိုင်များ

- `deploy/installer/build.ps1` – Set-Location, venv path, make_icon အတွက် venv python (Pillow)
- `deploy/installer/make_icon.py` – PermissionError try/except
- `deploy/portable/setup_embedded.ps1` – WinSW ဒေါင်းပြီး HoBoPOS.exe launcher ထွက်အောင်
- `install_deps.bat`, `run_lite.bat`, `run_lite.ps1`, `deploy/installer/check_deps.bat` – venv ဦးစားပေး
