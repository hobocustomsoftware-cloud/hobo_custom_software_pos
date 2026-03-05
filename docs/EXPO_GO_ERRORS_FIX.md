# Expo Go Errors Fix - Comprehensive Solution

**ရက်စွဲ**: 2026-02-20

---

## 🔍 ပြဿနာများ (Issues Identified)

### 1. **Expo CLI Network Error**
```
TypeError: fetch failed
```
**အကြောင်းရင်း**: Expo CLI က internet connection သို့မဟုတ် firewall/proxy settings ကြောင့် fetch လုပ်လို့မရဘူး။

**ဖြေရှင်းနည်း**:
- Offline mode သုံးပါ: `EXPO_OFFLINE=1 expo start`
- သို့မဟုတ် network check လုပ်ပါ

### 2. **Static Files 404 Errors**
```
GET http://localhost:8000/assets/index-Di-5CGW5.js 404 (Not Found)
```
**အကြောင်းရင်း**: Expo Go app က Django backend (`localhost:8000/app/`) ကို load လုပ်နေတယ်၊ ဒါပေမယ့် Vue dev server (`localhost:5173`) ကို load လုပ်ရမယ်။

**ဖြေရှင်းနည်း**: ✅ Fixed - Django `vue_spa_view` က assets folder ကို properly serve လုပ်ပေးပါတယ်။

### 3. **401 Unauthorized Errors**
```
GET http://localhost/api/staff/items/ 401 (Unauthorized)
```
**အကြောင်းရင်း**: User login မဝင်သေးလို့ authentication token မရှိဘူး။

**ဖြေရှင်းနည်း**: Normal behavior - User က login ဝင်ရမည်။

### 4. **IndexedDB Error**
```
[IndexedDB] Could not set up error handler: TypeError: Cannot read properties of undefined (reading 'subscribe')
```
**အကြောင်းရင်း**: Old cached code သို့မဟုတ် Dexie.js version compatibility issue.

**ဖြေရှင်းနည်း**: ✅ Fixed - `posDb.js` မှာ error handling ကို properly implement လုပ်ထားပါတယ်။

---

## ✅ ပြင်ဆင်ထားသော အချက်များ

### 1. **Django vue_spa_view - Assets Serving**
- ✅ Assets folder (`assets/`) ကို properly serve လုပ်ပေးပါတယ်
- ✅ Root files (favicon, logo) ကို serve လုပ်ပေးပါတယ်
- ✅ API URL injection for Expo/WebView compatibility

### 2. **Expo Go App Configuration**
- ✅ Vue dev server (`localhost:5173`) ကို use လုပ်ထားပါတယ်
- ✅ API URL injection via `window.EXPO_API_URL`
- ✅ Local IP detection and configuration

### 3. **IndexedDB Error Handling**
- ✅ Proper error handling in `posDb.open()`
- ✅ Database corruption recovery
- ✅ No `posDb.on('error')` calls (removed to prevent subscribe error)

---

## 🚀 Usage Instructions

### **For Expo Go App**:

1. **Start Vue Dev Server** (Terminal 1):
   ```bash
   cd yp_posf
   npm run dev
   # Runs on http://localhost:5173
   ```

2. **Start Expo** (Terminal 2):
   ```bash
   cd yp_posf
   # Option 1: Normal mode (same WiFi)
   npm run expo:start
   
   # Option 2: Tunnel mode (any network) - Recommended
   npm run expo:start:tunnel
   ```

3. **Start Backend** (Terminal 3 - if not using Docker):
   ```bash
   cd WeldingProject
   python manage.py runserver 0.0.0.0:8000
   ```

4. **Connect with Expo Go**:
   - Install Expo Go app on phone
   - Scan QR code from Terminal 2
   - App loads Vue dev server (`localhost:5173`)

### **For Django-served App** (`localhost:8000/app/`):

1. **Build Frontend**:
   ```bash
   cd yp_posf
   npm run build
   ```

2. **Sync to Django**:
   ```powershell
   .\scripts\sync_frontend_to_django.ps1
   ```

3. **Access**:
   - `http://localhost:8000/app/` - Django serves built Vue app
   - `http://localhost/` - Nginx serves built Vue app (same design)

---

## 🔧 Troubleshooting

### **Expo CLI Network Error**:
```bash
# Option 1: Use offline mode
EXPO_OFFLINE=1 expo start

# Option 2: Check network/firewall
# Allow Expo CLI through firewall
# Check proxy settings
```

### **Static Files 404**:
- ✅ Fixed - Django `vue_spa_view` က assets folder ကို serve လုပ်ပေးပါတယ်
- Ensure Vue dev server is running (`npm run dev`)
- Check `static_frontend` directory has latest build files

### **401 Unauthorized**:
- Normal - User needs to login
- Check authentication token in localStorage
- Verify backend API is accessible

### **IndexedDB Error**:
- ✅ Fixed - Error handling implemented
- Clear browser cache if error persists
- Check Dexie.js version compatibility

---

## 📝 Configuration Files

### **app.json**:
```json
{
  "expo": {
    "extra": {
      "apiUrl": "http://172.20.176.1:8000/api",
      "localIp": "172.20.176.1"
    }
  }
}
```

### **App.js** (Expo Go):
- Uses Vue dev server: `http://${localIp}:5173`
- Injects API URL: `window.EXPO_API_URL`
- Sets Expo ready flag: `window.EXPO_READY = true`

### **config.js** (Vue App):
- Detects Expo environment: `window.EXPO_READY === true`
- Uses injected API URL: `window.EXPO_API_URL`
- Falls back to environment variable or default

---

## ✅ Summary

1. ✅ **Django vue_spa_view** - Assets serving fixed
2. ✅ **Expo Go app** - Uses Vue dev server correctly
3. ✅ **IndexedDB** - Error handling implemented
4. ✅ **API URL injection** - Expo/WebView compatibility
5. ⚠️ **Expo CLI network error** - Use offline mode or check network

**Next Steps**:
- Start Vue dev server (`npm run dev`)
- Start Expo (`npm run expo:start:tunnel`)
- Connect with Expo Go app
- Login to access authenticated endpoints
