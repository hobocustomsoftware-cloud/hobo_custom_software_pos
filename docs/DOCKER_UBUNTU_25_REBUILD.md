# Docker – Ubuntu 25.10 မှာ အသစ်ပြန် build / push

Ubuntu 25.10 (နဲ့ အခြား host) မှာ image တွေ အသစ်ပြန် build ပြီး လိုရင် registry ကို push လုပ်နည်း။

---

## ၁။ ပြင်ဆင်ပြီးသား အရာများ

- **Base images** ကို Ubuntu 25.10 နဲ့ အဆင်ပြေအောင် ပြင်ထားပြီး:
  - Frontend: `node:22-bookworm-slim`
  - Backend (Django): `python:3.11-slim-bookworm`
- **Rebuild + push script:** `scripts/rebuild_and_push_docker.sh`

---

## ၂။ အသစ်ပြန် build လုပ်ရန် (repo root မှာ)

```bash
./scripts/rebuild_and_push_docker.sh
```

ဒါက frontend နဲ့ backend ကို ပြန် build ပြီး stack ကို ပြန် စတင်ပေးပါတယ်။

**သန့်သန့်နဲ့ ပြန် build (cache မသုံးချင်):**

```bash
./scripts/rebuild_and_push_docker.sh --no-cache
```

---

## ၃။ Build ပြီး Registry ကို push လုပ်ချင်

1. Registry ကို login လုပ်ပါ။ ဥပမာ:
   ```bash
   docker login ghcr.io
   # သို့မဟုတ်
   docker login your-registry.com
   ```
2. `REGISTRY` သတ်မှတ်ပြီး script ကို `--push` နဲ့ ပြေးပါ။ ဥပမာ:
   ```bash
   REGISTRY=ghcr.io/your-org/hobo-pos ./scripts/rebuild_and_push_docker.sh --push
   ```
   ဒါက image တွေကို `ghcr.io/your-org/hobo-pos-frontend:latest` နဲ့ `ghcr.io/your-org/hobo-pos-backend:latest` အနေနဲ့ push လုပ်ပါတယ်။

---

## ၄။ ရှိပြီးသား script များ

| Script | လုပ်ချက် |
|--------|-----------|
| `scripts/rebuild_ui_docker.sh` | UI/design ပြင်ပြီးရင် frontend + backend ပဲ ပြန် build + restart |
| `scripts/rebuild_and_push_docker.sh` | အသစ်ပြန် build + restart၊ လိုရင် push (Ubuntu 25.10 အတွက်) |

---

## ၅။ ပြဿနာတက်ရင်

- **Backend unhealthy / dependency failed:** Backend မတက်ရင် log ကြည့်ပါ:
  ```bash
  docker compose -f compose/docker-compose.yml logs backend
  ```
  migrate မှား / import မှား / port ယူပြီးသား စသည်ကို log မှာ မြင်ရပါမယ်။ ပြင်ပြီး ပြန် စတင်ရန်:
  ```bash
  docker compose -f compose/docker-compose.yml up -d --build backend
  ```
- **Build မအောင်ရင်:** `./scripts/rebuild_and_push_docker.sh --no-cache` နဲ့ ပြန် build ကြည့်ပါ။
- **Port ယူပြီးသား:** `.env` မှာ `FRONTEND_PORT`, `BACKEND_PORT` စသည် သတ်မှတ်ပါ။
- **Postgres / network:** `docker compose -f compose/docker-compose.yml down && docker compose -f compose/docker-compose.yml up -d --force-recreate`
