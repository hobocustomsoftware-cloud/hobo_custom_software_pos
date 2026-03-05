# ဆိုင်ခွဲများ တစ်ပြိုင်တည်းသုံးစွဲမှု (Multi-Branch Concurrency)

**ရက်စွဲ**: 2026-02-17  
**အချက်**: ဆိုင်ခွဲများ တစ်ပြိုင်တည်းသုံးပြီး user များများလာသည့်အခါ အဆင်ပြေစေရန် ပြင်ဆင်ထားချက်များ။

---

## ၁။ ပြင်ဆင်ပြီး အချက်များ

| အချက် | ရည်ရွယ်ချက် |
|--------|----------------|
| **Connection pooling** | PostgreSQL အတွက် `CONN_MAX_AGE=60` သတ်မှတ်ထားပြီး connection များ ပြန်သုံးသည်။ ဆိုင်ခွဲများ တစ်ပြိုင်တည်း request များပို့သည့်အခါ DB connection အရေအတွက် ထိန်းနိုင်သည်။ |
| **API rate limiting** | User တစ်ဦးချင်းစီအတွက် 200 req/min (`ApiUserThrottle`)။ တစ်ပြိုင်တည်း user များလာသည့်အခါ တစ်ဦးချင်း လုပ်ဆောင်မှု ထိန်းချုပ်ပြီး ဆာဗာမပျက်စီးစေရန်။ |
| **Auth rate limiting** | Login အတွက် 20/min per IP။ Brute force ကာကွယ်ပြီး ဆိုင်ခွဲများမှ တစ်ပြိုင်တည်း login များလည်း ထိန်းထားသည်။ |
| **Location-based data** | ရောင်းချမှု/လှည့်မှုများကို `sale_location` / `primary_location` ဖြင့် ခွဲထားသဖြင့် ဆိုင်ခွဲအလိုက် ဒေတာ ကွဲပြားသည်။ |
| **Redis** | Rate limiting နှင့် cache အတွက် Redis သုံးထားသဖြင့် worker/instance များကြား သတင်းချက်များ မျှဝေနိုင်သည်။ |

---

## ၂။ Production တွင် သတ်မှတ်ရန်

- **PostgreSQL**: Docker/Production မှာ `DATABASE_URL` သုံးပါ။ `CONN_MAX_AGE` ကို settings မှာ 60 သတ်မှတ်ပြီးသား။
- **Redis**: `REDIS_URL` သတ်မှတ်ပါ။ Rate limiting နှင့် cache အတွက် လိုအပ်သည်။
- **Daphne / Workers**: User အရေအတွက် များလာပါက Daphne worker အရေအတွက် သို့မဟုတ် process များ မြှင့်နိုင်သည်။
- **Load balancer**: ဆိုင်ခွဲများ/ဝန်ဆောင်မှု များလာပါက Nginx/HAProxy ဖြင့် backend များ ရှေ့မှာ load balance လုပ်နိုင်သည်။

---

## ၃။ စစ်ဆေးချက် (အဆင်ပြေမပြေ)

- **Health**: `GET /health/ready/` က 200 ပြန်ပါက app + DB ချိတ်ဆက်ပြီး ဝန်ဆောင်မှုပေးနိုင်သည်။
- **Rate limit**: API ကို 200/min ထက် ပိုခေါ်ပါက 429 ပြန်ပါသည်။
- **Load testing**: k6, Locust သို့မဟုတ် Apache Bench ဖြင့် တစ်ပြိုင်တည်း user/request များ စမ်းသပ်နိုင်သည်။  
  နမူနာ: `ab -n 500 -c 20 -H "Authorization: Bearer <token>" http://localhost:8000/api/staff/items/`

---

## ၄။ အတိုချုပ်

ဆိုင်ခွဲများ တစ်ပြိုင်တည်းသုံးစွဲခြင်းနှင့် user အရေအတွက် များလာခြင်းအတွက် connection pooling၊ rate limiting၊ location-based ဒေတာ နှင့် Redis ကို သတ်မှတ်ပြီး ပြင်ဆင်ထားပါသည်။ Load testing လုပ်ပြီး လိုအပ်ပါက worker/instance များ မြှင့်တင်နိုင်ပါသည်။
