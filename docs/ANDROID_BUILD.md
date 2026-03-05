# Android App ထုတ်နည်း (Capacitor)

## လိုအပ်ချက်များ

- **Node.js** 20+ (သို့) 22+
- **Android Studio** (Android SDK + emulator/device အတွက်)
- **Java JDK 11+** (Android Studio နဲ့ပါလာနိုင်)

## ပထမအကြိမ် (Android project မရှိသေးရင်)

```bash
cd "/media/htoo-myat-eain/New Volume1/hobo_license_pos/yp_posf"

# 1. Dependencies ရှိမရှိ စစ်ပါ
npm install

# 2. Web build လုပ်ပါ
npm run build

# 3. Android platform ထည့်ပါ (တစ်ကြိမ်သာ)
npx cap add android

# 4. Web assets ကို Android project ထဲ ကူးပါ
npx cap sync
```

## နောက်ထပ်အကြိမ်တိုင်း (ထုတ်ချင်တိုင်း)

```bash
cd yp_posf

# Build + Sync (တစ်ခါတည်း)
npm run cap:sync

# Android Studio ဖွင့်ပါ
npm run cap:android
```

Android Studio ဖွင့်ပြီးရင်:
- Gradle sync ပြီးသည်အထိ စောင့်ပါ
- Device / Emulator ရွေးပါ
- **Run (▶️)** နှိပ်ပါ

## Backend URL (အရေးကြီး)

- **Emulator:** `http://10.0.2.2:8000` (localhost နေရာ)
- **ဖုန်းအစစ် (ကွန်ပျူတာနဲ့ same WiFi):** ကွန်ပျူတာ IP သုံးပါ ဥပမာ `http://192.168.1.100:8000`
- **Production:** Backend ကို HTTPS domain သတ်မှတ်ပြီး `capacitor.config.ts` မှာ `server.url` ပြင်ပါ

ပြင်ချင်ရင်:
```bash
CAPACITOR_SERVER_URL=http://192.168.1.100:8000 npm run cap:sync
```
သို့မဟုတ် `yp_posf/capacitor.config.ts` ထဲက `server.url` ကို ပြင်ပါ။

## APK / AAB ထုတ်ချင်ရင်

1. Android Studio မှာ **Build → Build Bundle(s) / APK(s) → Build APK(s)** (သို့) **Build App Bundle(s)**
2. Release signing အတွက် keystore သတ်မှတ်ရပါမယ် (Play Store တင်မယ်ဆိုရင်)

## အတိုချုပ်

| လုပ်ချက် | Command |
|-----------|---------|
| Build + Sync | `npm run cap:sync` |
| Android Studio ဖွင့် | `npm run cap:android` |
| ပထမဆုံး Android ထည့်ရန် | `npx cap add android` (တစ်ကြိမ်သာ) |

**အဆင်ပြေနိုင်မလား:** ပြင်ထားပြီးသား။ `npx cap add android` လုပ်ပြီး `npm run cap:sync` → `npm run cap:android` လုပ်ရင် Android Studio ပွင့်ပြီး ထုတ်လို့ရပါပြီ။
