# Database ရှင်းပြီး Demo Trial တစ်လ + ဆိုင်များ စမ်းခြင်း

Database ကို ရှင်းပြီး **trial တစ်လ** စတင်ကာ **တစ်ဆိုင်တည်း** သို့မဟုတ် **ဆိုင်ခွဲ ၃/၄/၅ ဆိုင်** (သို့) **ဆိုင် ၂၀** စမ်းလို့ရအောင် setup လုပ်သည့် management command ဖြစ်သည်။ လာစမ်းသူက တစ်ဆိုင်တည်းလည်း ရှိနိုင်သလို ဆိုင်ခွဲ သုံးလေးငါးဆိုင်လည်း စမ်းလို့ရအောင် `--outlets` နဲ့ ရွေးနိုင်သည်။

---

## လုပ်ဆောင်ချက်

- **`--flush`** သုံးရင်: DB ရှင်း (flush) → migrate → `seed_base_units` → Trial စတင် (`trial_start_date` = ယနေ့) → admin user + Role များ → ဆိုင်များ ဖန်တီး။
- **`--outlets 1`** (default): တစ်ဆိုင်တည်း (ဆိုင်ချုပ် ပဲ)။
- **`--outlets 3` / `4` / `5`**: ဆိုင်ချုပ် ၁ + ဆိုင်ခွဲ ၂/၃/၄ ဆိုင်။
- **`--outlets 20`**: ဆိုင်ချုပ် ၁ + ဆိုင်ခွဲ ၁၉ = ၂၀ ဆိုင်။
- **`--flush` မသုံးရင်**: ရှိပြီး DB မှာ Trial ရက် ပြန်သတ်မှတ်ပြီး ဆိုင်များ မပြည့်သေးရင် ထပ်ဖန်တီးမည်။

Trial က **၃၀ ရက်**။ `SKIP_LICENSE=true` ထားရင် trial မစစ်ဘဲ သုံးလို့ရသည်။ Trial စစ်ချင်ရင် `SKIP_LICENSE=false` ထားပြီး run ပါ။

---

## Docker နဲ့ သုံးမယ်

```bash
# Repo root မှာ
cd /path/to/hobo_license_pos

# Stack စတင်ထားပြီးသား ဖြစ်ရမယ်
docker compose -f compose/docker-compose.yml up -d

# တစ်ဆိုင်တည်း
docker compose -f compose/docker-compose.yml exec backend python manage.py reset_trial_20_outlets --flush --outlets 1

# ဆိုင်ခွဲ ၃ သို့မဟုတ် ၅ ဆိုင်
docker compose -f compose/docker-compose.yml exec backend python manage.py reset_trial_20_outlets --flush --outlets 3
docker compose -f compose/docker-compose.yml exec backend python manage.py reset_trial_20_outlets --flush --outlets 5

# ဆိုင် ၂၀
docker compose -f compose/docker-compose.yml exec backend python manage.py reset_trial_20_outlets --flush --outlets 20
```

**Script သုံးမယ် (repo root မှ):**

```bash
./scripts/reset_trial_20_outlets_docker.sh --flush --outlets 1   # တစ်ဆိုင်တည်း
./scripts/reset_trial_20_outlets_docker.sh --flush --outlets 5   # ဆိုင်ခွဲ ၅ ဆိုင်
./scripts/reset_trial_20_outlets_docker.sh --flush               # default တစ်ဆိုင်တည်း
```

---

## Local / venv မှာ

```bash
cd /path/to/hobo_license_pos/WeldingProject
python manage.py reset_trial_20_outlets --flush --outlets 1   # တစ်ဆိုင်တည်း
python manage.py reset_trial_20_outlets --flush --outlets 5   # ဆိုင်ခွဲ ၅ ဆိုင်
```

ပြီးရင် **admin / admin123** နဲ့ login ဝင်ပြီး ဆိုင် ၂၀ ပြောင်းရွေးစမ်းလို့ရပါသည်။

ပစ္စည်း/ categories ထည့်ချင်ရင် ထပ်ပြေးပါ:

```bash
python manage.py seed_shop_demo --shop general
```

(Docker မှာဆိုရင် `docker compose -f compose/docker-compose.yml exec backend python manage.py seed_shop_demo --shop general`)

---

## ဆိုင်အရေအတွက်

| --outlets | ရလဒ် |
|-----------|--------|
| 1 | တစ်ဆိုင်တည်း (MAIN ပဲ) |
| 3 | ဆိုင်ချုပ် + ဆိုင်ခွဲ ၂ (MAIN, BRANCH_01, BRANCH_02) |
| 4 | ဆိုင်ချုပ် + ဆိုင်ခွဲ ၃ |
| 5 | ဆိုင်ချုပ် + ဆိုင်ခွဲ ၄ |
| 20 | ဆိုင်ချုပ် + ဆိုင်ခွဲ ၁၉ (BRANCH_01 … BRANCH_19) |

တစ်ဆိုင်ချင်းစီမှာ Warehouse + Shopfloor location အလိုအလျောက် ပါသွားသည်။
