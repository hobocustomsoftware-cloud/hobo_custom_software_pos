# User Registration Guide - စာရင်းသွင်းခြင်း လမ်းညွှန်

**ရက်စွဲ**: 2026-02-19

---

## 📋 အဓိက အချက်များ

### 1. **ပထမဆုံး User (Owner)**
- **အလိုအလျောက်**: ပထမဆုံး register လုပ်သူက **Owner** role ရရှိပြီး ချက်ချင်း login ဝင်နိုင်ပါသည်
- **Role**: `owner` (သတ်မှတ်ထားသည်)
- **Permission**: `is_staff=True` (Admin panel ဝင်ခွင့်ရှိသည်)

### 2. **ကျန်ရှိသော Users (Staff)**
- **Default Role**: `sale_staff` (အရောင်းဝန်ထမ်း)
- **Permission**: `is_staff=False` (Admin panel ဝင်ခွင့်မရှိပါ)
- **Status**: `is_active=True` (ချက်ချင်း login ဝင်နိုင်ပါသည်)
- **သတိထားရန်**: Owner/Admin က location assignment နဲ့ role ပြင်ဆင်ပေးရန် လိုအပ်နိုင်ပါသည်

---

## 🚀 Registration လုပ်နည်း

### **Method 1: Frontend (Browser)**
1. Browser မှာ `http://localhost/register` (သို့မဟုတ် production URL) သို့ သွားပါ
2. Form ဖြည့်ပါ:
   - **အသုံးပြုသူအမည်** (Username) - **Required**
   - **အမည်ပြည့်** (Full Name) - Optional
   - **အီးမေးလ်** (Email) - Optional
   - **စကားဝှက်** (Password) - **Required** (အနည်းဆုံး ၆ လုံး)
   - **စကားဝှက် ပြန်ရိုက်ပါ** (Password Confirm) - **Required**
3. "စာရင်းသွင်းရန်" button ကို နှိပ်ပါ
4. **ပထမဆုံး user ဆိုရင်**: ချက်ချင်း login ဝင်သွားမည်
5. **ကျန်ရှိသော users ဆိုရင်**: Success message ပြပြီး login page သို့ redirect ဖြစ်မည်

### **Method 2: API (cURL/Postman)**
```bash
curl -X POST http://localhost/api/core/register/ \
  -H "Content-Type: application/json" \
  -d '{
    "username": "staff001",
    "email": "staff001@example.com",
    "full_name": "ဦးမောင်မောင်",
    "password": "password123",
    "password_confirm": "password123"
  }'
```

**Response (First User - Owner)**:
```json
{
  "message": "စာရင်းသွင်းခြင်း အောင်မြင်ပါပြီ။ ချက်ချင်း ဝင်ရောက်နိုင်ပါပြီ။",
  "username": "owner001",
  "can_login_now": true
}
```

**Response (Subsequent Users - Staff)**:
```json
{
  "message": "စာရင်းသွင်းခြင်း အောင်မြင်ပါပြီ။ Admin မှ အတည်ပြုပြီးနောက် ဝင်ရောက်နိုင်ပါမည်။",
  "username": "staff001",
  "can_login_now": false
}
```

---

## ⚙️ Owner/Admin မှ User Management

### **1. User List ကြည့်ရန်**
- **Frontend**: `/user-management` page သို့ သွားပါ (Owner/Admin only)
- **API**: `GET /api/core/employees/` (Owner/Admin only)

### **2. User Role ပြင်ဆင်ရန်**
- **Frontend**: User Management page မှာ user ကို edit လုပ်ပြီး role ရွေးပါ
- **API**: `PUT /api/core/employees/{id}/` with `role_obj` field

**Available Roles**:
- `owner` - စနစ်ပိုင်ရှင်
- `admin` - စီမံခန့်ခွဲသူ
- `sale_staff` - အရောင်းဝန်ထမ်း (default)
- `inventory_manager` - ကုန်ပစ္စည်းစီမံခန့်ခွဲသူ
- (Custom roles များကို Owner က ဖန်တီးနိုင်သည်)

### **3. Location Assignment (ဆိုင်ခွဲ သတ်မှတ်ခြင်း)**
- **Frontend**: User Management page မှာ user ကို edit လုပ်ပြီး "Assigned Locations" မှာ ဆိုင်ခွဲများ ရွေးပါ
- **API**: `PUT /api/core/employees/{id}/` with `assigned_locations` array

**အရေးကြီးသော အချက်**:
- Staff users များက products list (`/api/staff/items/`) ခေါ်ရန် **location assignment** လိုအပ်ပါသည်
- `primary_location` သတ်မှတ်ထားရင် default location အဖြစ် သုံးမည်

### **4. User Activation/Deactivation**
- **Frontend**: User Management page မှာ user `is_active` toggle လုပ်ပါ
- **API**: `PUT /api/core/employees/{id}/` with `is_active: false` (deactivate)

---

## 🔐 Login ဝင်ရောက်ခြင်း

### **Registration ပြီးနောက်**
1. **First User (Owner)**: Frontend က ချက်ချင်း login ဝင်ပေးမည်
2. **Other Users**: Login page (`/login`) သို့ သွားပြီး username/password ဖြင့် login ဝင်ပါ

### **Login API**
```bash
curl -X POST http://localhost/api/token/ \
  -H "Content-Type: application/json" \
  -d '{
    "username": "staff001",
    "password": "password123"
  }'
```

**Response**:
```json
{
  "access": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGc..."
}
```

---

## ⚠️ သတိထားရန် အချက်များ

### **1. Username Uniqueness**
- Username က case-insensitive စစ်ဆေးသည် (ဥပမာ: `staff001` နဲ့ `Staff001` က တူညီသည်)
- Duplicate username ဆိုရင် error: "ဤအသုံးပြုသူအမည် ရှိပြီးသားဖြစ်ပါသည်။ ဝင်ရောက်ရန် ကြိုးစားပါ။"

### **2. Password Requirements**
- အနည်းဆုံး ၆ လုံး လိုအပ်သည်
- `password` နဲ့ `password_confirm` ကိုက်ညီရမည်

### **3. Location Assignment**
- Staff users များက products မြင်ရန် **location assignment** လိုအပ်ပါသည်
- Owner/Admin က User Management page မှာ location သတ်မှတ်ပေးရမည်

### **4. Role Permissions**
- `sale_staff` (default) - Products list, sales transactions only
- `inventory_manager` - Inventory management, product CRUD
- `admin` - User management, settings
- `owner` - Full access

---

## 📝 Example Workflow

### **Scenario: Owner ဖန်တီးပြီး Staff များ Register လုပ်ခြင်း**

1. **Owner Registration**:
   ```
   POST /api/core/register/
   {
     "username": "owner",
     "password": "owner123",
     "password_confirm": "owner123",
     "full_name": "ဦးပိုင်ရှင်"
   }
   ```
   → Owner role, can login immediately

2. **Staff Registration** (Multiple):
   ```
   POST /api/core/register/
   {
     "username": "staff001",
     "password": "staff123",
     "password_confirm": "staff123",
     "full_name": "ဦးမောင်မောင်"
   }
   ```
   → `sale_staff` role, can login immediately

3. **Owner မှ Location Assignment**:
   ```
   PUT /api/core/employees/{staff001_id}/
   {
     "assigned_locations": [1, 2],  // Location IDs
     "primary_location": 1
   }
   ```

4. **Staff Login**:
   ```
   POST /api/token/
   {
     "username": "staff001",
     "password": "staff123"
   }
   ```

5. **Staff မှ Products List ခေါ်ခြင်း**:
   ```
   GET /api/staff/items/
   Authorization: Bearer {access_token}
   ```
   → Assigned locations မှ products များ ပြန်ပေးမည်

---

## 🛠️ Troubleshooting

### **Problem: Register လုပ်လို့မရဘူး**
- **Check**: Username က unique ဖြစ်ပါသလား?
- **Check**: Password က ၆ လုံးနဲ့ အထက် ဖြစ်ပါသလား?
- **Check**: Password နဲ့ password_confirm ကိုက်ညီပါသလား?
- **Check**: Backend logs မှာ error ရှိပါသလား?

### **Problem: Register ပြီးပေမယ့် Products မမြင်ရဘူး**
- **Solution**: Owner/Admin က User Management page မှာ location assignment လုပ်ပေးရမည်
- **Check**: User က `assigned_locations` ရှိပါသလား?
- **Check**: User က `primary_location` သတ်မှတ်ထားပါသလား?

### **Problem: Login ဝင်လို့မရဘူး**
- **Check**: Username/password မှန်ကန်ပါသလား?
- **Check**: User `is_active=True` ဖြစ်ပါသလား?
- **Check**: Backend API `/api/token/` က 200 OK ပြန်ပါသလား?

---

## 📚 Related Documentation

- `docs/MULTI_BRANCH_CONCURRENCY.md` - Multi-branch usage guide
- `docs/SRE_GUARANTEE.md` - System reliability guide
- `WeldingProject/core/views.py` - RegisterView implementation
- `WeldingProject/core/serializers.py` - RegisterSerializer implementation

---

## ✅ Summary

1. **First User** → Owner role, can login immediately
2. **Other Users** → `sale_staff` role, can login immediately (but need location assignment for products)
3. **Owner/Admin** → User Management page မှာ roles, locations, permissions ပြင်ဆင်နိုင်သည်
4. **API Endpoint**: `POST /api/core/register/` (Public - AllowAny)
5. **Frontend**: `/register` page

**အရေးကြီးသော အချက်**: Staff users များက products မြင်ရန် **location assignment** လိုအပ်ပါသည်!
