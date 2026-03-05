# Design ပုံစံ နှင့် လုပ်ငန်းစဉ်

ပေးထားသော reference (POS.COM style) + Loyverse clean UI/UX + လက်ရှိ features list အားလုံး ပေါင်းစပ်ပြီး **Tailwind CSS** နဲ့ လုပ်မည့် စီမံချက်။

---

## ၁။ Reference Design အချက်အလက်

- **Left sidebar:** Logo, Nav (Dashboard, Home, Order, Payment, Inventory, Report, Settings), အောက်ခြေ Newsletter CTA
- **Main:** Search bar "Search items here...", filter, ညာဘက် notification + user (avatar, name, role) | Category tabs (All, Burger, Pizza...) | Product grid — **card တစ်ချပ်ချင်း:** ပုံ (အဝိုင်း), နာမည်, အတိုအကျ စာသား, ဈေး, **Add (+)** button (အပြာ/teal)
- **Right sidebar (Bills):** ခေါင်းစဉ် "Bills" | စာရင်းတစ်ခုချင်း: ပုံ, နာမည်, ဈေး, quantity (+/-), Remove | Sub Total, Tax, **Total (အစိမ်း)** | **Place Order** button (teal)
- **ရောင်:** white နောက်ခံ, **teal / light blue** accent, သန့်ရှင်း layout

---

## ၂။ Loyverse-style Clean

- သန့်သန့်ရှင်းရှင်း line, မလိုအပ်တဲ့ decoration နည်းခြင်း
- Touch-friendly (button အရွယ်, spacing)
- Myanmar + English နှစ်မျိုးလုံး ပြနိုင်ခြင်း

---

## ၃။ လက်ရှိ Features (ထိမ်းထားမည်)

- POS: ပစ္စည်းရွေး, unit (လုံး/တစ်ကတ်/ဗူး), cart, ဖောက်သည်ရွေး, လျှော့ဈေး, ပြန်အမ်းငွေ, checkout, receipt
- Dashboard, Items (list, categories, modifiers, discounts), Inventory, Reports, Settings
- Offline/sync, AI suggest, စသည် — logic အားလုံး မပြောင်းပါ။ **UI/layout နဲ့ ပုံစံပဲ** reference + Loyverse အတိုင်း ပြင်မည်။

---

## ၄။ Tailwind Theme (Reference နဲ့ ကိုက်အောင်)

- **Primary (teal):** `#0d9488` (teal-600), button/active: `#0f766e` (teal-700)
- **Background:** white, card: `bg-white`, sidebar: `bg-white` + border
- **Text:** black/gray-800 စာသား, muted: gray-500
- Category tab active: teal bg + white text; Bills Total: green (`emerald-600`)

---

## ၅။ အဆင့်များ (ခန့်မှန်း)

| အဆင့် | လုပ်မည့်အရာ | မှတ်ချက် |
|--------|----------------|-----------|
| 1 | **POS စာမျက်နှာ** (SalesRequest.vue) | Product cards (ပုံအဝိုင်း, နာမည်, စာတို, ဈေး, Add +), Category tabs teal, Right panel "Bills" (စာရင်း, Sub Total, Tax, Total, Place Order) |
| 2 | **Sidebar** (SidebarLoyverse.vue) | Logo, Nav items (Dashboard, Home/POS, Order, Payment, Inventory, Report, Settings), အောက်ခြေ CTA (optional) |
| 3 | **Top bar** | Search "Search items here...", filter, notification, user (avatar, name, role) |
| 4 | **အခြား စာမျက်နှာများ** | Dashboard, Items, Inventory, Reports, Settings — teal/white theme နဲ့ ကိုက်အောင် |

ယခု **အဆင့် ၁ (POS စာမျက်နှာ)** ကို reference ပုံအတိုင်း စပြီး ပြင်ဆင်နေပါသည်။
