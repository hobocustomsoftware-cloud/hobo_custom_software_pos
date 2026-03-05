# Performance Audit – 1-Month Business Simulation

This file is updated when you run the 1-Month Simulation Test and capture docker stats.

## Peak RAM/CPU (docker stats)

Run and paste output here, or use `scripts\run_1month_simulation.bat` which appends:

```
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"
```

## Report load times (seconds)

Filled by E2E when Phase 3–4 runs (Sales Summary, Sale by Item):

- Sales Summary: _N/A_ (run E2E Phase 3–4 after `simulation_1month_data`)
- Sale by Item: _N/A_

## How to run the full test

1. **Fix Backend first, then START browser (Owner Registration)**
   - From repo root: `scripts\run_1month_simulation.bat`
   - Or: `docker compose -f compose/docker-compose.yml --env-file .env up -d` then open http://localhost/register in browser.

2. **Phase 1** (E2E): Register → Setup Wizard (Pharmacy) → Create 4 roles (Manager, Inventory_Staff, Sale_Staff, Cashier).

3. **Phase 2** (Backend): Seed 500+ products, 10 inbound, 5 transfers, 1000+ sales over 30 days:
   ```bash
   docker compose -f compose/docker-compose.yml --env-file .env exec backend python manage.py simulation_1month_data
   ```

4. **Phase 3–4** (E2E): Open Sales Summary and Sale by Item, measure load time, capture `report_load_1month.png`:
   ```bash
   cd yp_posf
   set PLAYWRIGHT_BASE_URL=http://localhost:80
   set PLAYWRIGHT_LOGIN_EMAIL=<your-owner-email>
   set PLAYWRIGHT_LOGIN_PASSWORD=<your-owner-password>
   npx playwright test e2e/one_month_simulation.spec.js -g "Phase 3" --project=chromium
   ```

5. **Performance**: Run `docker stats --no-stream` and append to this file, or run `scripts\run_1month_simulation.bat` which records stats.
