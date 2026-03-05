# Demo – Docker နဲ့ စမ်းသပ်ချက်

Demo ကို **Docker** နဲ့ပဲ စမ်းရမယ်။ Browser ဖွင့်ပြီး Register လုပ်ကာ ဆိုင်တစ်ဆိုင်စတင် လည်ပတ်ပုံတွေကို အဆင့်ဆင့် အသေးစိတ် စမ်းပါ။

---

## ၁။ Docker နဲ့ စတင်မယ်

### လိုအပ်ချက်
- Docker Desktop (Windows/Mac) သို့မဟုတ် Docker Engine + Docker Compose
- Repo root မှာ `.env` ရှိရင် သုံးမယ် (မရှိရင် default သုံးမယ်)

### စတင်ရန် (repo root ကနေ)

```bat
docker compose -f compose/docker-compose.server.yml up -d --build
```

သို့မဟုတ် batch သုံးမယ်:

```bat
scripts\run_docker_demo.bat
```

- ပထမအကြိမ် build ကြာနိုင်ပါတယ် (၂–၅ မိနစ်)။
- Backend က Postgres စတင်ပြီး migrate ပြီးမှ စပါတယ်။ ပြီးရင် **http://localhost:8000** မှာ app ရပါပြီ။

### App ဖွင့်ရန်

Browser မှာ အောက်က URL ဖွင့်ပါ:

- **http://localhost:8000/app/**

(သို့) **http://127.0.0.1:8000/app/**

---

## ၂။ အဆင့်ဆင့် စမ်းသပ်လမ်းညွှန်

အောက်က ခြေလှမ်းတွေကို **တစ်ခုချင်း** လိုက်စမ်းပါ။

---

### အဆင့် ၁ – စာမျက်နှာ စစ်ဆေးခြင်း

1. **http://localhost:8000/app/** သို့ သွားပါ။
2. **စစ်ဆေးရန်:**
   - Login စာမျက်နှာ ပေါ်ရမယ် (သို့ redirect ဖြစ်ပြီး login သို့ ရောက်ရမယ်)။
   - စာသားအားလုံး **မြင်ရရမယ်** (font size ၂၅၊ Loyverse style)။
   - **EN** / **မြန်မာ** ခလုတ် ရှိရမယ်။ နှိပ်ပြီး ဘာသာပြောင်းလို့ ရရမယ်။
   - Logo သို့မဟုတ် ဆိုင်အမည် ပြရမယ်။

---

### အဆင့် ၂ – Register (အကောင့်အသစ်ဖွင့်ခြင်း)

1. Login စာမျက်နှာမှာ **"အကောင့်ဖွင့်ရန်"** / **"Create account"** link ကို နှိပ်ပါ။  
   သို့မဟုတ် **http://localhost:8000/app/register** သို့ သွားပါ။
2. **ဖြည့်ရန်:**
   - **ဖုန်းနံပါတ်** (သို့မဟုတ် အီးမေးလ်): ဥပမာ `09123456789`
   - **ဆိုင်အမည်**: ဥပမာ `Demo Shop`
   - **စကားဝှက်** နဲ့ **အတည်ပြုစကားဝှက်**: ဥပမာ `demo1234`
3. **"အကောင့်ဖွင့်မည်"** / **"Create account"** ခလုတ် နှိပ်ပါ။
4. **စစ်ဆေးရန်:**
   - ပထမဆုံး user ဆိုရင် အောင်မြင်ပြီး **Setup Wizard** စာမျက်နှာသို့ အလိုအလျောက် သွားရမယ် (လော့ဂ်အင်ထပ်မလုပ်ရ)။
   - ဒုတိယ user ဆိုရင် "Admin must approve" ဆိုပြီး login စာမျက်နှာသို့ ပြန်သွားမယ်။

---

### အဆင့် ၃ – Setup Wizard (ပထမဆုံးချိန်ညှိချက်)

1. Setup Wizard စာမျက်နှာ ပေါ်ရမယ်။
2. **စစ်ဆေးရန်:**
   - **လုပ်ငန်းအမျိုးအစား** (Business Type) ရွေးချယ်စရာ ရှိရမယ် (Pharmacy, Mobile, General Retail စသည်)။
   - **ငွေကြေး** (Currency) ရွေးချယ်စရာ ရှိရမယ် (MMK, USD, THB စသည်)။
   - စာသားအားလုံး **မြင်ရရမယ်** (font ၂၅)။
3. လိုသလို ရွေးပြီး **"ပြီးပါပြီ ဒက်ရှ်ဘုတ်သို့သွားမည်"** / **"Complete setup & go to Dashboard"** နှိပ်ပါ။
4. **စစ်ဆေးရန်:**
   - ၄၀၃ မပြန်ရပါ (Setup Wizard က PUT shop-settings ခွင့်ပြုထားရမယ်)။
   - ပြီးရင် **Dashboard** သို့ ရောက်ရမယ်။

---

### အဆင့် ၄ – Dashboard

1. Dashboard စာမျက်နှာ ပေါ်ရမယ်။
2. **စစ်ဆေးရန်:**
   - ဘာသာပြောင်းထားရင် စာသားများ ပြောင်းပြီး မြင်ရမယ်။
   - Sidebar မှာ POS, Inventory, Users, Settings, Reports စသည့် menu တွေ ရှိရမယ်။
   - Error message / 401 / 403 မပြနေရပါ။

---

### အဆင့် ၅ – ဝန်ထမ်းများ (Users)

1. Sidebar မှာ **Users** (သို့မဟုတ် ဝန်ထမ်းများ) ကို နှိပ်ပါ။  
   သို့မဟုတ် **http://localhost:8000/app/users** သို့ သွားပါ။
2. **စစ်ဆေးရန်:**
   - စာရင်းမှာ ကိုယ်စာရင်းသွင်းထားတဲ့ user (Owner) ပါရမယ်။
   - **Add** ခလုတ် ရှိရမယ် (ဝန်ထမ်းအသစ်ထည့်ဖို့)။
   - ၄၀၄ သို့မဟုတ် staff/items related error မပြနေရပါ။

---

### အဆင့် ၆ – POS (အရောင်းမျက်နှာပြင်)

1. Sidebar မှာ **POS** / **Sales** ကို နှိပ်ပါ။  
   သို့မဟုတ် **http://localhost:8000/app/sales/pos** သို့ သွားပါ။
2. **စစ်ဆေးရန်:**
   - POS layout ပေါ်ရမယ် (Loyverse လို ပစ္စည်းစာရင်း / cart ဘက်များ)။
   - ပစ္စည်းစာရင်း ခေါ်တဲ့ API (staff/items) ၄၀၄ မပြန်ရပါ (slash မပါ route ပါထားပြီး)။
   - ပစ္စည်းမရှိသေးရင် ဗလာ သို့မဟုတ် “No items” ပြရမယ်။

---

### အဆင့် ၇ – Settings (ဆိုင်ချိန်ညှိချက်)

1. Sidebar မှာ **Settings** ကို နှိပ်ပါ။  
   သို့မဟုတ် **http://localhost:8000/app/settings** သို့ သွားပါ။
2. **စစ်ဆေးရန်:**
   - ဆိုင်အမည်၊ လုပ်ငန်းအမျိုးအစား၊ ငွေကြေး စသည်တို့ ပြရမယ်။
   - ပြင်လို့ ရရမယ် (Owner ဖြစ်ရင်)။

---

### အဆင့် ၈ – Reports (အစီရင်ခံစာများ)

1. Sidebar မှာ **Reports** ကို နှိပ်ပါ။  
   သို့မဟုတ် **http://localhost:8000/app/reports** သို့ သွားပါ။
2. **စစ်ဆေးရန်:**
   - Reports စာမျက်နှာ ပေါ်ရမယ်။
   - Sales Summary သို့မဟုတ် အခြား report ရွေးစရာ ရှိရမယ်။

---

### အဆင့် ၉ – Login ပြန်စမ်းခြင်း (ရွေးချယ်မှု)

1. Logout လုပ်ပါ (သို့မဟုတ် incognito / ဖန်သားပြင်အသစ်ဖွင့်ပါ)။
2. **http://localhost:8000/app/login** သို့ သွားပါ။
3. စာရင်းသွင်းထားတဲ့ **ဖုန်းနံပါတ်** (သို့မဟုတ် အီးမေးလ်) နဲ့ **စကားဝှက်** ထည့်ပြီး Login နှိပ်ပါ။
4. **စစ်ဆေးရန်:**
   - အောင်မြင်ပြီး Dashboard သို့ ရောက်ရမယ်။
   - ၄၀၁ / ၄၀၀ များစွာ မပြနေရပါ။

---

## ၃။ ပြင်ဆင်ထားတာများ (စစ်ဆေးပြီး)

- **Auth:** Register ပထမဆုံး user က `can_login_now` + JWT ရပြီး Setup Wizard သို့ တိုက်ရိုက်သွားမယ်။
- **Setup 403:** Setup မပြီးသေးချိန်မှာ shop-settings PUT ခွင့်ပြုထားပြီး (Owner / first user / setup_wizard_done False)။
- **staff/items 404:** `staff/items` (slash မပါ) route ထပ်ထည့်ထားပြီး ၄၀၄ မပြနေတော့ပါ။
- **Font ၂၅:** Auth စာမျက်နှာများ (Login, Register, Setup Wizard) မှာ font size ၂၅၊ icon နဲ့ လိုက်အောင် ပြင်ထားပြီး။
- **EN / မြန်မာ:** Login, Register, Setup Wizard မှာ ဘာသာရွေးချယ်ခလုတ် ထည့်ထားပြီး။

---

## ၄။ Docker ရပ်ရန်

```bat
docker compose -f compose/docker-compose.server.yml down
```

---

## ၅။ ပြဿနာတက်ရင်

- **Backend မတက်ရင်:** `docker compose -f compose/docker-compose.server.yml logs backend` ကြည့်ပါ။ Postgres စတင်ပြီးမှ backend စတင်ပါတယ်။
- **၄၀၁ / ၄၀၃:** Token သက်တမ်းကုန် သို့မဟုတ် permission စစ်ဆေးပါ။ Register ပထမဆုံး user က Setup Wizard ပြီးသည်အထိ token သုံးပြီး သွားလို့ ရပါတယ်။
- **၄၀၄ staff/items:** Backend က `staff/items` နဲ့ `staff/items/` နှစ်မျိုးလုံး route ထည့်ထားပြီး ဖြစ်ရပါမယ်။
