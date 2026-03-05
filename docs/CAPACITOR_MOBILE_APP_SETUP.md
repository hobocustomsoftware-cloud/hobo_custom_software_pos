# Capacitor Mobile App Setup - iOS & Android

## ✅ Current Status

### Capacitor Packages Installed
- ✅ `@capacitor/core` ^8.1.0
- ✅ `@capacitor/cli` ^8.1.0
- ✅ `@capacitor/ios` ^8.1.0
- ✅ `@capacitor/android` ^8.1.0
- ✅ `@capacitor/camera` ^8.0.1

### NPM Scripts Available
- ✅ `npm run cap:sync` - Build and sync to native projects
- ✅ `npm run cap:ios` - Open iOS project in Xcode
- ✅ `npm run cap:android` - Open Android project in Android Studio

### Configuration
- ✅ `capacitor.config.ts` created

## 📱 iOS Testing Setup

### Prerequisites:
1. **macOS** with Xcode installed
2. **Xcode Command Line Tools**: `xcode-select --install`
3. **CocoaPods**: `sudo gem install cocoapods`
4. **Apple Developer Account** (for device testing) - Optional for simulator

### Steps to Build & Test iOS App:

#### 1. Initialize Capacitor (if not done):
```bash
cd yp_posf
npm run build
npx cap init
# App ID: com.hobopos.app
# App Name: HoBo POS
```

#### 2. Add iOS Platform:
```bash
npx cap add ios
```

#### 3. Sync Web Assets:
```bash
npm run build
npm run cap:sync
```

#### 4. Open in Xcode:
```bash
npm run cap:ios
```

#### 5. Configure in Xcode:
- Select your development team (Signing & Capabilities)
- Choose simulator or connected device
- Click Run (▶️)

### iOS Simulator Testing:
- **No Apple Developer Account needed**
- Works on macOS only
- Simulator: iPhone 14 Pro, iPhone 15, etc.

### iOS Device Testing:
- **Requires Apple Developer Account** ($99/year)
- Connect iPhone via USB
- Trust computer on iPhone
- Select device in Xcode
- Run

### Expo Alternative (if you have Expo app):
If you already have Expo app setup, you can:
1. Use Expo Go app on your iPhone
2. Point Expo to your backend URL
3. Or use Expo's development build

## 📱 Android Testing Setup

### Prerequisites:
1. **Android Studio** installed
2. **Java JDK** (11 or higher)
3. **Android SDK** (via Android Studio)
4. **Android device** or **Emulator**

### Steps to Build & Test Android App:

#### 1. Add Android Platform:
```bash
cd yp_posf
npm run build
npx cap add android
```

#### 2. Sync Web Assets:
```bash
npm run build
npm run cap:sync
```

#### 3. Open in Android Studio:
```bash
npm run cap:android
```

#### 4. Configure in Android Studio:
- Wait for Gradle sync
- Select device/emulator
- Click Run (▶️)

### Android Emulator Testing:
- **Free** - No account needed
- Works on Windows/Mac/Linux
- Create emulator in Android Studio

### Android Device Testing:
- **Free** - No account needed
- Enable USB Debugging on phone
- Connect via USB
- Select device in Android Studio
- Run

## 🔧 Configuration for Mobile

### Backend URL Configuration

#### Development (Local):
```typescript
// capacitor.config.ts
server: {
  url: 'http://localhost:8000',
  cleartext: true,
}
```

**Note**: iOS Simulator can use `localhost`, but physical devices need your computer's IP:
```typescript
server: {
  url: 'http://192.168.1.100:8000', // Your computer's local IP
  cleartext: true,
}
```

#### Production (Hosted):
```typescript
server: {
  url: 'https://your-domain.com',
  cleartext: false,
}
```

### API Base URL Configuration

Update `src/config.js` for mobile:
```javascript
// For mobile app (Capacitor)
const isCapacitor = window.Capacitor !== undefined;
const API_BASE = isCapacitor 
  ? 'http://your-backend-url.com/api'  // Production backend
  : import.meta.env.VITE_API_URL || 'http://localhost:8000/api';
```

## 📋 Mobile App Features

### Already Supported:
- ✅ Camera access (for QR scanning, payment proof upload)
- ✅ File system access
- ✅ Network requests (API calls)
- ✅ Local storage (IndexedDB for offline POS)

### Features That Work:
- ✅ Login/Register
- ✅ Sales POS
- ✅ Inventory Management
- ✅ Reports
- ✅ Accounting & P&L
- ✅ Payment Methods
- ✅ QR Code scanning (via html5-qrcode)
- ✅ Payment proof upload (via Camera plugin)

## 🧪 Testing Checklist

### iOS Testing:
- [ ] Capacitor initialized
- [ ] iOS platform added
- [ ] Web assets synced
- [ ] Xcode project opens
- [ ] App builds in Xcode
- [ ] App runs on simulator
- [ ] App runs on device (if have dev account)
- [ ] Backend connection works
- [ ] Camera works (QR scan, photo upload)
- [ ] All features work

### Android Testing:
- [ ] Capacitor initialized
- [ ] Android platform added
- [ ] Web assets synced
- [ ] Android Studio project opens
- [ ] App builds in Android Studio
- [ ] App runs on emulator
- [ ] App runs on device
- [ ] Backend connection works
- [ ] Camera works
- [ ] All features work

## 🚀 Quick Start Commands

### iOS:
```bash
cd yp_posf
npm run build
npm run cap:sync
npm run cap:ios
# Xcode opens → Click Run
```

### Android:
```bash
cd yp_posf
npm run build
npm run cap:sync
npm run cap:android
# Android Studio opens → Click Run
```

## ⚠️ Important Notes

1. **Backend URL**: 
   - Simulator: Can use `localhost`
   - Physical device: Need computer's IP address or hosted backend
   - Production: Use your domain URL

2. **HTTPS Required**:
   - iOS production requires HTTPS
   - Android can use HTTP for development
   - Use HTTPS for production builds

3. **CORS Configuration**:
   - Backend must allow mobile app origin
   - Update `CORS_ALLOWED_ORIGINS` in Django settings

4. **Expo Alternative**:
   - If you have Expo app, you can use Expo's development build
   - Point Expo to your backend URL
   - Or use Expo's API proxy

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

3. **Add Android Platform**:
   ```bash
   npx cap add android
   ```

4. **Build & Sync**:
   ```bash
   npm run build
   npm run cap:sync
   ```

5. **Test on iOS/Android**:
   - iOS: `npm run cap:ios` → Xcode → Run
   - Android: `npm run cap:android` → Android Studio → Run

## Status: ✅ READY FOR MOBILE BUILD

Capacitor packages installed, configuration ready. Just need to:
1. Initialize Capacitor (if not done)
2. Add iOS/Android platforms
3. Build and test
