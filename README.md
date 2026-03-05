# HoBo POS (License)

ပရောဂျက်ရဲ့ ဖိုလ်ဒါဖွဲ့စည်းပုံ နဲ့ ဘယ်လို run မလဲ အတိုချုပ်။

## ဖိုလ်ဒါဖွဲ့စည်းပုံ (Project structure)

| Folder | ရည်ရွယ်ချက် |
|--------|----------------|
| **compose/** | Docker Compose ဖိုင်အားလုံး။ Root မှာ run: `docker compose -f compose/docker-compose.server.yml up -d --build` |
| **docs/** | စာရွက်စာတမ်းများ။ **audit/** စစ်ဆေးချက်၊ **simulation/** စီမီကျူလေးရှင်း၊ **docker/** ဒေါကာချိန်ညှိ၊ **guides/** လမ်းညွှန် |
| **scripts/** | စကရစ်များ။ **bat/** Windows .bat၊ **ps1/** PowerShell၊ **sh/** Shell၊ **python/** Python၊ **mjs/** Node .mjs |
| **server/** | Backend (Django), Nginx, Dockerfile။ Standalone: `docker compose -f server/docker-compose.yml up -d --build` |
| **WeldingProject/** | Django project (core, inventory, accounting, …) |
| **yp_posf/** | Vue frontend |
| **deploy/** | Deploy, installer, backup, alerting |
| **assets/** | Logo, static assets |
| **data/** | machine_id, simulation_log စသည် |

## စတင်အသုံးပြုခြင်း

- **Docker (Standalone):**  
  **run.bat** (Windows) သို့ **run.sh** (Linux/macOS) သို့ **make up** — root က `.env` ကို အလိုအလျောက် သုံးသည်။  
  သို့မဟုတ်: `docker compose -f compose/docker-compose.server.yml --env-file .env up -d --build`  
  (.env မရှိလည်း default password နဲ့ စတင်နိုင်သည်။ Production အတွက် `.env` ထည့်ပါ။)
- **Scripts:** Root ကနေ run မယ်ဆိုရင် ဥပမာ `scripts\bat\run_lite.bat` သို့ `scripts\ps1\run_simulation.ps1`
- **လမ်းညွှန်:** `docs/guides/QUICK_START.md`, `docs/docker/RUN_MIGRATIONS_AND_DOCKER.md`

Root မှာ .env, .gitignore, db.sqlite3 လို လိုအပ်တဲ့ဖိုင်တွေပဲ ထားပြီး ကျန်တာတွေကို သက်ဆိုင်ရာ folder တွေထဲ စီထားပါတယ်။
