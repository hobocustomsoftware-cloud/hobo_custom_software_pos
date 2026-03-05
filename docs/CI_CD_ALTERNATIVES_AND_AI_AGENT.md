# CI/CD အခြားရွေးချယ်စရာများ၊ Docker ဖြင့် Prometheus+Grafana၊ AI Agent အတွက် Sales / Owner P&L

**ရက်စွဲ**: 2026-02-20

---

## ၁။ CI/CD ကို GitHub Actions မသုံးဘဲ ဘာသုံးလို့ရမလဲ

### ရွေးချယ်စရာများ

| ရွေးချယ်စရာ | အားသာချက် | အားနည်းချက် | သင့်တော်သည့်အခြေအနေ |
|----------------|-------------|----------------|---------------------------|
| **GitLab CI** | GitLab သုံးရင် တစ်ပါတည်း၊ YAML ရိုးရှင်း | GitLab လိုအပ် | Repo က GitLab မှာဆိုရင် |
| **Jenkins** | Self-hosted၊ plugin များ၊ လွတ်လပ် | Server လိုအပ်၊ ပြင်ဆင်ရမှု များ | On‑prem / VPS ရှိရင် |
| **Drone CI** | Lightweight, Docker-based, YAML | Self-hosted သို့မဟုတ် Drone Cloud | Docker environment ရှိရင် |
| **CircleCI** | Cloud, မြန်သည် | GitHub/GitLab နဲ့ ချိတ်လို့ရပြီး paid plan လိုအပ်နိုင် | Cloud CI လိုရင် |
| **Azure Pipelines** | Microsoft ecosystem, free tier ရှိ | Azure/Windows နဲ့ ရင်းနှီးရင် ပိုအဆင်ပြေ | Azure သုံးရင် |
| **Bitbucket Pipelines** | Bitbucket နဲ့ တစ်ပါတည်း | Bitbucket လိုအပ် | Repo က Bitbucket မှာဆိုရင် |
| **Cron + Scripts** | ရိုးရှင်း၊ server တစ်လုံးတည်းမှာပဲ | True CI မဟုတ်၊ schedule based | Auto build ကို အချိန်မှန် လုပ်ရုံလိုရင် |

### အကြံပြုချက်

- **Repo က GitLab မှာဆိုရင်** → **GitLab CI** သုံးပါ။ `.gitlab-ci.yml` တစ်ဖိုင် ထည့်ပြီး test + build stage သတ်မှတ်ရင် ရပါတယ်။
- **Self-hosted / VPS ရှိရင်** → **Jenkins** သို့မဟုတ် **Drone** ထားပြီး Git webhook နဲ့ trigger လုပ်နိုင်ပါတယ်။
- **အရမ်းမရှုပ်ချင်ရင်** → **Cron + script** (ဥပမာ ညနေပိုင်း `git pull && pytest && npm run build`) နဲ့ အချိန်မှန် build/test လုပ်ထားလို့ ရပါတယ်။

CI pipeline မှာ လုပ်သင့်တာများ: **Backend test** (`pytest` / `manage.py test`), **Frontend build** (`npm run build`), လိုရင် **Lint**။ CD က deploy လမ်းကြောင်း သတ်မှတ်ပြီးမှ ထည့်လို့ ရပါတယ်။

---

## ၂။ Prometheus + Grafana က Docker နဲ့ လုပ်ရင် ပိုကောင်းမလား / ဘယ်ဟာ ပိုအဆင်ပြေမလဲ

### Docker နဲ့ လုပ်ခြင်း ကောင်းကျိုးများ

| အချက် | ရှင်းလင်းချက် |
|--------|------------------|
| **တစ်ခါတည်း စနစ်ပါဝင်** | `docker-compose up` တစ်ချက်နဲ့ app + DB + Redis + Prometheus + Grafana အားလုံး တက်သွားနိုင်သည်။ |
| **Version / config ထိန်းချုပ်လွယ်** | Prometheus version, Grafana version နဲ့ config ဖိုင်များကို repo ထဲမှာ ထားနိုင်သည်။ |
| **ပတ်ဝန်းကျင် တူညီမှု** | Dev/Staging/Production မှာ တူညီတဲ့ stack ကို run နိုင်သည်။ |
| **ပြုပြင်လွယ်** | Prometheus scrape config, Grafana dashboard များကို ဖိုင်အဖြစ် ပြင်ပြီး image ပြန် build စရာ မလို။ |

### ဘယ်ဟာ ပိုအဆင်ပြေမလဲ

- **Repo ထဲမှာ Docker Compose နဲ့ Prometheus + Grafana ထည့်ခြင်း**  
  → **ပိုအဆင်ပြေသည်**။  
  - တစ်စီးတည်း run လို့ရသည်။  
  - Config များ repo ထဲမှာ ရှိသဖြင့် AI agent / developer များ “monitoring ဘယ်လို run လဲ” သိနိုင်သည်။  
  - Production မှာ Prometheus/Grafana ကို သီးသန့် server မှာ run မယ်ဆိုရင်လည်း ဒီ config ကို reference အဖြစ် ယူသုံးနိုင်သည်။  

ဒါကြောင့် **Docker နဲ့ လုပ်ထားတာက ပိုကောင်းပြီး အဆင်ပြေသည်**။  
အောက်မှာ `docker-compose.monitoring.yml` နမူနာ ထည့်ပေးထားပါတယ်။ လက်တွေ့ သုံးရင် `docker-compose -f docker-compose.yml -f docker-compose.monitoring.yml up -d` စသည်ဖြင့် run နိုင်ပါတယ်။

---

## ၃။ AI Agent က Sales, Owner Profit & Loss အတွက် ဘယ်လို လုပ်လို့ရမလဲ

### ၃.၁ လက်ရှိ API များ (Agent သုံးလို့ရပြီး)

ဒီ API များကို AI agent က **JWT token** (Owner/Admin user) နဲ့ ခေါ်ပြီး Sales / P&L ကို ရယူနိုင်ပါတယ်။

| API | ရည်ရွယ်ချက် | Query params |
|-----|----------------|-------------|
| `GET /api/accounting/pnl/summary/` | ဝင်ငွေ − ကုန်ကျစရိတ် (Net P&L) | `start_date`, `end_date` (YYYY-MM-DD) |
| `GET /api/accounting/pnl/profit-from-sales/` | အရောင်းမှ ရသော ဝင်ငွေ (Gross profit) | `start_date`, `end_date` |
| `GET /api/accounting/pnl/trend/` | နေ့စဉ် ဝင်ငွေ trend | `days` (default 30) |
| `GET /api/accounting/pnl/margin-analysis/` | ဝယ်ယူခ နဲ့ မျှဝေချက် (margin shrinkage) | - |
| `GET /api/admin/report/daily-summary/` | နေ့စဉ် အရောင်း summary | (inventory app) |
| `GET /api/admin/report/sales-period-summary/` | ကာလအလိုက် အရောင်း summary | (inventory app) |

Agent လုပ်နည်း (အကြံပြု):

1. **Owner/Admin role** နဲ့ JWT token ရယူပါ (သို့မဟုတ် service account)။  
2. **ကာလ သတ်မှတ်ပြီး** ခေါ်ပါ။ ဥပမာ ယမန်နေ့ / ယမန်လ:  
   - `GET /api/accounting/pnl/summary/?start_date=2026-02-01&end_date=2026-02-28`  
   - `GET /api/accounting/pnl/profit-from-sales/?start_date=2026-02-01&end_date=2026-02-28`  
3. Response ကို JSON အဖြစ် parse လုပ်ပြီး **အချက်အလက် စုစည်းကာ** Owner အတွက် စာသား/အစီရင်ခံစာ ထုတ်ပါ။  

### ၃.၂ Owner / AI Agent အတွက် “တစ်ချက်ခေါ်” Summary API (ထပ်ထည့်ခြင်း)

Agent က endpoint များစွာ မခေါ်ချင်ဘဲ **တစ်ခါတည်း Sales + P&L** လိုချင်ရင် အောက်က လို API တစ်ခု ထပ်ထည့်နိုင်ပါတယ်။

- **Endpoint နမူနာ**: `GET /api/accounting/owner-summary/`  
- **Query params**: `start_date`, `end_date` (optional; မပါရင် ယမန်လ သို့မဟုတ် ယမန်ရက်)  
- **Response နမူနာ**:
```json
{
  "period": { "start_date": "2026-02-01", "end_date": "2026-02-28" },
  "pnl": {
    "net_profit": "1500000.00",
    "profit_margin_percent": "12.5",
    "income_sum": "12000000.00",
    "expense_sum": "10500000.00"
  },
  "profit_from_sales": {
    "gross_profit": "2000000.00",
    "gross_profit_margin_percent": "18.0",
    "total_revenue": "11000000.00",
    "total_cost": "9000000.00"
  },
  "trend_days_30": [ { "date": "2026-02-01", "net_profit": "50000" }, ... ]
}
```

ဒီလို endpoint ရှိရင် AI agent က **တစ်ခါခေါ်**ပြီး Sales + Owner P&L ကို စုစည်းကာ မြန်မာလို/အင်္ဂလိပ်လို စာသား အစီရင်ခံစာ ထုတ်ပေးနိုင်ပါတယ်။  

ဒီ `owner-summary` API ကို repo ထဲမှာ ထပ်ထည့်ပေးထားပါမယ် (အောက်မှာ ဖော်ပြထားသည်)။

### ၃.၃ AI Agent လုပ်နည်း အတိုချုပ်

1. **Authentication**: Owner/Admin JWT သုံးပြီး `Authorization: Bearer <token>` ထည့်ပါ။  
2. **ကာလ ရွေးချယ်ခြင်း**: `start_date`, `end_date` သတ်မှတ်ပါ (သို့မဟုတ် owner-summary မှာ default ယမန်လ)။  
3. **Data ယူခြင်း**:  
   - ရွေးချယ်စရာ ၁: လက်ရှိ API များကို သီးသီး ခေါ်ပြီး စုစည်းခြင်း။  
   - ရွေးချယ်စရာ ၂: `GET /api/accounting/owner-summary/?start_date=...&end_date=...` တစ်ခါခေါ်ပြီး သုံးခြင်း။  
4. **အစီရင်ခံစာ ထုတ်ခြင်း**: JSON ကို စာသား/ဇယား ပြန်ပြင်ပြီး Owner ကိုြသခြင်း (Chatbot, Email, Dashboard စသည်)။  

---

## ၄။ ဖိုင်များ ထပ်ထည့်ထားသည်များ

- **`docker-compose.monitoring.yml`** – Prometheus + Grafana ကို Docker နဲ့ run ရန် (backend `metrics` ကို scrape လုပ်သည်)။  
- **`deploy/prometheus/prometheus.yml`** – Prometheus scrape config နမူနာ။  
- **`WeldingProject/accounting/views.py`** – `OwnerSummaryView` (owner-summary API) ထည့်ထားသည်။  
- **`WeldingProject/accounting/urls.py`** – `owner-summary/` route ထည့်ထားသည်။  

---

## ၅။ လက်တွေ့ သုံးစွဲနည်း

### Prometheus + Grafana (Docker)

```bash
# App + Monitoring အတူ run ရန်
docker-compose -f docker-compose.yml -f docker-compose.monitoring.yml up -d

# Grafana: http://localhost:3000 (admin / admin)
# Prometheus: http://localhost:9090
# Grafana မှာ Data source → Add Prometheus → URL: http://prometheus:9090
```

### Owner / AI Agent Summary API

```bash
# Owner or Admin JWT token လိုအပ်သည်
curl -H "Authorization: Bearer <TOKEN>" \
  "http://localhost:8000/api/accounting/owner-summary/?start_date=2026-02-01&end_date=2026-02-28"
```

---

ဤစာတမ်းကို ပြီးဆုံးအောင် ဖတ်ပြီး CI/CD ရွေးချယ်မှု၊ Docker monitoring သုံးစွဲမှု နဲ့ AI agent အတွက် owner-summary API ကို လက်တွေ့ သုံးနိုင်ပါပြီ။
