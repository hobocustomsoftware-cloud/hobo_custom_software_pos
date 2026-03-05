# UI/UX & Feature Roadmap (မှတ်တမ်း)

သင့် ပြောချက်အရ အောက်ပါအတိုင်း စီစဉ်ထားပါသည်။

---

## ပြင်ပြီး (Done)

### 1. `/api/staff/items/` 500 ပြင်ဆင်
- **အကြောင်းရင်း:** `ProductListAPIView` မှာ `inventorymovement` သုံးထားပြီး Product model က **inventorymovement_set** (Django default related_name) ဖြစ်နေသည်။
- **ပြင်ဆင်:** `inventory/views.py` ထဲက `inventorymovement__quantity` ကို **inventorymovement_set__quantity** ပြောင်းထားပြီး။
- **လုပ်ရမှာ:** Backend ပြန် build/restart လုပ်ပါ။ Docker ဆိုရင်:  
  `docker compose -p hobo -f compose/docker-compose.yml up -d --build backend`

---

## Sidebar အဆင်ပြေအောင်
- Sidebar က layout / ဖတ်လို့ရမရ ပြဿနာရှိရင် ထပ်ပြင်မယ်။ 500 ပျောက်ပြီး products load ဖြစ်ရင် sidebar လည်း အဆင်ပြေနိုင်သည်။

---

## ဆက်လက်လုပ်ရန် (Backlog)

| အချက် | အတိုချုပ် |
|--------|-------------|
| **Layout အချိုး** | Loyverse-style ဖြစ်ပြီး အချိုးမှန်အောင်၊ POS အတိုင်းဖြစ်အောင် ပြင်မယ်။ |
| **Tailwind + UI/UX** | Tailwind သုံးပြီး လှပပြီး Loyverse ထက် ပိုကောင်းအောင် design ပြင်မယ်။ |
| **မြန်မာ / English** | ဘာသာရွေးချယ်မှု (i18n) အဆင်ပြေပြေနဲ့ ရနေအောင် စစ်ပြီး ပြင်မယ်။ |
| **Purchase order** | သင့် feature စာရင်းနဲ့ ကိုက်ညီအောင် ပြင်မယ်။ |
| **Transfer order** | အရင် လုပ်လို့ရပြီး အခု မရတော့ဘူး → Inbound/Outbound flow ပြန်စစ်ပြီး ပြင်မယ်။ |
| **Modifiers** | Loyverse modifier နဲ့ သင့် feature list ကိုက်အောင် သတ်မှတ်ပြီး ပြင်မယ်။ |
| **Sale summary** | ကြည့်ရတာ အဆင်မပြေတာ ပြင်မယ်။ |
| **Receipts** | ဘာမှမရှိဘူး ဆိုတာ စစ်ပြီး receipt list/print ထည့်မယ်။ |
| **Shift** | Shift-based sales summary လုပ်မယ်။ |
| **Discounts** | Discount rules နဲ့ promotions လုပ်မယ်။ |
| **CBM / USD rate** | မြန်မာဗဟိုဘဏ် ဆွဲသုံးခြင်း သို့မဟုတ် ကိုယ်ထိလက်ရောက်ပြင်နိုင်ခြင်း၊ DYNAMIC_USD ပစ္စည်းများ ဈေးပြောင်းတိုင်း အလိုအလျောက်ပြောင်းမယ်၊ ကိုယ်တိုင်ပြင်နိုင်အောင် စစ်ပြီး ပြင်မယ်။ |

---

## လောလောဆယ် လုပ်ရမှာ

1. **Backend ပြန် build** (staff/items fix အတွက်):  
   `docker compose -p hobo -f compose/docker-compose.yml up -d --build backend`
2. Browser မှာ **http://localhost:8080** ဖွင့်ပြီး Register/Login → Sales Request (သို့) POS စစ်ပါ။ `/api/staff/items/` 500 ပျောက်ပြီး products load ဖြစ်ရင် sidebar လည်း အဆင်ပြေနိုင်သည်။
3. ထပ်ပြဿနာရှိရင် (sidebar layout, transfer, receipts စသည်) ပြောပါ။ ဒီ roadmap အလိုက် ဆက်ပြင်မယ်။
