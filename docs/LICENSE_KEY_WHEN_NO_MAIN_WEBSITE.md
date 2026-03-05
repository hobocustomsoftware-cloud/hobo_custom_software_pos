# License Key ကိစ္စ — Main Website မတင်ရသေးချိန်

လက်ရှိ license စနစ်မှာ **EXE** က license activate လုပ်တဲ့အခါ **LICENSE_SERVER_URL** သတ်မှတ်ထားရင် ဒီ server (main website) ကို ခေါ်ပြီး validate လုပ်မယ်။ Main website မတင်ရသေးရင် server မရှိသေးတာမို့ **offline** နည်းနဲ့ license ပေးလို့ရအောင် လုပ်ထားပါတယ်။

---

## ၁။ လက်ရှိ လမ်းကြောင်း အတိုချုပ်

| အခြေအနေ | ဖြစ်လေ့ |
|------------|----------|
| **Trial** | App စ run ကတည်းက ၃၀ ရက် trial + ၅ ရက် grace။ Server မလိုပါ။ |
| **Activate (key ထည့်ခြင်း)** | `LICENSE_SERVER_URL` ရှိရင် server ကို ခေါ်မယ်။ မရှိရင် **local DB** မှာ ရှိတဲ့ key ကိုပဲ စစ်မယ် (hosting/EXE ကိုယ်တိုင် run တဲ့ Django မှာ license သွင်းထားရမယ်)။ |
| **license.lic ဖိုင်** | EXE folder ထဲမှာ `license.lic` ရှိပြီး ထဲက `machine_id` က ဒီစက်နဲ့ ကိုက်ရင် **offline licensed** ဖြစ်မယ်။ Server မလိုပါ။ |

Main website မတင်ရသေးချိန်မှာ server မရှိသေးတာမို့ **license.lic ဖိုင်** နည်းနဲ့ ပေးတာက အဆင်ပြေဆုံးပါတယ်။

---

## ၂။ Main Website မတင်ရသေးချိန် — ဘယ်လို လုပ်သင့်သလဲ

### ၂.၁ ရွေးစရာ A: Offline license.lic ဖိုင် ထုတ်ပြီး ပေးခြင်း (အကြံပြု)

**အဆင့်:**

1. **Customer က app (သို့) EXE** စ run ပြီး **Machine ID** ယူမယ်  
   - App ထဲက License / Activate စာမျက်နှာမှာ Machine ID ပြမယ် (သို့)  
   - `GET /api/license/status/` ခေါ်ရင် response ထဲမှာ `machine_id` ပါမယ်။  

2. **သင့် (developer) ဘက်မှာ** ဒီ project ကို run ထားပြီး management command လုပ်မယ်:

   ```bash
   cd WeldingProject
   python manage.py issue_license_file --machine-id <customer_machine_id> --type on_premise_perpetual --output license.lic
   ```

   ဒါက **license.lic** ဖိုင် ထုတ်ပေးမယ် (key အသစ် ထုတ်ပြီး ဖိုင်ထဲ ထည့်မယ်)။  

3. **ဖိုင်** ကို customer ကို ပေးမယ် (email / link စသည်)။  

4. **Customer** က ဒီ ဖိုင်ကို **HoBoPOS.exe ရဲ့ folder ထဲ** ထည့်မယ် (EXE နဲ့ တစ်ခုတည်း directory)။  

5. App ကို ပြန် run လိုက်ရင် **license.lic** ဖတ်ပြီး **licensed** ဖြစ်မယ်။ Server မလိုပါ။  

**Hosted (သက်တမ်းသတ်မှတ်) ပေးချင်ရင်:**

```bash
python manage.py issue_license_file --machine-id <mid> --type hosted_annual --expires 2026-12-31 --output license.lic
```

---

### ၂.၂ ရွေးစရာ B: Key ကို DB မှာ သွင်းထားပြီး ဖိုင်ထုတ်ခြင်း

License key ကို သင် ကြိုသတ်မှတ်ထားပြီး (ဥပမာ ငွေစာရင်းနဲ့ ချိတ်မယ်) ဆိုရင်:

1. **Key ဖန်တီးမယ်** (တစ်ကြိမ်လောက်):

   ```bash
   python manage.py create_license --type on_premise_perpetual
   ```

   ထွက်လာတဲ့ key (ဥပမာ `WLD-XXX-YYY`) ကို မှတ်ထားမယ်။  

2. **Customer က machine_id** ပေးလာတိုင်း ဖိုင်ထုတ်မယ်:

   ```bash
   python manage.py issue_license_file --key WLD-XXX-YYY --machine-id <customer_machine_id> --output license.lic
   ```

   ဒီ key က **DB မှာ ရှိပြီးသား** ဖြစ်ရမယ်။ type / expires က DB ထဲက အတိုင်း သုံးမယ်။  

3. **license.lic** ကို customer ကို ပေးပြီး EXE folder ထဲ ထည့်ခိုင်းမယ်။  

---

### ၂.၃ ရွေးစရာ C: Main Website တင်ပြီးချိန်

Main website (license server) တင်ပြီးရင်:

- Server မှာ **LICENSE_SERVER_URL** မထည့်ထားဘဲ EXE က key ထည့်ရင် သာမာန် **local DB** path ပဲ ဖြစ်မယ် (EXE ဘက်က server ကို မခေါ်ပါ)။  
- EXE ဘက်မှာ **LICENSE_SERVER_URL** သတ်မှတ်ထားရင် (config / env) app က activate လုပ်တဲ့အခါ **main website** ကို ခေါ်မယ်။  
- Server မှာ **create_license** နဲ့ key ဖန်တီးထားပြီး **remote-activate** က key + machine_id စစ်ပြီး bind လုပ်မယ်။  

ဒီအခါ **license.lic ဖိုင် မပေးဘဲ** customer က app ထဲမှာ key ထည့်ပြီး Activate လုပ်ရင် server နဲ့ ချိတ်ပြီး activate ဖြစ်မယ်။  

---

## ၃။ Management commands အတိုချုပ်

| Command | ရည်ရွယ်ချက် |
|---------|----------------|
| `create_license --type on_premise_perpetual` | License key အသစ် ဖန်တီးပြီး **DB** မှာ သိမ်းမယ် (main website / server အတွက်)။ |
| `create_license --type hosted_annual --years 1` | သက်တမ်းသတ်မှတ် key ဖန်တီးမယ်။ |
| `issue_license_file --machine-id <mid> [--type TYPE] [--expires YYYY-MM-DD] [--output license.lic]` | **Offline** license.lic ထုတ်မယ် (key အသစ် ထုတ်ပြီး ဖိုင်ထဲ ထည့်မယ်)။ Main website မလိုပါ။ |
| `issue_license_file --key WLD-XXX --machine-id <mid>` | DB မှာ ရှိပြီးသား key နဲ့ license.lic ထုတ်မယ်။ |

---

## ၄။ အတိုချုပ်

- **Main website မတင်ရသေးချိန်**: Customer က **Machine ID** ပေးမယ် → သင် က **issue_license_file** နဲ့ **license.lic** ထုတ်မယ် → customer က ဒီ ဖိုင်ကို **EXE folder** ထဲ ထည့်မယ် → app က offline licensed ဖြစ်မယ်။  
- **Main website တင်ပြီးချိန်**: LICENSE_SERVER_URL သတ်မှတ်ပြီး app ထဲမှာ key ထည့်ပြီး Activate လုပ်ရင် server နဲ့ ချိတ်ပြီး activate လုပ်လို့ရမယ်။  

လိုရင် `issue_license_file` ကို script / ငွေစာရင်းစနစ်နဲ့ ချိတ်ပြီး ဖိုင်ထုတ်တာ automate လုပ်လို့ရပါတယ်။
