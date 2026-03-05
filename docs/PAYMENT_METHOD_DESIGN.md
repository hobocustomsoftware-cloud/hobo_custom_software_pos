# Payment Method Feature Design

## Overview
Payment Method feature က owner က KPay, Wave Pay, AYA Pay စတဲ့ QR codes တွေ ထည့်နိုင်ပြီး၊ sale လုပ်တဲ့အခါ customer က screenshot တင်ပေးပြီး payment proof လုပ်နိုင်အောင် ဖြစ်ပါသည်။

## Design Approach

### Option 1: Simple & Direct (Recommended)
1. **PaymentMethod Model**: Owner က QR codes ထည့်ရန်
2. **SaleTransaction မှာ fields ထည့်**:
   - `payment_method` (ForeignKey to PaymentMethod)
   - `payment_status` (pending, paid, failed)
   - `payment_proof_screenshot` (ImageField)
3. **Workflow**:
   - Sale create လုပ်တဲ့အခါ payment_method select လုပ်ရမယ်
   - Customer က QR scan လုပ်ပြီး screenshot တင်ပေးရမယ်
   - Staff က screenshot upload လုပ်ပြီး payment_status = 'paid' လုပ်ရမယ်

### Option 2: Separate Payment Model
- Payment model ကို separate လုပ်ပြီး SaleTransaction နဲ့ link လုပ်တာ
- More flexible but more complex

**Recommendation: Option 1** - Simple and direct for POS use case

## Database Schema

### PaymentMethod Model
```python
class PaymentMethod(models.Model):
    name = models.CharField(max_length=50)  # "KPay", "Wave Pay", "AYA Pay", "Cash"
    qr_code_image = models.ImageField(upload_to='payment_qr/', null=True, blank=True)
    account_name = models.CharField(max_length=200, blank=True)  # Account holder name
    account_number = models.CharField(max_length=100, blank=True)  # Phone/Account number
    is_active = models.BooleanField(default=True)
    display_order = models.IntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
```

### SaleTransaction Updates
```python
# Add to SaleTransaction model:
payment_method = models.ForeignKey(
    'PaymentMethod',
    on_delete=models.SET_NULL,
    null=True,
    blank=True
)
payment_status = models.CharField(
    max_length=20,
    choices=[
        ('pending', 'Pending Payment'),
        ('paid', 'Paid'),
        ('failed', 'Payment Failed'),
        ('cash', 'Cash Payment'),  # Cash doesn't need proof
    ],
    default='pending'
)
payment_proof_screenshot = models.ImageField(
    upload_to='payment_proofs/',
    null=True,
    blank=True
)
payment_proof_uploaded_at = models.DateTimeField(null=True, blank=True)
```

## API Endpoints

### Payment Methods
- `GET /api/payment-methods/` - List active payment methods
- `GET/POST /api/payment-methods/{id}/` - CRUD (Owner/Admin only)
- `PATCH /api/payment-methods/{id}/toggle-active/` - Toggle active status

### Payment Proof Upload
- `POST /api/sales/{sale_id}/upload-payment-proof/` - Upload screenshot
- `PATCH /api/sales/{sale_id}/payment-status/` - Update payment status

## Frontend UI

### 1. Payment Method Management (Settings/Admin)
- List payment methods
- Add/Edit payment methods
- Upload QR code image
- Toggle active/inactive
- Set display order

### 2. Sales POS - Payment Selection
- Payment method selection dropdown/buttons
- Show QR code if digital payment selected
- Upload payment proof screenshot button
- Payment status indicator

### 3. Sales History - Payment Status
- Show payment method
- Show payment status badge
- View payment proof screenshot
- Update payment status (for admin)

## Workflow

### Sale Creation Flow
1. Staff creates sale → Select payment method
2. If digital payment (KPay/Wave/AYA):
   - Show QR code
   - Customer scans and pays
   - Staff uploads screenshot
   - Payment status = 'paid'
3. If Cash:
   - Payment status = 'cash' (no proof needed)

### Payment Proof Upload Flow
1. Staff clicks "Upload Payment Proof"
2. File picker opens (image only)
3. Upload to backend
4. Backend saves to `payment_proofs/` folder
5. Update SaleTransaction:
   - `payment_proof_screenshot` = uploaded file
   - `payment_status` = 'paid'
   - `payment_proof_uploaded_at` = now()

## Implementation Steps

1. ✅ Create PaymentMethod model
2. ✅ Add fields to SaleTransaction
3. ✅ Create migrations
4. ✅ Create API endpoints
5. ✅ Create Vue UI for payment method management
6. ✅ Update Sales POS UI for payment selection
7. ✅ Add payment proof upload in Sales History
8. ✅ Update Docker (no changes needed - media handling already exists)

## File Storage

- QR Codes: `media/payment_qr/`
- Payment Proofs: `media/payment_proofs/`
- Both handled by Django's ImageField with Pillow

## Security Considerations

- Payment proof upload: Only authenticated staff can upload
- Payment method management: Only Owner/Admin can manage
- File size limit: Max 5MB per image
- File type validation: Only images (jpg, png, webp)
