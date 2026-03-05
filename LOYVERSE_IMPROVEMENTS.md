# HoBo POS – Loyverse-style improvements

ဒီဖိုင်မှာ လုပ်ပြီးသား ပြင်ဆင်ချက်တွေနဲ့ နောက်ထပ် လုပ်သင့်တဲ့ အချက်တွေကို ချရေးထားပါတယ်။

## လုပ်ပြီးသား (Done)

### 1. Unit မှာ ကဒ် (Card) ထည့်ခြင်း
- **Backend:** `WeldingProject/core/unit_templates.py` – PHARMACY_UNITS, ELECTRONIC_SOLAR_UNITS, GENERAL_UNITS အားလုံးမှာ `CARD (ကဒ်)` ထည့်ပြီး။
- **Backend:** `WeldingProject/inventory/models.py` – Product.UNIT_TYPE_CHOICES မှာ `('CARD', 'Card')` ထည့်ပြီး။
- **Backend:** Migration `0026_seed_card_unit.py` – ရှိပြီး DB တွေမှာ CARD unit ရှိအောင် seed လုပ်ထားပြီး။
- **Frontend:** Item/Product form မှာ Unit Type dropdown မှာ "Card (CARD)" ရွေးလို့ရပြီး။ Base unit / Purchase unit က API (`/api/units/`) ကနေဆွဲတာမို့ ဆိုင်သစ်တွေအတွက် setup wizard က CARD ကို seed လုပ်ပေးမယ်။

### 2. English / Myanmar ရွေးချယ်မှု
- **Frontend:** `yp_posf/src/stores/locale.js` – ရှိပြီးသား (lang: 'en' | 'mm', setLang, toggle).
- **Frontend:** `yp_posf/src/components/Topbar.vue` – Header မှာ **EN** | **မြန်မာ** ခလုတ် ထည့်ပြီး။ ရွေးထားတဲ့ ဘာသာကို localStorage မှာ သိမ်းပြီး စာမျက်နှာတွေ ပြန်ဖွင့်ရင် ပြန်သုံးလို့ရပါတယ်။

### 3. Location / ဆိုင်ခွဲ စီမံမှု
- **Frontend:** ဆိုင်ခွဲ စီမံမှု စာမျက်နှာ ရှိပြီးသား – `/shop-locations` (LocationManagement.vue).
- **Sidebar:** Loyverse-style sidebar မှာ Inventory အောက်ကို **Locations / ဆိုင်ခွဲ** လင့်ထည့်ပြီး။ ဒါကြောင့် Location စီမံမှုကို လွယ်လွယ်သွားလို့ရပါတယ်။

---

## နောက်ထပ် လုပ်သင့်သည်များ (Recommendations)

### UI/UX – Loyverse နဲ့ ချွတ်စွတ်တူအောင်
- စာမျက်နှာတိုင်းမှာ အချိုးအစား မျှတအောင် (spacing, grid, font size) ပြန်ချိန်ညှိပါ။
- Purchase Orders, Stock Counts, Receipts, Shift စတဲ့ စာမျက်နှာတွေမှာ စာရင်းဇယား / ဖောင်တွေ ထည့်ပြီး လုပ်ဆောင်ချက် ပြည့်စုံအောင် ဖြည့်ပါ။
- Senior Frontend / UI-UX နဲ့ အတူ layout နဲ့ component တူညီမှု ပြန်စစ်ပါ။

### Toggle နဲ့ လိုတာကို ပိုက်ဆံထပ်ကောက်ခြင်း
- Settings မှာ “Premium features” ကဲ့သို့ ကဏ္ဍတစ်ခု ထားပြီး လိုတဲ့ feature တွေကို toggle (ဖွင့်/ပိတ်) လုပ်လို့ရအောင် လုပ်ပါ။
- ဥပမာ: Advanced reports, Multi-location limits, API access စတာတွေကို toggle + subscription/one-time နဲ့ ချိတ်ပါ။

### လုပ်ထားပြီး feature တွေ မပျောက်စေရန်
- Refactor / Loyverse-style ပြင်တဲ့အခါ လက်ရှိ feature တွေ (Purchase Orders, Transfer, Stock Count, Discounts, Payment methods, User/Location management စသည်) ကို စာရင်းချပြီး regression test လုပ်ပါ။
- Toggle ထည့်တဲ့အခါ လက်ရှိ လုပ်ဆောင်ချက်တွေကို ပိတ်မသွားအောင် default-on ထားပါ။

---

## Migration ကို run လုပ်ရန်

```bash
cd WeldingProject
python manage.py migrate inventory
```

ဒါဆို CARD unit က ရှိပြီး DB တွေမှာပါ ထည့်သွင်းသွားပါမယ်။
