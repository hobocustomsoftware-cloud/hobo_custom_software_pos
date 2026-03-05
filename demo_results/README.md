# E2E Demo Screenshots

Screenshots from the automated E2E demo (Login Page, Dashboard, Product List, Stock Report).

## Folder structure

- `1_pharmacy/` – Pharmacy (ဆေးဆိုင်)
- `2_mobile/` – Mobile (ဖုန်းဆိုင်)
- `3_electrical/` – Electrical (လျှပ်စစ်)
- `4_solar/` – Solar (ဆိုလာ)

Each folder contains:

- `Login_Page.png`
- `Dashboard.png`
- `Product_List.png`
- `Stock_Report.png`

## Setup (one-time)

```bash
pip install -r scripts/requirements-e2e.txt
playwright install chromium
```

## Run (start with 1_pharmacy)

```bash
# From repo root
python scripts/e2e_demo_screenshots.py --shop pharmacy
```

Screenshots will appear in `demo_results/1_pharmacy/`.

To run all four shops:

```bash
python scripts/e2e_demo_screenshots.py --shop all
```

If the server is already running on port 8000:

```bash
python scripts/e2e_demo_screenshots.py --shop pharmacy --no-server
```
