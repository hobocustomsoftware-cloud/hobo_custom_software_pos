# Frontend Design Sync Guide - Design တူညီစေရန်

**ရက်စွဲ**: 2026-02-19

---

## 📋 ပြဿနာ

- `http://localhost/` (Nginx frontend - port 80) → ✅ Updated design
- `http://localhost:8000/app/` (Django serve - port 8000) → ❌ Old design

**အကြောင်းရင်း**: Django `vue_spa_view` က `static_frontend` directory ကို serve လုပ်နေတယ်၊ ဒါပေမယ့် old build files ရှိနေတယ်။

---

## ✅ ဖြေရှင်းနည်း

### **Method 1: Docker Compose (Automatic)**

Docker Compose က frontend build files ကို automatically sync လုပ်ပေးပါတယ်:

1. **Frontend build**:
   ```bash
   cd yp_posf
   npm run build
   ```

2. **Docker Compose restart**:
   ```bash
   docker-compose restart backend
   ```

   Backend container က startup မှာ frontend build files ကို `static_frontend` directory သို့ automatically copy လုပ်ပေးမည်။

### **Method 2: Manual Sync (Local Development)**

Local development အတွက် script သုံးနိုင်သည်:

**Windows (PowerShell)**:
```powershell
.\scripts\sync_frontend_to_django.ps1
```

**Linux/Mac (Bash)**:
```bash
chmod +x scripts/sync_frontend_to_django.sh
./scripts/sync_frontend_to_django.sh
```

---

## 🔧 Docker Compose Configuration

`docker-compose.yml` မှာ:

1. **Frontend service**:
   ```yaml
   frontend:
     volumes:
       - ./yp_posf/dist:/frontend_dist:ro
   ```

2. **Backend service**:
   ```yaml
   backend:
     volumes:
       - ./yp_posf/dist:/frontend_dist:ro
     command: >
       sh -c "... &&
              # Sync frontend build to static_frontend
              if [ -d /frontend_dist ] && [ \"\$(ls -A /frontend_dist 2>/dev/null)\" ]; then
                rm -rf /app/static_frontend/* &&
                cp -r /frontend_dist/* /app/static_frontend/ &&
                echo '✅ Frontend build synced!'
              fi &&
              daphne ..."
   ```

---

## 🚀 Workflow

### **Development Workflow**:

1. **Frontend changes**:
   ```bash
   cd yp_posf
   npm run build
   ```

2. **Restart backend** (auto-sync):
   ```bash
   docker-compose restart backend
   ```

   သို့မဟုတ် **Manual sync**:
   ```powershell
   .\scripts\sync_frontend_to_django.ps1
   docker-compose restart backend
   ```

3. **Test both URLs**:
   - `http://localhost/` → Nginx frontend (updated design)
   - `http://localhost:8000/app/` → Django serve (should match)

---

## ✅ Verification

Design တူညီမှု စစ်ဆေးရန်:

1. **Browser DevTools** (F12) ဖွင့်ပါ
2. **Network tab** မှာ:
   - `http://localhost/` → Check CSS/JS files (version/timestamp)
   - `http://localhost:8000/app/` → Check CSS/JS files (should match)
3. **Visual comparison**: Both URLs မှာ same design ဖြစ်ရမည်

---

## 🔍 Troubleshooting

### **Problem: Design မတူဘူး**

1. **Check frontend build**:
   ```bash
   ls -la yp_posf/dist/
   ```
   Build files ရှိပါသလား?

2. **Check sync**:
   ```bash
   ls -la WeldingProject/static_frontend/
   ```
   Files က sync ဖြစ်ပါသလား?

3. **Check Docker volumes**:
   ```bash
   docker-compose exec backend ls -la /frontend_dist/
   ```
   Frontend build files က container ထဲမှာ ရှိပါသလား?

4. **Restart backend**:
   ```bash
   docker-compose restart backend
   ```
   Logs မှာ "✅ Frontend build synced!" message ရှိပါသလား?

### **Problem: F12 / Right-click မဖွင့်ရဘူး**

`App.vue` မှာ:
```vue
// F12 and right-click: လောလောဆယ် ပိတ်မထားပါ - development မှာ လိုပါတယ်
// Production မှာ ပိတ်ချင်ရင် နောက်မှ ပြန်ထည့်နိုင်ပါတယ်
```

Development mode မှာ F12 နဲ့ right-click က **ဖွင့်ထားပြီးသား** ဖြစ်ရမည် (code က comment only).

---

## 📝 Notes

1. **Django Admin**: `path('admin/', lambda r: redirect('/app/'))` - Admin ကို `/app/` သို့ redirect လုပ်ထားသည် (custom design သုံးရန်)

2. **Static Files**: Django `vue_spa_view` က `static_frontend` directory ကို serve လုပ်သည်

3. **Nginx Frontend**: Port 80 မှာ latest frontend build ကို serve လုပ်သည်

4. **Sync Process**: Backend startup မှာ frontend build files ကို automatically sync လုပ်ပေးသည်

---

## ✅ Summary

- ✅ Frontend build → `yp_posf/dist/`
- ✅ Docker sync → `WeldingProject/static_frontend/` (via volume mount)
- ✅ Django serve → `http://localhost:8000/app/` (same design as `localhost/`)
- ✅ F12 / Right-click → Development mode မှာ ဖွင့်ထားပြီး
- ✅ Django Admin → Redirect to `/app/` (custom design)

**အရေးကြီးသော အချက်**: Frontend build လုပ်ပြီးတိုင်း backend restart လုပ်ရမည် (auto-sync အတွက်)!
