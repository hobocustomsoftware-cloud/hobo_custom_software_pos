# PostgreSQL "database hobo does not exist" ဖြေရှင်းနည်း

Compose default က database အမည် **hobo_pos** ဖြစ်ပါတယ်။ တစ်ခုခုက **hobo** ဆိုပြီး connect လုပ်နေရင် ဒီ error ပေါ်ပါတယ်။

---

## နည်း ၁ – database "hobo" ကို ဖန်တီးပါ

Postgres ထဲမှာ **hobo** ဆိုတဲ့ database မရှိရင် ဖန်တီးပါ။ (ယူဇာက default **hobo** ဖြစ်နေလို့ `-U hobo` သုံးပါ။)

```bash
cd "/media/htoo-myat-eain/New Volume/hobo_license_pos"
docker compose -p hobo -f compose/docker-compose.yml exec postgres psql -U hobo -d hobo_pos -c "CREATE DATABASE hobo;"
```

အကယ်၍ **user** က **hobo_admin** (သို့) အခြား ဖြစ်နေရင်:

```bash
docker compose -p hobo -f compose/docker-compose.yml exec postgres psql -U hobo_admin -d hobo_pos_db -c "CREATE DATABASE hobo;"
```

ပြီးရင် backend ပြန် start ပါ:

```bash
docker compose -p hobo -f compose/docker-compose.yml restart backend
```

---

## နည်း ၂ – Compose နဲ့ .env ကို ကိုက်ညီအောင်ထားပါ

Compose ကို **project root** မှ run မယ်၊ root မှာ **.env** ရှိမယ်ဆိုရင် ဒီလို ထားပါ:

- Database name တစ်ခုတည်း သုံးမယ် (ဥပမာ **hobo_pos**):
  - `.env` မှာ: `POSTGRES_DB=hobo_pos` နဲ့ `DATABASE_URL=postgres://hobo:hobo_secret@postgres:5432/hobo_pos`
- သို့မဟုတ် **hobo_pos_db** သုံးမယ်ဆိုရင်:
  - Postgres volume **အသစ်** ဖြစ်ရပါမယ် (အရင် run က `hobo_pos` နဲ့ init ဖြစ်ထားရင် `hobo_pos_db` မရှိပါ)။ ဒါကြောင့် နည်း ၁ နဲ့ **hobo** ဖန်တီးပြီး သုံးတာက ပိုမြန်ပါတယ်။

---

## Migrate ပြေးချိန် "postgres: name resolution" ဖြစ်ရင်

`exec backend python manage.py migrate` က backend container ထဲမှာ run ပြီး "postgres" ကို မရှာတွေ့ရင် **run --rm** သုံးပါ (container အသစ်က အတူ network မှာ join မယ်):

```bash
docker compose -p hobo -f compose/docker-compose.yml run --rm backend python manage.py migrate --noinput
```

သို့မဟုတ် stack ကို ပြန် စပါ ပြီးမှ migrate:

```bash
docker compose -p hobo -f compose/docker-compose.yml down
docker compose -p hobo -f compose/docker-compose.yml up -d
# postgres healthy ဖြစ်ပြီး ~30s စောင့်ပါ
docker compose -p hobo -f compose/docker-compose.yml run --rm backend python manage.py migrate --noinput
```

---

## အတိုချုပ်

| လုပ်ရမှာ | Command |
|-----------|---------|
| database "hobo" ဖန်တီးမယ် (user/db default) | `docker compose -p hobo -f compose/docker-compose.yml exec postgres psql -U hobo -d hobo_pos -c "CREATE DATABASE hobo;"` |
| Migrate (postgres resolve မရရင်) | `docker compose -p hobo -f compose/docker-compose.yml run --rm backend python manage.py migrate --noinput` |
| Backend ပြန် စမယ် | `docker compose -p hobo -f compose/docker-compose.yml restart backend` |

ဒီပြီးရင် Register / Login ထပ်စမ်းပါ။
