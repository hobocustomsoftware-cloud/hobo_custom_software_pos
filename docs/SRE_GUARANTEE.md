# HoBo POS - SRE အာမခံချက် (Site Reliability Assurance)

**ရက်စွဲ**: 2026-02-17  
**အဆင့်**: Production-ready / ဆိုင်ခွဲများ တစ်ပြိုင်တည်းသုံးစွဲမှု အတွက် ပြင်ဆင်ပြီး

---

## ၁။ အာမခံချက် ပြုထားသည့် အချက်များ

| အချက် | အာမခံချက် | စစ်ဆေးနည်း |
|--------|-------------|--------------|
| **Liveness** | App လည်ပတ်နေပါသည် | `GET /health/` → `{"status":"ok"}` |
| **Readiness** | DB ချိတ်ဆက်ပြီး ဝန်ဆောင်မှုပေးနိုင်ပါသည် | `GET /health/ready/` → `{"status":"ready","db":"ok"}` |
| **Metrics** | Prometheus ဖြင့် စောင့်ကြည့်နိုင်ပါသည် | `GET /metrics/` → Prometheus text format |
| **Rate limiting** | အသုံးပြုသူ/ဆိုင်ခွဲ တစ်ပြိုင်တည်းသုံးမှု ထိန်းချုပ်ပါသည် | API 200/min per user, Auth 20/min per IP |
| **Connection pooling** | DB connection ပြန်သုံးခြင်းဖြင့် ဆိုင်ခွဲများ အဆင်ပြေစေပါသည် | PostgreSQL `CONN_MAX_AGE=60` |
| **Structured logging** | Request/response မှတ်တမ်းများ ရရှိပါသည် | `user_id`, `status_code`, `response_time_ms` |
| **Database monitoring** | DB အရွယ်အစား စစ်ဆေးနိုင်ပါသည် | `GET /api/core/sre/db-stats/` (Staff only) |
| **API documentation** | Swagger/OpenAPI ဖြင့် API မှတ်တမ်းရရှိပါသည် | `GET /api/docs/` |

---

## ၂။ Monitoring စနစ် (Prometheus + Grafana)

- **`/metrics/`** မှ ရရှိသော metric များ:
  - `hobopos_requests_total` – စုစုပေါင်း request အရေအတွက်
  - `hobopos_requests_5xx_total` – 5xx error အရေအတွက်
  - `hobopos_response_time_sum_ms` – response time စုစုပေါင်း (ms)
  - `hobopos_info` – app version

- **Alerting အတွက် နမူနာ** (Prometheus Alertmanager / Grafana):
  - 5xx များလာပါက alert: `increase(hobopos_requests_5xx_total[5m]) > 0`
  - Readiness ပျက်ပါက: `/health/ready/` က 503 ပြန်ပါက alert

- **Optional**: Email/SMS alert များကို Alertmanager သို့မဟုတ် Grafana Notification channel မှ ချိတ်ဆက်နိုင်ပါသည်။ နမူနာ config များကို `deploy/alerting/` တွင် ထည့်သွင်းထားပါသည်။

---

## ၃။ ဆိုင်ခွဲများ တစ်ပြိုင်တည်းသုံးစွဲမှု (Multi-Branch Concurrency)

- **Connection reuse**: PostgreSQL အတွက် `CONN_MAX_AGE=60` သတ်မှတ်ထားပြီး၊ connection များ ပြန်သုံးသဖြင့် ဆိုင်ခွဲများ တစ်ပြိုင်တည်းသုံးစွဲသည့်အခါ DB ချိတ်ဆက်မှု ပိုမိုထိရောက်ပါသည်။
- **Rate limiting**: User တစ်ဦးချင်းစီအတွက် 200 req/min ဖြင့် ထိန်းချုပ်ထားသဖြင့် တစ်ပြိုင်တည်း user များလာသည့်အခါ စနစ် မပျက်စီးစေပါ။
- **စစ်ဆေးချက်**: Load testing လုပ်ရန် `docs/MULTI_BRANCH_CONCURRENCY.md` ကို ကြည့်ပါ။

---

## ၄။ Production Checklist

- [ ] `DJANGO_SECRET_KEY` ကို strong random key သတ်မှတ်ပါ
- [ ] `DJANGO_DEBUG=False` ထားပါ
- [ ] `DJANGO_ALLOWED_HOSTS` သတ်မှတ်ပါ
- [ ] `SECURE_SSL_REDIRECT=true` (HTTPS reverse proxy သုံးပါက)
- [ ] PostgreSQL password အားကောင်းစွာ သတ်မှတ်ပါ
- [ ] Redis သုံးပါ (rate limiting, cache, channels)
- [ ] Backup များ အချိန်မှန်လုပ်ပါ (`deploy/backup/`)

---

## ၅။ ဆက်သွယ်ရန်

- SRE / Monitoring မေးခွန်းများအတွက်: Project maintainer နှင့် ဆက်သွယ်ပါ။
- Runbook များ: `deploy/` အောက်ရှိ backup, Docker config များကို ကြည့်ပါ။
