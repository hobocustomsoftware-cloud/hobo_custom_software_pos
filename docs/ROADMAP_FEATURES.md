# နောက်ထပ်လုပ်ဆောင်ချက်များ (Roadmap)

ဒီစာမျက်နှာမှာ လုပ်ပြီးသားနဲ့ ဆက်လက်လုပ်ရမယ့် feature တွေကို မှတ်ထားပါတယ်။

---

## လုပ်ပြီးသား (ဒီအပိုင်း)

### ၁။ AI နဲ့ Accounting P&L နေရာထည့်ခြင်း
- **Sidebar:** Dashboard, Accounting (P&L Report, Expenses), Installation ထည့်ပြီး။
- **Route:** `/dashboard` ဖွင့်ပြီး – AI Smart Insights, ဒီနေ့ P&L, Revenue, Installation Jobs စသည်တို့ ပြမယ်။
- **Accounting:** Sidebar → Accounting → P&L Report (`/accounting/pl`), Expenses (`/accounting/expenses`)။

### ၂။ ဆိုင်အမျိုးအစားအလိုက် Unit များ
- **Backend:** `GET /api/units/?business_category=pharmacy|solar|mobile|computer|hardware|general` – ရွေးထားတဲ့ ဆိုင်အမျိုးအစားအတွက် unit တွေပဲ ပြန်ပေးမယ်။
- **Frontend:** Shop settings မှာ `business_category` သိမ်းပြီး၊ Product Management နဲ့ Purchase Orders မှာ unit list ခေါ်တဲ့အခါ ဒီ category နဲ့ ခေါ်သွားမယ်။ ဆေးဆိုင်ရွေးထားရင် ဆေးနဲ့ဆိုင်တဲ့ unit တွေပဲ ပြမယ်။
- **Unit templates:** `core/unit_templates.py` – `get_unit_codes_for_business_category()`, pharmacy / pharmacy_clinic / solar / mobile / computer / hardware / general အတွက် code list ပြန်ပေးမယ်။

### ၃။ Dashboard ပြင်ဆင်ခြင်း (Tailwind POS style)
- Dashboard စာမျက်နှာကို နောက်ခံအဖြူ၊ ကတ်များ (border, shadow) နဲ့ Tailwind သုံးပြီး POS dashboard ပုံစံ ပြင်ထားပြီး။
- Revenue, USD Rate, P&L, ဒီနေ့အရောင်း, Sales chart, Installation, Low Stock, Active Services, Smart Insights, Recent Transactions အကုန် ပါပြီး။

---

## ဆက်လုပ်ရမည့်အရာများ

### ၄။ ဆေးဆိုင် + ဆေးခန်းတွဲ – လူနာမှတ်တမ်း (Service = ကုသမှုမှတ်တမ်း)
- Service ကို ကုသမှုမှတ်တမ်းအနေနဲ့ သိမ်းမယ်။
- လိုအပ်ချက်: လူနာအမည်၊ အသက်၊ မတည့်သောဆေး (allergies) စတဲ့ field တွေ ထည့်ပြီး model / form / API ပြင်ရမယ်။
- နေရာ: Service app (သို့) inventory အတွင်း “treatment record” / “patient record” ဆိုပြီး သီးသန့် model ထားပြီး CRUD လုပ်ရမယ်။

### ၅။ Solar ဆိုင် – Installation + Survey CRUD, Auto Ticket
- Installation မလုပ်ခင် survey လုပ်တာမျိုး – Survey CRUD (ဖန်တီး/ဖတ်/ပြ/ဖျက်) လုပ်ရမယ်။
- Auto ticket number (ဥပမာ SUR-2025-0001, INST-2025-0001) ထုတ်ပေးရမယ်။
- နေရာ: `installation` app – survey model, ticket number generator, API + frontend စာမျက်နှာများ။

### ၆။ Solar / Computer – အတွဲလိုက် (Bundle) ပစ္စည်း
- တစ်ခုချင်း item ရော အတွဲလိုက် (bundle/kit) item ပါ လုပ်လို့ရမယ်။
- Bundle ထဲက ပစ္စည်းတွေကို edit လုပ်လို့ရမယ်၊ ပစ္စည်းကောင်းတာထည့်လို့ရမယ်။
- နေရာ: လက်ရှိ Bundle / BundleItem model ရှိပြီးသား – UI နဲ့ API မှာ bundle edit, item add/remove/update ပြည့်စုံအောင် လုပ်ရမယ်။

### ၇။ i18n – မြန်မာ / English ပြောင်းခြင်း
- မြန်မာစာရွေးရင် အကုန်လုံး မြန်မာလို၊ English ရွေးရင် အကုန်လုံး English ဖြစ်အောင် translation သုံးရမယ်။
- vue-i18n (သို့) ကိုယ်တိုင်ဘာသာပြန် key system ထားပြီး label/text တွေကို key နဲ့ ပြန်ပြရမယ်။

### ၈။ Unit toggle (ရွေးချယ်မှု)
- လက်ရှိ: business_category ရွေးထားတာနဲ့ unit list က အလိုအလျောက် filter ဖြစ်သွားပြီး။
- နောက်ထပ်: Settings မှာ “ဆိုင်အမျိုးအစားအလိုက် unit ပဲပြမယ်” on/off toggle ထည့်ပြီး၊ on ဆိုရင် ဒီ filter သုံး၊ off ဆိုရင် unit အားလုံး ပြလို့ရမယ်။

---

## ကိုးကားမှုများ
- AI / P&L API: `docs/AI_AND_EXCHANGE_VERIFICATION.md`
- Seed shop demo: `docs/SEED_SHOP_DEMO.md`
