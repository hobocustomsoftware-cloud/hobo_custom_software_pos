# HoBo POS - EXE Packaging (On-Premise)

PyInstaller + Inno Setup ဖြင့် Windows Installer ထုတ်ခြင်း။

## Prerequisites

- Python 3.11+
- Node.js (Vue build)
- PyInstaller: `pip install pyinstaller`
- Inno Setup 6: https://jrsoftware.org/isinfo.php

## Build Steps

```bash
# 1. Vue build
cd ../../yp_posf
npm run build

# 2. Copy static to WeldingProject
# (see build.ps1)

# 3. PyInstaller
cd deploy/installer
pyinstaller welding_pos.spec

# 4. Inno Setup (GUI or CLI)
# Compile welding_pos.iss
```

Or run full build from project root: `.\deploy\installer\build.ps1`

## Output

- `dist/HoBoPOS.exe` - Single EXE (onefile)
- `dist/setup.exe` - Installer (after Inno Setup)

## စမ်းမယ့်စက်ကို ဘာယူရမလဲ

**အလွယ်ဆုံး:** `dist\HoBoPOS.exe` တစ်ဖိုင်တည်း ယူပါ။

## ဆိုင်အမည် နှင့် Logo

- EXE run ပြီး **Settings** → ဆိုင်အမည် နှင့် Logo ကဏ္ဍမှာ ပြင်ဆင်နိုင်သည်
- ပိတ်ထားလိုပါက "ပိတ်ရန် ▲" နှိပ်ပါ
