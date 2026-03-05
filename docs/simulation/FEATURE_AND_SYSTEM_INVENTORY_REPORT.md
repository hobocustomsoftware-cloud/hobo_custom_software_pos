# HoBo POS – Feature List & System Inventory Report

This document provides a comprehensive scope for E2E testing and system understanding.

---

## 1. Core Modules

| Module | Description |
|--------|-------------|
| **Authentication & Users** | Login, register, JWT token, forgot/reset password, user profile, roles, employees. |
| **Sales / POS** | Point-of-sale (create sale, barcode scan, cart), sale request submission, admin approval, sale history, invoices. |
| **Inventory** | Products, categories, stock movements, locations, sites, bundles, serial tracking, inbound/transfer. |
| **Customer Management** | Customer CRUD, customer list (paginated), customer-linked sales and repairs. |
| **Service (Repairs)** | Repair job entry, repair list, calendar view, repair invoice, spare parts, status history. |
| **Reports & Analytics** | Sales report, inventory report, service report, customer report, P&L, dashboard analytics. |
| **Accounting** | Expenses, expense categories, P&L summary, profit trend, margin analysis, transactions. |
| **Installation** | Installation jobs, installation dashboard, job detail, technician assignment, customer signature. |
| **Settings** | Shop settings, exchange rate (USD), payment methods, expense categories. |
| **License** | License status, activate, remote activate (trial / on-premise). |
| **AI / Insights** | Best sellers, upsell suggest, sale auto tips, ask, smart insights (dashboard). |
| **Public** | Repair tracking (repair_no + phone), warranty check – no login. |

---

## 2. Key Functionalities by Module

### 2.1 Authentication & Users
- **Login** – Username/password, JWT token obtain & refresh.
- **Register** – New user registration (public).
- **Forgot / Reset password** – Request reset, reset with token.
- **User profile** – GET `/api/core/me/`, update profile.
- **Roles** – List/create/update/delete roles (RoleViewSet).
- **Employees** – List/create/update/delete employees (EmployeeViewSet), assign locations.
- **Select location** – Staff session / current location selection.

### 2.2 Sales / POS
- **Create sale (POS)** – Add items by search/SKU/barcode, set quantity, customer, discount; submit sale request.
- **Sale request** – POST sale (pending); staff can upload payment proof.
- **Admin approval** – List pending sales, approve/reject, optional payment proof.
- **Sale history** – List own (or all) approved/past sales; search, paginate; print A5 invoice.
- **Invoices** – List invoices (search, filter by status/location), detail, PDF download, cancel invoice.
- **Staff sales summary** – Today’s sales summary for staff.

### 2.3 Inventory
- **Products** – CRUD products (name, SKU, category, prices, serial tracking, specs); clone; bulk import; barcode print.
- **Categories** – CRUD categories (name, description); paginated list with search.
- **Stock movement** – List movements (search, paginate); record inbound; stock transfer (TransferUI).
- **Locations** – CRUD locations/sites; list for dropdowns.
- **Bundles** – Bundle validate endpoint; bundle items in sales.
- **Serial items** – Lookup, update, history.
- **Product lookup** – By SKU for barcode/scan.
- **Inventory report** – Full inventory, low stock; inventory management dashboard.

### 2.4 Customer Management
- **List customers** – Paginated, search (name, phone), ordering.
- **Create/update/delete customer** – Customer CRUD.
- **Customer detail** – Single customer; invoice detail (approved sale) for customer view.

### 2.5 Service (Repairs)
- **Create repair** – Service entry form (customer, item, problem, dates, deposit, cost).
- **Repair list** – Paginated, search (repair_no, item, customer, status), ordering; view repair detail/invoice.
- **Repair calendar** – Calendar view by month; select repair to open invoice.
- **Repair invoice** – View/print repair details, spare parts, status history.
- **Spare parts** – Add/remove spare parts on a repair (nested API).
- **Repair tracking (public)** – Lookup by repair_no + phone (no auth).

### 2.6 Reports & Analytics
- **Dashboard analytics** – Revenue, USD rate, P&L, today sales, low stock, installation count, sales trend, recent activities, smart insights.
- **Sales report** – Invoices list (paginated), search, PDF export.
- **Inventory report** – Products/stock view; low stock.
- **Service report** – Repairs list (paginated), search.
- **Customer report** – Customers list (paginated), search.
- **P&L report** – Profit & loss summary, trend, margin analysis.

### 2.7 Accounting
- **Expense categories** – CRUD (ExpenseCategoryViewSet).
- **Expenses** – CRUD (ExpenseViewSet).
- **Transactions list** – List accounting transactions.
- **P&L** – Summary, profit-from-sales, trend, margin analysis; owner summary.

### 2.8 Installation
- **Installation jobs** – CRUD (ViewSet); dashboard view.
- **Installation dashboard** – Dashboard stats and job list.
- **Job detail** – Detail view; customer signature upload; technician assignment.

### 2.9 Settings
- **Shop settings** – Shop name, logo, etc. (ShopSettingsView).
- **Exchange rate** – Get/patch USD rate; fetch; history; adjustments (DEBUG or owner).
- **Payment methods** – List (for POS); CRUD via PaymentMethodViewSet.
- **Expense category settings** – Via accounting app.

### 2.10 License
- **Status** – License status check.
- **Activate** – License activation (key, machine).
- **Remote activate** – Remote activation flow.

### 2.11 AI
- **Best sellers** – Best-selling products.
- **Suggest upsell** – AI upsell suggestions.
- **Sale auto tips** – Tips during sale.
- **Ask** – Generic ask endpoint.
- **Smart insights** – Dashboard insights (e.g. `/api/ai/insights/`).

### 2.12 Public (no login)
- **Repair track** – Enter repair_no + phone; view status.
- **Warranty check** – Warranty check (public).

---

## 3. Database Entities (Main Models)

| App | Model | Purpose |
|-----|--------|---------|
| **core** | User | Staff/user (extends AbstractUser); roles, locations. |
| **core** | Role | Role (owner, admin, sale_staff, etc.). |
| **core** | StaffSession | Active work session / current location. |
| **core** | ShopSettings | Shop name, logo, display settings. |
| **customer** | Customer | Customer (name, phone, email, preferred_branch). |
| **inventory** | Category | Product category. |
| **inventory** | Product | Product (name, SKU, category, prices, serial tracking). |
| **inventory** | ProductTag, ProductSpecification | Product tags and specs. |
| **inventory** | Bundle, BundleItem, BundleComponent | Product bundles. |
| **inventory** | PaymentMethod | Payment method. |
| **inventory** | SaleTransaction | Sale/invoice (staff, location, customer, status, items). |
| **inventory** | SaleItem | Line item of a sale. |
| **inventory** | InventoryMovement | Stock in/out/transfer. |
| **inventory** | Location, Site | Shop/warehouse locations and sites. |
| **inventory** | SerialItem, SerialNumberHistory | Serial tracking. |
| **inventory** | WarrantyRecord | Warranty. |
| **inventory** | GlobalSetting, ExchangeRateLog | Settings and exchange rate history. |
| **inventory** | Notification | In-app notifications. |
| **inventory** | Sale | Legacy sale model (if used). |
| **service** | RepairService | Repair job (repair_no, customer, item, status, dates). |
| **service** | RepairSparePart | Spare part on a repair. |
| **service** | RepairStatusHistory | Status change history. |
| **license** | AppInstallation | Installation/machine. |
| **license** | AppLicense | License (key, type, activated_at). |
| **installation** | InstallationJob | Installation job. |
| **installation** | InstallationStatusHistory | Installation status history. |
| **accounting** | ExpenseCategory | Expense category. |
| **accounting** | Expense | Expense entry. |
| **accounting** | Transaction | Accounting transaction (income/expense). |

---

## 4. API Endpoints (Primary Routes)

Base URL: `/api/` (and `/api/core/`, `/api/customers/`, etc. as below).

### 4.1 Auth
- `POST /api/token/` – Obtain JWT pair.
- `POST /api/token/refresh/` – Refresh access token.

### 4.2 Core (`/api/core/`)
- `GET /api/core/me/` – Current user.
- `GET|PATCH /api/core/shop-settings/` – Shop settings (also at `api/core/shop-settings`).
- `POST /api/core/register/` – Register.
- `POST /api/core/forgot-password/`, `POST /api/core/reset-password/` – Password reset.
- `GET /api/core/select-location/` – Select location.
- **Router:** `employees/`, `roles/` (CRUD).

### 4.3 Inventory (`/api/` – included at `api/`)
- **Router:** `categories/`, `products-admin/`, `product-specifications/`, `sites-admin/`, `locations-admin/`, `payment-methods/`.
- `GET /api/staff/items/` – Staff product list (no pagination).
- `POST /api/sales/request/` – Create sale request.
- `GET /api/sales/history/` – Sale history (paginated, search, ordering).
- `GET /api/staff/my-sales-summary/` – My sales summary.
- `GET /api/locations/` – Location list.
- `GET /api/admin/pending/` – Pending approvals.
- `GET|POST /api/admin/approve/<id>/` – Approve/reject.
- `GET /api/admin/report/daily-summary/`, `full-inventory/`, `low-stock/`, `sales-period-summary/` – Reports.
- `GET /api/movements/` – Movement list (paginated, search, ordering).
- `POST /api/movements/transfer/`, `POST /api/movements/inbound/` – Transfer, inbound.
- `GET /api/invoices/` – Invoice list (paginated, search, filter).
- `GET /api/invoice/<id>/`, `GET /api/invoice/<id>/pdf/`, `PATCH /api/invoice/<id>/cancel/` – Invoice detail, PDF, cancel.
- `GET /api/notifications/`, `POST /api/notifications/<id>/read/`, etc. – Notifications.
- `GET /api/products/lookup/` – Product lookup by SKU.
- `POST /api/products/import/`, `POST /api/products/<id>/clone/` – Import, clone.
- `GET /api/dashboard/analytics/` – Dashboard analytics.
- `GET /api/inventory/management/` – Inventory management (list + stats).
- `GET /api/payment-methods/list/` – Active payment methods (for POS).
- `POST /api/sales/<id>/upload-payment-proof/`, `PATCH /api/sales/<id>/payment-status/` – Payment proof.
- `GET|PATCH /api/settings/exchange-rate/`, history, fetch, adjustments – Exchange rate.
- `GET /api/warranty/check/`, `GET /api/warranty/expiring-soon/` – Warranty.
- `GET /api/serials/lookup/`, `PATCH /api/serials/<id>/`, `GET /api/serials/<id>/history/` – Serials.
- AI: `api/ai/` (see below).

### 4.4 Customers (`/api/customers/`)
- `GET|POST /api/customers/` – List (paginated, search, ordering), create.
- `GET|PUT|PATCH|DELETE /api/customers/<id>/` – Detail, update, delete.
- `GET /api/customers/invoice/<id>/` – Invoice detail (customer-facing).

### 4.5 Service (`/api/service/`)
- **Router:** `repairs/` – CRUD repairs (list paginated, search, ordering).
- Nested: `repairs/<id>/spare-parts/`, `repairs/<id>/cost-breakdown/`, etc.
- `GET /api/service/track/` – Public repair tracking (repair_no, phone).

### 4.6 Accounting (`/api/accounting/`)
- **Router:** `expense-categories/`, `expenses/`.
- `GET /api/accounting/transactions/` – Transaction list.
- `GET /api/accounting/pnl/summary/`, `profit-from-sales/`, `trend/`, `margin-analysis/` – P&L.
- `GET /api/accounting/owner-summary/` – Owner summary.

### 4.7 Installation (`/api/installation/`)
- **Router:** `jobs/` – Installation jobs CRUD.
- `GET /api/installation/dashboard/` – Installation dashboard.

### 4.8 License (`/api/license/`)
- `GET /api/license/status/` – License status.
- `POST /api/license/activate/` – Activate.
- `POST /api/license/remote-activate/` – Remote activate.

### 4.9 AI (`/api/ai/`)
- `GET /api/ai/best-sellers/`, `GET /api/ai/suggest/`, `GET /api/ai/sale-auto-tips/`, `GET /api/ai/ask/`, `GET /api/ai/insights/` – Various AI endpoints.

### 4.10 Docs
- `GET /api/schema/` – OpenAPI schema.
- `GET /api/docs/` – Swagger UI.

---

## 5. UI / Sidebar Menus

Sidebar is role-based; below is the full set of links that may appear.

### 5.1 General (by role)
| Label | Route | Roles (examples) |
|-------|--------|-------------------|
| Dashboard | `/` | All authenticated |
| Sales Request | `/sales/pos` | owner, admin, sale_staff, sale_supervisor, manager, assistant_manager |
| Inventory | `/inventory` | owner, admin, manager, inventory_*, sale_* |
| Sales History | `/sales/history` | owner, admin, manager, assistant_manager, sale_staff, sale_supervisor |
| Service | `/service` | owner, admin, manager, inventory_*, sale_* |
| Approve | `/sales/approve` | owner, admin, manager, assistant_manager |
| Settings | `/settings` | owner, admin, manager |

### 5.2 Management
| Label | Route | Roles |
|-------|--------|--------|
| Products | `/products` | owner, admin, manager, inventory_manager, inventory_staff |
| Categories | `/categories` | owner, admin, manager, inventory_manager |
| Users Management | `/users` | owner, admin, manager |
| Role များ (sub) | `/users/roles` | owner, admin, manager |
| Shop Location | `/shop-locations` | owner, admin, manager |
| Stock Movement | `/movements` | owner, admin, manager, inventory_* |

### 5.3 Reports & Analysis (role: canViewReports)
| Label | Route |
|-------|--------|
| အရောင်းအစီရင်ခံစာ | `/reports/sales` |
| ပစ္စည်းစာရင်း | `/reports/inventory` |
| စက်ပြင်ဝန်ဆောင်မှု | `/reports/service` |
| ဝယ်ယူသူ စာရင်း | `/reports/customers` |
| P&L အစီရင်ခံစာ | `/accounting/pl` |

### 5.4 Accounting (in sidebar as “ကုန်ကျစရိတ်”)
| Label | Route |
|-------|--------|
| ကုန်ကျစရိတ် | `/accounting/expenses` |

### 5.5 Installation
| Label | Route |
|-------|--------|
| တပ်ဆင်မှု Dashboard | `/installation/dashboard` |
| တပ်ဆင်မှု စီမံခန့်ခွဲမှု | `/installation` |

### 5.6 Public (Customer)
| Label | Route |
|-------|--------|
| စက်ပြင်ခြေရာခံမှု | `/repair-track` |
| အာမခံချက်စစ်ဆေးမှု | `/warranty-check` |

### 5.7 Other app routes (not necessarily in sidebar)
- `/inventory/transfer` – Inventory transfer (manager).
- `/installation/:id` – Installation job detail.
- **Auth:** `/login`, `/register`, `/forgot-password`, `/reset-password`, `/license-activate`.

---

## 6. Current Limitations & Notes for E2E

1. **Payment methods list** – Frontend calls `GET /api/payment-methods/list/`. If the request goes to a different base (e.g. missing `/api` prefix or wrong mount), it can return 404; verify base URL and that the route is mounted under `api/`.
2. **Vue “Package” component** – Dashboard (or another view) uses `<Package>` from lucide-vue-next; if the component is missing or mis-imported, a Vue warning can appear; ensure all icon imports resolve.
3. **Role-based sidebar** – E2E should run as a user with broad access (e.g. `sim_owner`) so all sidebar links are visible for “full sidebar traversal” tests.
4. **Pagination** – List endpoints use `PageNumberPagination` (e.g. 20 per page). Staff product list (`staff/items/`) is unpaginated for POS/offline. E2E should not assume unbounded list size.
5. **Offline POS** – POS can cache products and queue sales offline; E2E that depends on network should consider online-only or mock.
6. **Exchange rate** – In non-DEBUG, only Owner/Admin/Manager can edit; E2E with `sim_owner` is fine.
7. **Installation job detail** – Route `/installation/:id`; E2E should use an existing id or create one if testing that screen.
8. **Public routes** – Repair track and warranty check do not require login; E2E can hit them without auth.
9. **Inventory transfer** – Restricted to manager (meta.role); E2E as owner/manager to test.

---

## 7. E2E Test Scope Summary

- **Auth:** Login (sim_owner / demo123), optional register/forgot-password.
- **Sidebar:** Full traversal of every visible link (dashboard, POS, products, categories, movements, sales history, approve, service, users, roles, reports, accounting, installation, settings, public links).
- **Heavy lists:** Products, categories, movements, customers, invoices, repairs – all use FilterDataTable with search/pagination; use viewport screenshots and 10‑min timeout where needed.
- **Critical flows:** Create sale (POS), approve sale, view sale history, open invoice PDF; create/edit product and category; view movement list; create repair and view list; dashboard analytics; reports (sales, inventory, service, customer, P&L); settings (exchange rate if permitted).
- **APIs:** Prefer using existing paginated/search endpoints; handle `results` + `count` where applicable.

---

*Document generated from codebase analysis for HoBo POS E2E and system inventory.*
