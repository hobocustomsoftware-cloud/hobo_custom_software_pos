# Comprehensive Feature List & Loyverse POS Migration Plan

## 1. Current Modules Overview

| Module | Backend (Django) | Frontend (Vue) | Description |
|--------|------------------|----------------|-------------|
| **Inventory** | `inventory` app | Inventory.vue, ProductManagement, CategoryManagement, LocationManagement, TransferUI, InventoryMovement | Products, categories, locations, stock movements, serial/IMEI tracking |
| **Sales / POS** | `inventory` (sales APIs) | SalesRequest.vue, SaleHistory.vue, AdminApproval.vue, SaleStaff.vue | Sale requests, approval workflow, staff history |
| **Service / Repair** | `service` app | ServiceManagement.vue, RepairTrack.vue (public), RepairInvoice, RepairCalendar, ServiceEntry | Repair jobs, spare parts, tracking, calendar |
| **Warranty** | `inventory` (WarrantyRecord, SerialItem) | WarrantyCheck.vue (public) | Serial-based warranty check, expiring soon |
| **Spare Parts** | `service` (RepairSparePart) | ServiceManagement (inline) | Parts used in repairs, linked to Product |
| **User Management** | `core` (EmployeeViewSet, RoleViewSet) | UserManagement.vue, RoleManagement.vue | Employees, roles, permissions |
| **Accounting** | `accounting` app | ExpenseManagement.vue, ProfitLossReport.vue | Expenses, P&L, transactions |
| **Installation** | `installation` app | InstallationManagement, InstallationDashboard, InstallationDetail, SignatureCapture | Jobs linked to sales, technician, signature |
| **Customers** | `customer` app | CustomerReport.vue, customer in POS/sales | Customer CRUD, invoice detail |
| **Reports** | `inventory` + `accounting` + `service` | SalesReport, InventoryReport, ServiceReport, CustomerReport | Period summaries, low stock, full inventory |
| **Settings** | `inventory` (GlobalSetting, PaymentMethod), `core` (ShopSettings) | Settings.vue, PaymentMethodSettings, ExpenseCategorySettings | Shop, exchange rate, payment methods |
| **License** | `license` app | LicenseActivation.vue, LicenseBanner | License status, activate, remote activate |
| **Notifications** | `inventory` (Notification model) | Topbar (Bell) | In-app notifications, mark read |
| **AI / Insights** | `inventory` (CrossSell, BusinessInsight, StockPrediction), `ai` app | BusinessInsightCard, StockPredictionCard, AIProductSuggestion, CrossSellSuggestion, Dashboard | Best sellers, upsell, smart insights, stock prediction |

---

## 2. Backend (Django) – Detailed Feature List

### 2.1 Inventory App (`/api/`)

**Models:** Category, ProductTag, Product, ProductSpecification, Bundle, BundleItem, BundleComponent, PaymentMethod, SaleTransaction, SerialItem, SerialNumberHistory, WarrantyRecord, GlobalSetting, ExchangeRateLog, Site, Location, InventoryMovement, Notification, SaleItem, Sale.

**APIs:**

| Area | Endpoint / View | Functionality |
|------|-----------------|---------------|
| **Categories** | `categories/` (ViewSet) | CRUD categories |
| **Products (Admin)** | `products-admin/` (ViewSet) | CRUD products, pagination, search |
| **Product lookup** | `products/lookup/?sku=` | Lookup by SKU (barcode/scanner) |
| **Product search** | `products/search/?q=` | Search by SKU or serial_number (IMEI); used for scan |
| **Product bulk import** | `products/import/` | Bulk import products |
| **Product clone** | `products/<id>/clone/` | Clone product |
| **Product specs** | `product-specifications/` (ViewSet) | Product specifications |
| **Sites** | `sites-admin/` (ViewSet) | Multi-site (shop branches) |
| **Locations** | `locations-admin/` (ViewSet), `locations/` (list) | Warehouse/location CRUD and list for dropdowns |
| **Payment methods** | `payment-methods/` (ViewSet), `payment-methods/list/` | CRUD and list for POS |
| **Staff product list** | `staff/items/` | Products for staff (POS) |
| **Sale request** | `sales/request/` | Create sale request (cart → pending) |
| **Sale history** | `sales/history/` | Staff sale history list |
| **Staff sales summary** | `staff/my-sales-summary/` | Today’s sales summary for staff |
| **Admin approval** | `admin/pending/`, `admin/approve/<id>/` | List pending, approve/reject with serial handling |
| **Reports** | `admin/report/daily-summary/`, `full-inventory/`, `low-stock/`, `sales-period-summary/` | Daily summary, full inventory, low stock, sales by period |
| **Movements** | `movements/`, `movements/inbound/`, `movements/transfer/` | List movements, inbound, transfer (with serial support) |
| **Invoices** | `invoices/`, `invoice/<id>/`, `invoice/<id>/pdf/`, `invoice/<id>/cancel/` | List, detail, **PDF export**, cancel |
| **Notifications** | `notifications/`, `notifications/<id>/read/`, `unread-count/`, `mark-all-read/` | List, mark read, unread count |
| **Bundles** | `bundles/validate/` | Validate bundle composition |
| **Serials** | `serials/lookup/`, `serials/<id>/`, `serials/<id>/history/` | Lookup by product/location, update serial, history |
| **Warranty** | `warranty/check/?serial_number=`, `warranty/expiring-soon/` | Public warranty check, expiring soon list |
| **Dashboard** | `dashboard/analytics/` | Analytics by role, period, charts, recent activities |
| **Inventory management** | `inventory/management/` | Inventory dashboard payload |
| **Exchange rate** | `settings/exchange-rate/`, `.../history/`, `.../fetch/`, `.../adjustments/` | Get/patch rate, history, fetch CBM, adjustments |
| **Payment proof** | `sales/<id>/upload-payment-proof/`, `sales/<id>/payment-status/` | Upload proof, update payment status |
| **AI (inventory)** | `ai/cross-sell/`, `ai/business-insights/`, `ai/stock-prediction/` | Cross-sell, business insights, stock prediction |
| **AI product suggest** | `products/ai-suggest/` | AI product suggestion |
| **Sync prices** | `admin/sync-prices/` | Sync prices (e.g. USD-based) |

### 2.2 Service App (`/api/service/`)

**Models:** RepairService, RepairSparePart.

**APIs:**

| Endpoint | Functionality |
|----------|----------------|
| `repairs/` (ViewSet) | CRUD repair jobs (received → fixing → ready → completed/cancelled) |
| `track/` | Repair tracking (public: lookup by repair no) |

**Functionality:** Repair number auto-generation, labour + spare parts, deposit, return date, location (pickup branch), customer notification flag.

### 2.3 Customer App (`/api/customers/`)

**Models:** Customer (name, phone, email, address, preferred_branch).

**APIs:** List/create, detail, `invoice/<id>/` for sale invoice detail.

### 2.4 Accounting App (`/api/accounting/`)

**Models:** ExpenseCategory, Expense, Transaction (income/expense link).

**APIs:**

| Endpoint | Functionality |
|----------|----------------|
| `expense-categories/`, `expenses/` (ViewSets) | CRUD expense categories and expenses |
| `transactions/` | Transaction list |
| `pnl/summary/`, `profit-from-sales/`, `trend/`, `margin-analysis/` | P&L summary, profit from sales, trend, margin analysis |
| `owner-summary/` | Owner-facing sales + P&L summary |

### 2.5 Installation App (`/api/installation/`)

**Models:** InstallationJob (linked to SaleTransaction, Customer, Technician, status, signature).

**APIs:** `jobs/` (ViewSet), `dashboard/` for installation dashboard.

### 2.6 AI App (`/api/ai/`)

**APIs:** `best-sellers/`, `suggest/` (upsell), `sale-auto-tips/`, `ask/`, `insights/` (smart business insights).

### 2.7 Core App (`/api/core/`)

**APIs:** Register, shop-settings, forgot-password, reset-password, `me/`, select-location, `employees/`, `roles/` (ViewSets).

### 2.8 License App (`/api/license/`)

**APIs:** status, activate, remote-activate.

### 2.9 Notifications

**Model:** Notification (inventory app). APIs listed under Inventory above.

---

## 3. Frontend (Vue) – Detailed Feature List

### 3.1 Routes & Pages

| Route | Component | Functionality |
|-------|-----------|---------------|
| `/` | Dashboard.vue | Analytics cards, sales trend, smart insights, business insight card, stock prediction, recent transactions, installation count |
| `/inventory` | Inventory.vue | Inventory overview, stats, product table, inbound modal, transfer modal, search (barcode/SKU) |
| `/products` | ProductManagement.vue | Product list, CRUD, filters, **barcode scan** (products/search), specs, clone |
| `/categories` | CategoryManagement.vue | Category CRUD |
| `/movements` | InventoryMovement.vue | Movement list |
| `/shop-locations` | LocationManagement.vue | Locations CRUD |
| `/inventory/transfer` | TransferUI.vue | Transfer form, **scan** product (products/search), serial selection, inbound/outbound |
| `/sales/pos` | SalesRequest.vue | **POS:** search/scan (barcode/QR/IMEI), cart, payment method, discount, **BarcodeScanner**, submit request |
| `/sales/history` | SaleHistory.vue | Staff sale history list |
| `/sales/approve` | AdminApproval.vue | Pending list, approve/reject, serial numbers display |
| `/service` | ServiceManagement.vue | Repair list, calendar, service entry, spare parts |
| `/users`, `/users/roles` | UserManagement.vue, RoleManagement.vue | Employees, roles |
| `/reports/sales`, `/reports/inventory`, `/reports/service`, `/reports/customers` | SalesReport, InventoryReport, ServiceReport, CustomerReport | Period reports |
| `/accounting/expenses` | ExpenseManagement.vue | Expense list, categories |
| `/accounting/pl` | ProfitLossReport.vue | P&L report |
| `/installation`, `/installation/dashboard`, `/installation/:id` | InstallationManagement, InstallationDashboard, InstallationDetail | Installation jobs, dashboard, detail, SignatureCapture |
| `/settings` | Settings.vue | Shop settings, payment methods, expense categories (nested) |
| `/repair-track` (public) | RepairTrack.vue | Repair tracking by repair number |
| `/warranty-check` (public) | WarrantyCheck.vue | Warranty check by serial number |
| `/login`, `/register`, `/forgot-password`, `/reset-password`, `/license-activate` | Login, Register, ForgotPassword, ResetPassword, LicenseActivation | Auth and license |

### 3.2 Key Components

| Component | Functionality |
|-----------|---------------|
| **BarcodeScanner.vue** | Camera scan (html5-qrcode), QR + barcode (e.g. CODE_128, ITF for IMEI), emit scanned code |
| **BarcodeGenerator.vue** | Generate barcode (e.g. for products) |
| **InvoicePrint.vue** | Print receipt/invoice |
| **RepairInvoice.vue** | Repair job invoice layout |
| **RepairCalendar.vue** | Calendar view for repairs |
| **ServiceEntry.vue** | Single repair entry form |
| **BusinessInsightCard.vue** | Exchange rate / business insights (uses `ai/business-insights/` or inventory AI) |
| **StockPredictionCard.vue** | Stock prediction (inventory AI) |
| **CrossSellSuggestion.vue** | Cross-sell suggestions |
| **AIProductSuggestion.vue** | AI product suggestion |
| **RateManagementModal.vue** | USD exchange rate management |
| **LicenseBanner.vue** | License status banner |
| **Topbar.vue** | Header, menu toggle, notifications, profile |
| **Sidebar.vue** | Nav (Dashboard, Sales, Inventory, Service, Reports, Settings, etc.), USD rate, collapse |
| **FilterDataTable.vue**, **DataTable.vue** | Tables with filters |
| **InboundStock.vue** | Inbound stock UI block |

### 3.3 Specific Functionalities (Frontend)

- **Barcode / IMEI scanning:**  
  - **POS (SalesRequest):** Search field + Scan button → BarcodeScanner → `products/search/?q=<code>` → add to cart or toast.  
  - **ProductManagement:** Scan → product search → select product.  
  - **TransferUI:** Scan → product search → select product; serial selection for serial-tracked products.  
  - **Inventory:** Search placeholder “Scan barcode or search SKU” (table driven by `products-admin/` + filters).
- **Payment methods:** SalesRequest uses `payment-methods/list/` with fallback to `payment-methods/`; PaymentMethodSettings CRUD.
- **PDF reporting:** Backend `InvoicePDFView` generates PDF via ReportLab (invoice download). Frontend links to `invoice/<id>/pdf/`.
- **30-day / simulation logic:**  
  - Backend: `run_simulation_data` (e.g. 30/60 days), `simulate_month`, `simulate_exe_flow`, `simulate_errors`; accounting P&L default “last 30 days”; AI business insights “last 30 days”.  
  - Frontend: Dashboard analytics period filter (Daily/Weekly/Monthly/Yearly); reports use date ranges.
- **Serial / IMEI tracking:** Product flag `is_serial_tracked`; SerialItem model; POS and AdminApproval show serials; transfer/inbound support serial lists; warranty check by serial.

---

## 4. Loyverse-Style UX/UI Target

**Reference:** Loyverse POS layout.

- **Left:** Sales ticket (cart, line items, discount, payment, totals, actions).
- **Right:** Product grid (categories + products as tiles/cards; tap to add to cart).
- **Top:** Simple navigation tabs (e.g. Sales, Products, Reports, Settings) or a minimal top bar with tab switch.
- **Flow:** Open POS → see product grid on right, empty ticket on left → tap products or scan to add → set payment → complete. No “request → approve” in the main flow (or approve can be a separate tab for managers).

---

## 5. Migration Plan: Reorganize to Loyverse-Like Flow

### Phase 1: New POS Layout (Single Page)

**Goal:** One POS view with **left = ticket**, **right = product grid**, **top = simple tabs**.

| Step | Action | Notes |
|------|--------|--------|
| 1.1 | Add new route, e.g. `/pos` or keep `/sales/pos` | Dedicated Loyverse-style POS view. |
| 1.2 | Build **POS layout component** | Two-column layout: left column (ticket), right column (product grid). Responsive: on small screens stack (ticket above or full-screen ticket, then switch to grid). |
| 1.3 | **Left panel:** Reuse/refactor from SalesRequest.vue | Cart list, quantity adjust/remove, discount, payment method selector, total, “Complete sale” button. Optional: customer quick-select, notes. |
| 1.4 | **Right panel:** Product grid | Fetch `staff/items/` or `products-admin/` (with location filter if needed). Group by category. Large tiles/cards per product (image, name, price). Tap = add one to cart; optional long-press or +/- for qty. Search bar above grid; **Scan** button opens BarcodeScanner → `products/search/?q=` → add to cart. |
| 1.5 | **Top bar (POS only)** | Tabs: e.g. **Sale** (current ticket), **History** (last N or today’s sales), **Approve** (for managers – link to existing AdminApproval or embed minimal list). Optionally **Products** tab that opens product management in modal or side panel for quick edit. Keep Topbar minimal (menu, notifications, profile). |
| 1.6 | **Approval flow** | Either: (A) Keep approval as separate route `/sales/approve` and link from POS “Approve” tab, or (B) Inline minimal pending list in POS with Approve/Reject. Prefer (A) to avoid scope creep. |
| 1.7 | **Payment & completion** | On “Complete sale”: if role requires approval, submit to existing `sales/request/` and show “Pending approval”; else (if allowed) call a new “direct approve” endpoint or same approve API with auto-approve for certain roles. Backend may need a small change (e.g. “auto_approve” or role-based immediate approval). |

### Phase 2: Navigation Simplification

| Step | Action | Notes |
|------|--------|------|
| 2.1 | **Primary tabs (app-level)** | Reduce to 3–5 main tabs visible everywhere (or on POS): **POS**, **Products** (grid + list), **Reports**, **Settings**. “Inventory” can be under Products (stock, movements) or a sub-tab. |
| 2.2 | **Sidebar vs tabs** | Option A: Replace current sidebar with top horizontal tabs (Loyverse-like). Option B: Keep sidebar but simplify labels and group: “POS”, “Products & Stock”, “Sales & Reports”, “Service”, “Settings”. |
| 2.3 | **Dashboard** | Either: (1) Make dashboard the “Reports” tab content (summary + charts), or (2) Show dashboard only after login as landing, then primary action = “Open POS”. |

### Phase 3: Product Grid Standardization

| Step | Action | Notes |
|------|--------|------|
| 3.1 | **Single product grid component** | Reusable grid: receives list of products, category filter, search, scan button. Emits “add to cart” (product id, qty). Use in POS and optionally in ProductManagement (view mode). |
| 3.2 | **Categories** | Load categories; show as horizontal chips or dropdown above grid. Filter products by category. |
| 3.3 | **Search & scan** | One search input + one Scan button. Search: debounced call to `staff/items/?search=` or `products-admin/?search=`. Scan: BarcodeScanner → `products/search/?q=` → add to cart (POS) or select product (admin). |

### Phase 4: Backend Adjustments (Minimal)

| Step | Action | Notes |
|------|--------|------|
| 4.1 | **Direct sale (optional)** | If you want “complete sale without approval” for cashiers: add endpoint e.g. `sales/complete/` that creates sale request and approves in one shot for roles with permission; or add a query param to existing `sales/request/` like `?auto_approve=1` when role allows. |
| 4.2 | **Payment methods** | Ensure `payment-methods/list/` returns active methods (already exists). Frontend already uses it with fallback. |
| 4.3 | **Product list for POS** | `staff/items/` already exists; ensure it returns fields needed for grid (name, price, image, category, stock if needed). |

### Phase 5: Preserve Existing Features

| Area | Action | Notes |
|------|--------|-------|
| **Inventory** | Keep Inventory.vue, ProductManagement, CategoryManagement, LocationManagement, TransferUI, movements | Accessible from “Products & Stock” or “Inventory” tab/sidebar. |
| **Service / Repair** | Keep ServiceManagement, RepairTrack (public), RepairInvoice, Calendar | Separate tab “Service” or under “More”. |
| **Warranty** | Keep WarrantyCheck (public), warranty APIs | Link from product/serial detail or public menu. |
| **Installation** | Keep Installation* views | Under “Service” or “Operations”. |
| **Accounting** | Keep ExpenseManagement, P&L | Under “Reports” or “Accounting”. |
| **Reports** | Keep all report views | Under “Reports” tab. |
| **User/Role management** | Keep UserManagement, RoleManagement | Under “Settings” or “Admin”. |
| **AI / Insights** | Keep BusinessInsightCard, StockPrediction, cross-sell, etc. | Dashboard/Reports or optional panel in POS. |

### Phase 6: Responsive & Mobile (Capacitor)

| Step | Action | Notes |
|------|--------|------|
| 6.1 | **POS on mobile** | Product grid: 2 columns on phone, 3–4 on tablet. Ticket: full width below or slide-over drawer. Large tap targets (already improved with a11y). |
| 6.2 | **Tabs on mobile** | Bottom nav or collapsible top tabs so “POS”, “Products”, “Reports”, “Settings” are always reachable. |
| 6.3 | **Scan on mobile** | BarcodeScanner already supports camera; ensure Scan is prominent on POS and Product grid. |

### Implementation Order (Suggested)

1. **Phase 1 (POS layout)** – New POS view with left ticket + right product grid + top tabs (Sale / History / Approve). Reuse cart and payment logic from SalesRequest; build product grid and wire scan.
2. **Phase 2 (Navigation)** – Simplify global nav to Loyverse-like tabs or a reduced sidebar; link POS as primary.
3. **Phase 3 (Product grid)** – Extract reusable product grid component; use in POS and optionally elsewhere.
4. **Phase 4 (Backend)** – Add direct-sale or auto-approve only if required by business.
5. **Phase 5 & 6** – Keep all other modules; ensure they’re reachable from new nav and that POS works on mobile.

---

## 6. Summary Table: Features to Preserve in Loyverse Migration

| Feature | Keep | Where in new UX |
|---------|------|------------------|
| Barcode/IMEI scanning | ✅ | POS (right panel) + Product management |
| Product grid | ✅ (new) | POS right panel; reuse in Products tab |
| Sales ticket (cart) | ✅ | POS left panel |
| Approval workflow | ✅ | “Approve” tab or separate route |
| Invoice PDF | ✅ | Sale history / invoice detail |
| Serial/IMEI tracking | ✅ | Cart line + approval; product/transfer UIs |
| 30-day / period analytics | ✅ | Dashboard under Reports |
| Simulation commands | ✅ | Backend only; no UI change |
| Service / Repair | ✅ | Service tab |
| Warranty check (public) | ✅ | Public page + link from product/serial |
| Installation jobs | ✅ | Service or Operations |
| Expenses & P&L | ✅ | Reports / Accounting |
| Payment methods | ✅ | POS left panel + Settings |
| Exchange rate | ✅ | Settings; sidebar/widget optional |
| Notifications | ✅ | Topbar |
| User/Role management | ✅ | Settings / Admin |
| AI insights & cross-sell | ✅ | Dashboard; optional in POS |

This document can be used as the single reference for current capabilities and the step-by-step migration to a Loyverse-style POS flow while keeping all existing modules and features.
