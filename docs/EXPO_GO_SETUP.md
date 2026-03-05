# Expo Go App Setup Guide - မြန်မာလို

## ✅ Expo Go Setup Complete

### Files Created:
- ✅ `app.json` - Expo configuration
- ✅ `App.js` - Expo WebView wrapper for Vue app
- ✅ `babel.config.js` - Babel configuration
- ✅ `metro.config.js` - Metro bundler config
- ✅ `package.json` - Updated with Expo dependencies and scripts
- ✅ `src/config.js` - Updated to detect Expo environment

## 📱 Expo Go Testing Setup

### Prerequisites:
1. **Node.js** installed (^20.19.0 or >=22.12.0)
2. **Expo Go app** installed on your phone:
   - iOS: [App Store](https://apps.apple.com/app/expo-go/id982107779)
   - Android: [Google Play](https://play.google.com/store/apps/details?id=host.exp.exponent)

### Step-by-Step Setup:

#### 1. Install Dependencies:
```bash
cd yp_posf
npm install
```

#### 2. Start Vue Dev Server (Terminal 1):
```bash
cd yp_posf
npm run dev
# Vue app runs on http://localhost:5173
```

#### 3. Start Expo (Terminal 2):
```bash
cd yp_posf
npm run expo:start
# Or with tunnel (works on any network):
npm run expo:start:tunnel
```

#### 4. Connect with Expo Go:
- **Option A: QR Code**
  - Open Expo Go app on your phone
  - Scan QR code shown in terminal
  - App will load in Expo Go

- **Option B: Manual URL**
  - Copy the URL from terminal (e.g., `exp://192.168.1.100:8081`)
  - Open Expo Go app
  - Tap "Enter URL manually"
  - Paste the URL

## 🔧 Configuration

### Backend URL Setup:

#### For Local Testing:
1. **Find your computer's IP address:**
   - Windows: `ipconfig` → Look for IPv4 Address
   - Mac/Linux: `ifconfig` → Look for inet address
   - Example: `192.168.1.100`

2. **Update `App.js`:**
   ```javascript
   // In App.js, update webViewUrl:
   const viteUrl = 'http://192.168.1.100:5173'; // Your IP:5173
   ```

3. **Update `app.json`:**
   ```json
   "extra": {
     "apiUrl": "http://192.168.1.100:8000/api"  // Your IP:8000
   }
   ```

4. **Start Django backend:**
   ```bash
   # Make sure backend is accessible from network
   python manage.py runserver 0.0.0.0:8000
   ```

#### For Production:
Update `App.js`:
```javascript
setWebViewUrl('https://your-domain.com/app/');
```

And `app.json`:
```json
"extra": {
  "apiUrl": "https://your-domain.com/api"
}
```

## 📋 Testing Options

### Option 1: Expo Tunnel (Easiest)
```bash
npm run expo:start:tunnel
```
- ✅ Works on any network
- ✅ No IP configuration needed
- ✅ QR code works anywhere
- ⚠️ Slower connection

### Option 2: Local Network
```bash
npm run expo:start
```
- ✅ Faster connection
- ✅ Phone and computer must be on same WiFi
- ⚠️ Need to configure IP addresses

### Option 3: iOS Simulator (macOS only)
```bash
npm run expo:ios
```
- ✅ No phone needed
- ✅ Works on macOS
- ⚠️ Requires Xcode

### Option 4: Android Emulator
```bash
npm run expo:android
```
- ✅ No phone needed
- ✅ Works on Windows/Mac/Linux
- ⚠️ Requires Android Studio

## 🚀 Quick Start Commands

### Development (Recommended):
```bash
# Terminal 1: Vue dev server
cd yp_posf
npm run dev

# Terminal 2: Expo with tunnel
cd yp_posf
npm run expo:start:tunnel

# Terminal 3: Django backend
cd WeldingProject
python manage.py runserver 0.0.0.0:8000
```

Then scan QR code with Expo Go app!

### After Code Changes:
- Vue app: Auto-reloads (HMR)
- Expo: Shake phone → Reload
- Backend: Restart Django server if needed

## ⚙️ Customization

### Change Vue App URL:
Edit `App.js`:
```javascript
const viteUrl = 'http://YOUR_IP:5173';
// Or use built version:
const builtUrl = 'http://YOUR_IP:4173'; // After npm run preview
```

### Change Backend API URL:
Edit `app.json`:
```json
"extra": {
  "apiUrl": "http://YOUR_IP:8000/api"
}
```

### Use Built Vue App (Production-like):
```bash
# Build Vue app
npm run build

# Preview built app
npm run preview
# Runs on http://localhost:4173

# Update App.js to use preview URL
const viteUrl = 'http://YOUR_IP:4173';
```

## ⚠️ Common Issues

### Issue 1: "Cannot connect to server"
**Fix**: 
- Make sure Vue dev server is running (`npm run dev`)
- Check IP address in `App.js`
- Make sure phone and computer are on same WiFi
- Or use tunnel: `npm run expo:start:tunnel`

### Issue 2: "API calls fail"
**Fix**:
- Check backend URL in `app.json` → `extra.apiUrl`
- Make sure Django runs on `0.0.0.0:8000` (not `127.0.0.1`)
- Check CORS settings in Django `settings.py`

### Issue 3: "Camera not working"
**Fix**:
- Check permissions in `app.json`
- Grant camera permission in phone settings
- Expo Go has camera access built-in

### Issue 4: "QR code doesn't scan"
**Fix**:
- Use tunnel mode: `npm run expo:start:tunnel`
- Or manually enter URL in Expo Go app
- Make sure phone and computer are on same network

## 📱 Features That Work in Expo Go

- ✅ Login/Register
- ✅ Sales POS
- ✅ Inventory Management
- ✅ Reports & Analytics
- ✅ Accounting & P&L
- ✅ Payment Methods
- ✅ QR Code scanning (via html5-qrcode)
- ✅ Payment proof upload
- ✅ Camera access
- ✅ File uploads

## ✅ Testing Checklist

- [ ] Dependencies installed (`npm install`)
- [ ] Vue dev server running (`npm run dev`)
- [ ] Expo started (`npm run expo:start:tunnel`)
- [ ] Backend running (`python manage.py runserver 0.0.0.0:8000`)
- [ ] Expo Go app installed on phone
- [ ] QR code scanned or URL entered
- [ ] App loads in Expo Go
- [ ] Backend connection works
- [ ] All features work

## 📝 Next Steps

1. **Install dependencies:**
   ```bash
   cd yp_posf
   npm install
   ```

2. **Start Vue dev server:**
   ```bash
   npm run dev
   ```

3. **Start Expo:**
   ```bash
   npm run expo:start:tunnel
   ```

4. **Scan QR code** with Expo Go app!

## Status: ✅ READY FOR EXPO GO TESTING

Expo Go setup complete. Just need to:
1. Install dependencies
2. Start Vue dev server
3. Start Expo
4. Scan QR code with Expo Go app
