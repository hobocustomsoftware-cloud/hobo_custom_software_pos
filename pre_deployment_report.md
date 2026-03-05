# Pre-Deployment Report – Business Cycle Test

**Date:** _Fill after run_  
**Environment:** Docker (localhost) → Cloud VPS

---

## 1. Navigation & Static Assets

| Check | Status | Notes |
|-------|--------|--------|
| App loads at `http://localhost/app/` | | No 404 on `/app/assets/*` |
| Vite build base | `VITE_BASE=/app/` | Set in Docker build args and `env.docker.example` |
| Nginx | `location /app/assets/` serves files; `location /app/` SPA fallback | index.html no-cache |

---

## 2. Phone Login / Register

| Check | Status | Notes |
|-------|--------|--------|
| Register: Phone Number primary (required) | | Black-on-white, high contrast |
| Login: Phone or Email field | | Placeholder: 09xxxxxxxx or email |
| Backend `core/auth/login/` | Accepts `login` (phone or email) + password | |

---

## 3. Loyverse Workflow Validation

| Step | Description | Result |
|------|--------------|--------|
| A | Owner: Register via Phone, Setup Wizard (Pharmacy / MMK) | |
| B | Inventory: Item List; add product (Base Unit: Strip, Purchase: Box, Factor 10) | |
| C | Inbound: Purchase Order 5 Boxes → Stock +50 Strips | |
| D | POS: Login as Cashier, sell 2 Strips → Stock 48 | |
| E | Reports: Sales Summary – Net Sale & Tax correct | |

_Automated E2E (Steps A, B layout, C/D/E page load) appends below._

---

## 4. Error & Stability Audit

### API errors during cycle (401, 403, 500)

_Run Business Cycle E2E; errors are collected and listed in the "Business Cycle E2E (automated)" section below._

### Docker stats (RAM/CPU)

Run and paste output here:

```bash
docker stats --no-stream
```

| Service   | CPU % | MEM Usage / Limit |
|-----------|-------|--------------------|
| backend   |       |                    |
| frontend  |       |                    |
| postgres  |       |                    |
| redis     |       |                    |

---

## 5. Cloud Ready Check

| Item | Status |
|------|--------|
| No asset 404s | |
| No 401/403/500 in cycle | |
| Phone Register/Login working | |
| `docker-compose.prod.yml` | Ready (see `compose/docker-compose.prod.yml`) |
| Env for VPS | See `compose/.env.prod.example` |

---

## Business Cycle E2E (automated)

_E2E run appends here. Run:_

```bash
cd yp_posf && PLAYWRIGHT_BASE_URL=http://localhost/app npx playwright test e2e/business_cycle.spec.js --project=chromium
```

_For headed browser:_

```bash
PLAYWRIGHT_BASE_URL=http://localhost/app npx playwright test e2e/business_cycle.spec.js --project=chromium --headed
```
