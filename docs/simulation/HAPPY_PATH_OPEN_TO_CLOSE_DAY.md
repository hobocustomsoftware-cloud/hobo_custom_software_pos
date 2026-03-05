# Happy Path: Open Shop → Close Day

This document describes the typical **Happy Path** user flow from opening the shop to closing the day, for use in E2E simulation and test design.

---

## Overview

The system does **not** have an explicit "Open shop" or "Close day" button. The day is effectively:

- **Open:** Staff logs in; backend uses `StaffSession` (if any) or user’s `primary_location` for sales.
- **Close:** Last actions are viewing reports, entering expenses, and optionally checking today’s sales/P&L; no formal sign-off.

The flow below is **role-agnostic** where possible; steps that require Owner/Manager/Admin are marked.

---

## Phase 1: Open Shop (Start of Day)

| Step | Action | Route / API | Notes |
|------|--------|-------------|--------|
| 1.1 | **Login** | `/login` | Username + password → JWT; redirect to `/` (Dashboard). |
| 1.2 | **(Optional) Select location** | `GET/POST /api/core/select-location/` | Only needed if multi-location and no `primary_location`; simulation sets `primary_location` for `sim_owner`. |
| 1.3 | **View Dashboard** | `/` | Revenue, USD rate, P&L, today’s sales, low stock, installation count, recent activity. Confirms app is ready. |

**E2E:** Login (e.g. `sim_owner` / `demo123`) → wait for redirect → go to `/` → wait for dashboard data (e.g. `networkidle` or element).

---

## Phase 2: Morning Setup (Optional)

| Step | Action | Route / API | Notes |
|------|--------|-------------|--------|
| 2.1 | **Check/update USD rate** | Settings or POS header; `GET/PATCH /api/settings/exchange-rate/` | Owner/Manager in production; simulation can use default. |
| 2.2 | **Check low stock** | Dashboard “Low stock” card or `/reports/inventory` | Optional. |
| 2.3 | **Approve pending sales** (Manager/Owner) | `/sales/approve` → `GET /api/admin/pending/` → `PATCH /api/admin/approve/<id>/` | Clear any pending sales from previous day so they become invoices. |

**E2E:** Optional. For a full day simulation: visit `/sales/approve`, fetch pending, approve one (if any).

---

## Phase 3: During the Day (Core Operations)

### 3.1 Sales (POS)

| Step | Action | Route / API | Notes |
|------|--------|-------------|--------|
| 3.1.1 | **Open POS** | `/sales/pos` | Sales Terminal. |
| 3.1.2 | **Add items to cart** | — | By barcode (Enter in “Scan Barcode or Search”), by search, or by clicking product cards. Uses `staff/items/` or offline cache. |
| 3.1.3 | **Optional: customer** | Customer modal; `GET /api/customers/` | Select or add customer. |
| 3.1.4 | **Optional: discount** | UI only | Discount amount. |
| 3.1.5 | **Select payment method** | `GET /api/payment-methods/list/` | Dropdown in cart. |
| 3.1.6 | **Submit sale** | `POST /api/sales/request/` (or offline queue) | Creates sale in `pending`; may show “PENDING” or invoice number. |
| 3.1.7 | **Clear cart** | — | Ready for next customer. |

**E2E:** Go to `/sales/pos` → add items (e.g. fill SKU `SIM-P-001` + Enter, repeat for 2–3 products) → (optional) select payment method → click Submit → assert success or pending message.

### 3.2 Approval (Manager/Owner)

| Step | Action | Route / API | Notes |
|------|--------|-------------|--------|
| 3.2.1 | **Open Approve** | `/sales/approve` | List of pending sales. |
| 3.2.2 | **Approve (or Reject)** | `PATCH /api/admin/approve/<id>/` with `status: 'approved'` or `'rejected'` | List refreshes after action. |

**E2E:** After creating a sale from POS, go to `/sales/approve` → click Approve on the first pending row → verify list updates.

### 3.3 Sales History & Invoices

| Step | Action | Route / API | Notes |
|------|--------|-------------|--------|
| 3.3.1 | **View sales history** | `/sales/history` | Paginated list; filter by status/date. |
| 3.3.2 | **Open invoice / print** | `GET /api/invoice/<id>/`, `GET /api/invoice/<id>/pdf/` | View or open PDF in new tab. |

**E2E:** Go to `/sales/history` → wait for table → (optional) open first “Approved” row or click PDF.

### 3.4 Inventory (If Needed)

| Step | Action | Route / API | Notes |
|------|--------|-------------|--------|
| 3.4.1 | **Products list** | `/products` | Search, pagination. |
| 3.4.2 | **Categories** | `/categories` | CRUD. |
| 3.4.3 | **Stock movement** | `/movements` | List; `POST /api/movements/inbound/` or `transfer/` for receiving/transfer. |

**E2E:** Visit `/products`, `/categories`, `/movements`; optionally add one product or one inbound movement.

### 3.5 Service (Repairs)

| Step | Action | Route / API | Notes |
|------|--------|-------------|--------|
| 3.5.1 | **Repair list** | `/service` | List/calendar. |
| 3.5.2 | **Create repair** | `POST /api/service/repairs/` | Customer, item, problem, dates, cost. |
| 3.5.3 | **View repair detail / invoice** | `GET /api/service/repairs/<id>/` | — |

**E2E:** Go to `/service` → (optional) create one repair → open one repair from list.

### 3.6 Customers

| Step | Action | Route / API | Notes |
|------|--------|-------------|--------|
| 3.6.1 | **List / add customer** | `/customers` or customer modal in POS; `GET/POST /api/customers/` | — |

**E2E:** Optional; can add one customer from POS or from Customer management.

---

## Phase 4: Closing the Day

| Step | Action | Route / API | Notes |
|------|--------|-------------|--------|
| 4.1 | **View today’s sales** | `/sales/history` (filter today) or Dashboard “ဒီနေ့ အရောင်း” | Confirm numbers. |
| 4.2 | **Sales report** (optional) | `/reports/sales` | Date range, export PDF. |
| 4.3 | **P&L** (optional) | `/accounting/pl` or Dashboard P&L card | `GET /api/accounting/pnl/summary/` etc. |
| 4.4 | **Enter expenses** (if any) | `/accounting/expenses` → `POST /api/accounting/expenses/` | Categories from `expense-categories/`. |
| 4.5 | **Final dashboard check** | `/` | Revenue, today’s P&L, low stock. |

**E2E:** Visit `/sales/history` → `/reports/sales` → `/accounting/pl` → `/accounting/expenses` (list only or add one expense) → `/` (dashboard).

---

## Suggested E2E “Full Day” Flow (Order of Steps)

Use this order to align the Playwright script with the happy path:

1. **Login** → `/login`, fill credentials, submit, expect redirect to `/`.
2. **Dashboard** → `/`, wait for load, optional screenshot.
3. **Approve (optional)** → `/sales/approve`, load list; if any pending, approve one.
4. **POS – create sale** → `/sales/pos`, add 2–3 items (e.g. `SIM-P-001`, `SIM-P-002` via barcode input + Enter), select payment method if required, submit sale.
5. **Approve the new sale** → `/sales/approve`, approve the sale just created.
6. **Sales history** → `/sales/history`, wait for table, optional: open first approved invoice or PDF.
7. **Products / Inventory** → `/products`, wait for list; optional: `/categories`, `/movements`.
8. **Service** → `/service`, wait for list; optional: open one repair.
9. **Reports** → `/reports/sales`, `/reports/inventory` (or one of them), wait for load.
10. **P&L** → `/accounting/pl`, wait for load.
11. **Expenses** → `/accounting/expenses`, list only or add one expense.
12. **Dashboard again** → `/`, final screenshot.

This gives a single E2E run that covers: **Open (login + dashboard) → Approve → Sell → Approve → History → Inventory/Service → Reports → P&L → Expenses → Close (dashboard)**.

---

## Data Assumptions (Simulation)

- **User:** `sim_owner` / `demo123` (created by `run_simulation_data`).
- **Location:** “Sim Branch” exists; `sim_owner` has `primary_location` set.
- **Products:** At least `SIM-P-001` … `SIM-P-005` (or similar) exist for barcode scan.
- **Payment methods:** At least one active payment method (for POS dropdown).
- **Categories:** Exist for products.

If `run_simulation_data` has run, the above assumptions hold; otherwise ensure fixtures or simulation create them.

---

## Summary Table (Quick Reference)

| Phase | Key routes | Key APIs |
|-------|------------|----------|
| Open | `/login`, `/` | `POST /api/token/`, `GET /api/dashboard/analytics/` |
| Setup | `/sales/approve`, (Settings) | `GET /api/admin/pending/`, `PATCH /api/admin/approve/<id>/` |
| Sell | `/sales/pos` | `GET /api/staff/items/`, `GET /api/payment-methods/list/`, `POST /api/sales/request/` |
| Approve | `/sales/approve` | `GET /api/admin/pending/`, `PATCH /api/admin/approve/<id>/` |
| History | `/sales/history` | `GET /api/sales/history/`, `GET /api/invoice/<id>/pdf/` |
| Inventory | `/products`, `/movements` | `GET /api/...` (products, movements) |
| Service | `/service` | `GET /api/service/repairs/` |
| Close | `/reports/sales`, `/accounting/pl`, `/accounting/expenses`, `/` | P&L, expenses, dashboard |

Use this flow to extend your E2E simulation script with the steps above; add assertions (e.g. “pending count decreases after approve”, “invoice number appears”) as needed.
