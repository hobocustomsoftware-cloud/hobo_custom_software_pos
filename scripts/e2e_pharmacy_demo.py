#!/usr/bin/env python3
"""
E2E Pharmacy Demo: DB setup, start server, browser login, create product, purchase, transfer, sell.
Keeps browser visible. Self-fix: retries on connection refused; uses API for mutations.
Requires: pip install playwright requests && playwright install chromium
Run from repo root (parent of WeldingProject): python scripts/e2e_pharmacy_demo.py
"""
import os
import sys
import time
import subprocess
import urllib.request
import urllib.error

# Project root: script lives in scripts/ so parent of script dir is repo root; WeldingProject may be repo or subdir
_script_dir = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.dirname(_script_dir)
# Prefer WeldingProject as subdir of repo; else current dir if it has manage.py
if os.path.isfile(os.path.join(REPO_ROOT, "WeldingProject", "manage.py")):
    PROJECT_ROOT = os.path.join(REPO_ROOT, "WeldingProject")
else:
    PROJECT_ROOT = REPO_ROOT
sys.path.insert(0, REPO_ROOT)
os.chdir(PROJECT_ROOT)

BASE_URL = os.environ.get("E2E_BASE_URL", "http://127.0.0.1:8000")
HEALTH_URL = f"{BASE_URL}/health/"
LOGIN_PAGE = f"{BASE_URL}/app/login"
API_LOGIN = f"{BASE_URL}/api/core/auth/login/"
API_PRODUCTS = f"{BASE_URL}/api/products-admin/"
API_UNITS = f"{BASE_URL}/api/units/"
API_PURCHASES_CREATE = f"{BASE_URL}/api/purchases/create/"
API_MOVEMENTS_TRANSFER = f"{BASE_URL}/api/movements/transfer/"
API_SALES_REQUEST = f"{BASE_URL}/api/sales/request/"
API_LOCATIONS = f"{BASE_URL}/api/locations/"
API_CATEGORIES = f"{BASE_URL}/api/categories/"
API_ADMIN_APPROVE = f"{BASE_URL}/api/admin/approve/"

MAX_WAIT_SERVER = 60
POLL_INTERVAL = 1.0
CONNECTION_RETRIES = 3


def run_management_command(*args):
    cmd = [sys.executable, "manage.py"] + list(args)
    return subprocess.run(cmd, cwd=PROJECT_ROOT, capture_output=True, text=True, timeout=120)


def wait_for_server():
    for _ in range(int(MAX_WAIT_SERVER / POLL_INTERVAL)):
        try:
            req = urllib.request.Request(HEALTH_URL)
            with urllib.request.urlopen(req, timeout=5) as r:
                if r.status == 200:
                    return True
        except (urllib.error.URLError, OSError, Exception):
            pass
        time.sleep(POLL_INTERVAL)
    return False


def api_login(session):
    for attempt in range(CONNECTION_RETRIES):
        try:
            r = session.post(API_LOGIN, json={"login": "admin@example.com", "password": "admin123"}, timeout=10)
            r.raise_for_status()
            data = r.json()
            return data.get("access") or data.get("token")
        except Exception as e:
            if attempt < CONNECTION_RETRIES - 1:
                time.sleep(2)
                continue
            raise e


def run_api_steps(session, page, base_url):
    """Create product, purchase, transfer, sale via API."""
    ru = session.get(API_UNITS, timeout=10)
    ru.raise_for_status()
    units_list = ru.json() if isinstance(ru.json(), list) else ru.json().get("results", [ru.json()])
    units = {u["code"]: u["id"] for u in units_list}
    strip_id = units.get("STRIP")
    box_id = units.get("BOX")
    if not strip_id or not box_id:
        if len(units_list) >= 2:
            strip_id, box_id = units_list[0]["id"], units_list[1]["id"]
        else:
            raise ValueError("Need STRIP and BOX units. Run e2e_pharmacy_setup.")

    cat_resp = session.get(API_CATEGORIES, timeout=10)
    cats = cat_resp.json() if cat_resp.ok else []
    if isinstance(cats, dict) and "results" in cats:
        cats = cats["results"]
    category_id = cats[0]["id"] if cats else None

    product_payload = {
        "name": "Amoxicillin",
        "sku": "AMOX-E2E",
        "category": category_id,
        "retail_price": "120",
        "cost_price": "0",
        "base_unit": strip_id,
        "purchase_unit": box_id,
        "purchase_unit_factor": "10",
        "unit_type": "PCS",
    }
    rp = session.post(API_PRODUCTS, json=product_payload, timeout=10)
    rp.raise_for_status()
    product = rp.json()
    product_id = product["id"]

    locs_resp = session.get(API_LOCATIONS, timeout=10)
    locs_resp.raise_for_status()
    locs = locs_resp.json() if isinstance(locs_resp.json(), list) else locs_resp.json().get("results", [])
    main_wh = next((l for l in locs if "Main" in (l.get("name") or "") and "Warehouse" in (l.get("name") or "")), locs[0] if locs else None)
    if not main_wh:
        raise ValueError("No Main Warehouse location found.")
    to_location_id = main_wh["id"]
    outlet_id = main_wh.get("outlet") if isinstance(main_wh.get("outlet"), int) else main_wh.get("outlet_id")

    purchase_payload = {
        "to_location": to_location_id,
        "reference": "E2E-001",
        "lines": [{"product": product_id, "purchase_unit": box_id, "quantity": 5, "unit_cost": 5000, "to_location": to_location_id}],
    }
    if outlet_id is not None:
        purchase_payload["outlet"] = outlet_id
    rpu = session.post(API_PURCHASES_CREATE, json=purchase_payload, timeout=10)
    rpu.raise_for_status()

    branch_a_sf = next((l for l in locs if "Branch A" in (l.get("name") or "") and "Shopfloor" in (l.get("name") or "")), None)
    if not branch_a_sf:
        branch_a_sf = next((l for l in locs if "Branch A" in (l.get("name") or "")), locs[1] if len(locs) > 1 else None)
    if branch_a_sf:
        rtr = session.post(API_MOVEMENTS_TRANSFER, json={
            "product": product_id,
            "from_location": to_location_id,
            "to_location": branch_a_sf["id"],
            "quantity": 20,
        }, timeout=10)
        rtr.raise_for_status()

    sale_location_id = branch_a_sf["id"] if branch_a_sf else to_location_id
    sale_payload = {
        "sale_location": sale_location_id,
        "sale_items": [{"product": product_id, "quantity": 5, "unit_price": 120}],
    }
    rs = session.post(API_SALES_REQUEST, json=sale_payload, timeout=10)
    rs.raise_for_status()
    sale = rs.json()
    sale_id = sale.get("id")
    if sale_id:
        session.patch(f"{API_ADMIN_APPROVE}{sale_id}/", json={"status": "approved"}, timeout=10).raise_for_status()

    if page:
        try:
            page.goto(f"{base_url}/app/inventory", wait_until="domcontentloaded", timeout=10000)
        except Exception:
            pass
    return product_id


def main():
    print("\n=== E2E Pharmacy Demo (2 outlets) ===\n")

    print("Step 1: Database setup (flush, migrate, seed Box/Strip, admin, 2 outlets)...")
    result = run_management_command("e2e_pharmacy_setup")
    if result.returncode != 0:
        print("Setup failed:", result.stderr or result.stdout)
        sys.exit(1)
    print("  Setup OK.\n")

    print("Step 2: Starting Django server...")
    server_proc = subprocess.Popen(
        [sys.executable, "manage.py", "runserver", "127.0.0.1:8000"],
        cwd=PROJECT_ROOT,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.PIPE,
        text=True,
    )
    try:
        if not wait_for_server():
            print("  Server did not become ready. Check port 8000.")
            server_proc.terminate()
            sys.exit(1)
        print("  Server running.\n")
    except Exception as e:
        server_proc.terminate()
        print("  Error:", e)
        sys.exit(1)

    try:
        import requests
    except ImportError:
        print("  pip install requests")
        server_proc.terminate()
        sys.exit(1)

    session = requests.Session()
    session.headers.setdefault("Content-Type", "application/json")
    try:
        token = api_login(session)
        session.headers["Authorization"] = f"Bearer {token}"
    except Exception as e:
        print("  Login failed (Connection refused? Retry):", e)
        server_proc.terminate()
        sys.exit(1)

    use_browser = False
    try:
        from playwright.sync_api import sync_playwright
        use_browser = True
    except ImportError:
        print("  Playwright not installed. Run: pip install playwright && playwright install chromium")
        print("  Continuing with API-only steps...\n")

    if use_browser:
        with sync_playwright() as p:
            browser = p.chromium.launch(headless=False)
            context = browser.new_context()
            page = context.new_page()
            page.set_default_timeout(15000)
            print("Step 3: Opening browser to login page...")
            try:
                page.goto(LOGIN_PAGE, wait_until="domcontentloaded", timeout=15000)
                login_sel = page.locator('input[name="login"], input[placeholder*="mail"], input[placeholder*="Login"], input[type="text"]').first
                pw_sel = page.locator('input[name="password"], input[type="password"]').first
                btn = page.locator('button[type="submit"], button:has-text("Login"), button:has-text("Sign in")').first
                if login_sel.count() and pw_sel.count():
                    login_sel.fill("admin@example.com")
                    pw_sel.fill("admin123")
                    btn.click()
                    page.wait_for_load_state("networkidle", timeout=10000)
                page.goto(f"{BASE_URL}/app/", wait_until="domcontentloaded", timeout=10000)
                print("  Browser opened and login attempted.\n")
            except Exception as e:
                print("  Browser login (optional) error:", e)

            print("Step 4: Creating product 'Amoxicillin' (Base: Strip, Purchase: Box, Factor: 10)...")
            try:
                run_api_steps(session, page, BASE_URL)
                print("  Product created.")
                print("  Purchase 5 Boxes created.")
                print("  Transfer 2 Boxes to Branch A done.")
                print("  Sale 5 Strips from Branch A created and approved.")
            except Exception as e:
                print("  API steps failed:", e)
                import traceback
                traceback.print_exc()
                server_proc.terminate()
                sys.exit(1)

            print("\n  Browser left on inventory page. Close the window or press Enter to exit...")
            try:
                input("  Press Enter to close browser and exit...")
            except (EOFError, KeyboardInterrupt):
                pass
            context.close()
            browser.close()
    else:
        print("Step 4: Creating product, purchase, transfer, sale via API...")
        try:
            run_api_steps(session, None, BASE_URL)
            print("  Product created.")
            print("  Purchase 5 Boxes created.")
            print("  Transfer 2 Boxes to Branch A done.")
            print("  Sale 5 Strips from Branch A created and approved.")
        except Exception as e:
            print("  API steps failed:", e)
            import traceback
            traceback.print_exc()
            server_proc.terminate()
            sys.exit(1)

    server_proc.terminate()
    server_proc.wait(timeout=5)
    print("\nDone.")
    return 0


if __name__ == "__main__":
    sys.exit(main() or 0)
