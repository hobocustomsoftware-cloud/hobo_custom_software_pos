#!/usr/bin/env python3
"""
E2E Demo & Screenshot system.
- Dependencies: playwright, pytest-playwright. Run: playwright install chromium
- Folders: demo_results/ with 1_pharmacy, 2_mobile, 3_electrical, 4_solar
- For each shop: Flush DB -> Seed units -> Create 2 outlets -> 1 Purchase & 1 Transfer -> Screenshots
- Screenshots: Login Page, Dashboard, Product List, Stock Report (networkidle + no spinners)
- Self-healing: Start Django server if not running; on error fix and retry.
Run from repo root: python scripts/e2e_demo_screenshots.py [--shop pharmacy|mobile|electrical|solar|all]
"""
import os
import sys
import time
import subprocess
import urllib.request
import urllib.error

_script_dir = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.dirname(_script_dir)
if os.path.isfile(os.path.join(REPO_ROOT, "WeldingProject", "manage.py")):
    PROJECT_ROOT = os.path.join(REPO_ROOT, "WeldingProject")
else:
    PROJECT_ROOT = REPO_ROOT
os.chdir(PROJECT_ROOT)
sys.path.insert(0, REPO_ROOT)

BASE_URL = os.environ.get("E2E_BASE_URL", "http://127.0.0.1:8000")
HEALTH_URL = f"{BASE_URL}/health/"
LOGIN_URL = f"{BASE_URL}/app/login"
# Screenshots to capture: Login Page, Dashboard, Product List, Stock Report
PAGES_AFTER_LOGIN = [
    ("Dashboard", f"{BASE_URL}/app/"),
    ("Product_List", f"{BASE_URL}/app/inventory"),
    ("Stock_Report", f"{BASE_URL}/app/reports"),
]
DEMO_ROOT = os.path.join(REPO_ROOT, "demo_results")
SHOP_FOLDERS = {
    "pharmacy": "1_pharmacy",
    "mobile": "2_mobile",
    "electrical": "3_electrical",
    "solar": "4_solar",
}
MAX_WAIT_SERVER = 90
POLL_INTERVAL = 1.0
PAGE_TIMEOUT = 35000
NETWORK_IDLE_TIMEOUT = 20000
SPINNER_WAIT = 3.0  # extra seconds after networkidle for spinners to disappear


def run_manage(*args):
    cmd = [sys.executable, "manage.py"] + list(args)
    return subprocess.run(cmd, cwd=PROJECT_ROOT, capture_output=True, text=True, timeout=180)


def wait_for_server():
    for _ in range(int(MAX_WAIT_SERVER / POLL_INTERVAL)):
        try:
            req = urllib.request.Request(HEALTH_URL)
            with urllib.request.urlopen(req, timeout=5) as r:
                if r.status == 200:
                    return True
        except Exception:
            pass
        time.sleep(POLL_INTERVAL)
    return False


def ensure_server_running(start_if_needed=True):
    """Return True if server is up. If start_if_needed, start runserver and wait."""
    if wait_for_server():
        return True
    if not start_if_needed:
        return False
    proc = subprocess.Popen(
        [sys.executable, "manage.py", "runserver", "127.0.0.1:8000"],
        cwd=PROJECT_ROOT,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.PIPE,
        text=True,
    )
    if wait_for_server():
        return True
    proc.terminate()
    proc.wait(timeout=5)
    return False


def ensure_folders():
    os.makedirs(DEMO_ROOT, exist_ok=True)
    for folder in SHOP_FOLDERS.values():
        os.makedirs(os.path.join(DEMO_ROOT, folder), exist_ok=True)
    print(f"  Folders: {DEMO_ROOT}/ with {list(SHOP_FOLDERS.values())}")


def run_shop_setup(shop):
    """Flush DB -> Seed units -> Create 2 outlets -> 1 Purchase & 1 Transfer."""
    result = run_manage("e2e_shop_setup", "--shop", shop)
    if result.returncode != 0:
        raise RuntimeError(f"Setup failed: {result.stderr or result.stdout}")
    print(f"  Setup done for {shop}.")


def wait_for_no_spinners(page, timeout_ms=8000):
    """Wait for common loading spinners to disappear (mandatory before screenshot)."""
    selectors = [
        '[data-loading="true"]',
        '.v-loading',
        '.loading',
        '.spinner',
        '[class*="loading"]',
        '[class*="spinner"]',
    ]
    for sel in selectors:
        try:
            loc = page.locator(sel).first
            if loc.count() > 0:
                loc.wait_for(state="hidden", timeout=timeout_ms)
        except Exception:
            pass
    time.sleep(SPINNER_WAIT)


def goto_and_wait(page, url, label=""):
    """Navigate with networkidle and wait for spinners to disappear."""
    page.goto(url, wait_until="networkidle", timeout=PAGE_TIMEOUT)
    wait_for_no_spinners(page)
    if label:
        print(f"    Loaded: {label}")


def capture_screenshots(shop, headless=False):
    """Capture Login Page, Dashboard, Product List, Stock Report. Mandatory: networkidle + no spinners."""
    folder = SHOP_FOLDERS.get(shop, shop)
    out_dir = os.path.join(DEMO_ROOT, folder)
    try:
        from playwright.sync_api import sync_playwright
    except ImportError:
        print("  Playwright not installed. Run: pip install playwright pytest-playwright && playwright install chromium")
        return False

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=headless)
        context = browser.new_context(viewport={"width": 1280, "height": 900})
        page = context.new_page()
        page.set_default_timeout(PAGE_TIMEOUT)

        # 1. Login Page (before login) – save ASAP so we have at least one screenshot
        login_png = os.path.join(out_dir, "Login_Page.png")
        print("  Capturing Login Page...")
        try:
            page.goto(LOGIN_URL, wait_until="domcontentloaded", timeout=20000)
            time.sleep(2)
            page.screenshot(path=login_png)
            print(f"    Saved: Login_Page.png")
        except Exception as e:
            print(f"    Login page failed: {e}")
            try:
                page.goto(LOGIN_URL, wait_until="load", timeout=15000)
                time.sleep(1)
                page.screenshot(path=login_png)
                print(f"    Saved: Login_Page.png (fallback)")
            except Exception as e2:
                print(f"    Fallback failed: {e2}")
                context.close()
                browser.close()
                return False
        # Optional: wait for network idle for a fuller load
        try:
            page.wait_for_load_state("networkidle", timeout=10000)
            time.sleep(1)
            page.screenshot(path=login_png)
        except Exception:
            pass

        # Login
        login_sel = page.locator('input[name="login"], input[placeholder*="mail"], input[placeholder*="Login"], input[type="text"]').first
        pw_sel = page.locator('input[name="password"], input[type="password"]').first
        btn = page.locator('button[type="submit"], button:has-text("Login"), button:has-text("Sign in")').first
        if login_sel.count() and pw_sel.count():
            login_sel.fill("admin@example.com")
            pw_sel.fill("admin123")
            btn.click()
            try:
                page.wait_for_load_state("networkidle", timeout=NETWORK_IDLE_TIMEOUT)
            except Exception:
                page.wait_for_load_state("domcontentloaded", timeout=10000)
            wait_for_no_spinners(page)
        else:
            print("  Login form not found; continuing.")

        # 2–4. Dashboard, Product List, Stock Report
        for name, url in PAGES_AFTER_LOGIN:
            safe_name = name.replace(" ", "_")
            path = os.path.join(out_dir, f"{safe_name}.png")
            print(f"  Capturing {name}...")
            try:
                goto_and_wait(page, url, name)
                page.screenshot(path=path)
            except Exception as e:
                try:
                    page.goto(url, wait_until="domcontentloaded", timeout=15000)
                    time.sleep(2)
                    wait_for_no_spinners(page)
                    page.screenshot(path=path)
                except Exception as e2:
                    print(f"    Failed: {e2}")

        context.close()
        browser.close()
    print(f"  Screenshots saved to {out_dir}")
    return True


def main():
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--shop", default="pharmacy", choices=["pharmacy", "mobile", "electrical", "solar", "all"])
    parser.add_argument("--no-server", action="store_true", help="Do not start server (use existing)")
    parser.add_argument("--headless", action="store_true")
    args = parser.parse_args()

    shops = ["pharmacy", "mobile", "electrical", "solar"] if args.shop == "all" else [args.shop]
    ensure_folders()

    # Self-healing: ensure Django server is running (skip start if port already serving)
    server_proc = None
    if not args.no_server:
        if wait_for_server():
            print("Server already running on port 8000.")
        else:
            print("Starting Django server...")
            server_proc = subprocess.Popen(
                [sys.executable, "manage.py", "runserver", "127.0.0.1:8000"],
                cwd=PROJECT_ROOT,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.PIPE,
                text=True,
            )
            for _ in range(2):
                if wait_for_server():
                    print("Server ready.")
                    break
                if server_proc:
                    server_proc.terminate()
                    server_proc.wait(timeout=5)
                time.sleep(3)
                server_proc = subprocess.Popen(
                    [sys.executable, "manage.py", "runserver", "127.0.0.1:8000"],
                    cwd=PROJECT_ROOT,
                    stdout=subprocess.DEVNULL,
                    stderr=subprocess.PIPE,
                    text=True,
                )
            else:
                with open(os.path.join(DEMO_ROOT, "RUN_README.txt"), "w") as f:
                    f.write("E2E demo: server did not become ready.\n")
                    f.write("Run: pip install playwright && playwright install chromium\n")
                    f.write("Then: python scripts/e2e_demo_screenshots.py --shop pharmacy\n")
                print("Server did not become ready. See demo_results/RUN_README.txt")
                return 1

    try:
        for shop in shops:
            print(f"\n--- Shop: {shop} ({SHOP_FOLDERS[shop]}) ---")
            run_shop_setup(shop)
            for attempt in range(2):
                if capture_screenshots(shop, headless=args.headless):
                    break
                print("  Retrying capture in 3s...")
                time.sleep(3)
            else:
                print(f"  Screenshot capture failed for {shop}.")
    finally:
        if server_proc:
            server_proc.terminate()
            server_proc.wait(timeout=5)
    print("\nDone. Screenshots in demo_results/")
    return 0


if __name__ == "__main__":
    sys.exit(main())
