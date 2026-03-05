# Design / UI ပြင်ပြီးရင် မြင်ရအောင်

Docker နဲ့ ဖွင့်ထားတဲ့အခါ **Design/UI (Vue, CSS, layout) ပြင်ပြီးရင် ပြောင်းမှာမဟုတ်ဘူး** ဆိုရင် ဒီစာရွက်အတိုင်း လုပ်ပါ။

---

## ဘာကြောင့် မပြောင်းသလဲ

Docker မှာ **Frontend** က build လုပ်ထားတဲ့ file တွေကိုပဲ ပြသတာပါ။  
`yp_posf/src/` ထဲက ပြင်ထားတဲ့ ကုဒ်က container ထဲက **အရင် build ထားတဲ့** `dist/` မဟုတ်လို့ မြင်ရမှာ မဟုတ်ပါ။

---

## နည်း ၁ – Docker မှာပဲ သုံးမယ် (ပြင်ပြီးတိုင်း build ပြန်)

Design/UI ပြင်ပြီးတိုင်း **frontend (+ backend)** ကို ပြန် build ပြီး container ပြန် စတင်ရပါမယ်။

### တစ်ခါထဲ လုပ်မယ် (အကြံပြု)

**Repo root** မှာ:

```bash
./scripts/rebuild_ui_docker.sh
```

ဒီ script က **frontend** နဲ့ **backend** image ကို ပြန် build ပြီး container ပြန် စတင်မယ်။  
repo ထဲက `yp_posf/` ကုဒ် အသစ်ကို Docker build က ယူသွားလို့ **Design/UI ပြင်ပြီးရင်** script တစ်ခါ ပြေးပြီး browser မှာ **Hard Refresh** (Ctrl+Shift+R / Cmd+Shift+R) လုပ်ရင် ပြောင်းပြီး မြင်ရပါမယ်။

### ကိုယ်တိုင် လုပ်မယ်

```bash
# Repo root မှာ
docker compose -f compose/docker-compose.yml up -d --build frontend backend
```

ပြီးရင် browser မှာ **Hard Refresh** (Ctrl+Shift+R) သို့မဟုတ် **Cache ဖျက်ပြီး ပြန်ဖွင့်** ပါ။

---

## နည်း ၂ – UI ပြင်ချိန်မှာ ချက်ချင်း မြင်ချင် (Dev server)

Design/UI **အများကြီး ပြင်မယ်** ဆိုရင် **frontend ကို dev server** နဲ့ ဖွင့်ပြီး ပြင်တိုင်း auto reload မြင်အောင် လုပ်လို့ ရပါတယ်။

1. **Backend က Docker နဲ့ ဖွင့်ထားပါ** (API လိုတာကြောင့်):

   ```bash
   docker compose -f compose/docker-compose.yml up -d
   ```

2. **Frontend ကို dev mode** နဲ့ ဖွင့်ပါ:

   ```bash
   cd yp_posf
   npm run dev
   ```

3. Browser မှာ **Vite ပြထားတဲ့ URL** ဖွင့်ပါ (ဥပမာ `http://localhost:5173/app/`)။  
   ဒီ mode မှာ **ဖိုင် ပြင်တိုင်း စာမျက်နှာ auto reload** ဖြစ်ပြီး UI/UX ပြောင်းချက်တွေ ချက်ချင်း မြင်ရပါမယ်။

4. ပြင်ပြီးသား design ကို **Docker build** ထဲ ထည့်ချင်ရင် နည်း ၁ အတိုင်း `./scripts/rebuild_ui_docker.sh` (သို့) `npm run build` + `docker compose ... --build` ပြန်လုပ်ပါ။

---

## အတိုချုပ်

| လုပ်ချင် | လုပ်ရမယ် |
|-----------|------------|
| Design/UI ပြင်ပြီး Docker မှာ မြင်ချင် | `./scripts/rebuild_ui_docker.sh` ပြေးပြီး browser Hard Refresh |
| ပြင်တိုင်း ချက်ချင်း မြင်ချင် | Backend Docker ဖွင့်၊ `cd yp_posf && npm run dev` ဖွင့်ပြီး dev URL သုံး |
| ပြင်ပြီးသား မပေါ်ရင် | Browser cache ဖျက် (Ctrl+Shift+R) သို့မဟုတ် Incognito ဖွင့်ပြီး ထပ်စမ်းပါ |
