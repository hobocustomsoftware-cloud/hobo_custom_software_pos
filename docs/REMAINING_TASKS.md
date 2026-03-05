# ကျန်နေသော / ပြီးသော အချက်များ (Remaining & Done)

**နောက်ဆုံး စစ်ဆေးချက်:** 2026-02-21

---

## ဒီအကြိမ် ပြင်ပြီးသော အချက်များ

| အချက် | လုပ်ချက် |
|--------|-----------|
| **Capacitor appId** | `capacitor.config.json` ထဲက appId ကို `com.hobo.pos` မှ `com.hobopos.app` ပြောင်းပြီး (Expo / capacitor.config.ts နဲ့ ညီအောင်) |
| **Router imports** | `yp_posf/src/router/index.js` ထဲက `../views/...` အားလုံးကို `@/views/...` ပြောင်းပြီး |
| **README_SIMULATION** | Frontend URL ကို `localhost:8080` မှ `localhost:5173` ပြောင်းပြီး |
| **Prettier script** | `package.json` ထဲက format script မှ `--experimental-cli` ဖယ်ပြီး |

---

## လုပ်ပြီးသော လုပ်ငန်းစဉ်များ (အရင် ဆွေးနွေးချက်များမှ)

- Expo Go + Docker စတင်ခြင်း (roadmap, script, set-expo-ip)
- Register / Login testing (backend tests, E2E, testing guide)
- 401/404 ပြင်ဆင်ခြင်း (offlinePos token check, shop-settings resilience, license skip)
- ROADMAP: Expo Go → Docker → EXE → Marketing

---

## ကျန်နေနိုင်သော / စစ်ဆေးသင့်သော အချက်များ

### ကုဒ် / Config

- **TypeScript:** လက်ရှိ `tsconfig.json` က Expo base ကို extends လုပ်ထားပြီး၊ Vue စာများက .js ဖြစ်နေတယ်။ နောက်မှ TypeScript သုံးမယ်ဆိုရင် Vue-friendly tsconfig ထည့်ပါ။
- **Vite alias `@`:** လက်ရှိ `'@': '/src'` က အများအားဖြင့် အလုပ်လုပ်ပါတယ်။ Windows မှာ ပြဿနာရှိရင် `path.resolve` သုံးပါ။
- **Expo production URL:** `app.json` ထဲက `extra.appUrl` ကို production deploy မှာ domain အစစ်နဲ့ ပြင်ပါ။

### လည်ပတ်မှု / Testing (လိုမှ လုပ်ရန်)

- **Full simulation run** – `run_simulation.ps1` သို့မဟုတ် Docker simulation ပြေးပြီး ဒေတာ + screenshot စစ်ပါ။
- **Backup restore testing** – `deploy/backup/` script များ ပြေးပြီး restore စမ်းပါ။
- **Offline mode** – လက်ဖြင့် offline ဖွင့်ပြီး POS သုံးစွဲမှု စစ်ပါ။
- **Backend tests** – `python manage.py test core.tests` (venv + Django ပြည့်စုံတဲ့ environment မှာ)။

### Production မတိုင်မီ

- `AUDIT_SUMMARY.md` ထဲက **Production Deployment Checklist** အတိုင်း: SECRET_KEY, ALLOWED_HOSTS, DB/Redis password, SSL, backup schedule စသည်တို့ ပြည့်မီအောင် စစ်ပါ။

---

## အတိုချုပ်

- **ပြင်ပြီး:** Capacitor appId, Router `@/views`, README port 5173, Prettier script။
- **ကျန်နေနိုင်:** TypeScript ချဲ့ခြင်း, production env သတ်မှတ်ခြင်း, simulation/backup/offline စမ်းသပ်ခြင်း။
- **အသေးစိတ်:** `AUDIT_SUMMARY.md`, `docs/ROADMAP_EXPO_DOCKER_EXE_MARKETING.md`, `docs/TESTING_REGISTER_LOGIN.md` ကြည့်ပါ။
