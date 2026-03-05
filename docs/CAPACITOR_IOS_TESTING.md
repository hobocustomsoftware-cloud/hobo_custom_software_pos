# Capacitor iOS Testing Guide - မြန်မာလို

## ✅ Current Status

### Capacitor Setup:
- ✅ Capacitor packages installed (`@capacitor/core`, `@capacitor/ios`, `@capacitor/android`, `@capacitor/camera`)
- ✅ `capacitor.config.ts` created
- ✅ NPM scripts ready (`cap:sync`, `cap:ios`, `cap:android`)

### iOS Testing Options:

#### Option 1: Capacitor Native App (Recommended)
- Full native app experience
- Can publish to App Store
- Requires macOS + Xcode

#### Option 2: Expo (if you have Expo app)
- Use Expo Go app
- Point to your backend URL
- Easier for testing (no Xcode needed)

## 📱 iOS Testing with Capacitor

### Prerequisites:
1. **macOS** computer (required for iOS development)
2. **Xcode** installed (from App Store)
3. **Xcode Command Line Tools**:
   ```bash
   xcode-select --install
   ```
4. **CocoaPods** (for iOS dependencies):
   ```bash
   sudo gem install cocoapods
   ```

### Step-by-Step Setup:

#### 1. Initialize Capacitor (if not done):
```bash
cd yp_posf
npx cap init
# App ID: com.hobopos.app
# App Name: HoBo POS
# Web Dir: dist
```

#### 2. Add iOS Platform:
```bash
npx cap add ios
```

#### 3. Build Vue App:
```bash
npm run build
```

#### 4. Sync to iOS:
```bash
npm run cap:sync
# Or: npx cap sync
```

#### 5. Open in Xcode:
```bash
npm run cap:ios
# Or: npx cap open ios
```

#### 6. Configure in Xcode:
1. Select project in left sidebar
2. Go to "Signing & Capabilities"
3. Select your **Team** (Apple Developer Account)
   - For simulator: Can use "Personal Team" (free)
   - For device: Need paid Apple Developer Account ($99/year)
4. Choose **Simulator** or **Connected Device**
5. Click **Run** button (▶️)

### iOS Simulator Testing (Free):
- ✅ **No Apple Developer Account needed**
- ✅ Works on macOS only
- ✅ Simulator options: iPhone 14 Pro, iPhone 15, iPad, etc.
- ✅ Backend URL: `http://localhost:8000` works

### iOS Device Testing:
- ⚠️ **Requires Apple Developer Account** ($99/year)
- Connect iPhone via USB
- Trust computer on iPhone
- Select device in Xcode
- Run

**Note**: For physical device, backend URL must be your computer's IP:
```typescript
// capacitor.config.ts
server: {
  url: 'http://192.168.1.100:8000', // Your Mac's local IP
  cleartext: true,
}
```

Find your Mac's IP:
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

## 📱 iOS Testing with Expo (Alternative)

If you already have Expo app setup:

### Option A: Expo Go App
1. Install **Expo Go** app on iPhone (from App Store)
2. Update Expo config to point to your backend:
   ```javascript
   // expo.config.js or app.json
   extra: {
     apiUrl: 'http://your-backend-url.com/api',
   }
   ```
3. Start Expo:
   ```bash
   npx expo start
   ```
4. Scan QR code with Expo Go app

### Option B: Expo Development Build
1. Create development build:
   ```bash
   eas build --profile development --platform ios
   ```
2. Install on device via TestFlight or direct install
3. Point to your backend URL

## 🔧 Backend Configuration for Mobile

### CORS Settings:
Update Django `settings.py`:
```python
CORS_ALLOWED_ORIGINS = [
    "http://localhost:3000",
    "http://localhost:5173",
    "http://localhost",
    "capacitor://localhost",  # Capacitor iOS
    "ionic://localhost",      # Capacitor Android
    "http://localhost",       # Capacitor web
]
```

### For Physical Device Testing:
1. Find your computer's IP address
2. Update `capacitor.config.ts`:
   ```typescript
   server: {
     url: 'http://192.168.1.XXX:8000', // Your IP
     cleartext: true,
   }
   ```
3. Make sure backend is accessible from network:
   ```bash
   # Django runserver
   python manage.py runserver 0.0.0.0:8000
   ```

## 📋 Quick Commands

### iOS Build & Test:
```bash
cd yp_posf

# 1. Build Vue app
npm run build

# 2. Sync to iOS
npm run cap:sync

# 3. Open Xcode
npm run cap:ios

# 4. In Xcode: Click Run (▶️)
```

### After Code Changes:
```bash
# Rebuild and sync
npm run build
npm run cap:sync
# Then run again in Xcode
```

## ⚠️ Common Issues

### Issue 1: "No such module Capacitor"
**Fix**: Run `pod install` in `ios/` folder:
```bash
cd yp_posf/ios
pod install
cd ..
npm run cap:sync
```

### Issue 2: Backend connection fails on device
**Fix**: 
- Use computer's IP instead of localhost
- Make sure backend runs on `0.0.0.0:8000`
- Check firewall settings

### Issue 3: Camera permission denied
**Fix**: 
- Check `Info.plist` in Xcode
- Add camera usage description
- Or update `capacitor.config.ts` permissions

### Issue 4: Build fails in Xcode
**Fix**:
- Clean build folder: Product → Clean Build Folder
- Update CocoaPods: `pod repo update`
- Reinstall pods: `pod install`

## ✅ Testing Checklist

### iOS Simulator:
- [ ] Capacitor initialized
- [ ] iOS platform added
- [ ] Vue app built
- [ ] Assets synced
- [ ] Xcode opens successfully
- [ ] App builds without errors
- [ ] App runs on simulator
- [ ] Backend connection works
- [ ] Login/Register works
- [ ] All features work

### iOS Device:
- [ ] Apple Developer Account active
- [ ] Device connected via USB
- [ ] Device trusted
- [ ] Backend URL set to computer IP
- [ ] Backend accessible from network
- [ ] App installs on device
- [ ] App runs on device
- [ ] All features work

## 📝 Next Steps

1. **Initialize Capacitor** (if not done):
   ```bash
   cd yp_posf
   npx cap init
   ```

2. **Add iOS Platform**:
   ```bash
   npx cap add ios
   ```

3. **Build & Sync**:
   ```bash
   npm run build
   npm run cap:sync
   ```

4. **Open & Test**:
   ```bash
   npm run cap:ios
   # Xcode opens → Click Run
   ```

## Status: ✅ READY FOR iOS BUILD

Capacitor configuration ready. Just need to:
1. Initialize Capacitor (if not done)
2. Add iOS platform
3. Build and test in Xcode
