# Docker Test Checklist

ဒီစာရွက်မှာ Docker ဖွင့်ပြီး စစ်ရမယ့် အချက်တွေ စုစည်းထားပါတယ်။

---

## ၁။ ပြင်ထားတာ (Fixed Issues)

### Tailwind CSS v4 Compatibility

- ✅ **`shadow-glow`** utility class → `src/assets/main.css` မှာ `@layer utilities` နဲ့ သတ်မှတ်ထားပြီး
- ✅ **`bg-dashboard-deep`** → `@layer utilities` မှာ utility class အဖြစ် ထည့်ထားပြီး
- ✅ **`shadow-glow-sm`**, **`shadow-glow-lg`** → ထည့်ထားပြီး

**ဖိုင်များ:**
- `yp_posf/src/assets/main.css` – custom utilities အားလုံး `@layer utilities` ထဲမှာ

---

## ၂။ Docker စစ်ဆေးရမယ့် အချက်များ

### Backend (Django)

- [ ] **Build လုပ်လို့ ရမရ** → `docker-compose build backend`
- [ ] **Container စတင်လို့ ရမရ** → `docker-compose up backend`
- [ ] **Health check** → `GET http://localhost:8000/health/` (200 OK)
- [ ] **Database migration** → Logs မှာ "Running migrations..." ပြီး error မရှိ
- [ ] **Static files** → `collectstatic` ပြီးသား
- [ ] **API endpoints** → `GET /api/settings/exchange-rate/` (401/200)

### Frontend (Vue + Vite)

- [ ] **Build လုပ်လို့ ရမရ** → `docker-compose build frontend`
  - Tailwind CSS v4 build မှာ error မရှိ (shadow-glow, bg-dashboard-deep)
- [ ] **Container စတင်လို့ ရမရ** → `docker-compose up frontend`
- [ ] **Nginx serve** → `GET http://localhost/` (Vue app ပေါ်မယ်)
- [ ] **API proxy** → Frontend ကနေ `/api/` calls က backend ကို ရောက်မယ်
- [ ] **WebSocket** → `/ws/` proxy လုပ်လို့ ရမရ

### Integration

- [ ] **Frontend → Backend** → Login, API calls လုပ်လို့ ရမရ
- [ ] **WebSocket** → Real-time notifications (Channels) လုပ်လို့ ရမရ
- [ ] **Static files** → Media files (images, uploads) serve လုပ်လို့ ရမရ

---

## ၃။ Docker Commands

### Build & Start

```bash
cd F:\hobo_license_pos
docker-compose -f deploy/server/docker-compose.yml up -d --build
```

### Logs

```bash
# Backend logs
docker-compose -f deploy/server/docker-compose.yml logs -f backend

# Frontend logs
docker-compose -f deploy/server/docker-compose.yml logs -f frontend

# All logs
docker-compose -f deploy/server/docker-compose.yml logs -f
```

### Stop

```bash
docker-compose -f deploy/server/docker-compose.yml down
```

---

## ၄။ Environment Variables (.env)

`deploy/server/.env` ဖိုင်မှာ:

- `DJANGO_SECRET_KEY` (required)
- `POSTGRES_PASSWORD` (required)
- `OPENAI_API_KEY` (optional – AI features အတွက်)
- `AI_API_URL` (optional)
- `AI_MODEL` (optional)

`.env.example` ကို copy လုပ်ပြီး `.env` လုပ်ပါ။

---

## ၅။ စစ်ဆေးရမယ့် Features

- [ ] **Login** → Frontend မှာ login form, Backend API `/api/token/` လုပ်လို့ ရမရ
- [ ] **Dashboard** → Bento grid, Total Revenue, USD Rate, Smart Business Insight
- [ ] **POS** → Sales terminal, product search, cart, USD rate input
- [ ] **AI Features** → "ဒါလေးရောမလိုဘူးလား", Smart Insight (AI_API_KEY set လုပ်ထားရင်)
- [ ] **Inventory** → Products, Categories, Locations
- [ ] **Reports** → Sales, Inventory, Service reports

---

## ၆။ ပြဿနာ ရှိရင်

- **Build error** → Logs စစ်ပါ (`docker-compose logs`)
- **Tailwind error** → Frontend build logs မှာ `shadow-glow` / `bg-dashboard-deep` error ရှိမရှိ စစ်ပါ
- **API 404** → Nginx proxy config (`nginx.conf`) စစ်ပါ
- **Database error** → PostgreSQL container logs စစ်ပါ
- **WebSocket error** → `/ws/` proxy config စစ်ပါ

---

*စစ်ဆေးသည့်ရက်: ၂၀၂၅ ဖေဖော်ဝါရီ*
