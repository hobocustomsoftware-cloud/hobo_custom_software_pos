# Feature requests (2026-03-04) – လုပ်ပြီး / ကျန်ရှိ

## လုပ်ပြီး

### 1. Logo upload – Permission denied `/app/media/shop` ဖြေရှင်း
- **ပြဿနာ:** Logo သတ်မှတ်တဲ့အခါ `[Errno 13] Permission denied: '/app/media/shop'`
- **ပြင်ဆင်:** `WeldingProject/entrypoint.sh` ထည့်ပြီး backend container စတင်တိုင်း `/app/media/shop` ဖန်တီးကာ appuser ကို ပိုင်ဆိုင်ခွင့်ပေးသည်။ `WeldingProject/Dockerfile` မှာ gosu + ENTRYPOINT သုံးထားပြီး image ပြန် build လုပ်ရပါမယ်။

### 2. POS ကော်လံရွေးချယ်မှု (antibiotics, vitamins, PainRelief)
- **ပြဿနာ:** ကော်လံရွေးလိုက်ရင် ပစ္စည်းမပြ၊ အားလုံးမှာပဲ ပြနေသည်။
- **ပြင်ဆင်:** Backend `ProductListSerializer` မှာ **`category`** (category id) ထည့်ပေးထားပြီး။ POS မှာ category ရွေးရင် ဒီ id နဲ့ filter လုပ်လို့ ကော်လံအလိုက် ပစ္စည်းပြမယ်။

### 3. မြန်မာ / အင်္ဂလိပ် (POS)
- POS မှာ **အားလုံး** ခလုတ်ကို ဘာသာအလိုက် ပြအောင် ပြင်ထားပြီး (MYA = အားလုံး၊ EN = All)။

---

## ကုန်ကျစရိတ် (Expenses) CRUD
- Backend: `ExpenseViewSet` (List, Create, Update, Delete) ရှိပြီး။
- Frontend: `ExpenseManagement.vue` မှာ ထည့်ရန် / ပြင်ဆင်ရန် / ဖျက်ရန် ပါပြီး။
- API: `GET/POST /api/accounting/expenses/`, `PUT/DELETE /api/accounting/expenses/:id/`။
- မအလုပ်လုပ်ရင်: date filter သတ်မှတ်ပြီး Refresh နှိပ်ကြည့်ပါ၊ သို့မဟုတ် network/console error စစ်ပါ။

---

## ကျန်ရှိ (လုပ်ရန်)

- **ဝန်ဆောင်မှု / တပ်ဆင်မှု မီနူး ဖွင့်/ပိတ်:** Settings မှာ Service နဲ့ Installation မီနူး ဖွင့်/ပိတ် toggle ထည့်ရန်။ ကုသမှုမှတ်တမ်း (Treatment Records) လင့်ထည့်ရန်။
- **P&L မှာ transaction များ:** P&L report မှာ transaction listြသမှု စစ်ဆေးရန်။
- **Sale approve on/off toggle:** ရောင်းချပြီးတိုင်း အတည်ပြုစရာလိုမလို ဆိုင်အလိုက် on/off သတ်မှတ်နိုင်ရန် (Settings)။
- **Dashboard – Install job card & Active Service:** လုပ်ငန်းအမျိုးအစား (ဆိုလာ / ဆေးဆိုင် / ဖုန်း စသည်) အလိုက် ပြမည့် card ပြောင်းရန်။
- **Low stock:** စာဖတ်ရ အဆင်ပြေအောင် (contrast) ထပ်ပြင်ရန်။
- **Sales over time / Table:** Sales Summary မှာ chart နဲ့ table ရှိပြီး၊ onMounted မှာ doFetch() ခေါ်ထားပြီး။ ဒေတာမရရင် date range / outlet filter စစ်ပါ။
- **POS ကဒ်ယူနစ် ဈေးတွက်ချက်မှု:** တစ်လုံး ၁၂၀၊ တစ်ကဒ် ၁၀ လုံးဆို ၁၂၀၀/ကဒ် စသည့် unit conversion ကို POS မှာ သတ်မှတ်ပြီး ပြရန် (base_unit / purchase_unit_factor စသည် စစ်ဆေးရန်)။

---

## Logo permission အတွက် ပြန် build

```bash
cd "/media/htoo-myat-eain/New Volume1/hobo_license_pos"
docker compose -f compose/docker-compose.yml up -d --build backend
```
