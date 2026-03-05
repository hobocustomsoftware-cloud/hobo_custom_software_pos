# shop-settings 404 ဖြစ်ခြင်း ဖြေရှင်းနည်း

## လက္ခဏာ
- Browser Console မှာ `GET http://localhost:5173/api/core/shop-settings/ 404 (Not Found)` ပေါ်မယ်
- Login စာမျက်နှာမှာ ဆိုင်လိုဂို/အမည် မပေါ်ဘဲ default "HoBo POS" ပဲ ပြနိုင်သည်

## အကြောင်းရင်းများ နှင့် ဖြေရှင်းနည်း

### ၁။ Backend (Django) မစတင်ထားခြင်း
Request က Vite (5173) ကနေ Backend (8000) ကို proxy သွားသည်။ Backend မဖွင့်ရင် ချိတ်ဆက်မှု မရဘဲ 502 သို့မဟုတ် 404 ရနိုင်သည်。

**ဖြေရှင်းနည်း:** Backend စတင်ပါ။
```bat
cd WeldingProject
python manage.py runserver 0.0.0.0:8000
```
(venv သုံးထားရင် အရင် `venv\Scripts\activate`)

### ၂။ Backend route စစ်ဆေးခြင်း
Backend စတင်ထားပြီးရင် အောက်ပါ URL ကို Browser မှာ ဖွင့်ကြည့်ပါ။
```
http://localhost:8000/api/core/shop-settings/
```
- **200 OK** နဲ့ JSON (shop_name, logo_url စသည်) ပြန်ရင် route မှန်ပါသည်။ Frontend ကို ပြန်စတင် (npm run dev) ကြည့်ပါ။
- **404** ပြန်ရင် Django url config စစ်ပါ: `WeldingProject/WeldingProject/urls.py` မှာ `api/core/shop-settings` route ပါပါစေ။
- **500** ပြန်ရင် migration ပြေးပါ: `python manage.py migrate`

### ၃။ Frontend မှာ သတိပေးချက်
Login စာမျက်နှာမှာ "Backend API မချိတ်ရသေးပါ။ Backend (Django) စတင်ထားပါ။" ပေါ်နေရင် Backend မဖွင့်ရသေးခြင်း သို့မဟုတ် 404 ကြောင့် ဖြစ်နိုင်သည်။ Backend စတင်ပြီး စစ်ပါ။

---

## အတိုချုပ်
1. Backend စတင်ပါ – `python manage.py runserver 0.0.0.0:8000`
2. စစ်ပါ – `http://localhost:8000/api/core/shop-settings/` ဖွင့်ကြည့်ပါ (200 + JSON ရပါစေ)
3. Frontend ပြန်စတင်ပါ – `cd yp_posf` then `npm run dev`
