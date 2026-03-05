"""
Senior QA Automation - POS Dashboard Simulation (Playwright).
Run: python final_pos_simulation.py
Requires: pip install playwright && playwright install chromium
"""
import os
import re
from pathlib import Path
from datetime import datetime, timedelta

from playwright.sync_api import sync_playwright, TimeoutError as PlaywrightTimeout

# ---------------------------------------------------------------------------
# SELECTOR MAPPING (from Login.vue and Dashboard.vue)
# ---------------------------------------------------------------------------
# Login form (no IDs in HTML; using exact classes and structure)
SELECTOR_USERNAME = 'form.space-y-6 input[type="text"]'
SELECTOR_PASSWORD = 'form.space-y-6 input[type="password"]'
SELECTOR_SUBMIT = 'form.space-y-6 button[type="submit"]'
# Dashboard time/date filter button (parent div.relative, single button with filter label)
SELECTOR_DATE_FILTER_BUTTON = "div.flex.justify-between.items-center.mb-2 div.relative button"

# ---------------------------------------------------------------------------
# CONFIG
# ---------------------------------------------------------------------------
BASE_URL = os.environ.get("POS_BASE_URL", "http://localhost:8000/app").rstrip("/")
LOGIN_USER = os.environ.get("POS_USER", "owner")
LOGIN_PASS = os.environ.get("POS_PASS", "demo123")
TOTAL_DAYS = 30
CONTEXT_RESTART_EVERY = 10
CHART_WAIT_MS = 2500
SCRIPT_DIR = Path(__file__).resolve().parent
OUTPUT_DIR = SCRIPT_DIR / "monthly_reports_png"


def ensure_output_dir():
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    return OUTPUT_DIR


def do_login(page):
    page.goto(f"{BASE_URL}/login", wait_until="domcontentloaded", timeout=20000)
    page.wait_for_load_state("networkidle", timeout=15000)
    page.locator(SELECTOR_USERNAME).first.fill(LOGIN_USER)
    page.locator(SELECTOR_PASSWORD).first.fill(LOGIN_PASS)
    page.locator(SELECTOR_SUBMIT).first.click()
    page.wait_for_url(re.compile(rf"^{re.escape(BASE_URL)}/?(\?|$)"), timeout=20000)
    page.wait_for_load_state("networkidle", timeout=15000)


def set_date_filter_to_daily(page):
    try:
        btn = page.locator(SELECTOR_DATE_FILTER_BUTTON).first
        btn.wait_for(state="visible", timeout=5000)
        if "Daily" not in (btn.inner_text() or ""):
            btn.click()
            page.wait_for_timeout(400)
            daily_opt = page.get_by_text("Daily", exact=True).first
            if daily_opt.is_visible():
                daily_opt.click()
                page.wait_for_timeout(400)
    except Exception:
        pass


def run_iteration(page, day_one_indexed, base_date):
    target_date = base_date + timedelta(days=day_one_indexed - 1)
    date_str = target_date.strftime("%Y-%m-%d")
    url_with_date = f"{BASE_URL}/?date={date_str}"

    page.goto(url_with_date, wait_until="domcontentloaded", timeout=20000)
    page.wait_for_load_state("networkidle", timeout=15000)
    set_date_filter_to_daily(page)
    page.wait_for_timeout(CHART_WAIT_MS)
    filename = f"day_{day_one_indexed:02d}_sales.png"
    filepath = OUTPUT_DIR / filename
    page.screenshot(path=str(filepath), full_page=True)
    print(f"  Saved: {filename}")
    return filepath


def main():
    ensure_output_dir()
    print(f"Output folder: {OUTPUT_DIR}")
    print(f"Base URL: {BASE_URL}")
    print(f"Total days: {TOTAL_DAYS}, restart context every {CONTEXT_RESTART_EVERY} iterations")
    print("-" * 50)

    today = datetime.now().date()
    base_date = today - timedelta(days=TOTAL_DAYS)

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        context = browser.new_context(viewport={"width": 1280, "height": 900})
        context.set_default_timeout(20000)
        page = None

        for day in range(1, TOTAL_DAYS + 1):
            if (day - 1) % CONTEXT_RESTART_EVERY == 0 and day > 1:
                print(f"[Day {day}] Restarting browser context (memory optimization)")
                if context:
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
                run_iteration(page, day, base_date)
            except PlaywrightTimeout as e:
                print(f"  [ERROR] Day {day} timeout: {e}. Skipping.")
            except Exception as e:
                print(f"  [ERROR] Day {day} failed: {e}. Skipping.")

        if context:
            context.close()
        browser.close()

    print("-" * 50)
    print(f"Done. Screenshots saved to: {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
