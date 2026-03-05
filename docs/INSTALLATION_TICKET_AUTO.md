# Installation Ticket အလိုအလျောက် ဖန်တီးခြင်း / သွားတိုင်းရမည့်အဆင့်

## Ticket (Installation No.) ဘယ်လို ထုတ်သလဲ

- **Installation Job** တစ်ခု ဖန်တီးတိုင်း **installation_no** က **အလိုအလျောက်** ထွက်ပါတယ်။
- ပုံစံ: **`INST-YYMMDD-0001`** (ဥပမာ INST-260221-0001 = 2026-02-21 ရက်နေ့ ပထမခု)
- ကုဒ်: `installation/models.py` ထဲက `InstallationJob.save()` မှာ `installation_no` မရှိရင် ဒီပုံစံနဲ့ generate လုပ်ပါတယ်။

---

## အလိုအလျောက် Ticket ဖန်တီးခြင်း (ပြင်ပြီး)

**လက်ရှိ:** Sale **approved** ဖြစ်ပြီး ထို sale မှာ အောက်ပါအခြေအနေ ပါရင် **Installation Job (ticket)** တစ်ခု **အလိုအလျောက်** ဖန်တီးပါတယ်။

1. **Bundle (Set)** ရောင်းထားပြီး bundle type က **Solar** သို့မဟုတ် **Machine** ဖြစ်ခြင်း  
2. **ပစ္စည်းအမည်** မှာ စာလုံး solar, inverter, battery, panel, machine ပါခြင်း  

ထို sale အတွက် Installation Job ရှိပြီးသား ဖြစ်နေရင် ထပ်မဖန်တီးပါ။  

**ကုဒ်:** `installation/signals.py` – `create_installation_job_on_sale`  
- လိပ်စာ: ဖောက်သည့် address ရှိရင် သုံး၊ မရှိရင် "လိပ်စာ ထည့်သွင်းရန်"  
- ရက်စွဲ: ယနေ့ + ၃ ရက် (ပြင်လို့ရပါတယ်)  
- created_by: စနစ်က ဖန်တီးတာမို့ null (လိုရင် နောက်မှ user ပြင်နိုင်သည်)  

---

## လက်ဖြင့် Ticket ဖန်တီးခြင်း

- Installation စာမျက်နှာမှ **Installation Job အသစ် ထည့်ခြင်း** နဲ့လည်း ticket ဖန်တီးလို့ ရပါတယ်။  
- ထိုအခါ လည်း **installation_no** က အလိုအလျောက် **INST-YYMMDD-XXXX** ထွက်ပါတယ်။  

---

## သွားတိုင်းရမည့်အဆင့် (Site visit)

တပ်ဆင်မပြုလုပ်မီ **သွားရောက်စစ်ဆေးရမည့်** job တွေအတွက်:

- **Status:** **သွားတိုင်းရမည် (Site visit)** ထည့်ထားပါတယ်။  
  - အဆင့်အလိုက်: Pending → **သွားတိုင်းရမည်** → In Progress → Completed → Signed Off
- **သွားတိုင်းရမည့်ရက် (site_visit_date):** Installation Job detail မှာ ရက်စွဲ ထည့်ပြင်နိုင်ပါတယ်။ (ရွေးချယ်မှု)
- Dashboard မှာ **သွားတိုင်းရမည်** အရေအတွက် ပြပါတယ်။

---

## အတိုချုပ်

| အချက် | ဖြေရှင်း |
|--------|------------|
| **Ticket number (installation_no)** | Installation Job ဖန်တီးတိုင်း model save() မှာ အလိုအလျောက် INST-YYMMDD-0001 ပုံစံ ထုတ်သည်။ |
| **အလိုအလျောက် ticket ဖန်တီးခြင်း** | Sale approved + Solar/Machine bundle သို့မဟုတ် installation ပါသော ပစ္စည်းရောင်းရင် signal က Installation Job တစ်ခု အလိုအလျောက် ဖန်တီးသည်။ |
| **လက်ဖြင့်** | Installation UI ကနေ လိုသလို Job ထပ်ထည့်နိုင်သည်။ |
| **သွားတိုင်းရမည့်အဆင့်** | Status **သွားတိုင်းရမည်** နဲ့ **သွားတိုင်းရမည့်ရက်** ထည့်ပြီး စီမံနိုင်သည်။ |
