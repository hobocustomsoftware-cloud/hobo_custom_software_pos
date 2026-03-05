# Accounting & P&L Module Documentation

## Overview

Accounting & P&L (Profit & Loss) Module သည် POS system အတွက် ဝင်ငွေ၊ ကုန်ကျစရိတ်၊ နှင့် အမြတ်အစွန်း တွက်ချက်ရန် ဖြစ်ပါသည်။

## Features

### 1. Expense Management (ကုန်ကျစရိတ် စီမံခန့်ခွဲမှု)
- **ExpenseCategory**: ကုန်ကျစရိတ် အမျိုးအစားများ (Rent, Utilities, Salaries, Supplies, etc.)
- **Expense**: ကုန်ကျစရိတ်များ မှတ်တမ်းတင်ခြင်း

### 2. Transaction Model
- **Transaction**: Unified model linking:
  - **Income**: `SaleTransaction` (approved sales) → Auto-created via signals
  - **Expense**: `Expense` → Auto-created via signals

### 3. Real-time P&L Calculation
- **Net Profit**: `ဝင်ငွေ - ကုန်ကျစရိတ်`
- **Gross Profit**: `ရောင်းရငွေ - ကုန်ကျစရိတ် (Product Cost)`
- **Profit Margin**: `(Net Profit / Total Income) × 100%`

### 4. AI Integration
- **Profit Margin Analysis**: USD inflation ကြောင့် profit margin ကျဆင်းနေလား စစ်ဆေးခြင်း
- **Automatic Price Suggestion**: Profit margin ကျဆင်းပြီး USD တက်နေလျှင် ဈေးတင်ရန် အကြံပြုခြင်း

## API Endpoints

### Expense Categories
- `GET /api/accounting/expense-categories/` - List all categories
- `POST /api/accounting/expense-categories/` - Create category
- `GET /api/accounting/expense-categories/{id}/` - Get category
- `PUT/PATCH /api/accounting/expense-categories/{id}/` - Update category
- `DELETE /api/accounting/expense-categories/{id}/` - Delete category

### Expenses
- `GET /api/accounting/expenses/` - List expenses (supports `?start_date=YYYY-MM-DD&end_date=YYYY-MM-DD`)
- `POST /api/accounting/expenses/` - Create expense
- `GET /api/accounting/expenses/{id}/` - Get expense
- `PUT/PATCH /api/accounting/expenses/{id}/` - Update expense
- `DELETE /api/accounting/expenses/{id}/` - Delete expense

### Transactions
- `GET /api/accounting/transactions/` - List transactions (supports `?type=income|expense&start_date=YYYY-MM-DD&end_date=YYYY-MM-DD`)

### P&L Reports
- `GET /api/accounting/pnl/summary/?start_date=YYYY-MM-DD&end_date=YYYY-MM-DD` - Net Profit Summary
- `GET /api/accounting/pnl/profit-from-sales/?start_date=YYYY-MM-DD&end_date=YYYY-MM-DD` - Gross Profit from Sales
- `GET /api/accounting/pnl/trend/?days=30` - Daily Profit Trend
- `GET /api/accounting/pnl/margin-analysis/` - Profit Margin Analysis with USD Impact

## Usage Examples

### Create Expense Category
```python
POST /api/accounting/expense-categories/
{
  "name": "အငှားချ",
  "description": "ဆိုင်ငှားချ"
}
```

### Create Expense
```python
POST /api/accounting/expenses/
{
  "category": 1,
  "description": "ဇန်နဝါရီလ အငှားချ",
  "amount": "500000.00",
  "expense_date": "2025-01-15",
  "notes": "Monthly rent"
}
```

### Get P&L Summary (Last 30 days)
```python
GET /api/accounting/pnl/summary/
Response:
{
  "total_income": "5000000.00",
  "total_expenses": "1500000.00",
  "net_profit": "3500000.00",
  "profit_margin_percent": "70.00",
  "transaction_count": 45,
  "start_date": "2025-01-01",
  "end_date": "2025-01-31"
}
```

### Get Profit Margin Analysis
```python
GET /api/accounting/pnl/margin-analysis/
Response:
{
  "is_shrinking": true,
  "current_margin": "65.50",
  "previous_margin": "72.30",
  "margin_change": "-6.80",
  "usd_rate_change_percent": "3.50",
  "usd_rising": true,
  "suggestion": "ဒေါ်လာဈေး 3.5% တက်နေပြီး အမြတ်အစွန်း 6.8% ကျဆင်းနေပါသည်။ ဈေးနှုန်းများ ပြန်လည်သုံးသပ်ရန် အကြံပြုပါသည်။"
}
```

## How It Works

### Automatic Transaction Creation

1. **Income Transaction**: When `SaleTransaction` is approved:
   ```python
   # Signal automatically creates Transaction
   Transaction.objects.create(
       transaction_type='income',
       sale_transaction=sale_transaction,
       amount=sale_transaction.total_amount,
       transaction_date=sale_transaction.created_at.date()
   )
   ```

2. **Expense Transaction**: When `Expense` is created:
   ```python
   # Signal automatically creates Transaction
   Transaction.objects.create(
       transaction_type='expense',
       expense=expense,
       amount=-abs(expense.amount),  # Negative
       transaction_date=expense.expense_date
   )
   ```

### Profit Margin Analysis

The `analyze_profit_margin_shrinkage()` function:
1. Compares current 7-day profit margin vs previous 7-day margin
2. Checks USD rate change percentage
3. Detects if margin is shrinking (>2% drop)
4. Detects if USD is rising (>2% increase)
5. Returns suggestion in Burmese if action needed

### AI Integration

The AI service (`get_smart_business_insights()`) automatically:
- Calls `analyze_profit_margin_shrinkage()`
- If margin shrinking + USD rising → Suggests price increase
- Displays suggestion in dashboard Bento card

## Database Schema

### ExpenseCategory
- `id`: Primary key
- `name`: Category name (unique)
- `description`: Description

### Expense
- `id`: Primary key
- `category`: ForeignKey to ExpenseCategory
- `description`: Expense description
- `amount`: Amount in MMK
- `expense_date`: Date of expense
- `created_by`: User who created
- `created_at`: Timestamp
- `notes`: Additional notes

### Transaction
- `id`: Primary key
- `transaction_type`: 'income' or 'expense'
- `sale_transaction`: ForeignKey to SaleTransaction (nullable, for income)
- `expense`: ForeignKey to Expense (nullable, for expense)
- `amount`: Amount (positive for income, negative for expense)
- `transaction_date`: Date of transaction (indexed)
- `created_at`: Timestamp

## Migration

After adding the module, run:

```bash
python manage.py makemigrations accounting
python manage.py migrate accounting
```

## Admin Interface

All models are registered in Django Admin:
- ExpenseCategory: CRUD operations
- Expense: CRUD with filtering by date
- Transaction: Read-only view (auto-created)

## Notes

- Transactions are **auto-created** via signals - don't create manually
- Expense amounts are stored as **positive** in Expense model, but **negative** in Transaction model
- Profit calculations use **real-time** data from database
- AI suggestions are **automatic** - no user prompt needed
