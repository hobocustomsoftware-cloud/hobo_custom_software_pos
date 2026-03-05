# Electronic & Machinery – Product, Serial, Warranty, Spare Parts အခြေအနေ

ဘယ်ဆိုင်မဆို Electronic & Machinery ရောင်းလို့အဆင်ပြေအောင် ပစ္စည်းစနစ်၊ Serial၊ Warranty၊ Spare part တို့ လက်ရှိရှိပြီးသား နဲ့ လိုအပ်ချက်တို့ကို အောက်မှာ စုစည်းထားပါတယ်။

---

## ၁) Product – အဆင်ပြေပြေဖြစ်ရဲ့လား

**ဖြေရှင်း:** လက်ရှိ Product model က **Electronic & Machinery** ဆိုင်တွေအတွက် သင့်တော်အောင် ထည့်သွင်းထားပြီးပါပြီ။

| အချက် | လက်ရှိရှိပြီး |
|--------|------------------|
| **Category** | Hierarchical (parent > child), ဥပမာ Electronics > Solar > Inverters |
| **SKU / Barcode** | Unique SKU၊ name ကနေ auto-generate လို့ရ၊ ဖတ်ရန်/ပြင်ရန် Product Management မှာ |
| **Model No.** | `model_no` field (ရှာမယ်ဆိုရင် index သုံးထားသည်) |
| **Unit** | PCS, SET, MTR, ROL, KG, BOX, PKG, UNT |
| **Pricing** | Fixed MMK သို့မဟုတ် Dynamic (USD + exchange rate) |
| **Serial ခြေရာခံ** | `is_serial_tracked` (ပစ္စည်းတစ်ခုချင်း Serial ထည့်မည်) |
| **Serial လိုအပ်ချက်** | `serial_number_required` (ရောင်းတိုင်း Serial ထည့်ရမည်) |
| **Warranty** | `warranty_months` (လ) – ပစ္စည်းအလိုက် သက်တမ်းသတ်မှတ် |
| **Compatibility tags** | Bundle configurator အတွက် (ဥပမာ 48V-System, Socket-AM4) |
| **Specifications** | ProductSpecification model ဖြင့် သတ်မှတ်ချက်ထည့်လို့ရ |

ဆိုင်တစ်ဆိုင်ချင်း သီးသန့်: လက်ရှိ backend က **တစ်ဆိုင်တစ်စနစ်** (database တစ်ခုတည်း သို့မဟုတ် tenant တစ်ခုတည်း) ဖြစ်အောင် သတ်မှတ်ထားပါက ထို ဆိုင်ရဲ့ product/category တွေပဲ ရောင်းချမှုမှာ ပါပါတယ်။ ဆိုင်အများကြီး ပါဝင်မယ့် multi-tenant လိုချင်ရင် Product/SaleTransaction ကို shop/site နဲ့ ချိတ်ပြီး filter ထည့်ရန် လိုအပ်နိုင်ပါတယ်။

---

## ၂) Serial Numbers

**ဖြေရှင်း:** Serial ခြေရာခံစနစ် ရှိပြီးသား။

| အချက် | ဖော်ပြချက် |
|--------|--------------|
| **SerialItem** | Product က `is_serial_tracked=True` ဖြစ်ရင် တစ်ခုချင်း SerialItem ထည့်နိုင်သည်။ |
| **Auto number** | Serial မထည့်ရင် `SN-{SKU}-YYYYMM-0001` ပုံစံ အလိုအလျောက်ထုတ်သည်။ |
| **Status** | in_stock → sold / defective / pending_sale |
| **ရောင်းချချိန်** | Sale approved ဖြစ်ရင် SerialItem ကို sold လုပ်ပြီး sale_transaction ချိတ်သည်။ ရောင်းတိုင်း serial ထည့်ရမည့် ပစ္စည်းဆိုရင် serial ထည့်မှ approval ပေးသည်။ |
| **မှတ်တမ်း** | SerialNumberHistory ဖြင့် purchased, received, transferred, sold, returned, repair_started/completed, defective စသည်တို့ မှတ်နိုင်သည်။ |

API: SerialItem lookup/update, sale request/approval မှာ serial ထည့်သွင်းမှု ပါပြီးသား။

---

## ၃) Warranty

**ဖြေရှင်း:** ပစ္စည်းအလိုက် သက်တမ်း + Serial အလိုက် မှတ်တမ်း ရှိပြီးသား။

| အချက် | ဖော်ပြချက် |
|--------|--------------|
| **Product** | `warranty_months` (လ) – သတ်မှတ်ထားသော ပစ္စည်းအတွက် သက်တမ်းကာလ။ |
| **WarrantyRecord** | Serial ပစ္စည်း ရောင်းချပြီးချိန် (သို့မဟုတ် Installation ပြီးချိန်) မှာ warranty_start_date / warranty_end_date ဖြင့် မှတ်တမ်းဖန်တီးသည်။ |
| **ရောင်းချပြီး** | Sale approved ဖြစ်ရင် ထို serial အတွက် WarrantyRecord create လုပ်ပြီး စသည့်ရက်/ကုန်ဆုံးရက် သတ်မှတ်သည်။ |
| **တပ်ဆင်ပြီးမှ စ** | Installation Job completed ဖြစ်ရင် `sync_warranty_dates` ဖြင့် ထို sale မှ serial တွေရဲ့ warranty စသည့်ရက်ကို ယနေ့သို့ ပြင်ပေးနိုင်သည် (တပ်ဆင်ပြီးမှ သက်တမ်းစမှတ်ချင်ရင်)။ |
| **Warranty စစ်ဆေးခြင်း** | Serial number ဖြင့် စစ်ဆေးရန် API: `GET /api/warranty/check/?serial_number=xxx` (public)။ Frontend: **Warranty Check** စာမျက်နှာ ရှိပြီး။ |

အတိုချုပ်: Electronic/Machinery ပစ္စည်းတွေအတွက် ပစ္စည်းအလိုက် လအရေအတွက် သတ်မှတ်ပြီး၊ ရောင်းချ/တပ်ဆင်ပြီးချိန်မှာ serial အလိုက် warranty စ/ကုန်ရက် မှတ်တမ်းထားကာ၊ ဖောက်သည်က serial ထည့်ပြီး warranty စစ်လို့ရပါတယ်။

---

## ၄) Spare Parts

**ဖြေရှင်း:** **စက်ပြင်ဝန်ဆောင်မှု (Repair)** မှာ Spare parts သုံးထားပြီးသား။ ပစ္စည်းကတ်တလောက် “ဒီပစ္စည်းရဲ့ spare parts စာရင်း” ဆိုတာတော့ သီးသန့် model မရှိသေးပါ။

| အချက် | ဖော်ပြချက် |
|--------|--------------|
| **RepairSparePart** | RepairService (စက်ပြင်အမှု) တစ်ခုချင်းအတွက် spare parts စာရင်း။ part_name, quantity, unit_price, subtotal။ ရွေးချယ်မှုအားဖြင့် inventory က **Product** နဲ့ ချိတ်လို့ရသည် (product FK)။ |
| **API** | Repair အတွက် `spare-parts` (GET/POST/DELETE) ရှိပြီး။ |
| **Bundle / Set** | Bundle (Set) မှာ BundleItem / BundleComponent ဖြင့် “ဒီ set မှာ ဒီပစ္စည်းတွေ ပါမည်” သတ်မှတ်နိုင်သည်။ စက်နဲ့အတူ ရောင်းမယ့် spare/accessory တွေကို bundle အနေနဲ့ ထည့်သုံးလို့ရပါတယ်။ |

**လိုချင်ရင် (optional):** “ဒီ Product (စက်/အီလက်ထရွန်းနစ်) ရဲ့ သတ်မှတ် spare parts စာရင်း” လိုချင်ရင် နောက်မှ ProductSparePart (main_product, spare_product, quantity) လို model ထပ်ထည့်ပြီး UI/API ထည့်နိုင်ပါတယ်။ လက်ရှိမှာ repair အတွက် spare နဲ့ bundle/set နဲ့ က cover လုပ်ထားပါတယ်။

---

## ၅) အတိုချုပ်

| ခေါင်းစဉ် | အခြေအနေ |
|------------|-----------|
| **Product** | Electronic & Machinery အတွက် category, model_no, unit, serial/warranty flags, tags, specifications စသည်တို့ ရှိပြီး။ ဘယ်ဆိုင်မဆို ရောင်းလို့အဆင်ပြေအောင် product စာရင်းသတ်မှတ်ပြီး ရောင်းချမှုမှာ သုံးနိုင်ပါတယ်။ |
| **Serial** | is_serial_tracked / serial_number_required၊ SerialItem၊ auto number၊ status၊ ရောင်းချချိန်မှတ်တမ်း ရှိပြီး။ |
| **Warranty** | warranty_months၊ WarrantyRecord၊ ရောင်းချ/တပ်ဆင်ပြီးမှ စသည့်ရက်၊ warranty check API + Warranty Check စာမျက်နှာ ရှိပြီး။ |
| **Spare parts** | စက်ပြင်အမှုမှာ spare parts စာရင်း + လိုရင် Product နဲ့ ချိတ်မှု ရှိပြီး။ ပစ္စည်းတစ်ခုချင်း “recommended spare parts” စာရင်းဆိုတာတော့ လက်ရှိ Bundle/Repair နဲ့ သုံးနိုင်ပြီး၊ လိုရင် နောက်မှ ProductSparePart ထပ်ထည့်နိုင်သည်။ |

အကျဉ်းချုပ်: **Product တွေက Electronic & Machinery နဲ့ ပတ်သက်တဲ့ ဘယ်ဆိုင်မဆို ရောင်းလို့အဆင်ပြေပြေ ဖြစ်အောင် ထည့်သွင်းထားပြီး၊ Serial တွေ၊ Warranty တွေ၊ (စက်ပြင်မှ) Spare part တွေလည်း လက်ရှိစနစ်မှာ ပါဝင်ပြီးသား ဖြစ်ပါတယ်။**
