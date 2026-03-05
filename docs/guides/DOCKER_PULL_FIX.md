# Docker Pull Error ဖြေရှင်းနည်း (connection reset by peer)

Error မှာ `r2.cloudflarestorage.com` ပါနေရင် Docker က **registry mirror** (Cloudflare) ကနေ ဆွဲနေပြီး connection ပြတ်နေတာပါ။

---

## နည်း ၁ – Registry mirror ပိတ်ပြီး ပြန် pull မယ်

### ၁.၁ Docker config စစ်ပါ

```bash
# System Docker config
cat /etc/docker/daemon.json

# သို့မဟုတ် user config (Docker Desktop style)
cat ~/.docker/daemon.json
```

အထဲမှာ **`registry-mirrors`** ပါနေရင် ဒီ mirror ကြောင့် Cloudflare ဆီ သွားနေတာပါ။

### ၁.၂ registry-mirrors ဖယ်ပါ

```bash
sudo nano /etc/docker/daemon.json
```

**ဖြစ်နိုင်တဲ့ ပုံစံများ:**

ဒီလိုပါနေရင်:
```json
{
  "registry-mirrors": ["https://xxxx.r2.cloudflarestorage.com/..."],
  ...
}
```

**`registry-mirrors` လိုင်းကို ဖျက်ပါ** (သို့) လိုင်းတစ်ခုလုံး ဖျက်ပြီး အောက်က လို ကျန်ရင် ဒီအတိုင်းထားပါ:
```json
{
  "dns": ["8.8.8.8", "8.8.4.4"]
}
```

သိမ်းပါ (Ctrl+O, Enter, Ctrl+X)။

### ၁.၃ Docker ပြန် start ပြီး pull ပါ

```bash
sudo systemctl restart docker
docker compose -f compose/docker-compose.yml up -d --build
```

ဒီအခါ Docker Hub ကို တိုက်ရိုက် ဆွဲမှာမို့ connection reset မဖြစ်တော့နိုင်ပါ။  

(Mirror ပြန်သုံးချင်ရင် နောက်မှ `daemon.json` ပြန် ပြင်နိုင်ပါတယ်။)

---

## နည်း ၂ – Docker မသုံးပဲ ကိုယ်တိုင် run ပြီး စစ်မယ်

Docker pull မရသေးရင် **Postgres/Redis မလို** ပဲ Backend (SQLite) + Frontend ကို ကွန်ပျူတာမှာ တိုက်ရိုက် run ပြီး စစ်လို့ရပါတယ်။

### လိုအပ်ချက်
- Python 3.11+
- Node.js 18+
- (Redis မလိုပါ – SQLite only သုံးမယ်)

### Backend (SQLite)

```bash
cd "/media/htoo-myat-eain/New Volume/hobo_license_pos/WeldingProject"
python -m venv .venv
source .venv/bin/activate   # Linux/Mac. Windows: .venv\Scripts\activate
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver 0.0.0.0:8000
```

Backend: http://localhost:8000

### Frontend (terminal အသစ်)

```bash
cd "/media/htoo-myat-eain/New Volume/hobo_license_pos/yp_posf"
npm install --legacy-peer-deps
npm run dev
```

Frontend: http://localhost:5173 (သို့မဟုတ် ပြသထားတဲ့ port)

Browser မှာ http://localhost:5173 သွားပြီး App စစ်ကြည့်နိုင်ပါတယ်။ API က Backend ကို ညွှန်းထားဖို့ လိုပါမယ် (Vite env မှာ `VITE_API_URL=http://localhost:8000/api` စသဖြင့်)။

---

## အတိုချုပ်

| ပြဿနာ | လုပ်ရမှာ |
|--------|------------|
| Cloudflare / connection reset | `/etc/docker/daemon.json` မှာ `registry-mirrors` ဖယ်ပြီး `sudo systemctl restart docker` |
| Docker မသုံးချင် | Backend: `python manage.py runserver 0.0.0.0:8000`၊ Frontend: `npm run dev` |
