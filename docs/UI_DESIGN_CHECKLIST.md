# UI Design စစ်ဆေးစာရင်း (UI Design Checklist)

ဒီစာရွက်မှာ HoBo POS ရဲ့ UI ကို စစ်ဆေးထားတဲ့ အချက်တွေ၊ ပြီးပြီးသား အချက်တွေ နဲ့ ပြင်သင့်တဲ့ အချက်တွေကို စုစည်းထားပါတယ်။

---

## ၁။ ပြီးပြီးသား / ကောင်းပြီးသား

| အချက် | မျက်နှာစာ/အစိတ်အပိုင်း | မှတ်ချက် |
|--------|---------------------------|-----------|
| Dark theme နဲ့ glassmorphism | MainLayout, Dashboard, SalesRequest | `bg-dashboard-deep`, `bg-white/10`, `backdrop-blur-2xl`, `rounded-[2rem]` တစ်သမတ်တည်း သုံးထား |
| Shadow / glow | Dashboard, Sales cards | `shadow-glow`, `shadow-glow-lg` သတ်မှတ်ထား |
| Responsive sidebar | MainLayout | Desktop: slim sidebar, Mobile: bottom nav + hamburger |
| POS မျက်နှာစာ | SalesRequest | USD rate, barcode search, cart, AI ဒါလေးရောမလိုဘူးလား, ဈေး/ပရိုမိုး အကြံပြု ပါဝင် |
| Dashboard Bento | Dashboard | Total Revenue, USD Rate, Revenue Growth, Sales Analytics, Low Stock, Active Services, Smart Business Insight, Recent Transactions |
| Loading / empty states | Dashboard (Smart Insight), SalesRequest (AI suggest) | "အကြံပြုချက်ယူနေပါသည်...", "ဒေတာ စုစည်းပြီး..." |
| Login / Public | Login, Register, ForgotPassword | Light card on gradient, amber accent, မြန်မာစာ လင့်များ |
| Settings | Settings | ဆိုင်အမည်/Logo, လိုင်စင်, အကောင့်အချက်အလက် ကဏ္ဍများ |

---

## ၂။ စစ်ဆေးရမည့် အချက်များ (စစ်ရန်)

| # | အချက် | မျက်နှာစာ | လုပ်ရန် |
|---|--------|-------------|----------|
| 1 | **Product Management စာသားအရောင်** | ProductManagement.vue | Layout က dark (bg-dashboard-deep) ဖြစ်ပြီး table ထဲမှာ `text-gray-800`, `text-gray-400`, `bg-gray-100` သုံးထားသဖြင့် dark ပေါ်မှာ contrast နည်းနိုင်သည်။ စစ်ဆေးပြီး လိုရင် `text-white/90`, `text-white/50`, `bg-white/10` ကဲ့သို့ dark-theme နဲ့ ကိုက်အောင် ပြင်ပါ။ |
| 2 | **Sale History / Admin Approval** | SaleHistory, AdminApproval | မျက်နှာစာတွေက `bg-white` card သုံးထားပြီး MainLayout ရဲ့ dark ပေါ်မှာ ထိုင်သည်။ ဖတ်လို့ ကောင်းပါက ဒီအတိုင်းထားနိုင်သည်။ |
| 3 | **Settings စာမျက်နှာ** | Settings.vue | လက်ရှိ light card style။ Dashboard နဲ့ တစ်သမတ်တည်း dark glass လုပ်မလား ဆုံးဖြတ်ပါ။ |
| 4 | **Focus / Keyboard** | အားလုံး | Input/button များတွင် `focus:ring-*` ရှိမရှိ၊ Tab နဲ့ လှည့်သွားလို့ ရမရ စစ်ပါ။ |
| 5 | **မြန်မာစာ ဖောင့်** | အားလုံး | Inter ဖြင့် မြန်မာစာြသမှု ကောင်းမကောင်း စစ်ပါ။ လိုရင် `font-family` မှာ Myanmar-ready ဖောင့် ထည့်စဉ်းစားပါ။ |
| 6 | **Mobile: POS** | SalesRequest | ဈေးနှုန်းပြသော ဧရိယာ၊ cart၊ AI အကြံပြုချက် များ ဖုန်းမျက်နှာပြင်မှာ သက်တောင့်သက်သာြသမရှိ စစ်ပါ။ |
| 7 | **Empty cart / No products** | SalesRequest | Cart ဗလာ ဖြစ်သောအခါ၊ ပစ္စည်းမရှိသောအခါ messageြသမှု ရှိမရှိ စစ်ပါ။ |
| 8 | **Print Receipt / Invoice** | SalesRequest, SaleHistory | Print layout နဲ့ စာရွက်ထုတ်မှု စစ်ပါ။ |

---

## ၃။ အကြံပြုချက်များ (Quick wins)

- **ProductManagement**: Table စာသားကို dark theme နဲ့ ကိုက်အောင် `text-white/90`, `text-white/60` နဲ့ badge ကို `bg-white/10 text-white/80` ကဲ့သို့ ပြောင်းပါက တစ်သမတ်တည်း ဖြစ်မည်။
- **USD rate သိမ်းခြင်း**: Sales မျက်နှာစာမှာ ဒေါ်လာဈေး ပြောင်းလိုက်ရင် backend ကို PATCH သိမ်းပြီး ပစ္စည်းဈေးများ auto-sync လုပ်ပြီးသား ဖြစ်သည်။
- **Error message**: API မှားသောအခါ မြန်မာစာ သို့မဟုတ် ရိုးရှင်းသော messageြသပါ။

---

## ၄။ Theme / Token အတိုချုပ်

- **Background (main)**: `bg-dashboard-deep` = `linear-gradient(135deg, #aa0000 0%, #151515 100%)`
- **Cards (dark glass)**: `bg-white/10 backdrop-blur-2xl border border-white/20 shadow-glow rounded-[2rem]`
- **Text**: `text-white`, `text-white/90`, `text-white/50` (labels)
- **Accent**: amber (`amber-400`, `amber-500`), emerald (success), rose (danger)
- **Inputs**: `bg-white/5 border border-white/20 rounded-xl focus:ring-1 focus:ring-white/30`

---

*စစ်ဆေးသည့်ရက်: ၂၀၂၅ ဖေဖော်ဝါရီ*
