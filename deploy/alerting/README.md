# Alerting (SRE - A to K Recommendation)

HoBo POS အတွက် critical error / downtime များကို Email/SMS ဖြင့် အကြောင်းကြားနိုင်ရန် နမူနာ configuration များ။

## Prometheus Alertmanager

- `prometheus_alerts.yml` – 5xx များလာချိန်၊ readiness ပျက်ချိန် alert များ
- Alertmanager မှာ email/SMS receiver သတ်မှတ်ပြီး route ချိတ်ဆက်နိုင်ပါသည်။

## Grafana

- Grafana Notification channels မှာ Email / Slack / Webhook ထည့်ပြီး Dashboard alert များ ချိတ်ဆက်နိုင်ပါသည်။

## လိုအပ်ချက်

- Prometheus က `/metrics/` နှင့် `/health/ready/` ကို scrape လုပ်ထားရမည်။
- Production မှာ Alertmanager / Grafana ကို deploy လုပ်ပြီး ဤ folder မှ config များ ယူသုံးနိုင်ပါသည်။
