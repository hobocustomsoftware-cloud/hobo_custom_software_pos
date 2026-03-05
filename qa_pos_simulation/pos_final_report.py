"""
Production-ready Playwright script: 30-day POS report screenshots.
- Creates monthly_reports_png if missing
- Login at configurable URL (register or login page)
- 30 iterations: trigger sales simulation -> dashboard -> wait 2.5s -> screenshot
- Context restart every 10 days (headless), try/except per day, final summary
"""
import os
import re
import subprocess
import sys
import urllib.request
from pathlib import Path
from datetime import datetime, timedelta
from urllib.error import URLError

from playwright.sync_api import sync_playwright, TimeoutError as PlaywrightTimeout

# ---------------------------------------------------------------------------
# CONFIG
# ---------------------------------------------------------------------------
SCRIPT_DIR = Path(__file__).resolve().parent
OUTPUT_DIR = SCRIPT_DIR / "monthly_reports_png"
LOGIN_URL = os.environ.get("POS_LOGIN_URL", "http://localhost:8000/app/login")
DASHBOARD_URL = os.environ.get("POS_DASHBOARD_URL", "http://localhost:8000/app")
LOGIN_USER = os.environ.get("POS_USER", "owner")
LOGIN_PASS = os.environ.get("POS_PASS", "demo123")
TOTAL_DAYS = 30
CONTEXT_RESTART_EVERY = 10
CHART_WAIT_SEC = 2.5
HEADLESS = True
PROJECT_ROOT = SCRIPT_DIR.parent
MANAGE_PY = PROJECT_ROOT / "WeldingProject" / "manage.py"

# HTML selectors (Login.vue: form.space-y-6, input type text/password, button submit)
SELECTOR_USERNAME = 'form.space-y-6 input[type="text"]'
SELECTOR_PASSWORD = 'form.space-y-6 input[type="password"]'
SELECTOR_SUBMIT = 'form.space-y-6 button[type="submit"]'


def setup_output_dir():
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    return OUTPUT_DIR


def check_server_reachable():
    """Ensure the POS server is running before opening the browser."""
    base = DASHBOARD_URL.rstrip("/").replace("http://", "").replace("https://", "")
    host_port = base.split("/", 1)[0] if "/" in base else base
    if ":" not in host_port:
        host_port = host_port + ":80" if "https" in DASHBOARD_URL else host_port + ":8000"
    try:
        req = urllib.request.Request(
            LOGIN_URL,
            headers={"User-Agent": "POS-Report-Script"},
            method="GET",
        )
        urllib.request.urlopen(req, timeout=5)
        return True
    except URLError as e:
        print("ERROR: Cannot reach the POS server.")
        print(f"  URL: {LOGIN_URL}")
        print(f"  Reason: {e.reason if getattr(e, 'reason', None) else e}")
        print()
        print("Start the server first, then run this script again:")
        print("  From project root:  python WeldingProject\\manage.py runserver")
        print("  Or use:             run_lite.bat")
        return False
    except Exception as e:
        print("ERROR: Server check failed:", e)
        return False


def trigger_sales_simulation(date_str: str) -> bool:
    """Trigger sales for the given date via management command. Returns True on success."""
    if not MANAGE_PY.exists():
        return False
    try:
        subprocess.run(
            [
                sys.executable,
                str(MANAGE_PY),
                "create_sales_for_date",
                date_str,
                "--count",
                "2",
            ],
            cwd=str(PROJECT_ROOT),
            capture_output=True,
            text=True,
            timeout=45,
        )
        return True
    except Exception:
        return False


def do_login(page):
    page.goto(LOGIN_URL, wait_until="domcontentloaded", timeout=25000)
    page.wait_for_load_state("networkidle", timeout=15000)
    page.locator(SELECTOR_USERNAME).first.fill(LOGIN_USER)
    page.locator(SELECTOR_PASSWORD).first.fill(LOGIN_PASS)
    page.locator(SELECTOR_SUBMIT).first.click()
    base = re.escape(DASHBOARD_URL.rstrip("/"))
    page.wait_for_url(re.compile(rf"^{base}/?(\?|$)"), timeout=20000)
    page.wait_for_load_state("networkidle", timeout=15000)


def run_day(page, day: int, base_date: datetime) -> bool:
    """Run one day: simulation -> dashboard -> wait -> screenshot. Returns True if screenshot saved."""
    target_date = base_date + timedelta(days=day - 1)
    date_str = target_date.strftime("%Y-%m-%d")
    trigger_sales_simulation(date_str)
    page.goto(DASHBOARD_URL.rstrip("/"), wait_until="domcontentloaded", timeout=25000)
    page.wait_for_load_state("networkidle", timeout=15000)
    page.wait_for_timeout(int(CHART_WAIT_SEC * 1000))
    filename = f"day_{day:02d}_sales.png"
    filepath = OUTPUT_DIR / filename
    page.screenshot(path=str(filepath), full_page=True)
    return filepath.exists()


def main():
    if not check_server_reachable():
        sys.exit(1)
    setup_output_dir()
    captured = 0
    errors = []
    today = datetime.now().date()
    base_date = today - timedelta(days=TOTAL_DAYS)

    print(f"Output folder: {OUTPUT_DIR}")
    print(f"Login URL: {LOGIN_URL}")
    print(f"Dashboard URL: {DASHBOARD_URL}")
    print(f"Iterations: {TOTAL_DAYS} | Context restart every: {CONTEXT_RESTART_EVERY} | Headless: {HEADLESS}")
    print("-" * 56)

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=HEADLESS)
        context = browser.new_context(viewport={"width": 1280, "height": 900})
        context.set_default_timeout(20000)
        page = None

        for day in range(1, TOTAL_DAYS + 1):
            if (day - 1) % CONTEXT_RESTART_EVERY == 0 and day > 1:
                print(f"[Day {day}] Restarting browser context (memory management)")
                context.close()
                context = browser.new_context(viewport={"width": 1280, "height": 900})
                context.set_default_timeout(20000)
                page = context.new_page()
                do_login(page)
            elif day == 1:
                page = context.new_page()
                print("Logging in...")
                do_login(page)
                print("Login OK.")

            try:
                if run_day(page, day, base_date):
                    captured += 1
                    print(f"  Day {day:2d}: screenshot saved.")
            except PlaywrightTimeout as e:
                msg = f"Day {day}: timeout - {e}"
                errors.append(msg)
                print(f"  [ERROR] {msg}")
            except Exception as e:
                msg = f"Day {day}: {e}"
                errors.append(msg)
                print(f"  [ERROR] {msg}")

        context.close()
        browser.close()

    print("-" * 56)
    print("SUMMARY")
    print(f"  Screenshots captured: {captured} / {TOTAL_DAYS}")
    if errors:
        print(f"  Errors: {len(errors)}")
        for err in errors:
            print(f"    - {err}")
    print(f"  Output directory: {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
