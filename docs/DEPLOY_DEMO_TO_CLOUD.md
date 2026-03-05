# Demo ကို Cloud Server ပေါ်တင်နည်း

လက်ရှိ Docker Compose နဲ့ သုံးနေတဲ့ POS ကို **cloud server (VPS)** ပေါ်မှာ တင်ပြီး demo ပြလို့ရအောင် အတိုချုပ် လမ်းညွှန်။

---

## ၁။ Server လိုအပ်ချက်

- **OS:** Ubuntu 22.04 LTS (သို့) မျိုးတူ Linux
- **RAM:** အနည်းဆုံး 1 GB (2 GB ဆိုပိုကောင်းသည်)
- **Disk:** 10 GB ကျော်
- **Docker + Docker Compose** တပ်ထားရမည်

```bash
# Ubuntu မှာ Docker တပ်နည်း (တစ်ကြိမ်လောက်)
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
# Logout/Login ပြီး
sudo apt install -y docker-compose-plugin
```

---

## ၂။ Project ကို Server ပေါ်ရောက်အောင် လုပ်ခြင်း

**နည်း A — Git clone (အကြံပြု)**

```bash
cd ~
git clone <your-repo-url> hobo_license_pos
cd hobo_license_pos
```

**နည်း B — Zip ပို့ပြီး ဖြေခြင်း**

- Local မှာ project ကို zip လုပ်ပြီး server ပေါ်ကို `scp` / SFTP နဲ့ ပို့ပါ။ Server မှာ `unzip` လုပ်ပါ။

---

## ၃။ Environment သတ်မှတ်ခြင်း (Production)

Repo root မှာ `.env` ဖိုင်ဖန်တီးပြီး (သို့) ပြင်ပါ။

```env
# မထားမဖြစ်
DJANGO_SECRET_KEY=your-very-long-random-secret-key-here
POSTGRES_PASSWORD=strong-password-for-database
DJANGO_ALLOWED_HOSTS=your-domain.com,www.your-domain.com,YOUR_SERVER_IP

# Demo အတွက် license/trial မစစ်ချင်ရင် (တစ်လလောက် သုံးချင်ရင်)
SKIP_LICENSE=true

# Optional
DJANGO_DEBUG=False
FRONTEND_PORT=80
BACKEND_PORT=8001
```

- **DJANGO_ALLOWED_HOSTS:** Domain မရှိသေးရင် server IP ထည့်ပါ (ဥပမာ `43.123.45.67`)။ နောက်မှ domain ချိတ်ရင် domain ကို ထပ်ထည့်ပါ။
- **SKIP_LICENSE=true:** Demo အတွက် license/trial မစစ်ဘဲ သုံးလို့ရအောင် ထားထားနိုင်သည်။

---

## ၄။ Docker Compose နဲ့ စတင်ခြင်း

```bash
cd /path/to/hobo_license_pos
docker compose -f compose/docker-compose.yml up -d --build
```

ပြီးရင်:

- **Port 8888** ဖွင့်ထားရင်: `http://YOUR_SERVER_IP:8888/app/`
- **FRONTEND_PORT=80** ထားရင်: `http://YOUR_SERVER_IP/app/`

Firewall မှာ လိုအပ်သော port (ဥပမာ 8888 သို့မဟုတ် 80) ဖွင့်ထားပါ။

---

## ၅။ Domain + HTTPS (လိုရင်)

- Domain ကို server IP ဆီ **A record** လုပ်ပါ။
- `.env` မှာ `DJANGO_ALLOWED_HOSTS=your-domain.com,www.your-domain.com` ထည့်ပါ။
- Nginx (သို့) Caddy နဲ့ **reverse proxy** လုပ်ပြီး **HTTPS** ထည့်ပါ။ ဥပမာ Nginx:

```nginx
server {
    listen 80;
    server_name your-domain.com;
    location / {
        proxy_pass http://127.0.0.1:8888;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

HTTPS အတွက် Let's Encrypt (certbot) သုံးနိုင်ပါတယ်။

---

## ၆။ Login 500 ဖြစ်နေရင် (ပြင်ဆင်ရန်)

Login လုပ်တိုင်း 500 ပြနေရင် **အမှန်တကယ် error** ကို မြင်အောင် ယာယီ လုပ်ပါ:

1. `.env` မှာ ယာယီ **`DJANGO_DEBUG=True`** ထားပါ။
2. Backend ပြန် start: `docker compose -f compose/docker-compose.yml up -d backend`
3. Browser မှာ Login ပြန်လုပ်ပါ။ 500 ရရင် **Network** tab မှာ response **body** ကြည့်ပါ — ယခု code က DEBUG ဖြစ်ရင် `detail` ထဲမှာ error စာသား ပြပေးမည်။
4. ဒီ error စာသားကို မှတ်ပြီး ပြင်ဆင်နိုင်သည် (သို့) ပြန်ပို့ပြီး မေးနိုင်သည်)။
5. ပြီးရင် **`DJANGO_DEBUG=False`** ပြန်ထားပါ။

Backend log ကြည့်ချင်ရင်:

```bash
docker compose -f compose/docker-compose.yml logs backend --tail=200
```

`Login response build failed:` နဲ့ အတူ ပါတဲ့ line ကို ကြည့်ပါ။

---

## ၇။ အတိုချုပ်

| အဆင့် | လုပ်ရန် |
|--------|----------|
| 1 | Cloud VPS (Ubuntu) + Docker + Docker Compose တပ်ပါ။ |
| 2 | Project ကို Git clone (သို့) zip ပို့ပြီး server ပေါ်တင်ပါ။ |
| 3 | `.env` မှာ `DJANGO_SECRET_KEY`, `POSTGRES_PASSWORD`, `DJANGO_ALLOWED_HOSTS` ထည့်ပါ။ Demo အတွက် `SKIP_LICENSE=true` ထားနိုင်သည်။ |
| 4 | `docker compose -f compose/docker-compose.yml up -d --build` ပြေးပါ။ |
| 5 | Firewall ဖွင့်ပြီး `http://SERVER_IP:8888/app/` ဖွင့်ကြည့်ပါ။ |
| 6 | Domain/HTTPS လိုရင် Nginx reverse proxy + SSL ထည့်ပါ။ |

အသေးစိတ်: `docs/READINESS_HOSTING_EXE_SECURITY.md`, `deploy/multi-instance/README.md` ကြည့်ပါ။
