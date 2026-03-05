# Design ခေတ်မီပြင်ဆင်ခြင်း နဲ့ Location / Warehouse / ဆိုင်ခွဲ ဆွေးနွေးချက်

ဒီစာမှာ နှစ်ခု ဆွေးနွေးထားပါတယ် – (၁) UI design ကို modernize လုပ်နည်း၊ (၂) Location (warehouse, shop floor, ဆိုင်ခွဲ) ကို စိတ်တိုင်းကျအောင် ဘယ်လို သတ်မှတ်သင့်သလဲ။

---

## ၁။ Design ခေတ်မီပြင်ဆင်ခြင်း (Modernize)

### ၁.၁ အခု ဘာကြောင့် “အရင်ခေတ်” လို့ ခံစားရသလဲ

- **Typography**: Label တွေ အားလုံး UPPERCASE + မဲမဲ → လေးပြီး ခေတ်ဟောင်းပုံစံ။
- **Color**: မီးခိုးနဲ့ ပြာ ပဲ သုံးပြီး၊ contrast / hierarchy မထင်သေး။
- **Shape**: ဘောင်းဘီဖြီး rounded (rounded-2xl, rounded-[30px]) အနေအထား တူညီလွန်းတာ။
- **Table-centric**: စာမျက်နှာတိုင်း table နဲ့ list ပဲ → မျက်နှာပြင် ပြားပြီး depth မရှိ။
- **Spacing & density**: padding/margin တွေ တစ်ပုံစံတည်း ဖြစ်နေတတ်ပြီး၊ “breathing room” နည်းတာ (သို့) ကပ်လွန်းတာ။

### ၁.၂ ခေတ်မီ design အတွက် လုပ်သင့်တာများ

| အချက် | အကြံပြုချက် |
|--------|-----------------|
| **Design tokens** | ပြာ/မီးခိုး/အစိမ်း စသည့် အနည်းငယ် primary color + neutral scale သတ်မှတ်ပြီး CSS variables (သို့) Tailwind config မှာ သုံးပါ။ ခလုတ် / card / border က တစ်စီတူညီအောင်။ |
| **Typography** | Label ကို UPPERCASE အားလုံး မလုပ်ပါနဲ့။ Sentence case သို့မဟုတ် Title Case နဲ့ font-weight (bold/medium) နဲ့ hierarchy ပေးပါ။ Heading နဲ့ body ကို ရွေးထားတဲ့ font တစ်ခု (သို့) အုပ်စုနဲ့ သတ်မှတ်ပါ။ |
| **Radius & shadow** | Border radius ကို တစ်နေရာတည်းမှာ သတ်မှတ်ပါ (ဥပမာ card=12px, button=8px)။ Shadow က soft လေးပဲ ထားပြီး depth အနည်းငယ်ပေးပါ။ |
| **Cards / surfaces** | Table ပဲ မဟုတ်ဘဲ card layout၊ section ခွဲပြီး header + content ပုံစံ သုံးပါ။ List များရင် row hover state နဲ့ spacing သတ်မှတ်ပါ။ |
| **Buttons & inputs** | Primary / secondary / ghost ခွဲပြီး style တစ်စီတူညီအောင် လုပ်ပါ။ Input မှာ border အနုအရင့်၊ focus ring နဲ့ placeholder ကို သတ်မှတ်ပါ။ |
| **Responsive** | Mobile မှာ table က card stack ပြောင်းပြီး သုံးစွဲလို့ရအောင် စဉ်းစားပါ။ |

### ၁.၃ လုပ်နည်း အဆင့်လိုက်

1. **Tailwind config** – `theme.extend` မှာ colors, borderRadius, boxShadow သတ်မှတ်ပါ။
2. **Base components** – ခလုတ်၊ input၊ card၊ badge စသည်ကို class set (သို့) Vue component အဖြစ် သတ်မှတ်ပြီး စာမျက်နှာတွေမှာ ပြန်သုံးပါ။
3. **စာမျက်နှာ တစ်ခုချင်း** – Dashboard → Product → Location → Sales စသဖြင့် စီပြီး typography + spacing + card ပုံစံ ပြင်ပါ။
4. **လိုရင် design reference** – ကြိုက်တဲ့ admin template / POS UI ကို reference ယူပြီး color + layout ယူနိုင်ပါတယ်။

ဒါတွေကို လက်တွေ့ စလုပ်ချင်ရင် “ပထမ Dashboard နဲ့ Product list ကို modernize လုပ်ပေးပါ” လို့ ပြောပါက အဲဒီစာမျက်နှာကနေ စပြီး ပြင်ပေးလို့ ရပါတယ်။

---

## ၂။ Location / Warehouse / ဆိုင်ခွဲ – စိတ်တိုင်းကျအောင် ဘယ်လိုသတ်မှတ်မလဲ

ပြောထားတဲ့ ပုံစံတွေက အောက်ပါအတိုင်းပါ။

- **ဆိုင်တစ်ဆိုင်မှာ** အရောင်းဆိုင်ကြီးပဲ ရှိသလို၊ **warehouse နဲ့လည်း တွဲထားနိုင်တယ်** – အရှေ့မှာ ရောင်းမယ်၊ အနောက်မှာ ဂိုထောင်ရှိမယ်။
- **နောက်တစ်မျိုး** – ဂိုထောင်သက်သက်၊ အရောင်းဆိုင်သက်သက် ရှိမယ်။
- **ဆိုင်ခွဲတွေ** ရှိမယ်၊ အဲမှာလည်း အရောင်းဆိုင်နဲ့ ဂိုထောင်တွဲရက်ထားနိုင်မယ်။

### ၂.၁ လက်ရှိ Model က ဘာရှိသလဲ

- **Location** – `name`, `location_type` (warehouse / branch / shop_floor), `is_sale_location`, `branch_group` (string)။
- တစ်နေရာတစ်ခုကို ဂိုဒေါင်လား ရောင်းချရန်နေရာလား ဆိုတာ `location_type` နဲ့ `is_sale_location` နဲ့ ခွဲထားပြီးသား။

ဒီအတိုင်းနဲ့လည်း အောက်က ပုံစံတွေ **လုပ်လို့ရပါတယ်**။

### ၂.၂ ပုံစံ ၁ – ဆိုင်တစ်ဆိုင်မှာ အရှေ့ရောင်း + အနောက်ဂိုထောင်

- **ဆိုင်တစ်ခုကို “အစု” တစ်ခုလို မှတ်ပါ။** လက်ရှိ field ထဲမှာ **`branch_group`** ကို ဒီအတွက် သုံးပါ။
- နေရာ နှစ်ခု ထည့်ပါ:
  - **Location ၁**: အမည် ဥပမာ `Main - Sales`၊ `location_type` = `shop_floor`၊ `is_sale_location` = True၊ `branch_group` = `Main`။
  - **Location ၂**: အမည် ဥပမာ `Main - Warehouse`၊ `location_type` = `warehouse`၊ `is_sale_location` = False၊ `branch_group` = `Main`။
- `branch_group` တူတာကို “ဆိုင်တစ်ခုထဲက ရောင်းရာနဲ့ ဂိုထောင်” လို့ သတ်မှတ်ပါ။

ဒါဆို ဆိုင်တစ်ဆိုင်မှာ အရှေ့ရောင်း + အနောက်ဂိုထောင် ပုံစံ ရပါပြီ။

### ၂.၃ ပုံစံ ၂ – ဂိုထောင်သက်သက် / အရောင်းဆိုင်သက်သက်

- **ဂိုထောင်သက်သက်**: Location တစ်ခု၊ `location_type` = `warehouse`၊ `is_sale_location` = False၊ `branch_group` ဗလာ (သို့) ဥပမာ `Central WH`။
- **အရောင်းဆိုင်သက်သက်**: Location တစ်ခု၊ `location_type` = `shop_floor` (သို့) `branch`၊ `is_sale_location` = True၊ `branch_group` ဗလာ (သို့) ဆိုင်အမည်။

ဒီအတိုင်း သတ်မှတ်ရင် ဂိုထောင်သက်သက် / အရောင်းဆိုင်သက်သက် နှစ်မျိုးလုံး ရပါတယ်။

### ၂.၄ ပုံစံ ၃ – ဆိုင်ခွဲတွေ (အခွဲတိုင်း ရောင်း + ဂိုထောင်တွဲ)

- **ဆိုင်ခွဲတစ်ခုချင်းစီကို** `branch_group` တစ်မျိုးနဲ့ သတ်မှတ်ပါ။ ဥပမာ:
  - ခွဲ (က) – `branch_group` = `Branch A`  
    - Location: `Branch A - Sales` (shop_floor, is_sale_location=True), `Branch A - Warehouse` (warehouse, is_sale_location=False)
  - ခွဲ (ခ) – `branch_group` = `Branch B`  
    - Location: `Branch B - Sales`, `Branch B - Warehouse`
- ဆိုင်ခွဲတွေမှာလည်း “အရောင်းဆိုင်နဲ့ ဂိုထောင်တွဲ” ပုံစံ ဒီအတိုင်း ရပါတယ်။

### ၂.၅ စိတ်တိုင်းမကျသေးတာ ဘာဖြစ်နိုင်သလဲ

- **UI မှာ ပုံစံမထင်သေး**: “ဆိုင်တစ်ခု = ရောင်းရာ + ဂိုထောင်” ဆိုတာ မထင်သေးဘဲ၊ location တစ်ခုချင်းပဲ မြင်နေတာ။  
  → **ညှိမယ့်အချက်**: Location စာမျက်နှာမှာ **`branch_group` အလိုက် စုပြီး ပြပါ**။ ဥပမာ “Main” အောက်မှာ “Main - Sales”, “Main - Warehouse” ဆိုပြီး ခေါင်းစဉ်နဲ့ အုပ်စုပြပါ။
- **အမည်နဲ့ အမျိုးအစား ရှုပ်နေတာ**: `location_type` က warehouse / branch / shop_floor သုံးခုရှိပြီး၊ “ဆိုင်ခွဲ” ဆိုတာနဲ့ “ရောင်းချရန်နေရာ” ဆိုတာ ရောနေတာ။  
  → **ညှိမယ့်အချက်**:  
  - **branch** = ဆိုင်ခွဲ (အပြင်မှာ ဆိုင်တစ်ဆိုင်လို မြင်ရတဲ့ unit)  
  - **shop_floor** = ရောင်းချရန်နေရာ (အဲဒီဆိုင်ထဲက ရောင်းတဲ့နေရာ)  
  - **warehouse** = ဂိုထောင်  
  ဆိုပြီး UI label နဲ့ help text မှာ ရှင်းပြထားပါ။ “ဆိုင်တစ်ခု / ဆိုင်ခွဲတစ်ခု” ကို `branch_group` နဲ့ အုပ်စုပြပါ။
- **Drop-down / POS မှာ ရွေးရခက်**: နေရာတွေ များလာရင် “ဆိုင်တစ်ခု” ရွေးပြီးမှ အတွင်းက Sales/Warehouse ရွေးမလား စဉ်းစားရတာ။  
  → **ညှိမယ့်အချက်**: POS / stock ရွေးတဲ့နေရာမှာ **ရောင်းချရန်နေရာပဲ ပြပါ** (is_sale_location=True)။ Transfer/inbound မှာပဲ warehouse ပါအောင် လုပ်ပါ။ လိုရင် `branch_group` အလိုက် group byြပြီး ရွေးခိုင်းပါ။

### ၂.၆ Site model ထည့်ပြီး ပြည့်စုံအောင် လုပ်ထားခြင်း (ပြီးပြီ)

- **Site** model ထည့်ပြီးသား – ဆိုင်တစ်ခု / ဆိုင်ခွဲတစ်ခု = Site တစ်ခု။
- **Location** မှာ **site** (ForeignKey) ထည့်ထားပြီး – ဆိုင်အောက်မှာ အရောင်းဆိုင် + ဂိုထောင် တွဲထားနိုင်သည်။
- စိတ်တိုင်းကျအောင် လုပ်မယ်ဆိုရင်:
  1. **Location UI** မှာ `branch_group` အလိုက် စုပြီး ပြပါ (ဆိုင်တစ်ခု / ဆိုင်ခွဲတစ်ခု = အုပ်စုတစ်ခု)။
  2. **ဆိုင်အသစ်ထည့်ချိန်** “ဒီဆိုင်မှာ ရောင်းရာနဲ့ ဂိုထောင် တွဲမလား?” မေးပြီး Yes ဆိုရင် နေရာ နှစ်ခု (Sales + Warehouse) တစ်ခါထည့်ပေးတဲ့ flow ထည့်လို့ ရပါတယ်။
  3. Label / help text တွေကို “ဆိုင်တစ်ဆိုင် (သို့) ဆိုင်ခွဲ” = `branch_group`၊ “အရှေ့ရောင်း / အနောက်ဂိုထောင်” = location type + is_sale_location ဆိုပြီး ရှင်းပြထားပါ။

---

## ၃။ အတိုချုပ်

| ခေါင်းစဉ် | အကြံပြုချက် |
|------------|-----------------|
| **Design modernize** | Design tokens (color, radius, shadow), typography (လျှော့ uppercase), card/surface သတ်မှတ်ပြီး စာမျက်နှာတွေကို တဖြည်းဖြည်း ပြင်ပါ။ စလုပ်ချင်ရင် Dashboard / Product list ကနေ စပါ။ |
| **Location စိတ်တိုင်းကျ** | လက်ရှိ Model နဲ့ပဲ ရပါတယ်။ `branch_group` = ဆိုင်တစ်ခု (သို့) ဆိုင်ခွဲတစ်ခု။ နေရာ နှစ်ခု (Sales + Warehouse) ကို တူညီတဲ့ `branch_group` နဲ့ ထည့်ပြီး “အရှေ့ရောင်း + အနောက်ဂိုထောင်” ပုံစံ သုံးပါ။ UI မှာ `branch_group` အလိုက် စြပြီး၊ ဆိုင်အသစ်ထည့်တဲ့အခါ “ရောင်း + ဂိုထောင် တွဲမလား?” flow ထည့်ပါ။ |

လက်တွေ့ ပြင်ချင်တဲ့ စာမျက်နှာ (ဥပမာ Dashboard, Product, Location) သို့မဟုတ် Location flow အတိအကျ ပြောပါက ဒီအတိုင်း implement လုပ်ပေးလို့ ရပါတယ်။
