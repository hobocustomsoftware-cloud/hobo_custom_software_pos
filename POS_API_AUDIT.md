# POS API & Frontend Connection Audit

Base URL: `/api/` (web) or `VITE_API_URL` (Capacitor/Expo).

## POS-used endpoints (verified against backend)

| Frontend call | Backend route | App | Status |
|---------------|---------------|-----|--------|
| `staff/items/` | `path('staff/items/', ...)` | inventory | OK |
| `staff/items` (no slash) | `path('staff/items', ...)` | inventory | OK |
| `sales/request/` | `path('sales/request/', ...)` | inventory | OK |
| `payment-methods/` | ViewSet `payment-methods` | inventory | OK |
| `payment-methods/list/` | `path('payment-methods/list/', ...)` | inventory | OK (fallback) |
| `customers/` | `path('api/customers/', include(customer.urls))` → `''` | customer | OK |
| `categories/` | router `categories` | inventory | OK |
| `products/search/` | `path('products/search/', ...)` | inventory | OK |
| `settings/exchange-rate/` | `path('settings/exchange-rate/', ...)` | inventory | OK |
| `ai/cross-sell/` | `path('ai/cross-sell/', ...)` | inventory | OK |
| `ai/sale-auto-tips/` | `path('api/ai/', include(ai.urls))` → `sale-auto-tips/` | ai | OK |
| `ai/ask/` | ai urls → `ask/` | ai | OK |
| `sales/<pk>/upload-payment-proof/` | `path('sales/<int:pk>/upload-payment-proof/', ...)` | inventory | OK |

## Error handling (POS)

- **Payment methods**: Tries `payment-methods/` then `payment-methods/list/`; on 404 no toast; empty list used.
- **Customers / Categories**: `api.get('customers/').catch(() => ({ data: [] }))` and same for categories so one failure does not break POS.
- **Offline / Retry**: "ပြန်ဆွဲမည်" calls `offlinePos.fetchProductsAndCache()` and shows toast.

## Main URL includes (WeldingProject/urls.py)

- `path('api/', include('inventory.urls'))` — staff/items, sales/request, categories, payment-methods, products/search, settings/exchange-rate, ai/cross-sell, etc.
- `path('api/customers/', include('customer.urls'))` — customers list/detail.
- `path('api/ai/', include('ai.urls'))` — sale-auto-tips, ask, etc.

All POS API calls match backend routes; no missing or wrong paths found.
