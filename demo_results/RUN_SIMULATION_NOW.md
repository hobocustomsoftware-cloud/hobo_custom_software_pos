# Simulation + Screenshot ကိုယ်တို့ စမ်းနည်း

**ကျွန်တော် စမ်းပြီးပါပြီ။** ဒီစက်မှာ **Node.js / npx မရှိ**တာကြောင့် browser ဖွင့်ပြီး Playwright မပြေးနိုင်ပါ။ Screenshot များ မရသေးပါ။

---

## ၁။ Node.js တပ်ဆင်ပါ (တစ်ခါပဲ)

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y nodejs npm

# သို့မဟုတ် Node 20 LTS (အကြံပြု)
# https://nodejs.org မှ ဒေါင်းပြီး install ပါ
```

---

## ၂။ Backend စတင်ပါ

Terminal ၁ မှာ:

```bash
cd "/media/htoo-myat-eain/New Volume/hobo_license_pos"
source venv/bin/activate
cd WeldingProject
python manage.py runserver 0.0.0.0:8000
```

ဒီ terminal ကို ဖွင့်ထားပါ။

---

## ၃။ Simulation + Screenshot ပြေးပါ

Terminal ၂ (အသစ်) မှာ:

```bash
cd "/media/htoo-myat-eain/New Volume/hobo_license_pos"
chmod +x scripts/run_simulation_screenshots.sh
./scripts/run_simulation_screenshots.sh
```

Browser ပွင့်ပြီး Register → Setup → feature list → daily report အထိ သွားမယ်၊ screenshot များ ယူမယ်။

---

## ၄။ Screenshot ကြည့်မယ်

```bash
ls -la demo_results/simulation_screenshots/
# အတွင်းက 2025-03-03_xx-xx-xx/ folder ထဲမှာ 00_login.png, 00_register_filled.png, ... ရပါမယ်
```

---

အတိုချုပ်: **Node.js တပ်ဆင်ပြီး** အောက်က ၂ ချက်လုပ်ပါ — (၁) Backend run ထားပါ၊ (၂) `./scripts/run_simulation_screenshots.sh` ပြေးပါ။
