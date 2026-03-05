# Payment Method Feature - Sale Staff Screenshot Upload

## ✅ Completed

### Backend
1. ✅ PaymentMethod model created
2. ✅ SaleTransaction payment fields added
3. ✅ API endpoints:
   - Payment Method CRUD (Admin/Owner)
   - Payment Method List (for POS)
   - Payment Proof Upload (Sale Staff can upload)
   - Payment Status Update (Admin)
4. ✅ Permission: Sale staff who created the sale can upload payment proof

### Frontend
1. ✅ Sales POS (SalesRequest.vue):
   - Payment method selection dropdown
   - QR code display when digital payment selected
   - Payment proof upload after sale submission
   - Screenshot file picker and upload

### Serializer
1. ✅ SaleRequestSerializer updated to accept payment_method

## Workflow

### Sale Staff Flow:
1. **Create Sale**:
   - Select payment method (KPay, Wave Pay, AYA Pay, Cash)
   - If digital payment → QR code displayed
   - Customer scans QR and pays
   - Submit sale

2. **Upload Payment Proof**:
   - After sale submission, if digital payment → Upload button appears
   - Sale staff clicks "Screenshot ရွေးရန်"
   - Select image file (max 5MB, JPEG/PNG/WebP)
   - Click "Screenshot တင်ရန်"
   - Payment status automatically set to 'paid'

### Permission:
- ✅ Sale staff who created the sale can upload payment proof
- ✅ Admin/Manager can also upload for any sale
- ✅ Only authenticated users can upload

## API Usage

### Upload Payment Proof
```javascript
POST /api/sales/{sale_id}/upload-payment-proof/
Content-Type: multipart/form-data

FormData:
- payment_proof: File (image)
- payment_status: 'paid' (optional, default: 'paid')

Response:
{
  "message": "Payment proof uploaded successfully",
  "payment_status": "paid",
  "payment_proof_url": "http://..."
}
```

## Next Steps

1. **Run Migrations**:
   ```bash
   python manage.py makemigrations inventory
   python manage.py migrate inventory
   ```

2. **Create Payment Methods** (via Admin or API):
   - Cash (no QR needed)
   - KPay (with QR code image)
   - Wave Pay (with QR code image)
   - AYA Pay (with QR code image)

3. **Test Flow**:
   - Create sale with payment method
   - Upload payment proof screenshot
   - Verify payment status updated

## Files Modified

### Backend:
- `inventory/models.py` - PaymentMethod model, SaleTransaction fields
- `inventory/views.py` - Payment proof upload view
- `inventory/serializers.py` - SaleRequestSerializer updated
- `inventory/serializers_payment.py` - Payment serializers
- `inventory/urls.py` - Payment endpoints
- `inventory/admin.py` - PaymentMethod admin

### Frontend:
- `yp_posf/src/views/sales/SalesRequest.vue` - Payment selection & upload UI

## Status: ✅ COMPLETE

Sale staff can now:
1. Select payment method during sale
2. See QR code for digital payments
3. Upload payment proof screenshot after sale
4. Payment status automatically updated to 'paid'
