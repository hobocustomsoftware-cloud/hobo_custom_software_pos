# ဆိုင်အမျိုးအစားအလိုက် Demo Data ထည့်ခြင်း

တစ်ဆိုင်ချင်းစီ ကိုယ်တိုင် စမ်းကြည့်နိုင်ရန် categories, products, units, outlets နှင့် stock ထည့်ပေးသည့် management command ဖြစ်သည်။

---

## Docker နဲ့ သုံးမယ်

Stack ကို Docker Compose နဲ့ ဖွင့်ထားပြီးရင် **backend** container ထဲမှာ seed ပြေးပါ။

**`Unknown command: 'seed_shop_demo'` ပြရင်** – backend image ကို ပြန် build လုပ်ပါ (ဖိုင် အသစ်ထည့်ပြီး build မလုပ်ရသေးရင်):

```bash
docker compose -f compose/docker-compose.yml build backend
docker compose -f compose/docker-compose.yml up -d
```

ပြီးမှ အောက်က command တွေ ပြေးပါ။

```bash
# Repo root မှာ
cd /path/to/hobo_license_pos

# Stack စတင်ထားပြီးသား ဖြစ်ရမယ်
docker compose -f compose/docker-compose.yml up -d

# ဆေးဆိုင် data (DB ရှင်းပြီးမှ ထည့်မယ်)
docker compose -f compose/docker-compose.yml exec backend python manage.py seed_shop_demo --shop pharmacy --flush

# ဖုန်းဆိုင် data
docker compose -f compose/docker-compose.yml exec backend python manage.py seed_shop_demo --shop mobile --flush

# ဆိုင်အားလုံး တစ်ခါထည့်မယ် (flush မလုပ်)
docker compose -f compose/docker-compose.yml exec backend python manage.py seed_shop_demo --shop all
```

**Script သုံးမယ် (repo root မှ):**

```bash
./scripts/seed_shop_demo_docker.sh --shop pharmacy --flush
./scripts/seed_shop_demo_docker.sh pharmacy --flush
./scripts/seed_shop_demo_docker.sh all
```

**သတိပြုရန်:** `--flush` သုံးရင် DB အားလုံး ရှင်းသွားပြီး migrate ပြန်ပြေးကာ demo data ထည့်မယ်။ Docker volume (`postgres_data`) မှာ data ရှိနေရင် ပြန်ထည့်တာဖြစ်ပါတယ်။

**Database ရှင်းပြီး trial တစ်လ + ဆိုင် ၂၀ စမ်းချင်ရင်:** [RESET_TRIAL_20_OUTLETS.md](RESET_TRIAL_20_OUTLETS.md) ကြည့်ပါ။ `python manage.py reset_trial_20_outlets --flush` (သို့) `./scripts/reset_trial_20_outlets_docker.sh --flush` သုံးပါ။

---

## လိုအပ်ချက် (local / venv)

- Django project (WeldingProject) အတွက် virtual environment ဖွင့်ပြီး `pip install -r requirements.txt` လုပ်ထားပါ။

---

## Command လုပ်ဆောင်ချက်

```bash
cd WeldingProject
# Virtual environment ဖွင့်ပါ (ဥပမာ)
# source venv/bin/activate   # Linux/Mac
# .\venv\Scripts\activate    # Windows

python manage.py seed_shop_demo --shop <type> [--flush]
```

### ဆိုင်အမျိုးအစား (`--shop`)

| Value | ဆိုင်အမျိုးအစား |
|-------|---------------------|
| `pharmacy` | ဆေးဆိုင် |
| `pharmacy_clinic` | ဆေးခန်းတွဲ ဆေးဆိုင် |
| `mobile` | ဖုန်း/အီလက်ထရွန်းနစ်ဆိုင် |
| `computer` | ကွန်ပျူတာဆိုင် |
| `solar` | ဆိုလာ/ဘက်ထရီဆိုင် |
| `hardware` | အိမ်ဆောက်ပစ္စည်းဆိုင် |
| `general` | အထွေထွေလက်လီ |
| `all` | အားလုံး တစ်ခါထည့်မည် |

### Options

- **`--flush`** – DB ရှင်းပြီးမှ migrate ပြေးကာ demo data ထည့်မည်။ တစ်ဆိုင်ချင်း သန့်သန့်စမ်းချင်ရင် သုံးပါ။

---

## ဥပမာ

```bash
# ဆေးဆိုင် data သပ်ထည့်မယ် (DB ရှင်းပြီးမှ)
python manage.py seed_shop_demo --shop pharmacy --flush

# ဖုန်းဆိုင် data သပ်ထည့်မယ်
python manage.py seed_shop_demo --shop mobile --flush

# ဆိုင်အားလုံး (ဆေးဆိုင်၊ ဆေးခန်းတွဲ၊ ဖုန်း၊ ကွန်ပျူတာ၊ ဆိုလာ၊ သံပစ္စည်း၊ အထွေထွေ) တစ်ခါထည့်မယ်
python manage.py seed_shop_demo --shop all

# DB မရှင်းပဲ ဆိုလာ data ထပ်ထည့်မယ်
python manage.py seed_shop_demo --shop solar
```

---

## ထည့်ပေးသော Data

- **User:** `admin` / `admin123` (သို့) ဖုန်း `09123456789`
- **Outlets:** ဆိုင်ချုပ် (Main), ဆိုင်ခွဲ အေ (Branch A)
- **Units:** ရွေးထားသော ဆိုင်အမျိုးအစားအလိုက် (ဆေးဆိုင် → Tablet/Strip/Box စသည်၊ သံပစ္စည်း → ပေ/မီတာ/ဒါဇင် စသည်)
- **Categories & Products:** ဆိုင်အမျိုးအစားနဲ့ ကိုက်ညီသော ဥပမာ ပစ္စည်းများ
- **Stock:** ပထမဆုံး ပစ္စည်းအတွက် Inbound + Transfer ထည့်ပေးထားသည် (POS/Inventory စမ်းလို့ရအောင်)

---

## စမ်းသပ်နည်း

1. လိုသော ဆိုင်အမျိုးအစားအတွက် `seed_shop_demo` ပြေးပါ (လိုရင် `--flush` သုံးပါ)။  
2. Frontend ဖွင့်ပြီး **Login:** `admin@example.com` / `admin123` (သို့) ဖုန်း `09123456789`။  
3. **Settings** မှ လုပ်ငန်းအမျိုးအစားကို ထိုဆိုင်နဲ့ ကိုက်အောင် ရွေးပါ (ဥပမာ ဆေးဆိုင် ရွေးထားရင် ယူနစ်များ ဆေးဆိုင်အတွက် ပြမည်)။  
4. **Items/Products**, **Inventory**, **POS**, **Reports** စသည်ဖြင့် စမ်းကြည့်ပါ။  

ဆိုင်တစ်မျိုးပြီး တစ်မျိုး စမ်းချင်ရင် `--shop pharmacy --flush` ပြေးပြီး စမ်းကာ၊ ပြီးရင် `--shop mobile --flush` ထပ်ပြေးပြီး စမ်းနိုင်ပါသည်။
