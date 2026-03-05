# Docker + Expo Go Testing Guide

## Overview
This guide helps you test HoBo POS with Docker backend and Expo Go app on your phone.

---

## Prerequisites

1. **Docker & Docker Compose** installed
2. **Node.js** (^20.19.0 or >=22.12.0)
3. **Expo Go app** on your phone:
   - iOS: [App Store](https://apps.apple.com/app/expo-go/id982107779)
   - Android: [Google Play](https://play.google.com/store/apps/details?id=host.exp.exponent)

---

## Step 1: Start Docker Backend

### 1.1 Setup Environment
```bash
cd deploy/server
cp .env.example .env
# Edit .env and set:
# - DJANGO_SECRET_KEY (random string)
# - POSTGRES_PASSWORD (secure password)
# - DJANGO_ALLOWED_HOSTS (add your computer's IP, e.g., 192.168.1.100)
```

### 1.2 Start Docker Services
```bash
# From project root
docker-compose -f deploy/server/docker-compose.yml up -d

# Check logs
docker-compose -f deploy/server/docker-compose.yml logs -f backend
```

### 1.3 Expose Backend Port (for Mobile Access)
The backend runs on port 8000 inside Docker. To access from your phone:

**Option A: Add port mapping** (recommended for testing)
Edit `deploy/server/docker-compose.yml` and add to `backend` service:
```yaml
backend:
  # ... existing config ...
  ports:
    - "8000:8000"  # Expose backend API
```

Then restart:
```bash
docker-compose -f deploy/server/docker-compose.yml up -d
```

**Option B: Use computer's IP** (if backend is already accessible)
Make sure your firewall allows port 8000, and backend is accessible at `http://YOUR_IP:8000`

---

## Step 2: Find Your Computer's IP Address

### Windows:
```powershell
ipconfig
# Look for "IPv4 Address" under your active network adapter
# Example: 192.168.1.100
```

### Mac/Linux:
```bash
ifconfig
# Look for "inet" address (not 127.0.0.1)
# Example: 192.168.1.100
```

### Or use helper script:
```bash
cd yp_posf
node scripts/find-ip.js
```

---

## Step 3: Configure Expo App

### 3.1 Update `app.json`
Set your computer's IP address:

```json
{
  "expo": {
    "extra": {
      "apiUrl": "http://192.168.1.100:8000/api",  // Your IP:8000
      "localIp": "192.168.1.100"  // Your IP for Vue dev server
    }
  }
}
```

**Important**: Replace `192.168.1.100` with your actual IP address.

---

## Step 4: Start Vue Dev Server

### 4.1 Install Dependencies (if not done)
```bash
cd yp_posf
npm install
```

### 4.2 Start Dev Server
```bash
npm run dev
# Vue app runs on http://localhost:5173
```

**Note**: Make sure your firewall allows connections on port 5173, or use Expo tunnel (see Step 5).

---

## Step 5: Start Expo Go

### Option A: Expo Tunnel (Recommended - Works on Any Network)
```bash
cd yp_posf
npm run expo:start:tunnel
```

This creates a tunnel URL that works even if your phone is on a different network.

### Option B: Local Network (Same WiFi)
```bash
cd yp_posf
npm run expo:start
```

**Important**: Your phone and computer must be on the same WiFi network.

---

## Step 6: Connect with Expo Go App

1. **Open Expo Go app** on your phone
2. **Scan QR code** shown in terminal
   - Or tap "Enter URL manually" and paste the URL (e.g., `exp://192.168.1.100:8081`)
3. **App will load** - you should see the HoBo POS login screen

---

## Troubleshooting

### Backend API Not Accessible

**Problem**: Expo Go can't connect to backend API (`http://YOUR_IP:8000/api`)

**Solutions**:
1. **Check Docker port mapping**: Make sure `backend` service has `ports: ["8000:8000"]`
2. **Check firewall**: Allow port 8000 in Windows Firewall / macOS Firewall
3. **Check DJANGO_ALLOWED_HOSTS**: Add your IP to `.env`:
   ```
   DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1,192.168.1.100
   ```
4. **Test backend**: Open `http://YOUR_IP:8000/api/` in browser (should show Django REST API)

### Vue Dev Server Not Accessible

**Problem**: Expo Go can't load Vue app (`http://localhost:5173` or `http://YOUR_IP:5173`)

**Solutions**:
1. **Use Expo tunnel**: `npm run expo:start:tunnel` (works on any network)
2. **Check firewall**: Allow port 5173
3. **Check IP**: Make sure `app.json` has correct `localIp` or use tunnel

### CORS Errors

**Problem**: Browser/Expo shows CORS error when calling API

**Solutions**:
1. **Check backend CORS settings**: In Docker `.env`, set:
   ```
   CORS_ALLOW_ALL=True  # For testing only
   ```
   Or add your IP to `CORS_ALLOWED_ORIGINS` in Django settings.

2. **Restart Docker**:
   ```bash
   docker-compose -f deploy/server/docker-compose.yml restart backend
   ```

### Network Connection Issues

**Problem**: Phone can't reach computer

**Solutions**:
1. **Same WiFi**: Phone and computer must be on same network
2. **Use tunnel**: `npm run expo:start:tunnel` (works across networks)
3. **Check IP**: Verify IP hasn't changed (DHCP may assign new IP)

---

## Quick Test Checklist

- [ ] Docker backend running (`docker-compose ps`)
- [ ] Backend accessible at `http://YOUR_IP:8000/api/` (test in browser)
- [ ] Vue dev server running (`npm run dev`)
- [ ] `app.json` has correct `apiUrl` and `localIp`
- [ ] Expo Go app installed on phone
- [ ] Phone and computer on same WiFi (or using tunnel)
- [ ] Expo started (`npm run expo:start` or `npm run expo:start:tunnel`)
- [ ] QR code scanned in Expo Go app
- [ ] App loads and shows login screen

---

## Production vs Development

### Development (Current Setup)
- Backend: Docker on `http://YOUR_IP:8000`
- Frontend: Vite dev server on `http://localhost:5173` (or IP)
- Expo: Loads Vue app via WebView

### Production (Future)
- Backend: Hosted at `https://your-domain.com`
- Frontend: Built and served from backend or CDN
- Expo: Loads built app from production URL

Update `app.json` `extra.apiUrl` and `App.js` production URL when deploying.

---

## Next Steps

After testing with Expo Go:
1. **Build native app**: Use Capacitor (`npm run cap:sync`, `npm run cap:ios`, `npm run cap:android`)
2. **Test on device**: Install APK/IPA on real device
3. **Deploy**: Set up production backend and update app config
