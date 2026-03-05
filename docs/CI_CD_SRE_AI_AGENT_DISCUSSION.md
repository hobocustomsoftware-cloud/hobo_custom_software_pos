# CI/CD, SRE Tools နှင့် AI Agent အတွက် ဆွေးနွေးချက်

**ရက်စွဲ**: 2026-02-20  
**အကြောင်းအရာ**: CI/CD ရှိ/မရှိ၊ SRE tools ထည့်ပြီး/မထည့်ရသေး၊ AI agent သုံးမှာဖြစ်တဲ့အတွက် ဘာတွေထည့်ရမလဲ ဆွေးနွေးချက်

---

## ၁။ လက်ရှိအခြေအနေ (ဘာရှိပြီးသား / ဘာမရှိသေး)

### CI/CD (Continuous Integration / Continuous Deployment)

| အချက် | အနေအထား | မှတ်ချက် |
|--------|-------------|-----------|
| **Project CI/CD** | ❌ **မရှိသေး** | Repo root မှာ `.github/workflows/` (GitHub Actions) သို့မဟုတ် `.gitlab-ci.yml` မရှိပါ။ |
| **Build scripts** | ✅ ရှိပြီး | `deploy/installer/` မှာ build scripts (PowerShell, Inno Setup), `docker-compose` ဖြင့် build လုပ်နိုင်ပါသည်။ |
| **Deploy scripts** | ✅ ရှိပြီး | `deploy/server/`, `deploy/portable/` မှာ run scripts ရှိပါသည်။ |

**ဆိုလိုချက်**: Code ကို push လုပ်တိုင်း auto test / auto build / auto deploy လုပ်ပေးတဲ့ **pipeline မရှိသေး**။ လိုရင် ထည့်ရမည်။

---

### SRE Tools (Monitoring / Observability)

| အချက် | အနေအထား | မှတ်ချက် |
|--------|-------------|-----------|
| **Metrics endpoint** | ✅ **ရှိပြီး** | `GET /metrics/` – Prometheus format (requests_total, 5xx, response_time_sum_ms) |
| **Health endpoints** | ✅ ရှိပြီး | `GET /health/`, `GET /health/ready/` |
| **Structured logging** | ✅ ရှိပြီး | SRE middleware (user_id, status_code, response_time_ms) |
| **Alert rules (နမူနာ)** | ✅ ရှိပြီး | `deploy/alerting/prometheus_alerts.yml` |
| **Prometheus server** | ❌ **မထည့်ရသေး** | Metrics ကို scrape လုပ်မယ့် Prometheus process/config က repo ထဲမှာ မပါသေး။ |
| **Grafana** | ❌ **မထည့်ရသေး** | Dashboard / visualization အတွက် Grafana မပါသေး။ |
| **Alertmanager** | ❌ **မထည့်ရသေး** | Alert ပို့မယ့် Alertmanager config မပါသေး။ |

**ဆိုလိုချက်**: App က **SRE-ready** (metrics + health + logging) ဖြစ်ပြီးသား။ ဒါပေမယ့် **Prometheus / Grafana / Alertmanager** ကို repo ထဲမှာ (ဥပမာ docker-compose) ထည့်မထားသေး။ ထည့်ချင်ရင် ထပ်ထည့်ရမည်။

---

## ၂။ CI/CD ထည့်မယ်ဆိုရင် ဘာတွေထည့်ရမလဲ

AI agent သုံးမယ်ဆိုရင် pipeline က **predictable** နဲ့ **repeatable** ဖြစ်ဖို့ အရေးကြီးပါတယ်။ အောက်က ရွေးချယ်စရာများ ဖြစ်ပါတယ်။

### Option A: GitHub Actions (Repo က GitHub မှာဆိုရင်)

ထည့်သင့်တာများ:

1. **CI (Continuous Integration)**  
   - Trigger: `push` / `pull_request` (main, develop)  
   - Steps:  
     - Backend: `cd WeldingProject && pip install -r requirements.txt && python manage.py check && pytest` (သို့မဟုတ် `manage.py test`)  
     - Frontend: `cd yp_posf && npm ci && npm run build`  
   - Optional: Lint (ESLint, Prettier, flake8/black), security scan (e.g. `pip-audit`, `npm audit`)

2. **CD (Continuous Deployment)** – လိုမှ ထည့်ပါ  
   - Trigger: tag (e.g. `v1.0.0`) သို့မဟုတ် `main` branch  
   - Steps: Build Docker images, push to registry, deploy (e.g. SSH to server သို့မဟုတ် k8s)

3. **AI agent အတွက် အကျိုးရှိသည်များ**  
   - Test results / build status ကို report လုပ်နိုင်မယ်  
   - Failure ဖြစ်ရင် log/output များကို context အဖြစ် agent က သုံးနိုင်မယ်  
   - Pipeline config ကို repo ထဲမှာ ရှင်းရှင်းလင်းလင်း ထားရင် agent က “ဘာတွေလုပ်နေလဲ” သိနိုင်မယ်  

### Option B: GitLab CI

- `.gitlab-ci.yml` ထည့်ပြီး stages: `test` → `build` (→ `deploy`)  
- Backend test, frontend build, Docker build စသည်တို့ ထည့်နိုင်ပါတယ်။

### Option C: Local / Self-hosted (Jenkins, Drone, etc.)

- Server မှာ runner တင်ပြီး repo နဲ့ ချိတ်ဆက်ကာ အလားတူ step များ လုပ်နိုင်ပါတယ်။

**ဆွေးနွေးချက်**:  
- **အရင်ထည့်သင့်တာ** = **CI** (test + build). CD က deploy လမ်းကြောင်း သတ်မှတ်ပြီးမှ ထည့်လို့ ရပါတယ်။  
- AI agent အတွက်: `README` သို့မဟုတ် `docs/CI_CD.md` မှာ “CI မှာ ဘာတွေလုပ်လဲ” ကို ရေးထားရင် agent က pipeline ကို ပိုနားလည်နိုင်ပါတယ်။  

---

## ၃။ SRE Tools ထည့်မယ်ဆိုရင် ဘာတွေထည့်ရမလဲ

လက်ရှိ app က **metrics + health** ပေးပြီးသား ဖြစ်တဲ့အတွက် ထပ်ထည့်ရမယ့်က **scraper + dashboard + alerting** ပါ။

### ၃.၁ ထည့်သင့်သည်များ (အကြံပြု)

| Tool | ရည်ရွယ်ချက် | ထည့်နည်း (ဥပမာ) |
|------|----------------|---------------------|
| **Prometheus** | `/metrics/` နဲ့ `/health/ready/` ကို အချိန်မှန် scrape လုပ်ပြီး သိမ်းခြင်း | `docker-compose` ထဲမှာ `prometheus` service + `prometheus.yml` (scrape_configs မှာ backend:8000) |
| **Grafana** | Graph / dashboard (request rate, 5xx, latency) | `docker-compose` ထဲမှာ `grafana` service, Prometheus ကို data source အဖြစ် ထည့်ခြင်း |
| **Alertmanager** (optional) | Alert rule များကို evaluate လုပ်ပြီး Email/Slack စသည်ပို့ခြင်း | `docker-compose` ထဲမှာ `alertmanager` + config, Prometheus ကို alertmanager နဲ့ ချိတ်ခြင်း |

ဒါတွေ ထည့်ပြီးရင်:  
- **SRE / Human** က Grafana ကနေ စောင့်ကြည့်နိုင်မယ်။  
- **AI agent** အတွက်: metrics ကို Prometheus API သို့မဟုတ် Grafana API ကနေ query လုပ်ပြီး “အခု error rate ဘယ်လို ရှိလဲ” စသည်ဖြင့် ဆုံးဖြတ်ချက် ချနိုင်မယ်။  

### ၃.၂ မထည့်လည်း ရသည့်အခြေအနေ

- Production server မှာ Prometheus/Grafana ကို သီးသန့် install လုပ်ပြီး ရှိပြီးသား `/metrics/` ကို scrape လုပ်နေရင် repo ထဲမှာ docker-compose မထည့်လည်း ရပါတယ်။  
- ဆွေးနွေးချက်: **AI agent က metrics ကို သုံးမယ်ဆိုရင်** Prometheus (သို့မဟုတ် metrics endpoint) ကို agent က **ရယူနိုင်တဲ့နေရာ** (internal API, Grafana API, သို့မဟုတ် export script) သတ်မှတ်ပေးရင် ကောင်းပါတယ်။  

---

## ၄။ AI Agent သုံးမှာဖြစ်တဲ့အတွက် ဘာတွေထည့်ရမလဲ (ဆွေးနွေးချက်)

AI agent က **စနစ်ကို စောင့်ကြည့်ခြင်း၊ ပြဿနာ ရှာခြင်း၊ ဆုံးဖြတ်ချက် ပေးခြင်း** လုပ်မယ်ဆိုရင် အောက်က အချက်တွေက အကျိုးရှိပါတယ်။

### ၄.၁ လက်ရှိ ရှိပြီးသား (Agent သုံးလို့ရသည်များ)

| အချက် | ဘာသုံးလို့ရလဲ |
|--------|---------------------|
| **Health** | `GET /health/`, `GET /health/ready/` – agent က “အသက်ရှင်လား၊ traffic ယူနိုင်လား” စစ်နိုင်သည်။ |
| **Metrics** | `GET /metrics/` – request count, 5xx, latency; agent က “error များလား၊ နှေးလား” ဆုံးဖြတ်နိုင်သည်။ |
| **Structured logs** | Log format မှန်ရင် agent က log aggregation နဲ့ ချိတ်ပြီး “ဘာ error တွေဖြစ်နေလဲ” စစ်နိုင်သည်။ |
| **API docs** | `GET /api/docs/` (Swagger) – agent က API ဖွင့်ပိတ် နားလည်နိုင်သည်။ |
| **DB stats** | `GET /api/core/sre/db-stats/` (Staff) – agent က DB အရွယ်အစား စစ်နိုင်သည်။ |

ဒါတွေကို agent က **HTTP API** အနေနဲ့ ခေါ်သုံးနိုင်ပါတယ်။  

### ၄.၂ ထပ်ထည့်သင့်သည်များ (ဆွေးနွေးချက်)

| အချက် | ရည်ရွယ်ချက် | ထည့်နည်း (အကြံပြု) |
|--------|----------------|------------------------|
| **Runbook / Playbook** | Agent က “ပြဿနာ X ဖြစ်ရင် ဘာလုပ်ရမလဲ” သိနိုင်ရန် | `docs/RUNBOOK.md` (သို့မဟုတ် `deploy/runbook/`) မှာ scenario လိုက် steps ရေးထားခြင်း (ဥပမာ: 5xx များရင် log ကြည့်ရန်, DB connection စစ်ရန်) |
| **CI status / Artifacts** | Agent က “နောက်ဆုံး build/test ဘယ်လို ရှိလဲ” သိနိုင်ရန် | CI (GitHub Actions / GitLab CI) ထည့်ပြီး status API သို့မဟုတ် badge/link ကို doc မှာ ဖော်ပြခြင်း |
| **Metrics ရယူနည်း** | Agent က Prometheus/Grafana မရှိလည်း metrics သုံးနိုင်ရန် | `GET /metrics/` ကို doc မှာ ရှင်းပြထားခြင်း၊ လိုရင် `GET /api/sre/summary/` လို simple JSON summary endpoint ထည့်ခြင်း (optional) |
| **Alert → Agent** | Alert ဖြစ်တိုင်း agent က context ရနိုင်ရန် | Alertmanager webhook သို့မဟုတ် Grafana webhook မှ agent (e.g. chatbot / internal API) ကို ပို့ခြင်း |
| **Security / Secrets** | Agent က production credentials မသိရန် | Agent က read-only (health, metrics, logs) သာ သုံးပြီး deploy/secret ကို မထိအောင် စည်းမျဉ်းသတ်မှတ်ခြင်း |

### ၄.၃ မထည့်လိုသည်များ (သို့မဟုတ် သတိနဲ့ထည့်ရမည်များ)

- **Production DB / Redis တိုက်ရိုက်ဝင်ခြင်း** – Agent က application API နဲ့ metrics ကိုသာ သုံးပြီး DB/Redis ကို တိုက်ရိုက်မဝင်အောင် ထားသင့်ပါတယ်။  
- **Secret / credential** – Agent config မှာ secret မထည့်ဘဲ env သို့မဟုတ် secret manager ကနေသာ ယူသင့်ပါတယ်။  

---

## ၅။ အတိုချုပ် – ဘာလုပ်ထားပြီး ဘာထပ်လုပ်ရမလဲ

| ကဏ္ဍ | လုပ်ထားပြီး | ထပ်လုပ်ရမည် (ဆွေးနွေးချက်) |
|--------|----------------|--------------------------------|
| **CI/CD** | Build/deploy scripts ရှိပြီး | **CI pipeline** (test + build on push/PR); လိုမှ CD (auto deploy); doc ထဲမှာ pipeline ဖော်ပြခြင်း |
| **SRE (App)** | Metrics, health, logging, alert rules နမူနာ | - |
| **SRE (Stack)** | - | **Prometheus** (scrape config), **Grafana** (dashboard), လိုရင် **Alertmanager** ထည့်ခြင်း |
| **AI Agent** | Health/metrics/API docs သုံးလို့ရပြီး | **Runbook**, **CI status** ဖော်ပြခြင်း၊ metrics ရယူနည်း ရှင်းပြခြင်း၊ လိုရင် **summary API** သို့မဟုတ် **webhook** ချိတ်ခြင်း |

---

## ၆။ နောက်တစ်ခါ ဆွေးနွေးရန် အချက်များ

1. **CI**: GitHub Actions လား GitLab CI လား? Branch strategy (main vs develop)?  
2. **CD**: Deploy က manual ပဲ ထားမလား၊ tag/main push မှ auto deploy လုပ်မလား?  
3. **SRE stack**: Prometheus + Grafana (နဲ့ Alertmanager) ကို **repo ထဲက docker-compose** မှာ ထည့်မလား၊ သီးသန့် server မှာ ထားမလား?  
4. **AI agent**: Agent က ဘာ platform မှာ run မလဲ (Cursor, internal bot, စသည်)? Agent က metrics ကို **ဘယ်ကနေ** ယူမလဲ (direct `/metrics/`, Prometheus API, Grafana API)?  
5. **Runbook**: ဘယ် scenario တွေအတွက် runbook ရေးမလဲ (5xx, DB down, disk full, စသည်)?  

ဒီအချက်တွေကို ဆွေးနွေးပြီး ဆုံးဖြတ်ချက်ချမှ လိုအပ်တဲ့ config ဖိုင်တွေ (GitHub Actions workflow, docker-compose SRE services, RUNBOOK.md) ကို အတိအကျ ရေးပေးနိုင်ပါတယ်။  

---

**ဆွေးနွေးချက် စာတမ်း ပြီးဆုံးပါသည်။**
