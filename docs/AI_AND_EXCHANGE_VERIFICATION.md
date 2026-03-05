# AI နှင့် ဒေါ်လာလဲလှယ်နှုန်း စစ်ဆေးချက်

## ၁။ AI လုပ်ဆောင်ချက်များ

### ၁.၁ ပိုင်ရှင်အတွက် အရှုံးအမြတ် (P&L) နှင့် ဒီနေ့အရောင်း
| နေရာ | API / ဒေတာ | မှတ်ချက် |
|--------|----------------|----------|
| **Dashboard** | `GET /api/dashboard/analytics/?period=...` | `stats.today_pl` (ဒီနေ့အရောင်း၊ အမြတ်၊ ကုန်ကျစရိတ်၊ အမြတ်အစွန်း %), `stats.revenue_growth` |
| **P&L စာမျက်နှာ** | `/accounting/pl` | `ProfitLossReport.vue` – စတင်ရက်/ပြီးဆုံးရက် ရွေးပြီး ဝင်ငွေ/ကုန်ကျ/အမြတ် ကြည့်ခြင်း |

### ၁.၂ Smart Business Insight (အကြံဉာဏ်ပေးချက်)
| နေရာ | API | ပါဝင်သည့်အကြောင်းအရာ |
|--------|-----|----------------------------|
| **Dashboard** | `GET /api/ai/insights/` | ရောင်းရေအင်း၊ ဒေါ်လာဈေးတက်/ကျ၊ မျက်နှာပြင်အမြတ်၊ ပြန်မှာသင့်ပစ္စည်း၊ ပရိုမိုးရှင်း အကြံပြုချက် (ပိုင်ရှင်အတွက်) |

- **Frontend**: `Dashboard.vue` → `fetchSmartInsights()` → `api.get('ai/insights/')` → `smartInsights`
- **Backend**: `ai.views.SmartInsightsView` → `ai.services.get_smart_business_insights()`

### ၁.၃ Business Insights (ဒေါ်လာဈေးခွဲခြမ်းစိတ်ဖြာမှု + ဈေးညှိအကြံပြုချက်)
| နေရာ | API | ပါဝင်သည့်အကြောင်းအရာ |
|--------|-----|----------------------------|
| **Dashboard** | `GET /api/ai/business-insights/` | ဒေါ်လာဈေးပြောင်းလဲမှု၊ လက်ရှိ/ပျမ်းမျှဈေး၊ ဈေးတင်/ချအကြံပြုချက် (product-level) |

- **Frontend**: `BusinessInsightCard.vue` → `api.get('ai/business-insights/')`
- **Backend**: `inventory.views.BusinessInsightView` (exchange rate history + DYNAMIC_USD product recommendations)

### ၁.၄ Sale အတွက် AI (POS ခြင်းတောင်း)
| လုပ်ဆောင်ချက် | API | Frontend |
|------------------|-----|----------|
| **ဒါလေးရောမလိုဘူးလား + ဈ/ပရိုမို အကြံပြု** | `POST /api/ai/sale-auto-tips/` body: `product_ids[], product_names[]` | `SalesRequest.vue` → `fetchAiSuggestions()` → `aiSuggestions`, `salePriceTip`, `salePromotionTip` |
| **Compatible Products (Cross-sell)** | `POST /api/ai/cross-sell/` body: `product_ids[], max_results` | `SalesRequest.vue` → `fetchCrossSellSuggestions()` → `CrossSellSuggestion.vue` |
| **ပစ္စည်းရှာပါ (query + use_case)** | `POST /api/products/ai-suggest/` body: `query, use_case, max_results` | `AIProductSuggestion.vue` (modal) → suggestions + bundles |
| **မေးမြန်းချက် (Ask)** | `POST /api/ai/ask/` body: `question` | `SalesRequest.vue` → `submitAiAsk()` → `aiAskAnswer` |

---

## ၂။ ဒေါ်လာလဲလှယ်နှုန်း (Dollar Exchange)

### ၂.၁ API များ
| API | Method | ဖော်ပြချက် |
|-----|--------|-------------|
| `GET /api/settings/exchange-rate/` | GET | လက်ရှိ USD rate, is_auto_sync, market_margin % |
| `PATCH /api/settings/exchange-rate/` | PATCH | ဈေးနှုန်းပြင်ခြင်း (manual rate / auto sync / market margin) |
| `GET /api/settings/exchange-rate/history/` | GET | ယခင်ဈေးများ (chart/trend) |
| `POST /api/settings/exchange-rate/fetch/` | POST | CBM မှ အလိုအလျောက်ဆွဲခြင်း + DYNAMIC_USD ပစ္စည်းဈေးများ sync |

### ၂.၂ Frontend အသုံးပြုမှု
| နေရာ | သုံးစွဲမှု |
|--------|-------------|
| **Sidebar** | `useExchangeRateStore().usdExchangeRate` ပြခြင်း၊ Settings ချိန်ညှိရန် link၊ “Sync from CBM” |
| **Dashboard** | USD Rate ကတ်၊ P&L နှင့် AI insights တွင်ဒေါ်လာဈေးအခြေခံ ပါဝင် |
| **Settings** | `RateManagementModal` – CBM auto / manual rate၊ market margin %၊ သိမ်းချက် |
| **POS (SalesRequest)** | DYNAMIC_USD ပစ္စည်းများ `exchangeRate.priceInMmk(product)` ဖြင့်ဈေးတွက်ချက်ပြခြင်း |

### ၂.၃ Backend
- **GlobalSetting** `usd_exchange_rate`, **ExchangeRateLog** (နေ့စဉ်မှတ်တမ်း)
- **fetch_exchange_rates** management command / Celery: CBM မှဆွဲပြီး GlobalSetting နှင့် ExchangeRateLog ထည့်ခြင်း
- **sync_all_prices()**: DYNAMIC_USD ပစ္စည်းများ ဈေးပြန်တွက်ချက်ခြင်း

---

## ၃။ စစ်ဆေးရန် အဆင့်များ (Checklist)

1. **Dashboard**
   - [ ] Total Revenue, USD Rate, P&L ကတ်များြသမှု
   - [ ] ဒီနေ့အရောင်း / P&L (today_pl)ြသမှု
   - [ ] Smart Business Insight စာရင်း (ai/insights/)ြသမှု
   - [ ] Business Insights (ဒေါ်လာခွဲခြမ်းစိတ်ဖြာမှု)ြသမှု

2. **Settings → ဒေါ်လာဈေးနှုန်း**
   - [ ] ဒေါ်လာဈေးနှုန်း ချိန်ညှိရန် ဖွင့်ပြီး GET/PATCH အဆင်ပြေခြင်း
   - [ ] CBM မှဆွဲခြင်း (fetch) နှင့် manual rate သိမ်းခြင်း

3. **POS (Sales)**
   - [ ] ခြင်းတောင်းထဲ ပစ္စည်းထည့်ပြီး Cross-sell အကြံပြုချက် ပေါ်ခြင်း
   - [ ] Sale auto tips (ဈေး/ပရိုမို) ပေါ်ခြင်း
   - [ ] AI ပစ္စည်းအကြံပြုချက် (products/ai-suggest) ဖွင့်ပြီး ရှာခြင်း
   - [ ] DYNAMIC_USD ပစ္စည်းများ လက်ရှိ USD rate နဲ့ ဈေးပြခြင်း

4. **Accounting**
   - [ ] `/accounting/pl` P&L စာမျက်နှာ ရက်စွဲရွေးပြီး ဝင်ငွေ/ကုန်ကျ/အမြတ်ြသမှု

---

## ၄။ E2E / Simulation

**လိုအပ်ချက်**: Backend (`python manage.py runserver`) နှင့် Frontend (`npm run dev` – port 5173) နှစ်ခုလုံး ဖွင့်ထားရပါမယ်။

### Spec များ
- **Pharmacy simulation**: `yp_posf/e2e/pharmacy_simulation.spec.js` – Register → Setup Wizard → Dashboard, POS, Reports, Settings screenshots  
  `PLAYWRIGHT_BASE_URL=http://127.0.0.1:5173 npx playwright test e2e/pharmacy_simulation.spec.js --project=chromium`
- **Full simulation**: `yp_posf/e2e/full_simulation.spec.js` – စာမျက်နှာများစွာ ဖြတ်သန်းပြီး screenshots (Django-served SPA အတွက် BASE_URL=http://127.0.0.1:8000/app)
- **AI + Exchange verification**: `yp_posf/e2e/ai_exchange_verification.spec.js` – Dashboard (USD, P&L, Smart Insight, Business Insights), Settings ဒေါ်လာဈေးမျက်နှာပြင်, Accounting P&L, POS စစ်ဆေးခြင်း  
  - သတ်မှတ်ထားသော user မရှိရင်: `TEST_USE_REGISTER=1 npx playwright test e2e/ai_exchange_verification.spec.js --project=chromium`  
  - သတ်မှတ်ထားသော user ရှိရင်: `TEST_LOGIN_ID=owner TEST_LOGIN_PASSWORD=owner123 npx playwright test e2e/ai_exchange_verification.spec.js --project=chromium`

### အသေးစိတ် simulation လုပ်နည်း
1. Terminal ၁: `cd WeldingProject && python manage.py runserver 0.0.0.0:8000`  
2. Terminal ၂: `cd yp_posf && npm run dev`  
3. Terminal ၃: `cd yp_posf && TEST_USE_REGISTER=1 npx playwright test e2e/ai_exchange_verification.spec.js e2e/pharmacy_simulation.spec.js --project=chromium`  
Screenshots: `demo_results/simulation_screenshots/` အောက်တွင် သိမ်းမည်။
