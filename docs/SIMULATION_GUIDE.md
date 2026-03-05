# Browser Simulation & Screenshot Guide

ဆိုင်အမျိုးအစားအလိုက် POS စမ်းသပ်ခြင်း၊ Daily Sale ပြီးရင် Sale Report ကြည့်ခြင်း၊ တစ်ဆိုင်ချင်း တစ်လစာ Report ကြည့်နည်း နှင့် Screenshot ရိုက်နည်း။

---

## ၁။ ပြင်ဆင်ချက်

- **Backend:** `cd WeldingProject && python manage.py runserver`
- **Frontend:** `cd yp_posf && npm run dev`
- **Browser:** Chrome/Edge ဖွင့်ပြီး `http://localhost:5173` (သို့) deploy URL သို့သွားပါ။

---

## ၂။ ဆိုင်အမျိုးအစားအလိုက် စမ်းသပ်ခြင်း

Register ပြီးချိန်တွင် **Setup Wizard** မှ လုပ်ငန်းအမျိုးအစား ရွေးပါ။ ရွေးထားသော အမျိုးအစားအလိုက် **ယူနစ်များ** အလိုအလျောက်သတ်မှတ်ပါမည်။

| ဆိုင်အမျိုးအစား | ရွေးရန် Value | ရရှိမည့် ယူနစ်များ (ဥပမာ) |
|-------------------|-----------------|------------------------------|
| ဆေးဆိုင် | Pharmacy | Tablet, Strip, Card, Bottle, Box |
| ဆေးခန်းတွဲ ဆေးဆိုင် | Pharmacy + Clinic | အပေါ်နဲ့အတူ |
| ဖုန်း/အီလက်ထရွန်းနစ် | Mobile / Electronics | Pcs, Card, Box |
| Solar / လျှပ်စစ် | Electronic / Solar | Feet, Inch, Pcs, Card, Roll |
| အိမ်ဆောက်ပစ္စည်းဆိုင် | Hardware | Pcs, Feet, Meter, Dozen, Box, Roll |
| အထွေထွေလက်လီ | General Retail | Pcs, Card, Box |

**စမ်းသပ်အဆင့် (တစ်ဆိုင်ချင်း):**

1. **Register** → ဆိုင်အမည်၊ ဖုန်း၊ စကားဝှက် ထည့်ပြီး အကောင့်ဖွင့်ပါ။
2. **Setup Wizard** → လုပ်ငန်းအမျိုးအစား ရွေးပါ (အပေါ်ဇယားပါ တစ်ခုခု)။ ပြီးရင် **Complete setup** နှိပ်ပါ။ ယူနစ်များ အလိုအလျောက်သတ်မှတ်ပါမည်။
3. **Shop Locations** → ဆိုင်ခွဲ (Outlet) ဖန်တီးပါ။ Purchase Order ထည့်မည်ဆိုလျှင် အနည်းဆုံး Outlet တစ်ခု လိုပါမည်။
4. **Items / Products** → ပစ္စည်းထည့်ပါ။ Item Modal ကို **Basic | Units | Specs | Serial** tab များနဲ့ ပြင်ဆင်ထားပါပြီး ကြည့်ကောင်းအောင် သုံးနိုင်ပါသည်။
5. **Inventory** → Inbound Entry နှင့် Transfer စမ်းပါ။
6. **Purchase Orders** → Outlet မရှိရင် “Shop Locations သို့သွားမည်” လင့်ပြမည်။ Outlet ဖန်တီးပြီးမှ New Purchase ထည့်ပါ။
7. **POS** → ရောင်းချပြီး Daily Sale ပြီးအောင် လုပ်ပါ။
8. **Reports → Sales Summary** → **ဆိုင်ရွေး (Outlet)**၊ **From / To ရက်စွဲ** ထည့်ပြီး **တစ်ဆိုင်ချင်း တစ်လစာ** Sale Report ကြည့်ပါ။

---

## ၃။ Sidebar နဲ့ Content CRUD စမ်းသပ်ခြင်း

Sidebar မှ မီနူးတိုင်းသွားပြီး အောက်ပါအတိုင်း စစ်ပါ။

| မီနူး | စစ်ရန် |
|--------|----------|
| POS | ပစ္စည်းထည့်၊ ရောင်းချ၊ အတည်ပြု |
| Items → Item List, Categories, Modifiers, Discounts | CRUD အားလုံး |
| Inventory → Locations, Purchase Orders, Transfer, Stock Counts | Outlet/Location ဖန်တီး၊ PO ထည့်၊ Transfer၊ Stock Count |
| Reports → Sales Summary, Receipts, Shift | Date + Outlet filter နဲ့ စာရင်းကြည့် |
| Settings | ဆိုင်အမည်၊ လုပ်ငန်းအမျိုးအစား၊ ငွေကြေး |

Error တက်ရင် Console (F12) ကြည့်ပြီး ပြင်ပါ။

---

## ၄။ Inbound / Outbound စစ်ဆေးခြင်း

- **Inbound:** Inventory စာမျက်နှာ → **INBOUND ENTRY** နှိပ်ပြီး ပစ္စည်း + ပမာဏ + Location ရွေးကာ သွင်းပါ။ Stock မြင့်လာရမည်။
- **Transfer:** Inventory → Transfer (သို့) Sidebar **Inventory → Transfer Orders** မှ From/To Location ရွေးပြီး ရွှေ့ပါ။
- **Outbound:** POS မှ ရောင်းချပြီး **Approve** လုပ်လိုက်သည့်အခါ Stock ထွက်သွားပါမည် (outbound movement အဖြစ် မှတ်တမ်းတင်ပါသည်)။

---

## ၅။ Screenshot ရိုက်နည်း

1. **Browser ဖွင့်ပြီး** လိုအပ်သော စာမျက်နှာသို့ သွားပါ (Login, Dashboard, POS, Sales Summary စသည်)။
2. **F12** ဖွင့်ပြီး Console မှ error ရှိ/မရှိ စစ်ပါ။
3. **Screenshot ရိုက်ရန်:**
   - **Windows:** `Win + Shift + S` (သို့) Browser မှ Right-click → Inspect → Device toolbar (mobile view) နှင့်ြပြီး screenshot ယူနိုင်ပါသည်။
   - **Mac:** `Cmd + Shift + 4` (region) သို့မဟုတ် `Cmd + Shift + 5` (full/section)။
4. **သိမ်းမည့်နေရာ:** ဥပမာ `demo_results/1_pharmacy/`, `2_mobile/` စသဖြင့် ဆိုင်အမျိုးအစားခွဲပြီး သိမ်းပါ။

---

## ၆။ Automated E2E Script (Optional)

Repo ထဲတွင် `scripts/e2e_demo_screenshots.py` ရှိပါသည်။

- **လိုအပ်ချက်:** `playwright install chromium`
- **အသုံးပြုနည်း:**  
  `python scripts/e2e_demo_screenshots.py --shop pharmacy`  
  (သို့) `--shop all` ဖြင့် ဆိုင်အမျိုးအစားအားလုံး စမ်းပြီး screenshot ယူနိုင်ပါသည်။
- Backend server ကို မဖွင့်ရသေးရင် script က runserver စတင်ပေးပါမည် (optional)။

---

## ၇။ တစ်ဆိုင်ချင်း တစ်လစာ Sale Report ကြည့်နည်း

1. **Reports → Sales Summary** သို့သွားပါ။
2. **ဆိုင်ရွေးချယ်ခြင်း:** ထိပ်ရှိ **Outlet** dropdown မှ ဆိုင်တစ်ခုခု ရွေးပါ (သို့) “ဆိုင်အားလုံး” ထားပါ။
3. **ရက်စွဲ:** **From** နှင့် **To** ထည့်ပါ။ ဥပမာ ယမန်လ ၁ ရက်မှ ယမန်လ ၃၀ ရက် (သို့) ဒီလ ၁ ရက်မှ ယနေ့အထိ။
4. **Refresh** နှိပ်ပါ။ စာရင်းသည် ရွေးထားသော ဆိုင်နှင့် ရက်စွဲအပိုင်းအခြားအတိုင်း ပြပါမည်။

အဆင်မပြေသည့်အခါ error များကို Browser Console (F12) နှင့် Backend log မှ စစ်ပြီး ပြင်ဆင်ပါ။
