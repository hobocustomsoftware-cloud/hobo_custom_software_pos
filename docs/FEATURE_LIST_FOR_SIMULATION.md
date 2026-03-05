# Complete Feature List for Simulation - HoBo POS System

## 📋 Complete Feature Inventory

This document lists ALL features, models, endpoints, pages, and business logic in the HoBo POS system for simulation planning.

---

## 1. Django Models (27 Models)

### Core App (`core`)
1. **User** (extends AbstractUser)
   - Dynamic role assignment (`role_obj`)
   - Staff assignment type (fixed/rotating)
   - Primary location assignment
   - Temporary password storage
2. **Role** - User roles (owner, admin, manager, technician, etc.)
3. **StaffSession** - Staff work sessions for rotating assignments
4. **ShopSettings** - Shop name, logo, settings

### Inventory App (`inventory`)
5. **Category** - Product categories
6. **ProductTag** - Compatibility/attribute tags
7. **Product** - Main product model
   - SKU (auto-generated), Model number
   - Pricing: Fixed MMK or Dynamic USD
   - Cost price, retail price, selling price
   - USD cost & markup percentage
   - Serial tracking support
   - Warranty months
   - Stock calculation (via InventoryMovement)
8. **Bundle** - Product bundles (PC, Solar, Machine, Fixed)
9. **BundleItem** - Items in a bundle
10. **BundleComponent** - Configurator slots
11. **PaymentMethod** - Payment methods (KPay, Wave Pay, Cash, etc.)
12. **SaleTransaction** - Sales with approval flow
13. **SaleItem** - Items in a sale transaction
14. **Sale** - Legacy sale model
15. **SerialItem** - Serial number tracking
16. **WarrantyRecord** - Warranty period records
17. **GlobalSetting** - Key-value app settings
18. **ExchangeRateLog** - Daily USD exchange rate logs
19. **Site** - Shop/branch sites
20. **Location** - Storage/sale locations
21. **InventoryMovement** - Stock movement tracking
22. **Notification** - System notifications

### Customer App (`customer`)
23. **Customer** - Customer information

### Service App (`service`)
24. **RepairService** - Repair service orders
25. **RepairSparePart** - Spare parts used in repairs
26. **RepairStatusHistory** - Status change history

### Installation App (`installation`) - NEW
27. **InstallationJob** - Installation jobs for Solar/Machinery
28. **InstallationStatusHistory** - Status change history

### Accounting App (`accounting`)
29. **ExpenseCategory** - Expense categories
30. **Expense** - Individual expenses
31. **Transaction** - Unified transaction model

### License App (`license`)
32. **AppInstallation** - First run tracking (trial)
33. **AppLicense** - Activated licenses

---

## 2. API Endpoints (90+ Endpoints)

### Authentication (`/api/token/`)
- `POST /api/token/` - JWT token obtain (login)
- `POST /api/token/refresh/` - Refresh token

### Core (`/api/core/`)
- `POST /api/core/register/` - User registration
- `GET /api/core/me/` - Current user info
- `GET /api/core/shop-settings/` - Shop settings
- `PUT /api/core/shop-settings/` - Update shop settings
- `POST /api/core/forgot-password/` - Forgot password
- `POST /api/core/reset-password/` - Reset password
- `POST /api/core/select-location/` - Select work location
- `GET /api/core/employees/` - List employees (ViewSet)
- `POST /api/core/employees/` - Create employee
- `GET /api/core/roles/` - List roles (ViewSet)
- `POST /api/core/roles/` - Create role

### Inventory (`/api/`)
- **Categories** (ViewSet): GET, POST, GET/{id}, PUT/{id}, DELETE/{id}
- **Products Admin** (ViewSet): GET, POST, GET/{id}, PUT/{id}, DELETE/{id}
- **Sites** (ViewSet): GET, POST
- **Locations** (ViewSet): GET, POST
- **Payment Methods** (ViewSet): GET, POST, PUT/{id}, DELETE/{id}
- **Staff APIs**:
  - `GET /api/staff/items/` - Product list for POS
  - `POST /api/sales/request/` - Create sale request
  - `GET /api/sales/history/` - Staff sale history
  - `GET /api/staff/my-sales-summary/` - Today's sales summary
  - `GET /api/locations/` - Location list
- **Admin APIs**:
  - `GET /api/admin/pending/` - Pending approvals
  - `POST /api/admin/approve/{id}/` - Approve/reject sale
  - `GET /api/admin/report/daily-summary/` - Daily sales summary
  - `GET /api/admin/report/full-inventory/` - Full inventory report
  - `GET /api/admin/report/low-stock/` - Low stock report
  - `GET /api/admin/report/sales-period-summary/` - Sales period summary
  - `POST /api/admin/sync-prices/` - Sync USD prices
- **Inventory Movements**:
  - `GET /api/movements/` - List movements
  - `POST /api/movements/transfer/` - Transfer stock
  - `POST /api/movements/inbound/` - Stock inbound
- **Invoices**:
  - `GET /api/invoices/` - List invoices
  - `GET /api/invoice/{id}/` - Invoice detail
  - `GET /api/invoice/{id}/pdf/` - Invoice PDF
  - `POST /api/invoice/{id}/cancel/` - Cancel invoice
- **Notifications**:
  - `GET /api/notifications/` - List notifications
  - `POST /api/notifications/{id}/read/` - Mark as read
  - `GET /api/notifications/unread-count/` - Unread count
  - `POST /api/notifications/mark-all-read/` - Mark all read
- **Product Lookup**:
  - `GET /api/products/lookup/` - Lookup by SKU
  - `POST /api/products/import/` - Bulk import
- **Settings**:
  - `GET /api/settings/exchange-rate/` - Get USD rate
  - `PUT /api/settings/exchange-rate/` - Update USD rate
- **Bundles**:
  - `POST /api/bundles/validate/` - Validate bundle
- **Serials**:
  - `GET /api/serials/lookup/` - Lookup serial
  - `PUT /api/serials/{id}/` - Update serial item
- **Warranty**:
  - `GET /api/warranty/check/` - Check warranty (public)
  - `GET /api/warranty/expiring-soon/` - Expiring soon
- **Dashboard**:
  - `GET /api/dashboard/analytics/` - Dashboard analytics
  - `GET /api/inventory/management/` - Inventory dashboard
- **Payment**:
  - `GET /api/payment-methods/list/` - Active payment methods
  - `POST /api/sales/{id}/upload-payment-proof/` - Upload payment proof
  - `PUT /api/sales/{id}/payment-status/` - Update payment status

### Customer (`/api/customers/`)
- `GET /api/customers/` - List customers
- `POST /api/customers/` - Create customer
- `GET /api/customers/{id}/` - Get customer
- `PUT /api/customers/{id}/` - Update customer
- `GET /api/customers/invoice/{id}/` - Invoice detail

### Service (`/api/service/`)
- **Repairs** (ViewSet): GET, POST, GET/{id}, PUT/{id}
- `GET /api/service/track/` - Track repair (public)

### Installation (`/api/installation/`) - NEW
- **Installation Jobs** (ViewSet): GET, POST, GET/{id}, PUT/{id}, PATCH/{id}, DELETE/{id}
- `POST /api/installation/jobs/{id}/update-status/` - Update status with history
- `POST /api/installation/jobs/{id}/upload-signature/` - Upload customer signature
- `GET /api/installation/jobs/{id}/warranty-sync/` - Manually sync warranty dates
- `GET /api/installation/dashboard/` - Dashboard with statistics

### AI (`/api/ai/`)
- `GET /api/ai/best-sellers/` - Best sellers list
- `POST /api/ai/suggest/` - Upsell suggestions
- `GET /api/ai/sale-auto-tips/` - Sale tips
- `POST /api/ai/ask/` - Ask AI question
- `GET /api/ai/insights/` - Smart business insights

### Accounting (`/api/accounting/`)
- **Expense Categories** (ViewSet): GET, POST, PUT/{id}, DELETE/{id}
- **Expenses** (ViewSet): GET, POST, PUT/{id}, DELETE/{id}
- `GET /api/accounting/transactions/` - List transactions
- `GET /api/accounting/pnl/summary/` - P&L summary
- `GET /api/accounting/pnl/profit-from-sales/` - Profit from sales
- `GET /api/accounting/pnl/trend/` - Profit trend
- `GET /api/accounting/pnl/margin-analysis/` - Profit margin analysis

### License (`/api/license/`)
- `GET /api/license/status/` - License status
- `POST /api/license/activate/` - Activate license
- `GET /api/license/check/` - Check license (public)

---

## 3. Vue.js Pages & Components (28 Pages, 16 Components)

### Public Pages (No Auth)
1. **Login.vue** - User login
2. **Register.vue** - User registration
3. **ForgotPassword.vue** - Forgot password
4. **ResetPassword.vue** - Reset password
5. **LicenseActivation.vue** - License activation
6. **RepairTrack.vue** (`/repair-track`) - Public repair tracking
7. **WarrantyCheck.vue** (`/warranty-check`) - Public warranty check

### Main Layout Pages (Auth Required)
8. **Dashboard.vue** (`/`) - Main dashboard
9. **Inventory.vue** (`/inventory`) - Inventory overview
10. **CategoryManagement.vue** (`/categories`) - Category CRUD
11. **ProductManagement.vue** (`/products`) - Product CRUD
12. **InventoryMovement.vue** (`/movements`) - Stock movements
13. **LocationManagement.vue** (`/shop-locations`) - Location management
14. **TransferUI.vue** (`/inventory/transfer`) - Stock transfer
15. **SalesRequest.vue** (`/sales/pos`) - POS sales interface
16. **SaleHistory.vue** (`/sales/history`) - Sales history
17. **AdminApproval.vue** (`/sales/approve`) - Approve/reject sales
18. **ServiceManagement.vue** (`/service`) - Repair service management
19. **InstallationManagement.vue** (`/installation`) - Installation job CRUD - NEW
20. **InstallationDashboard.vue** (`/installation/dashboard`) - Installation dashboard - NEW
21. **InstallationDetail.vue** (`/installation/:id`) - Installation details - NEW
22. **UserManagement.vue** (`/users`) - User management
23. **RoleManagement.vue** (`/users/roles`) - Role management
24. **SalesReport.vue** (`/reports/sales`) - Sales reports
25. **InventoryReport.vue** (`/reports/inventory`) - Inventory reports
26. **ServiceReport.vue** (`/reports/service`) - Service reports
27. **CustomerReport.vue** (`/reports/customers`) - Customer reports
28. **ExpenseManagement.vue** (`/accounting/expenses`) - Expense management
29. **ProfitLossReport.vue** (`/accounting/pl`) - P&L report
30. **Settings.vue** (`/settings`) - Settings page
    - Shop settings
    - Payment method settings
    - Expense category settings
    - License info
    - User info

### Components
1. **Sidebar.vue** - Navigation sidebar
2. **Topbar.vue** - Top navigation bar
3. **BarcodeScanner.vue** - Barcode scanning
4. **BarcodeGenerator.vue** - Barcode generation
5. **InvoicePrint.vue** - Invoice printing
6. **RepairInvoice.vue** - Repair invoice
7. **RepairCalendar.vue** - Repair calendar view
8. **ServiceEntry.vue** - Service entry form
9. **InboundStock.vue** - Stock inbound form
10. **SignatureCapture.vue** - Canvas signature capture - NEW
11. **DataTable.vue** - Reusable data table
12. **LicenseBanner.vue** - License status banner
13. **Avatar.vue** - User avatar
14. **Bell.vue** - Notification bell
15. **WelcomeItem.vue** - Welcome component
16. **TheWelcome.vue** - Welcome section

---

## 4. User Roles & Permissions (11 Roles)

### Roles (Hierarchy)
1. **super_admin** - Full system access
2. **owner** - Owner access (can delete)
3. **admin** - Administrator access
4. **manager** - Manager access
5. **assistant_manager** - Assistant manager
6. **inventory_manager** - Inventory manager
7. **inventory_staff** - Inventory staff
8. **sale_supervisor** - Sales supervisor
9. **sale_staff** - Sales staff
10. **technician** - Installation technician - NEW
11. **employee** - Basic employee (default)

### Permission Classes
- **IsSuperAdmin** - Superuser only
- **IsOwner** - Owner role only
- **IsAdminOrHigher** - Owner, Admin, Manager, Super Admin
  - DELETE: Owner only
- **IsInventoryManagerOrHigher** - Inventory Manager, Admin, Owner, Manager
  - DELETE: Owner only
- **IsStaffOrHigher** - All authenticated users with roles

### Role-Based Menu Access
- **Dashboard** - All roles
- **Inventory** - super_admin, owner, admin, manager, inventory_manager, inventory_staff
- **Categories** - super_admin, owner, admin, manager, inventory_manager
- **Products** - super_admin, owner, admin, manager, inventory_manager, inventory_staff
- **Stock Movement** - super_admin, owner, admin, manager, inventory_manager, inventory_staff
- **Shop Location** - super_admin, owner, admin, manager
- **Users Management** - super_admin, owner, admin, manager
- **Sales Request** - super_admin, owner, admin, sale_staff, sale_supervisor, manager, assistant_manager
- **Sales History** - All sales roles + managers
- **Service** - All roles except basic employee
- **Installation Dashboard** - super_admin, owner, admin, manager - NEW
- **Installation Management** - super_admin, owner, admin, manager, inventory_manager - NEW
- **Approve** - super_admin, owner, admin, manager, assistant_manager
- **Settings** - super_admin, owner, admin, manager
- **Expenses** - super_admin, owner, admin, manager
- **P&L Report** - super_admin, owner, admin, manager

---

## 5. Business Logic & Features (16+ Major Features)

### Inventory Management
- **Stock Tracking**
  - Double-entry system via InventoryMovement
  - Location-based stock
  - Shop floor stock calculation
  - Total stock calculation
- **Product Pricing**
  - Fixed MMK pricing
  - Dynamic USD pricing (auto-updates with exchange rate)
  - Markup percentage
  - Cost price tracking
- **Product Bundles**
  - PC Building bundles
  - Solar set bundles
  - Machinery packages
  - Fixed bundles
  - Configurator with min/max/default quantities
- **Serial Number Tracking**
  - Auto-generated serial numbers
  - Status tracking (in_stock/sold/defective)
  - Warranty period calculation
- **Stock Movements**
  - Inbound (stock received)
  - Outbound (sales/withdrawals)
  - Transfer (location change)
  - Adjustment (count/fix)
  - Rejected sale logging

### Sales & POS
- **Sales Flow**
  - Staff creates sale request
  - Admin/Manager approves/rejects
  - Auto-generates invoice number
  - Stock deducted on approval
- **Payment Methods**
  - Cash
  - Digital payments (KPay, Wave Pay, AYA Pay, etc.)
  - QR code display
  - Payment proof upload
  - Payment status tracking
- **Discounts**
  - Transaction-level discounts
  - Bundle discounts (percentage/fixed)
- **Invoices**
  - PDF generation
  - Invoice cancellation
  - Invoice history

### Customer Management
- **Customer Records**
  - Name, phone, email, address
  - Preferred branch tracking
- **Customer History**
  - Purchase history
  - Service history

### Service/Repair Management
- **Repair Orders**
  - Auto-generated repair numbers
  - Status workflow: received → fixing → ready → completed
  - Labour cost tracking
  - Spare parts tracking
  - Deposit management
  - Customer notification tracking
- **Repair Calendar**
  - Return date tracking
  - Status visualization
- **Public Tracking**
  - Customers can track repairs by repair number

### Installation Management - NEW
- **Installation Jobs**
  - Links to approved sales (Bundle or Product)
  - Auto-generated installation numbers (INST-YYMMDD-XXXX)
  - Customer from sale transaction
  - Installation address and dates
  - Technician assignment (filters by Technician role)
  - Status workflow: pending → in_progress → completed → signed_off
  - Status history tracking
- **Signature Capture**
  - Canvas-based signature drawing
  - File upload alternative
  - Auto-updates status to signed_off
- **Warranty Sync**
  - Automatically syncs warranty_start_date to today when completed
  - Updates WarrantyRecord for all serial items in sale
  - Only processes products with warranty_months > 0
- **Dashboard**
  - Statistics: Total Active, Pending, In Progress, Completed
  - Active installations list view
  - Filter by status and technician

### Accounting & P&L
- **Expense Management**
  - Expense categories
  - Expense tracking with dates
  - Notes and descriptions
- **Transaction System**
  - Unified income/expense model
  - Auto-links to sales and expenses
  - Real-time calculation
- **Profit & Loss**
  - Net profit calculation
  - Gross profit from sales
  - Profit margin calculation
  - Daily profit trends
  - Profit margin shrinkage analysis
- **USD Inflation Analysis**
  - Tracks USD rate changes
  - Analyzes profit margin impact
  - Suggests price adjustments

### AI & Business Insights
- **Best Sellers**
  - Top selling products
  - Sales velocity tracking
- **Upsell Suggestions**
  - AI-powered product suggestions
  - Cart-based recommendations
- **Sale Auto Tips**
  - Price tips based on USD rate
  - Promotion suggestions
  - Marketing tips
- **Smart Business Insights**
  - Profit margin analysis
  - USD rate impact analysis
  - Reorder suggestions
  - Marketing advice for owners
- **AI Ask**
  - Natural language questions
  - Business advice
  - Sales data queries

### Notifications
- **Real-time Notifications**
  - Sale approval/rejection
  - Low stock alerts
  - System notifications
- **Notification Management**
  - Read/unread status
  - Mark all as read
  - Unread count

### Reports & Analytics
- **Sales Reports**
  - Daily summary
  - Period summary
  - Sales history
- **Inventory Reports**
  - Full inventory report
  - Low stock report
  - Stock movements
- **Service Reports**
  - Repair service reports
  - Status tracking
- **Customer Reports**
  - Customer activity
  - Purchase history
- **Dashboard Analytics**
  - Sales metrics
  - Inventory metrics
  - Profit metrics

### License System
- **Trial System**
  - 30-day trial
  - 5-day grace period
  - Machine ID tracking
- **License Types**
  - Trial
  - On-Premise Perpetual
  - Hosted Annual
- **License Activation**
  - License key validation
  - Machine ID binding
  - Expiration tracking

### Settings & Configuration
- **Shop Settings**
  - Shop name
  - Logo upload
- **Payment Methods**
  - Add/edit payment methods
  - QR code upload
  - Account details
  - Active/inactive toggle
- **Expense Categories**
  - Category management
  - Descriptions
- **Exchange Rate**
  - USD rate setting
  - Daily rate logging
  - Price auto-sync

### User Management
- **User CRUD**
  - Create/edit users
  - Role assignment
  - Location assignment
  - Assignment type (fixed/rotating)
- **Role Management**
  - Create/edit roles
  - Role descriptions
- **Password Management**
  - Temporary password storage
  - Password reset
  - Forgot password flow

### Public Features
- **Repair Tracking**
  - Public repair lookup by repair number
- **Warranty Check**
  - Public warranty lookup by serial number

---

## Summary Statistics

- **Total Django Models**: 27 models
- **Total API Endpoints**: 90+ endpoints
- **Total Vue Pages**: 28 pages
- **Total Vue Components**: 16 components
- **Total User Roles**: 11 roles
- **Total Permission Classes**: 5 classes
- **Total Business Features**: 16+ major features

---

## Simulation Workflows

### Core Workflows:
1. **User Registration & Login**
2. **Product Management** (CRUD)
3. **Stock Management** (Inbound, Transfer, Outbound)
4. **Sales Flow** (Create → Approve → Payment)
5. **Service/Repair** (Create → Update Status → Complete)
6. **Installation** (Create from Sale → Assign Technician → Update Status → Signature → Warranty Sync) - NEW
7. **Expense Entry** (Category → Expense)
8. **P&L Calculation** (View reports)
9. **AI Insights** (View dashboard insights)
10. **Payment Methods** (Add → Use in sale → Upload proof)
11. **Reports** (Generate various reports)

### Data to Generate:
- Products with categories (including Solar/Machinery products)
- Customers
- Users with different roles (including Technician role)
- Sales transactions (pending → approved)
- Installation jobs (linked to sales) - NEW
- Repair services
- Expenses
- Inventory movements
- Exchange rate logs
- Notifications
- Warranty records (from installations) - NEW

---

**Last Updated**: 2026-02-16
**System Version**: HoBo POS v1.0
**Includes**: Installation Module (NEW)
