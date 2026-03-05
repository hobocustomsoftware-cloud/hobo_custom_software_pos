# Register / Login စစ်ဆေးခြင်း လမ်းညွှန်

ဒီစာရွက်မှာ **စာရင်းသွင်းခြင်း (Register)**၊ **ဝင်ရောက်ခြင်း (Login)**၊ **ပထမဦးဆုံး စာရင်းသွင်းသူ Owner ဖြစ်ခြင်း** နဲ့ **ဆိုင်တစ်ဆိုင်ချင်း သီးသန့်ဖြစ်ခြင်း** ကို ဘယ်လို စစ်ဆေးရမလဲ ဖော်ပြထားပါတယ်။

---

## ၁။ စစ်ဆေးရမယ့် အချက်များ

| အချက် | ရှင်းလင်းချက် |
|--------|------------------|
| **Register** | စာရင်းသွင်းခြင်း API နဲ့ စာမျက်နှာ အလုပ်လုပ်မလား |
| **Login** | Username/Password ဖြင့် JWT token ရပြီး ဝင်ရောက်နိုင်မလား |
| **ပထမဦးဆုံး စာရင်းသွင်းသူ = Owner** | ဒီ ဆိုင်အတွက် ပထမဆုံး စာရင်းသွင်းသူက **owner** role ရပြီး ချက်ချင်း ဝင်ရောက်နိုင်ရမယ်။ ဒုတိယသူမှ စပြီး **sale_staff** ဖြစ်ပြီး Admin အတည်ပြုမှ ဝင်ရမယ်။ |
| **တစ်ဆိုင်နဲ့တစ်ဆိုင် မတူခြင်း** | ဆိုင်တစ်ဆိုင်ချင်းက ဒေတာ သီးသန့်ဖြစ်ရမယ် (တစ်ဆိုင်က ဒေတာနဲ့ အခြားဆိုင်က ရောမသွားရ)။ လက်ရှိ ဒီဇိုင်းမှာ EXE တစ်ခုချင်းစီ (သို့) Docker/Hosting instance တစ်ခုချင်းစီမှာ **Database သီးသန့်ရှိပါတယ်**။ ဒါကြောင့် ဆိုင်တစ်ဆိုင်ချင်း သီးသန့်ဖြစ်ခြင်းက **instance တစ်ခုချင်းစီမှာ DB သီးသန့်ရှိခြင်း** နဲ့ စစ်ဆေးရပါတယ်။ |

---

## ၂။ Backend Tests (Django)

Register နဲ့ Login ကို API အဆင့်မှာ စစ်ဆေးဖို့ `core.tests` ထဲမှာ test များ ထည့်ထားပါတယ်။

### ပြေးနည်း
```bat
cd WeldingProject
python manage.py test core.tests.RegisterViewTest core.tests.LoginTokenTest -v 2
```
(ပရောဂျက် root မှာ `venv` သုံးထားရင် အရင် `venv\Scripts\activate` လုပ်ပါ။)

### စစ်ဆေးသည့် အချက်များ
- **RegisterViewTest**
  - `test_register_first_user_is_owner` — ပထမဦးဆုံး စာရင်းသွင်းသူက **owner** role ရပြီး `can_login_now: true` ပြန်ရမယ်
  - `test_register_second_user_is_sale_staff` — ဒုတိယ စာရင်းသွင်းသူက **sale_staff** ဖြစ်ပြီး `can_login_now: false` ပြန်ရမယ်
  - `test_register_validation_password_mismatch` — စကားဝှက် မကိုက်ညီရင် 400
  - `test_register_validation_duplicate_username` — Username ရှိပြီးသားဆိုရင် 400
- **LoginTokenTest**
  - `test_login_success_returns_token` — မှန်ကန်သော username/password ဖြင့် **access** နဲ့ **refresh** token ရမယ်
  - `test_login_invalid_credentials_returns_401` — မှားသော password ဖြင့် 401

---

## ၃။ E2E Tests (Playwright)

Frontend စာမျက်နှာ Register / Login နဲ့ Dashboard သို့ ပြောင်းခြင်းကို စစ်ဆေးဖို့ `yp_posf/e2e/register-login.spec.js` သုံးပါတယ်။

### လိုအပ်ချက်
- Backend (Django) စတင်ထားရမယ် (ဥပမာ `python manage.py runserver` သို့ Docker backend)
- Frontend (Vite) စတင်ထားရမယ် (`cd yp_posf` then `npm run dev`)

### ပြေးနည်း
```bat
cd yp_posf
npx playwright test e2e/register-login.spec.js --project=chromium
```

### Test များ
1. **register first user then login and see dashboard** — Register စာမျက်နှာမှာ ပထမဦးဆုံး user စာရင်းသွင်းပြီး ချက်ချင်း Dashboard သို့ ရောက်မလား စစ်မယ်။ (ဒီ test က **user မရှိသေးတဲ့ DB** မှာပဲ အောင်မြင်မယ် — ဥပမာ SQLite သစ် သို့ test DB)
2. **login with invalid credentials shows error** — မှားသော username/password နဲ့ ဝင်ရောက်ကြိုးစားရင် error ပြမလား စစ်မယ်
3. **login with valid credentials redirects to dashboard** — မှန်ကန်သော user (ဥပမာ `owner` / `demo123` — seed_demo_users ပြေးထားရင်) နဲ့ login ဝင်ပြီး Dashboard သို့ ပြောင်းမလား စစ်မယ်

Environment variable သတ်မှတ်ချင်ရင်:
```bat
set PLAYWRIGHT_LOGIN_USER=owner
set PLAYWRIGHT_LOGIN_PASS=demo123
npx playwright test e2e/register-login.spec.js --project=chromium
```

---

## ၄။ လက်ဖြင့် စစ်ဆေးခြင်း (Manual)

### Register
1. Browser မှာ `/register` ဖွင့်ပါ
2. ပထမဦးဆုံး user အနေနဲ့ စာရင်းသွင်းပါ (username, စကားဝှက် နှစ်ကြိမ်)
3. အောင်မြင်ပြီး **ချက်ချင်း Dashboard** သို့ သွားမလား စစ်ပါ
4. Logout လုပ်ပြီး **ဒုတိယ user** အသစ် စာရင်းသွင်းကြည့်ပါ — အောင်မြင်ပြီး “Admin မှ အတည်ပြုပြီးနောက် ဝင်ရောက်နိုင်ပါမည်” လို မျိုးြပြီး `/login` သို့ ပြန်သွားမလား စစ်ပါ

### Login
1. `/login` မှာ မှန်ကန်သော username/password ထည့်ပြီး Sign In — Dashboard သို့ ရောက်ရမယ်
2. မှားသော password ထည့်ပြီး Sign In — error ပြရမယ်

### ပထမဦးဆုံး user = Owner စစ်ဆေးခြင်း
- ပထမဦးဆုံး စာရင်းသွင်းထားသော user နဲ့ login ဝင်ပြီး **Settings**၊ **Users/Roles** စတဲ့ owner-only စာမျက်နှာများ ဝင်ရောက်နိုင်မလား စစ်ပါ
- Backend မှာ `/api/core/me/` ခေါ်ပြီး response ထဲက `role_name` က **owner** ဖြစ်နေမလား စစ်ပါ

### တစ်ဆိုင်နဲ့တစ်ဆိုင် သီးသန့်ဖြစ်ခြင်း
- **EXE:** EXE တစ်ခု run ထားတဲ့ ကွန်ပျူတာမှာ စာရင်းသွင်းထားတဲ့ user နဲ့ ဒေတာများက ဒီ EXE instance ရဲ့ DB (ဥပမာ SQLite) ထဲမှာပဲ ရှိရမယ်။ အခြား EXE (သို့) အခြား ကွန်ပျူတာ) က ဒေတာ မမြင်ရပါ။
- **Docker:** Docker instance တစ်ခုချင်းစီမှာ Postgres သီးသန့်ရှိပြီး၊ တစ်ဆိုင်နဲ့တစ်ဆိုင် ဒေတာ မရောပါ။
- စစ်ဆေးရင်: instance နှစ်ခု (ဥပမာ EXE နှစ်ခု သို့ Docker နှစ်ခု) ဖွင့်ပြီး တစ်ခုမှာ စာရင်းသွင်းထားသော user/ဒေတာက အခြားတစ်ခုမှာ မပေါ်ရပါ။

---

## ၅။ အတိုချုပ်

- **Register / Login စစ်ဆေးခြင်း:** Backend tests (`core.tests.RegisterViewTest`, `core.tests.LoginTokenTest`) နဲ့ E2E (`e2e/register-login.spec.js`) သုံးပါ။
- **ပထမဦးဆုံး စာရင်းသွင်းသူ Owner:** Backend မှာ `RegisterSerializer` က ပထမဦးဆုံး user ကို **owner** သတ်မှတ်ပြီး `can_login_now: true` ပြန်ပေးပါတယ်။ ဒါကို `test_register_first_user_is_owner` နဲ့ စစ်ပါ။
- **တစ်ဆိုင်နဲ့တစ်ဆိုင် သီးသန့်ဖြစ်ခြင်း:** Instance တစ်ခုချင်းစီမှာ DB သီးသန့်ရှိခြင်း (EXE = SQLite per install, Docker = Postgres per stack) နဲ့ စစ်ဆေးပါ။
