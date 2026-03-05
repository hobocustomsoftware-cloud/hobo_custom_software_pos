# Expo Go Quick Start - မြန်မာလို

## 🚀 အမြန်စတင်ရန်

### 1. Dependencies Install လုပ်ပါ
```bash
cd yp_posf
npm install
```

### 2. Vue Dev Server စတင်ပါ (Terminal 1)
```bash
npm run dev
# http://localhost:5173 မှာ run မယ်
```

### 3. Expo စတင်ပါ (Terminal 2)
```bash
npm run expo:start:tunnel
# QR code ပြမယ်
```

### 4. Backend စတင်ပါ (Terminal 3)
```bash
cd ../WeldingProject
python manage.py runserver 0.0.0.0:8000
```

### 5. Expo Go App နဲ့ Connect လုပ်ပါ
1. Phone မှာ **Expo Go** app install လုပ်ပါ
   - iOS: [App Store](https://apps.apple.com/app/expo-go/id982107779)
   - Android: [Google Play](https://play.google.com/store/apps/details?id=host.exp.exponent)
2. Terminal 2 က QR code ကို scan လုပ်ပါ
3. App Expo Go မှာ load ဖြစ်မယ်!

## 📱 Configuration

### Local Network Testing အတွက်:

1. **Computer IP address ရှာပါ:**
   - Windows: `ipconfig` → IPv4 Address ကြည့်ပါ
   - Mac/Linux: `ifconfig` → inet address ကြည့်ပါ
   - Example: `192.168.1.100`

2. **`App.js` update လုပ်ပါ (line ~30):**
   ```javascript
   const viteUrl = 'http://192.168.1.XXX:5173'; // သင့် IP
   ```

3. **`app.json` update လုပ်ပါ:**
   ```json
   "extra": {
     "apiUrl": "http://192.168.1.XXX:8000/api"
   }
   ```

### Tunnel Mode (အလွယ်ဆုံး):
`npm run expo:start:tunnel` သုံးပါ - IP config မလိုပါ!

## ⚠️ အရေးကြီးသော Notes

- **Vue dev server** run နေရမယ် (`npm run dev`)
- **Backend** က `0.0.0.0:8000` မှာ run ရမယ် (`127.0.0.1` မဟုတ်ဘူး)
- **Phone နဲ့ computer** same WiFi မှာ ရှိရမယ် (tunnel သုံးရင် မလို)
- **Expo Go** app phone မှာ install လုပ်ထားရမယ်

## 🎯 အလုပ်လုပ်တဲ့ Features

✅ Login/Register  
✅ Sales POS  
✅ Inventory Management  
✅ Reports & Analytics  
✅ Accounting & P&L  
✅ Payment Methods  
✅ QR Code Scanning  
✅ Camera Upload  

## 📋 Testing Checklist

- [ ] Dependencies installed (`npm install`)
- [ ] Vue dev server running (`npm run dev`)
- [ ] Expo started (`npm run expo:start:tunnel`)
- [ ] Backend running (`python manage.py runserver 0.0.0.0:8000`)
- [ ] Expo Go app installed on phone
- [ ] QR code scanned
- [ ] App loads in Expo Go
- [ ] Backend connection works
- [ ] All features work

## 🔧 Troubleshooting

### "Cannot connect to server"
- Vue dev server run နေလား check လုပ်ပါ
- `App.js` မှာ IP address မှန်လား check လုပ်ပါ
- Tunnel mode သုံးကြည့်ပါ: `npm run expo:start:tunnel`

### "API calls fail"
- Backend `0.0.0.0:8000` မှာ run နေလား check လုပ်ပါ
- `app.json` → `extra.apiUrl` မှန်လား check လုပ်ပါ
- CORS settings check လုပ်ပါ

### "QR code doesn't scan"
- Tunnel mode သုံးကြည့်ပါ
- Expo Go app မှာ manually URL enter လုပ်ကြည့်ပါ

## 📖 Full Documentation

အသေးစိတ် guide အတွက် `docs/EXPO_GO_SETUP.md` ကြည့်ပါ။
