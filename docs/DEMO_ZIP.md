# Demo Folder + Zip ထုတ်ခြင်း

လာစမ်းသူများကို **တစ်ဆိုင်တည်း** သို့မဟုတ် **ဆိုင်ခွဲ ၃/၄/၅ ဆိုင်** စမ်းလို့ရအောင် လိုအပ်တာတွေပဲ ပါတဲ့ demo folder ဖန်တီးပြီး zip ထုတ်နည်း။

## Demo zip ထုတ်မယ်

Repo root မှာ:

```bash
./scripts/build_demo_zip.sh
```

ထွက်လာမယ့် ဖိုင်: **`build/hobo_pos_demo.zip`**

ဒီ zip ထဲမှာ ပါတာတွေ:
- `compose/` – Docker Compose
- `WeldingProject/` – Backend (Django)
- `yp_posf/` – Frontend (Vue) – node_modules မပါ (Docker build မှာ npm install ပြေးမယ်)
- `scripts/` – reset_trial, seed_shop_demo Docker scripts
- `docs/` – RESET_TRIAL_20_OUTLETS.md, SEED_SHOP_DEMO.md
- `deploy/backup/` – ဗလာ folder (compose က mount လုပ်ထားသည့်အတွက်)
- `README_DEMO.md` – ဖြည်ပြီး စမ်းနည်း

## လာစမ်းသူက သုံးနည်း

1. **hobo_pos_demo.zip** ကို ဖြည်ပါ။
2. ဖြည်ထားတဲ့ folder ထဲ သွားပြီး:
   ```bash
   docker compose -f compose/docker-compose.yml up -d --build
   ```
3. Trial တစ်လ + ဆိုင်များ ထည့်မယ်:
   - **တစ်ဆိုင်တည်း:**  
     `docker compose -f compose/docker-compose.yml exec backend python manage.py reset_trial_20_outlets --flush --outlets 1`
   - **ဆိုင်ခွဲ ၃ သို့မဟုတ် ၅ ဆိုင်:**  
     `--outlets 3` သို့မဟုတ် `--outlets 5` သုံးပါ။
4. Browser: **http://localhost:8888/app/** → Login: **admin / admin123**

အသေးစိတ် ဖြည်ထားတဲ့ folder ထဲက **README_DEMO.md** မှာ ပါပြီးသား။
