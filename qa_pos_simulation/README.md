# QA POS Simulation – Playwright

Folder: **qa_pos_simulation**  
Script: **final_pos_simulation.py**

## 1. Install (run these in terminal)

```bash
cd qa_pos_simulation
pip install -r requirements.txt
playwright install chromium
```

Or in one line:

```bash
pip install playwright && playwright install chromium
```

## 2. Run

- Start your POS server first (e.g. `python WeldingProject/manage.py runserver` from project root).
- From project root:

```bash
cd qa_pos_simulation
python final_pos_simulation.py
```

Or from anywhere:

```bash
python path/to/qa_pos_simulation/final_pos_simulation.py
```

## 3. Behaviour

- **Login** at `{BASE_URL}/login` using Username + Password + Submit (selectors from your HTML).
- **Loop 1–30:** Navigate to Dashboard with `?date=YYYY-MM-DD` → set date filter to Daily → wait 2.5s → full-page screenshot.
- **Memory:** Browser context is closed and reopened every 10 iterations (12GB RAM–friendly).
- **Output:** All files saved under **qa_pos_simulation/monthly_reports_png/** as `day_01_sales.png` … `day_30_sales.png`.

## 4. Selectors (from your Vue HTML)

| Element        | Selector |
|----------------|----------|
| Username      | `form.space-y-6 input[type="text"]` |
| Password      | `form.space-y-6 input[type="password"]` |
| Submit button | `form.space-y-6 button[type="submit"]` |
| Date filter   | `div.flex.justify-between.items-center.mb-2 div.relative button` (then click "Daily" if needed) |

## 5. Env (optional)

- `POS_BASE_URL` – default `http://localhost:8000/app`
- `POS_USER` / `POS_PASS` – default `owner` / `demo123`
