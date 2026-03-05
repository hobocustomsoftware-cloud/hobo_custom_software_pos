# HoBo POS — လုပ်ငန်းစဉ်: Expo Go → Docker → EXE → ကြော်ငြာ

အဓိက စမ်းသပ်နဲ့ ထုတ်လုပ်မှု လမ်းကြောင်း ဖြစ်ပါတယ်။

---

## လမ်းကြောင်း အကျဉ်း

| အဆင့် | လုပ်ချက် | ရလဒ် |
|--------|-----------|--------|
| **၁** | Expo Go မှာ စမ်းကြည့်ခြင်း | ဖုန်းပေါ်မှာ app အလုပ်လုပ်မလား သိနိုင်မယ် |
| **၂** | Docker မှာ စမ်းကြည့်ခြင်း | Backend + Frontend တစ်ခါတည်း စစ်ဆေးမယ် |
| **၃** | အကုန်အဆင်ပြေပြီဆိုမှ EXE ထုတ်ခြင်း | Windows .exe ဖိုင် ထုတ်မယ် |
| **၄** | ကြော်ငြာ / Marketing အတွက် လုပ်ချက်များ | Screenshot များ၊ ပြင်ဆင်မှုများ |

---

## အဆင့် ၁ — Expo Go မှာ စမ်းကြည့်ခြင်း

### လိုအပ်ချက်များ
- Node.js (^20.19.0 သို့မဟုတ် >=22.12.0)
- ဖုန်းမှာ **Expo Go** app ထည့်ထားရမယ်  
  - [Android](https://play.google.com/store/apps/details?id=host.exp.exponent) | [iOS](https://apps.apple.com/app/expo-go/id982107779)
- Backend စတင်ထားရမယ် (အောက်က နည်း ၂ မျိုးထဲက တစ်မျိုး)

### ၁.၁ ကွန်ပျူတာ IP သတ်မှတ်ခြင်း
ဖုန်းက ကွန်ပျူတာပေါ်က Vue app နဲ့ Backend ကို ချိတ်နိုင်ဖို့ IP လိုပါတယ်။

**အလွယ်:** `yp_posf` ထဲမှာ ပြေးပါ —
```bat
cd yp_posf
node scripts/set-expo-ip.js
```
ဒါက `app.json` ထဲက `extra.apiUrl` နဲ့ `extra.localIp` ကို လက်ရှိ ကွန်ပျူတာ IP နဲ့ အလိုအလျောက် ပြင်ပေးမယ်။

**ကိုယ်တိုင် ပြင်မယ်ဆိုရင်:**  
Windows မှာ `ipconfig` ပြေးပြီး IPv4 Address ယူပါ (ဥပမာ `192.168.1.100`)။  
`yp_posf/app.json` ထဲက `expo.extra` မှာ ထည့်ပါ —
```json
"extra": {
  "apiUrl": "http://192.168.1.100:8000/api",
  "localIp": "192.168.1.100",
  ...
}
```

### ၁.၂ Backend စတင်ခြင်း (နည်း ၂ မျိုး)

**နည်း က** — Django တိုက်ရိုက် (ပရောဂျက် root မှာ):
```bat
cd WeldingProject
python manage.py runserver 0.0.0.0:8000
```

**နည်း ခ** — Docker နဲ့ Backend တစ်ခုတည်း:
```bat
docker-compose up -d postgres redis backend
```
(ပရောဂျက် root က `docker-compose.yml` သုံးပါ။ မစတင်ရသေးရင် အရင် `yp_posf` မှာ `npm run build` ပြေးပြီး `yp_posf/dist` ရှိအောင် လုပ်ထားပါ။)

Backend စစ်ဆေးရန် ဘရောက်ဆာမှာ ဖွင့်ပါ: `http://YOUR_IP:8000/api/` (သို့) `http://localhost:8000/api/`

### ၁.၃ Frontend (Vite) စတင်ခြင်း
```bat
cd yp_posf
npm install
npm run dev
```
Vue app က `http://localhost:5173` မှာ ပေါ်မယ်။

### ၁.၄ Expo စတင်ပြီး ဖုန်းနဲ့ ချိတ်ခြင်း

**တစ်ကွန်ရက်တည်း (Same WiFi):**
```bat
cd yp_posf
npm run expo:start
```
Terminal မှာ ပေါ်တဲ့ **QR code** ကို Expo Go app နဲ့ စကင်န်ပါ။

**မတူညီတဲ့ ကွန်ရက်မှာပဲ စမ်းမယ်ဆိုရင် (Tunnel):**
```bat
cd yp_posf
npm run expo:start:tunnel
```
Tunnel URL / QR ပေါ်လာရင် ဖုန်းမှာ ဖွင့်ပါ။

### ၁.၅ စစ်ဆေးစရာ
- [ ] Backend ဖွင့်ထား (Django သို့ Docker backend)
- [ ] `app.json` ထဲမှာ မှန်တဲ့ IP ထည့်ထား (သို့ `set-expo-ip.js` ပြေးပြီး)
- [ ] `npm run dev` ဖြင့် Vue စတင်ထား
- [ ] `npm run expo:start` (သို့) `expo:start:tunnel` ဖြင့် Expo စတင်ထား
- [ ] ဖုန်းမှာ Expo Go နဲ့ QR စကင်န်ပြီး Login စာမျက်နှာ ပေါ်မလား စစ်ပါ

အဆင်ပြေပြီဆိုမှ **အဆင့် ၂** သို့ သွားပါ။

---

## အဆင့် ၂ — Docker မှာ စမ်းကြည့်ခြင်း

ဒီအဆင့်မှာ Backend + Frontend အားလုံးကို Docker ထဲမှာ စမ်းမယ် (အပြင်မှာ Django/Vite မလိုပါ)။

### ၂.၁ Frontend build ထုတ်ခြင်း
```bat
cd yp_posf
set VITE_API_URL=/api
npm run build
```
`yp_posf/dist` ထဲမှာ build ထွက်ရပါမယ်။

### ၂.၂ Docker Compose စတင်ခြင်း
ပရောဂျက် **root** မှာ:
```bat
docker-compose up -d
```
(ပထမအကြိမ် build ကြာနိုင်ပါတယ်။)

### ၂.၃ စစ်ဆေးခြင်း
- **Frontend (Vue):** ဘရောက်ဆာမှာ `http://localhost` ဖွင့်ပါ (port 80)
- **Backend API:** `http://localhost:8000/api/` ဖွင့်ပါ
- Login ဝင်ပြီး POS လုပ်ငန်းစဉ် စမ်းပါ

### ၂.၄ ပြဿနာရှိရင်
- `yp_posf/dist` မရှိရင် အဆင့် ၂.၁ ပြန်လုပ်ပါ
- Log ကြည့်ရန်: `docker-compose logs -f backend` သို့ `docker-compose logs -f frontend`
- ရပ်ရန်: `docker-compose down`

Docker မှာ အကုန်အဆင်ပြေပြီဆိုမှ **အဆင့် ၃** သို့ သွားပါ။

---

## အဆင့် ၃ — Windows EXE ထုတ်ခြင်း

Expo Go နဲ့ Docker စမ်းပြီး အကုန်အဆင်ပြေမှ EXE ထုတ်ပါ။

### ၃.၁ လိုအပ်ချက်များ
- Python (Django project အတွက်)
- Node (Vue build အတွက်)
- PyInstaller, PyArmor (build script က ထည့်ပေးမယ်)

### ၃.၂ EXE ထုတ်ခြင်း
ပရောဂျက် **root** မှာ:
```bat
build_exe.bat
```
ဒီ script က —
1. Vue ကို `VITE_BASE=/app/` နဲ့ build လုပ်မယ်  
2. `WeldingProject/static_frontend` ကို copy လုပ်မယ်  
3. Python deps (waitress, pyinstaller, pyarmor) ထည့်မယ်  
4. PyArmor နဲ့ obfuscate လုပ်မယ်  
5. PyInstaller နဲ့ EXE ထုတ်မယ်  

ပြီးရင် `HoBoPOS_Release` ဖိုလ်ဒါထဲမှာ `HoBoPOS.exe` ရမယ်။

### ၃.၃ စစ်ဆေးခြင်း
- `HoBoPOS_Release\HoBoPOS.exe` ကို run ပြီး app ပွင့်မလား စစ်ပါ
- DB နဲ့ media က release ဖိုလ်ဒါအတွင်းမှာ သိမ်းမယ်

---

## အဆင့် ၄ — ကြော်ငြာ / Marketing အတွက် လုပ်ချက်များ

### ၄.၁ Marketing Screenshots (အလိုအလျောက်)
Backend + Frontend စတင်ပြီး စာမျက်နှာအလိုက် screenshot များ ရိုက်မယ်။

ပရောဂျက် **root** မှာ:
```bat
run_marketing_screenshots.bat
```
(သို့) `node run_marketing_screenshots.mjs`

ဒါက —
- Backend (Django) စတင်မယ်  
- Frontend (Vite) စတင်မယ်  
- Playwright နဲ့ login + စာမျက်နှာများ သွားပြီး screenshot များ ယူမယ်  
- ရလဒ်များကို `yp_posf/screenshots_for_marketing/run_YYYY-MM-DD_HH-mm-ss/` ထဲမှာ သိမ်းမယ်  

### ၄.၂ လုပ်နိုင်သည့် အခြား လုပ်ချက်များ
- **Playwright E2E screenshots:** `cd yp_posf` then `npm run screenshots` (marketing spec အတွက်)
- **Slideshow /ြသမှု:** ရှိပြီးသား simulation/slideshow script များ သုံးပြီး screenshot များကနေ ပြင်ဆင်နိုင်ပါတယ်
- **App icon / Splash:** `yp_posf/assets` ထဲက icon/splash ပြင်ပြီး `expo` / `capacitor` config များ ညှိပါ

---

## အတိုချုပ် စီးရီးလ်အစဉ်

1. **Expo Go:** IP သတ်မှတ် → Backend စတင် → `npm run dev` → `npm run expo:start` → ဖုန်းနဲ့ QR စကင်န်  
2. **Docker:** `yp_posf` မှာ `npm run build` → root မှာ `docker-compose up -d` → `http://localhost` နဲ့ စမ်းပါ  
3. **EXE:** root မှာ `build_exe.bat` ပြေးပြီး `HoBoPOS_Release\HoBoPOS.exe` စမ်းပါ  
4. **Marketing:** root မှာ `run_marketing_screenshots.bat` ပြေးပြီး `yp_posf/screenshots_for_marketing` ထဲက screenshot များ သုံးပါ  

အသေးစိတ် Expo + Docker လှည့်ကွက်များအတွက်: `docs/DOCKER_EXPO_GO_TESTING.md` ကို ကြည့်ပါ။
