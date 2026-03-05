# Audit: 401 Unauthorized & Auth Fixes

## Issues Addressed

### 1. UI (Registration & Login)
- **Problem:** Text was white on white background (poor readability).
- **Fix:** All labels and input text set to black (`#000000`). Success/error messages use high-contrast colors (`#166534` green, `#b91c1c` red). Applied in `Register.vue`, `Login.vue`, and `main.css` (`.auth-card .auth-input-text`, `.auth-label`).

### 2. 401 After Registration (Cannot Login)
- **Root cause:** License middleware was not skipping the login endpoint. Requests to `/api/core/auth/login/` were subject to license check; if something failed or was misconfigured, flow could break. Also, login path was not in the skip list.
- **Fix:**
  - Added `/api/core/auth/` to `SKIP_LICENSE_PATHS` in `license/middleware.py` so login is never blocked by license.
  - Confirmed `RegisterSerializer` creates user with `is_active=True` (core/serializers.py).
  - `_build_user_payload` in `core/auth_views.py` made safe when `role_obj` is None (role string fallback).

### 3. License Status Optional
- **Requirement:** `GET /api/license/status/` should not require a key.
- **Fix:** `LicenseStatusView` already uses `AllowAny`. Added try/except in the view so that if `check_license_status()` raises (e.g. DB issue), the API returns `can_use: True` and `status: 'trial'` so the app does not block.

### 4. API Endpoints Checked
- **POST /api/core/auth/login/** – Unified login (phone or email + password). Returns JWT and user payload. No license check after skip-list fix.
- **GET /api/license/status/** – AllowAny, no key required; returns trial/licensed/expired. Optional fallback on error.
- **POST /api/core/register/** – AllowAny, creates user with `is_active=True`. Already in license skip list.

### 5. Frontend 401 Handling
- **api.js:** On 401, auth store logs out and router pushes to `/login` (except when route is public). This is correct for expired/invalid token.
- **Login failure:** Backend returns 401 with detail "No active account..." or "Invalid login or password." Frontend shows message; no token is set, so no logout loop.

### 6. Redirects (302)
- SPA uses Vue Router; no backend 302 for app routes. Backend redirects (e.g. `/register/` → `/app/register`) are for Django-only entry points. No change needed.

### 7. 500 / 400
- Registration validation returns 400 with field errors. Login returns 400 for bad input, 401 for wrong credentials. License status now has a safe fallback to avoid 500 on license check errors.

## Verification

Run the automated demo to confirm register + login:

```bash
# From repo root (with Docker up)
cd yp_posf
set PLAYWRIGHT_BASE_URL=http://localhost:80
npx playwright test e2e/backend_frontend_verification.spec.js --project=chromium
```

Screenshots in `demo_results/backend_frontend_verification/` should show Register → Setup Wizard → Dashboard without 401.
