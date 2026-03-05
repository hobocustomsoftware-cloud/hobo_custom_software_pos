# ဒီဇိုင်းချိန်ညှိမှု (Design Consistency) နဲ့ Capacitor Native App ဆွေးနွေးချက်

## ၁။ လက်ရှိ ဒီဇိုင်းဘယ်မှာရှိသလဲ

- **Dashboard စာမျက်နှာ တစ်ခုတည်း** မှာပဲ Apple-style Glassmorphism + Bento Grid သုံးထားပါတယ်။  
  (အနီရောင်အပြာရ gradient၊ `rounded-[2rem]`, `bg-white/10`, `backdrop-blur-2xl`, စသည်)
- **ကျန်စာမျက်နှာများ** (Sales, Inventory, Products, Locations, Users, Reports, စသည်) က **အရင် design** အတိုင်းပဲ ရှိပါသေးတယ်။  
  (အဖြူ/မီးခိုး card တွေ၊ `rounded-2xl`, `border-slate-200` စသည်)

ဒါကြောင့် **“အဲ့ design က အကုန်လုံးချိန်းမှာ အဲ့တာတွေရပြီးလား”** ဆိုရင် — **မရသေးပါ**။  
Dashboard မှာပဲ ရပြီး၊ ကျန်စာမျက်နှာတွေကို တစ်ခုချင်း (သို့) design system နဲ့ ပြန်ချိန်ညှိရပါမယ်။

---

## ၂။ Responsive ဖြစ်အောင် လုပ်ထားတာ

Dashboard မှာ responsive လုပ်ထားပြီးသား —

| Breakpoint | Layout |
|------------|--------|
| **Mobile** (default) | 1 column Bento၊ အောက်မှာ glass bottom-tab nav (`md:hidden`) |
| **Tablet** (`md:`) | 2 column grid၊ ဘယ်ဘက် slim sidebar ပြ (`hidden md:flex`) |
| **Desktop** (`xl:`) | 4 column Bento၊ Total Revenue / Sales Analytics က 2 col span |

- Sidebar က **margin 1.5rem** (parent `p-6`) နဲ့ main content နဲ့ **height align** (`self-stretch`) လုပ်ထားပါတယ်။
- Mobile မှာ bottom nav အတွက် **spacer** `h-16` ထည့်ထားလို့ နောက်ဆုံး card က nav အောက်မှာ မပျောက်ပါ။

ဒါတွေက **Dashboard တစ်ခုအတွက်** responsive ဖြစ်ပါတယ်။ ကျန်စာမျက်နှာတွေကိုလည်း mobile/tablet/desktop စစ်ပြီး လိုရင် ချိန်ညှိရပါမယ်။

---

## ၃။ အကုန်လုံး ဒီဇိုင်းချိန်ညှိမှု လုပ်ချင်ရင်

ဒီဇိုင်းကို **အကုန်လုံး** (သို့) **အများစု** ချိန်ညှိချင်ရင် အောက်က နည်းတွေ သုံးလို့ရပါတယ်။

### ၃.၁ Design Tokens (Tailwind + CSS variables)

- **Colors**: gradient (`#aa0000` → `#151515`), glass (`white/10`, `white/20`) စတာတွေကို `tailwind.config.js` မှာ သတ်မှတ်ပြီး စာမျက်နှာတိုင်းမှာ သုံးမယ်။
- **Radius**: `rounded-[2rem]` ကို token တစ်ခု (ဥပမာ `rounded-dash`) လုပ်ပြီး အနှံ့သုံးမယ်။
- **Shadows**: `shadow-glow`, `shadow-glow-lg` စသည်ကို သတ်မှတ်ပြီးသား။

ဒါတွေက **ပြီးသား** (Dashboard မှာ သုံးထားပြီး)။ ကျန်စာမျက်နှာတွေမှာ ဒီ class တွေကို ပြောင်းသုံးရင် ဒီဇိုင်းနဲ့ နီးစပ်သွားမယ်။

### ၃.၂ Shared Layout / Wrapper

- **MainLayout** မှာ theme ရွေးချယ်မှု ထည့်မယ် (ဥပမာ “Glass” vs “Light”)။  
  Glass ရွေးရင် `bg-dashboard-deep` + ကလစ်တွေကို glass card ပုံစံ ပြမယ်။
- ဒါမှမဟုတ် **layout နှစ်မျိုး** ထားမယ် —  
  - `MainLayout.vue` = လက်ရှိ (အဖြူ/မီးခိုး)  
  - `GlassLayout.vue` = Dashboard လို gradient + glass  
  ပြီးတော့ Dashboard ကလွဲပြီး ဘယ်စာမျက်နှာကို Glass သုံးမလဲ ဆုံးဖြတ်မယ်။

### ၃.၃ စာမျက်နှာအလိုက် ပြင်ဆင်ခြင်း

- Sales (POS), Inventory, Products, Locations စသည်ကို **တစ်ခုချင်း** ပြင်မယ်။  
  Card တွေကို `bg-white/10 backdrop-blur-2xl border border-white/20 rounded-[2rem]` စသည်နဲ့ လဲပြီး၊ background ကို `bg-dashboard-deep` (သို့) ဆင်တူ gradient ပေးမယ်။
- ဒါက **အချိန်ယူရပြီး** စာမျက်နှာတိုင်း responsive (mobile / tablet / desktop) ပါ စစ်ရပါမယ်။

**အတိုချုပ်**: လက်ရှိမှာ design က **Dashboard တစ်ခုတည်းမှာပဲ** ရပါသေးတယ်။ အကုန်လုံး ချိန်ညှိချင်ရင် tokens + shared layout (သို့) စာမျက်နှာအလိုက် ပြင်ဆင်ရပါမယ်။ Responsive က Dashboard မှာ လုပ်ထားပြီး ဖြစ်ပါတယ်။

---

## ၄။ Capacitor နဲ့ Native Mobile App

**Capacitor** က **Vue / React / Angular** လို web app ကို **iOS နဲ့ Android** native app အဖြစ် wrap လုပ်ပေးတဲ့ framework ပါ။  
PWA နဲ့ ဆင်တူပေမယ့် App Store / Play Store မှာ တင်လို့ရပြီး၊ native APIs (camera, file, status bar, စသည်) ကို JavaScript ကနေ ခေါ်သုံးလို့ရပါတယ်။

### ၄.၁ ဒီ project မှာ Capacitor

- **ပြီးသား**: `package.json` မှာ `@capacitor/core`, `@capacitor/cli`, `@capacitor/ios`, `@capacitor/android`, `@capacitor/camera` စသည်တွေ **ထည့်ပြီးသား** ပါတယ်။  
  ဒါကြောင့် **Capacitor ကို သုံးဖို့ အဆင်သင့်နီးပါး** ဖြစ်နေပါပြီ။

### ၄.၂ လုပ်ရမယ့်အဆင့်များ (အတိုချုပ်)

1. **Web build ထုတ်ပြီး native ကို sync လုပ်မယ်**  
   `npm run cap:sync`  
   (ဒီ script က `npm run build` ပြီးမှ `npx cap sync` ခေါ်ပါတယ်။)
2. **iOS / Android ဖွင့်မယ်**  
   - iOS: `npm run cap:ios` (သို့) `npx cap open ios` → Xcode နဲ့ simulator / device  
   - Android: `npm run cap:android` (သို့) `npx cap open android` → Android Studio နဲ့ emulator / device  
3. **Safe area**: MainLayout မှာ `env(safe-area-inset-*)` padding ထည့်ပြီးသား၊ `index.html` မှာ `viewport-fit=cover` ထည့်ပြီးသား။  
4. **Capacitor config**: `capacitor.config.json` မှာ `androidScheme` / `iosScheme` = https, `android.allowMixedContent`, `ios.contentInset` သတ်မှတ်ပြီးသား။  

### ၄.၃ စဉ်းစားရမယ့်အချက်များ

| အချက် | ဆွေးနွေးချက် |
|--------|-----------------|
| **API URL** | App က Django backend ကို ခေါ်မယ်။ Device / emulator မှာ `localhost` မသုံးနိုင်လို့ **real URL** (ဥပမာ `https://api.yourdomain.com`) သတ်မှတ်ရပါမယ်။ `VITE_API_URL` သို့မဟုတ် Capacitor config မှာ environment ခွဲပြီး သတ်မှတ်နိုင်ပါတယ်။ |
| **Auth** | Token (JWT) ကို `localStorage` မှာ သိမ်းထားပြီးသား။ Native app မှာလည်း သုံးလို့ရပါတယ်။ Secure storage (Capacitor Preferences / Keychain) သုံးချင်ရင် နောက်မှ ပြောင်းနိုင်ပါတယ်။ |
| **Offline** | လက်ရှိ offline POS (Dexie + Pinia) က native app မှာလည်း အလုပ်လုပ်နိုင်ပါတယ်။ |
| **Status bar / Safe area** | iPhone notch စသည်အတွက် `@capacitor/status-bar` နဲ့ CSS `env(safe-area-inset-*)` သုံးပြီး ခလုတ်/နေရာတွေ မထိအောင် ချိန်ညှိရပါမယ်။ |
| **Camera / Barcode** | `@capacitor/camera` ပါပြီးသား။ Barcode scanner က web (html5-qrcode) နဲ့ သုံးထားရင် native မှာလည်း သုံးလို့ရပါတယ်။ လိုရင် native barcode plugin နဲ့ လဲနိုင်ပါတယ်။ |

### ၄.၄ Capacitor config စစ်ဆေးခြင်း

ဒီ project မှာ **`capacitor.config.json` ရှိပြီးသား** ဖြစ်ပါတယ်။  
- **appId**: `com.hobo.pos`  
- **appName**: `HoBo POS`  
- **webDir**: `dist`  
- **server.androidScheme**: `https`  

လိုရင် **server.url** ထည့်ပြီး dev server ကို device ကနေ ခေါ်မယ် (live reload)။ Production မှာ API URL ကို `VITE_API_URL` သို့မဟုတ် build မှာ သတ်မှတ်ပါ။

---

## ၅။ အတိုချုပ်

| မေးခွန်း | အဖြေ |
|------------|--------|
| **အဲ့ design က အကုန်လုံးချိန်းမှာ ရပြီးလား?** | **မရသေးပါ**။ လက်ရှိ ဒီဇိုင်းက **Dashboard တစ်ခုတည်းမှာပဲ** ရှိပါတယ်။ ကျန်စာမျက်နှာတွေကို design tokens + shared layout (သို့) စာမျက်နှာအလိုက် ပြင်ဆင်မှ အကုန်လုံး ချိန်ညှိရပါမယ်။ |
| **Responsive ဖြစ်ရမယ်** | **Dashboard မှာ** mobile (1 col + bottom nav), tablet (2 col + sidebar), desktop (4 col) လုပ်ထားပြီး ဖြစ်ပါတယ်။ ကျန်စာမျက်နှာတွေကို လိုသလို breakpoint / layout ထပ်ချိန်ညှိရပါမယ်။ |
| **Capacitor / Native mobile app** | **Capacitor** က Vue web app ကို iOS/Android native app အဖြစ် wrap လုပ်ပေးတဲ့ framework ပါ။ ဒီ project မှာ **Capacitor packages ထည့်ပြီးသား** ဖြစ်လို့ build + `cap add ios/android` + `cap sync` နဲ့ native project ထုတ်ပြီး Xcode / Android Studio နဲ့ run လို့ရပါတယ်။ API URL, auth, offline, safe area စသည်ကို စာမျက်နှာထဲမှာ ဆွေးနွေးထားပါတယ်။ |

လိုရင် စာမျက်နှာအလိုက် glass design ပြန်သတ်မှတ်တာ၊ သို့မဟုတ် Capacitor config / build script ထည့်တာ ဆက်လုပ်ပေးလို့ ရပါတယ်။
