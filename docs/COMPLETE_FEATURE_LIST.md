# Complete POS System Feature List

## 📋 Table of Contents
1. [Django Models](#django-models)
2. [API Endpoints](#api-endpoints)
3. [Vue.js Pages & Components](#vuejs-pages--components)
4. [User Roles & Permissions](#user-roles--permissions)
5. [Business Logic & Features](#business-logic--features)

---

## Django Models

### Core App (`core`)
- **User** (extends AbstractUser)
  - Dynamic role assignment (`role_obj`)
  - Staff assignment type (fixed/rotating)
  - Primary location assignment
  - Temporary password storage
- **Role** - User roles (owner, admin, manager, etc.)
- **StaffSession** - Staff work sessions for rotating assignments
- **ShopSettings** - Shop name, logo, settings

### Inventory App (`inventory`)
- **Category** - Product categories
- **ProductTag** - Compatibility/attribute tags
- **Product** - Main product model
  - SKU (auto-generated from name)
  - Model number
  - Pricing: Fixed MMK or Dynamic USD
  - Cost price, retail price, selling price
  - USD cost & markup percentage
  - Serial tracking support
  - Warranty months
  - Stock calculation (via InventoryMovement)
- **Bundle** - Product bundles (PC, Solar, Machine, Fixed)
  - Bundle pricing types
  - Discount configuration
- **BundleItem** - Items in a bundle
- **BundleComponent** - Configurator slots (min/max/default qty)
- **PaymentMethod** - Payment methods (KPay, Wave Pay, Cash, etc.)
  - QR code images
  - Account details
  - Active status
- **SaleTransaction** - Sales with approval flow
  - Invoice number (auto-generated)
  - Status: pending/approved/rejected
  - Payment method & status
  - Payment proof screenshot
  - Approval tracking
- **SaleItem** - Items in a sale transaction
- **Sale** - Legacy sale model (deprecated?)
- **SerialItem** - Serial number tracking
  - Status: in_stock/sold/defective/pending_sale
  - Warranty tracking
- **WarrantyRecord** - Warranty period records
- **GlobalSetting** - Key-value app settings (USD rate, etc.)
- **ExchangeRateLog** - Daily USD exchange rate logs
- **Site** - Shop/branch sites
- **Location** - Storage/sale locations
  - Types: warehouse/branch/shop_floor
  - Staff assignments
- **InventoryMovement** - Stock movement tracking
  - Types: inbound/outbound/transfer/adjustment/rejected
  - Double-entry system
- **Notification** - System notifications
  - Types: sale approved/rejected, low stock, etc.
  - Read/unread status

### Customer App (`customer`)
- **Customer** - Customer information
  - Name, phone, email, address
  - Preferred branch/location

### Service App (`service`)
- **RepairService** - Repair service orders
  - Status: received/fixing/ready/completed/cancelled
  - Repair number (auto-generated)
  - Labour cost, parts cost, deposit
  - Customer notification tracking
- **RepairSparePart** - Spare parts used in repairs
- **RepairStatusHistory** - Status change history

### Installation App (`installation`)
- **InstallationJob** - Installation jobs for Solar/Machinery
  - Links to SaleTransaction (Bundle or Product sale)
  - Installation number (auto-generated: INST-YYMMDD-XXXX)
  - Customer from sale transaction
  - Installation address, dates
  - Technician assignment (User with Technician role)
  - Status: pending → in_progress → completed → signed_off → cancelled
  - Customer signature capture (ImageField)
  - Auto-sets completed_at and signed_off_at timestamps
- **InstallationStatusHistory** - Status change history
  - Tracks all status transitions
  - Notes and updated_by user

### Accounting App (`accounting`)
- **ExpenseCategory** - Expense categories
- **Expense** - Individual expenses
  - Category, amount, date, notes
- **Transaction** - Unified transaction model
  - Types: income (from SaleTransaction) / expense
  - Links to SaleTransaction or Expense
  - Auto-calculated amounts

### License App (`license`)
- **AppInstallation** - First run tracking (trial)
  - Machine ID
  - Trial expiration (30 days + 5 days grace)
- **AppLicense** - Activated licenses
  - Types: trial/on_premise_perpetual/hosted_annual
  - License key, expiration

---

## API Endpoints

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
- **Categories** (ViewSet)
  - `GET /api/categories/` - List categories
  - `POST /api/categories/` - Create category
  - `GET /api/categories/{id}/` - Get category
  - `PUT /api/categories/{id}/` - Update category
  - `DELETE /api/categories/{id}/` - Delete category
- **Products Admin** (ViewSet)
  - `GET /api/products-admin/` - List products
  - `POST /api/products-admin/` - Create product
  - `GET /api/products-admin/{id}/` - Get product
  - `PUT /api/products-admin/{id}/` - Update product
  - `DELETE /api/products-admin/{id}/` - Delete product
- **Sites** (ViewSet)
  - `GET /api/sites-admin/` - List sites
  - `POST /api/sites-admin/` - Create site
- **Locations** (ViewSet)
  - `GET /api/locations-admin/` - List locations
  - `POST /api/locations-admin/` - Create location
- **Payment Methods** (ViewSet)
  - `GET /api/payment-methods/` - List payment methods
  - `POST /api/payment-methods/` - Create payment method
  - `PUT /api/payment-methods/{id}/` - Update payment method
  - `DELETE /api/payment-methods/{id}/` - Delete payment method
- **Staff APIs**
  - `GET /api/staff/items/` - Product list for POS
  - `POST /api/sales/request/` - Create sale request
  - `GET /api/sales/history/` - Staff sale history
  - `GET /api/staff/my-sales-summary/` - Today's sales summary
  - `GET /api/locations/` - Location list (dropdown)
- **Admin APIs**
  - `GET /api/admin/pending/` - Pending approvals list
  - `POST /api/admin/approve/{id}/` - Approve/reject sale
  - `GET /api/admin/report/daily-summary/` - Daily sales summary
  - `GET /api/admin/report/full-inventory/` - Full inventory report
  - `GET /api/admin/report/low-stock/` - Low stock report
  - `GET /api/admin/report/sales-period-summary/` - Sales period summary
  - `POST /api/admin/sync-prices/` - Sync USD prices
- **Inventory Movements**
  - `GET /api/movements/` - List movements
  - `POST /api/movements/transfer/` - Transfer stock
  - `POST /api/movements/inbound/` - Stock inbound
- **Invoices**
  - `GET /api/invoices/` - List invoices
  - `GET /api/invoice/{id}/` - Invoice detail
  - `GET /api/invoice/{id}/pdf/` - Invoice PDF
  - `POST /api/invoice/{id}/cancel/` - Cancel invoice
- **Notifications**
  - `GET /api/notifications/` - List notifications
  - `POST /api/notifications/{id}/read/` - Mark as read
  - `GET /api/notifications/unread-count/` - Unread count
  - `POST /api/notifications/mark-all-read/` - Mark all read
- **Product Lookup**
  - `GET /api/products/lookup/` - Lookup by SKU
  - `POST /api/products/import/` - Bulk import
- **Settings**
  - `GET /api/settings/exchange-rate/` - Get USD rate
  - `PUT /api/settings/exchange-rate/` - Update USD rate
- **Bundles**
  - `POST /api/bundles/validate/` - Validate bundle
- **Serials**
  - `GET /api/serials/lookup/` - Lookup serial
  - `PUT /api/serials/{id}/` - Update serial item
- **Warranty**
  - `GET /api/warranty/check/` - Check warranty (public)
  - `GET /api/warranty/expiring-soon/` - Expiring soon
- **Dashboard**
  - `GET /api/dashboard/analytics/` - Dashboard analytics
  - `GET /api/inventory/management/` - Inventory dashboard
- **Payment**
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
- **Repairs** (ViewSet)
  - `GET /api/service/repairs/` - List repairs
  - `POST /api/service/repairs/` - Create repair
  - `GET /api/service/repairs/{id}/` - Get repair
  - `PUT /api/service/repairs/{id}/` - Update repair
- `GET /api/service/track/` - Track repair (public)

### AI (`/api/ai/`)
- `GET /api/ai/best-sellers/` - Best sellers list
- `POST /api/ai/suggest/` - Upsell suggestions
- `GET /api/ai/sale-auto-tips/` - Sale tips
- `POST /api/ai/ask/` - Ask AI question
- `GET /api/ai/insights/` - Smart business insights

### Accounting (`/api/accounting/`)
- **Expense Categories** (ViewSet)
  - `GET /api/accounting/expense-categories/` - List categories
  - `POST /api/accounting/expense-categories/` - Create category
  - `PUT /api/accounting/expense-categories/{id}/` - Update category
  - `DELETE /api/accounting/expense-categories/{id}/` - Delete category
- **Expenses** (ViewSet)
  - `GET /api/accounting/expenses/` - List expenses
  - `POST /api/accounting/expenses/` - Create expense
  - `PUT /api/accounting/expenses/{id}/` - Update expense
  - `DELETE /api/accounting/expenses/{id}/` - Delete expense
- `GET /api/accounting/transactions/` - List transactions
- `GET /api/accounting/pnl/summary/` - P&L summary
- `GET /api/accounting/pnl/profit-from-sales/` - Profit from sales
- `GET /api/accounting/pnl/trend/` - Profit trend
- `GET /api/accounting/pnl/margin-analysis/` - Profit margin analysis

### Installation (`/api/installation/`)
- **Installation Jobs** (ViewSet)
  - `GET /api/installation/jobs/` - List installations (filters: status, technician, active_only)
  - `POST /api/installation/jobs/` - Create installation job
  - `GET /api/installation/jobs/{id}/` - Get installation details
  - `PUT /api/installation/jobs/{id}/` - Update installation
  - `PATCH /api/installation/jobs/{id}/` - Partial update
  - `DELETE /api/installation/jobs/{id}/` - Delete installation
- `POST /api/installation/jobs/{id}/update-status/` - Update status with history
- `POST /api/installation/jobs/{id}/upload-signature/` - Upload customer signature
- `GET /api/installation/jobs/{id}/warranty-sync/` - Manually sync warranty dates
- `GET /api/installation/dashboard/` - Dashboard with statistics and active jobs

### License (`/api/license/`)
- `GET /api/license/status/` - License status
- `POST /api/license/activate/` - Activate license
- `GET /api/license/check/` - Check license (public)

---

## Vue.js Pages & Components

### Public Pages (No Auth)
- **Login.vue** - User login
- **Register.vue** - User registration
- **ForgotPassword.vue** - Forgot password
- **ResetPassword.vue** - Reset password
- **LicenseActivation.vue** - License activation
- **RepairTrack.vue** (`/repair-track`) - Public repair tracking
- **WarrantyCheck.vue** (`/warranty-check`) - Public warranty check

### Main Layout Pages (Auth Required)
- **Dashboard.vue** (`/`) - Main dashboard
- **Inventory.vue** (`/inventory`) - Inventory overview
- **CategoryManagement.vue** (`/categories`) - Category CRUD
- **ProductManagement.vue** (`/products`) - Product CRUD
- **InventoryMovement.vue** (`/movements`) - Stock movements
- **LocationManagement.vue** (`/shop-locations`) - Location management
- **TransferUI.vue** (`/inventory/transfer`) - Stock transfer
- **SalesRequest.vue** (`/sales/pos`) - POS sales interface
- **SaleHistory.vue** (`/sales/history`) - Sales history
- **AdminApproval.vue** (`/sales/approve`) - Approve/reject sales
- **ServiceManagement.vue** (`/service`) - Repair service management
- **UserManagement.vue** (`/users`) - User management
- **RoleManagement.vue** (`/users/roles`) - Role management
- **SalesReport.vue** (`/reports/sales`) - Sales reports
- **InventoryReport.vue** (`/reports/inventory`) - Inventory reports
- **ServiceReport.vue** (`/reports/service`) - Service reports
- **CustomerReport.vue** (`/reports/customers`) - Customer reports
- **ExpenseManagement.vue** (`/accounting/expenses`) - Expense management
- **ProfitLossReport.vue** (`/accounting/pl`) - P&L report
- **InstallationManagement.vue** (`/installation`) - Installation job CRUD
- **InstallationDashboard.vue** (`/installation/dashboard`) - Installation dashboard with statistics
- **InstallationDetail.vue** (`/installation/:id`) - View/edit installation details
- **Settings.vue** (`/settings`) - Settings page
  - Shop settings
  - Payment method settings
  - Expense category settings
  - License info
  - User info

### Components
- **Sidebar.vue** - Navigation sidebar
- **Topbar.vue** - Top navigation bar
- **BarcodeScanner.vue** - Barcode scanning
- **BarcodeGenerator.vue** - Barcode generation
- **InvoicePrint.vue** - Invoice printing
- **RepairInvoice.vue** - Repair invoice
- **RepairCalendar.vue** - Repair calendar view
- **ServiceEntry.vue** - Service entry form
- **InboundStock.vue** - Stock inbound form
- **SignatureCapture.vue** - Canvas signature capture component
- **DataTable.vue** - Reusable data table
- **LicenseBanner.vue** - License status banner
- **Avatar.vue** - User avatar
- **Bell.vue** - Notification bell
- **WelcomeItem.vue** - Welcome component
- **TheWelcome.vue** - Welcome section

---

## User Roles & Permissions

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
10. **technician** - Installation technician
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
- **Approve** - super_admin, owner, admin, manager, assistant_manager
- **Settings** - super_admin, owner, admin, manager
- **Expenses** - super_admin, owner, admin, manager
- **P&L Report** - super_admin, owner, admin, manager
- **Installation Dashboard** - super_admin, owner, admin, manager
- **Installation Management** - super_admin, owner, admin, manager, inventory_manager

---

## Business Logic & Features

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

### Installation Management
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

- **Total Django Models**: ~27 models
- **Total API Endpoints**: ~90+ endpoints
- **Total Vue Pages**: ~28 pages
- **Total Vue Components**: ~16 components
- **Total User Roles**: 11 roles
- **Total Permission Classes**: 5 classes
- **Total Business Features**: 16+ major features

---

## Notes for Simulation

### Key Workflows to Simulate:
1. **User Registration & Login**
2. **Product Management** (CRUD)
3. **Stock Management** (Inbound, Transfer, Outbound)
4. **Sales Flow** (Create → Approve → Payment)
5. **Service/Repair** (Create → Update Status → Complete)
6. **Installation** (Create from Sale → Assign Technician → Update Status → Signature → Warranty Sync)
7. **Expense Entry** (Category → Expense)
8. **P&L Calculation** (View reports)
9. **AI Insights** (View dashboard insights)
10. **Payment Methods** (Add → Use in sale → Upload proof)
11. **Reports** (Generate various reports)

### Data to Generate:
- Products with categories
- Customers
- Users with different roles (including Technician role)
- Sales transactions (pending → approved)
- Installation jobs (linked to sales)
- Repair services
- Expenses
- Inventory movements
- Exchange rate logs
- Notifications
- Warranty records (from installations)

---

**Last Updated**: 2026-02-16
**System Version**: HoBo POS v1.0
**Includes**: Installation Module (NEW)
