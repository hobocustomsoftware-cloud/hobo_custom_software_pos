# Monthly Dashboard Screenshots (Playwright)

Script: **monthly_dashboard_screenshots.py** — simulates 30 days of POS activity and captures full-page PNG screenshots of the Dashboard.

## Requirements

- Python 3.10+
- Server running at `http://localhost:8000` (e.g. `python WeldingProject/manage.py runserver` or `run_lite.bat`)
- At least one user (e.g. run `python WeldingProject/manage.py seed_demo_users` for `owner` / `demo123`)

## Install

```bash
pip install playwright
playwright install chromium
```

## Run

From project root:

```bash
python scripts/monthly_dashboard_screenshots.py
```

Optional env vars:

- `POS_BASE_URL` — default `http://localhost:8000/app`
- `POS_USER` / `POS_PASS` — login (default `owner` / `demo123`)
- `POS_DAYS` — number of days (default `30`)

## Behaviour

1. **Login** at `{BASE_URL}/login`, then continues in the app.
2. **Per day (1..30):**
   - Runs `create_sales_for_date YYYY-MM-DD --count 3` (creates approved sales for that day).
   - Opens Dashboard with `?date=YYYY-MM-DD` (daily view for that day).
   - Waits **2.5 s** for ApexCharts/animations.
   - Takes a **full-page** screenshot.
3. **Resource:** Browser context is closed and recreated **every 10 days** (re-login) to limit RAM on 12GB / i5 7th Gen.
4. **Errors:** If a page fails to load, the error is logged and the script continues with the next day.
5. **Output:** `monthly_reports_png/day_01_sales.png` … `day_30_sales.png` (headless run).

## Backend / frontend

- Dashboard API accepts optional `date=YYYY-MM-DD` with `period=daily` for a single-day view.
- Dashboard Vue reads `?date=` from the route and requests the API with that date.
