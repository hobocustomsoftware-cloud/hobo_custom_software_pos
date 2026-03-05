# Register / Login 500 Error ဖြေရှင်းနည်း (Docker)

POST `/api/core/register/` သို့မဟုတ် login မှာ **500 Internal Server Error** ရရင် backend မှာ Python exception တက်နေတာပါ။ အတိအကျ သိဖို့ **backend log** ကြည့်ရပါမယ်။

---

## ⚠️ Login 500 ပြင်ပြီး ကုဒ်အသစ် သုံးဖို့ – Docker ပြန် build လုပ်ရမယ်

Backend ကုဒ် (auth_views, settings စသည်) **ပြင်ပြီးရင်** container ထဲမှာ အဟောင်းပဲ ပြေးနေသေးတတ်ပါတယ်။ **ပြန် build လုပ်မှ** အသစ် ဝင်ပါတယ်။

**Project root** မှာ အောက်က အတိုင်း run ပါ:

```bash
cd "/path/to/hobo_license_pos"   # မိမိ repo path နဲ့ အစားထိုးပါ
docker compose -f compose/docker-compose.yml down
docker compose -f compose/docker-compose.yml up -d --build
```

သို့မဟုတ် **တစ်ချက်တည်း** (down မလုပ်):

```bash
docker compose -f compose/docker-compose.yml up -d --build
```

Build ပြီးရင် **Login** ပြန်စမ်းပါ။ မရသေးရင် အောက်က **၁။ Backend log ကြည့်ပါ** နဲ့ **၂။** ဆက်ဖတ်ပါ။

---

## Design ပြင်ပြီးရင် မပေါ်ရင် (UI/CSS အသစ် မတက်ရင်)

Frontend (Vue) design ပြင်ထားတာတွေ **အဆင်ပြေပြေမပေါ်ရင်** အောက်က နည်းနှစ်မျိုးထဲက တစ်မျိုး လုပ်ပါ။

### နည်း ၁ – Frontend ကို ပြန် build ပြီး Docker သုံးမယ်

Docker က **host ပေါ်က `yp_posf/dist`** ကို သုံးနေရင် – design အသစ် ထည့်ပြီးရင် **frontend ပြန် build** လုပ်ပါ။

```bash
cd "/path/to/hobo_license_pos/yp_posf"
VITE_BASE=/app/ npm run build
```

ပြီးရင် **backend container ပြန် start** လုပ်ပါ (dist အသစ်ကို copy ယူမယ်):

```bash
cd "/path/to/hobo_license_pos"
docker compose -f compose/docker-compose.yml restart backend
```

သို့မဟုတ် အကုန်ပြန် တင်မယ်:

```bash
docker compose -f compose/docker-compose.yml up -d --build
```

### နည်း ၂ – Docker image ကို ပြန် build (Frontend ပါ အသစ်ထည့်မယ်)

Host မှာ `yp_posf/dist` မသုံးဘဲ **image ထဲက frontend** သုံးနေရင် (သို့) နည်း ၁ နဲ့ မရသေးရင် – **backend image ပြန် build** လုပ်ပါ။ Frontend stage ပါ ပြန် run မယ်၊ design အသစ် ပါသွားမယ်။

```bash
cd "/path/to/hobo_license_pos"
docker compose -f compose/docker-compose.yml build --no-cache backend
docker compose -f compose/docker-compose.yml up -d
```

### Browser cache ရှင်းပါ

Design ပြင်ပြီးသား မြင်ချင်ရင် browser က **cache** ကြောင့် အဟောင်းပဲ ပြနေတတ်ပါတယ်။

- **Hard refresh:** `Ctrl+Shift+R` (Windows/Linux) သို့မဟုတ် `Cmd+Shift+R` (Mac)  
- သို့မဟုတ် **Incognito/Private window** နဲ့ ဖွင့်ပြီး စမ်းပါ။

---

## ရှိနေတဲ့ Docker တွေအကုန်ဖျက်ပြီး အသစ်ပြန် တင်ခြင်း

Container တွေ + volume တွေ ဖျက်ပြီး image အသစ်နဲ့ ပြန် တင်ချင်ရင် **project root** မှာ အောက်က အတိုင်း run ပါ။

**၁။ ရပ်ပြီး container + volume ဖျက်ပါ** (DB ထဲက data ပါ ပျက်သွားမယ် – လိုမှ လုပ်ပါ)

```bash
cd "/path/to/hobo_license_pos"
docker compose -f compose/docker-compose.yml down -v
```

**၂။ (ချင်မှ) image တွေပါ ဖျက်ပါ** – နောက်တစ်ခါ build က အစမှ ပြန် build ဖြစ်မယ်

```bash
docker compose -f compose/docker-compose.yml down --rmi local
```

**၃။ အသစ်ပြန် တင်ပါ**

```bash
docker compose -f compose/docker-compose.yml up -d --build
```

**တစ်ချက်တည်း (container + volume ဖျက် + ပြန် တင်):**

```bash
docker compose -f compose/docker-compose.yml down -v && docker compose -f compose/docker-compose.yml up -d --build
```

---

## ၁။ Backend log ကြည့်ပါ

**Project root** မှာ:

```bash
cd "/media/htoo-myat-eain/New Volume/hobo_license_pos"
docker compose -p hobo -f compose/docker-compose.yml logs backend
```

သို့မဟုတ် real-time:

```bash
docker compose -p hobo -f compose/docker-compose.yml logs -f backend
```

ပြီးမှ Browser မှာ **Register** (သို့) **Login** ထပ်လုပ်ပါ။ Log ထဲမှာ **Traceback** နဲ့ **Error message** ပေါ်လာပါမယ်။

---

## ၂။ အဖြစ်များတဲ့ အကြောင်းရင်းများ

### (က) Database table မရှိခြင်း (migrations မပြေးသေးခြင်း)

Error မှာ ဒီလိုပါနေရင်:
- `relation "core_user" does not exist`
- `relation "core_role" does not exist`
- `no such table`

**ဖြေရှင်း:** Backend container ထဲမှာ migrate ပြေးပါ။

```bash
docker compose -p hobo -f compose/docker-compose.yml exec backend python manage.py migrate --noinput
```

ပြီးရင် Browser မှာ Register/Login ထပ်စမ်းပါ။

---

### (ခ) Static/Media သို့မဟုတ် အခြား path ပြဿနာ

Error မှာ `FileNotFoundError` သို့မဟုတ် `Permission denied` ပါနေရင် log အပြည့်အစုံကြည့်ပြီး path / permission ပြင်ပါ။

---

### (ဂ) Redis / Celery မရခြင်း

Register မှာ marketing sync task သုံးထားရင် Redis မရရင် warning ပဲ ထွက်ပြီး 500 မဖြစ်သင့်ပါ။ သို့သော် log မှာ Redis connection error ပါနေရင် Redis container စနေပါစေ: `docker compose -p hobo -f compose/docker-compose.yml ps` နဲ့ စစ်ပါ။

---

## ၃။ Migrate ပြန်ပြေးခြင်း (အားလုံး စစ်ပြီးသား)

မှားယွင်းမှု မရှိဘဲ DB နဲ့ code ကိုက်အောင် migrate ပြန်ပြေးချင်ရင်:

```bash
docker compose -p hobo -f compose/docker-compose.yml exec backend python manage.py migrate --noinput
```

ပြီးရင် backend ပြန် start (optional):

```bash
docker compose -p hobo -f compose/docker-compose.yml restart backend
```

---

## အတိုချုပ်

| လုပ်ရမှာ | Command |
|-----------|---------|
| 500 ဖြစ်ရင် ပထမ လုပ်မှာ | `docker compose -p hobo -f compose/docker-compose.yml logs backend` |
| Table မရှိရင် | `docker compose -p hobo -f compose/docker-compose.yml exec backend python manage.py migrate --noinput` |
| Backend ပြန် စရင် | `docker compose -p hobo -f compose/docker-compose.yml restart backend` |

Log ထဲက **Traceback နဲ့ error စာသား** ကို copy ယူပြီး ပြဿနာ ဆက်ရှာနိုင်ပါတယ်။
