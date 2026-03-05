# Docker Compose – တစ်စုတည်း သုံးရန်

Container နှစ်စု (compose-* နဲ့ hobo-*) ပြေးနေရင် port နဲ့ network ပြဿနာ ဖြစ်တတ်ပါတယ်။ **တစ်စုတည်း** သုံးပါ။

---

## လက်ရှိ ပြဿနာ

- **compose-postgres-1** က port **5432** ယူထားတယ်
- **hobo** project က postgres စချင်ရင် 5432 လိုတယ် → **port already allocated**
- Backend နှစ်ခု (compose-backend, hobo-backend) ရှိနေတယ်

---

## ဖြေရှင်းနည်း – "compose" ရပ်၊ "hobo" ပဲ သုံးမယ်

### ၁။ "compose" project အားလုံး ရပ်ပါ

```bash
cd "/media/htoo-myat-eain/New Volume/hobo_license_pos"
docker compose -f compose/docker-compose.yml down
```

(ဒီ command က **current directory name** ကို project name အဖြစ် သုံးတတ်ပါတယ်။ directory name က "hobo_license_pos" ဆိုရင် project က "hobo_license_pos" ဖြစ်နိုင်ပါတယ်။)

**Container name** က **compose-** နဲ့ စနေရင် project name က "compose" ဖြစ်နိုင်ပါတယ် (compose/ ဖိုလ်ဒါထဲမှာ run ထားလို့)။ ဒါဆိုရင်:

```bash
docker compose -p compose -f compose/docker-compose.yml down
```

သို့မဟုတ် container တွေကို ကိုယ်တိုင် ရပ်မယ်:

```bash
docker stop compose-postgres-1 compose-backend-1 compose-frontend-1 compose-redis-1
```

### ၂။ "hobo" project ကို ပြန် စပါ

```bash
docker compose -p hobo -f compose/docker-compose.yml up -d
```

အခု **hobo-postgres-1** က 5432 ယူနိုင်ပြီး **hobo-backend-1**, **hobo-frontend-1** တွေလည်း စမယ်။

### ၃။ Status စစ်ပါ

```bash
docker compose -p hobo -f compose/docker-compose.yml ps -a
```

postgres, redis, backend, frontend အားလုံး **Up** (ပါရင် healthy) ဖြစ်နေရပါမယ်။

### ၄။ Migrate ပြေးပါ

```bash
docker compose -p hobo -f compose/docker-compose.yml run --rm backend python manage.py migrate --noinput
```

---

## နောက်ထပ် မှတ်ချက်

- Compose ကို **အမြဲ project root** မှာ run ပါ: `cd "/media/htoo-myat-eain/New Volume/hobo_license_pos"`
- **Project name တစ်ခုတည်း** သုံးပါ: `-p hobo` ထည့်ပြီး `docker compose -p hobo -f compose/docker-compose.yml up -d`
- ဒီလို လုပ်ထားရင် compose-* နဲ့ hobo-* နှစ်စု တစ်ချိန်တည်း မပြေးတော့ပါ။
