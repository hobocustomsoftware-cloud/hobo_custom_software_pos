#!/usr/bin/env python3
"""
Playwright script: 30 days of POS dashboard screenshots.
- Login at localhost:8000/app
- For each day 1..30: run sales for that day, open dashboard with date filter, wait for charts, full-page PNG.
- Restart browser context every 10 days to limit RAM (i5 7th Gen / 12GB).
- Saves to monthly_reports_png/day_01_sales.png ... day_30_sales.png.
Run: pip install playwright && playwright install chromium
      python scripts/monthly_dashboard_screenshots.py
Server must be running: python manage.py runserver (or run_lite.bat).
"""
import os
import sys
import subprocess
import logging
from pathlib import Path
from datetime import datetime, timedelta

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")
logger = logging.getLogger(__name__)

# --- Config (override with env if needed) ---
BASE_URL = os.environ.get("POS_BASE_URL", "http://localhost:8000/app")
LOGIN_USER = os.environ.get("POS_USER", "owner")
LOGIN_PASS = os.environ.get("POS_PASS", "demo123")
DAYS = int(os.environ.get("POS_DAYS", "30"))
CONTEXT_RESTART_EVERY = 10
CHART_WAIT_SEC = 2.5
OUTPUT_DIR = Path(__file__).resolve().parent.parent / "monthly_reports_png"
PROJECT_ROOT = Path(__file__).resolve().parent.parent
MANAGE_PY = PROJECT_ROOT / "WeldingProject" / "manage.py"


def run_sales_for_date(target_date: str, count: int = 3) -> bool:
    """Create approved sales for target_date via management command. Returns True on success."""
    if not MANAGE_PY.exists():
        logger.error("manage.py not found at %s", MANAGE_PY)
        return False
    cmd = [
        sys.executable,
        str(MANAGE_PY),
        "create_sales_for_date",
        target_date,
        "--count",
        str(count),
    ]
    try:
        result = subprocess.run(
            cmd,
            cwd=str(PROJECT_ROOT),
            capture_output=True,
            text=True,
            timeout=60,
        )
        if result.returncode != 0:
            logger.warning("create_sales_for_date failed: %s", result.stderr or result.stdout)
            return False
        return True
    except Exception as e:
        logger.warning("create_sales_for_date error: %s", e)
        return False


def main():
    try:
        from playwright.sync_api import sync_playwright
    except ImportError:
        logger.error("Playwright not installed. Run: pip install playwright && playwright install chromium")
        sys.exit(1)

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    logger.info("Output folder: %s", OUTPUT_DIR)

    # Base date for "day 1" (e.g. first day of current month or 30 days ago)
    today = datetime.now().date()
    base_date = today - timedelta(days=DAYS)

    def do_login(page):
        page.goto(f"{BASE_URL.rstrip('/')}/login", wait_until="domcontentloaded", timeout=15000)
        page.wait_for_load_state("networkidle", timeout=10000)
        page.get_by_placeholder("Enter your username").fill(LOGIN_USER)
        page.get_by_placeholder("••••••••").fill(LOGIN_PASS)
        page.get_by_role("button", name="Sign In").click()
        page.wait_for_url(f"{BASE_URL.rstrip('/')}/**", timeout=15000)
        page.wait_for_load_state("networkidle", timeout=10000)

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        context = browser.new_context(viewport={"width": 1280, "height": 900})
        context.set_default_timeout(15000)

        for day_one_indexed in range(1, DAYS + 1):
            if (day_one_indexed - 1) % CONTEXT_RESTART_EVERY == 0 and day_one_indexed > 1:
                logger.info("Restarting browser context (every %s days) to reduce RAM.", CONTEXT_RESTART_EVERY)
                context.close()
                context = browser.new_context(viewport={"width": 1280, "height": 900})
                context.set_default_timeout(15000)
                page = context.new_page()
                do_login(page)
            elif day_one_indexed == 1:
                page = context.new_page()
                do_login(page)

            target_date = base_date + timedelta(days=day_one_indexed - 1)
            date_str = target_date.strftime("%Y-%m-%d")
            filename = f"day_{day_one_indexed:02d}_sales.png"
            filepath = OUTPUT_DIR / filename

            # 1) Create sales for this day
            run_sales_for_date(date_str, count=3)

            # 2) Open dashboard with date filter for that day
            url = f"{BASE_URL.rstrip('/')}/?date={date_str}"
            try:
                page.goto(url, wait_until="domcontentloaded", timeout=15000)
                page.wait_for_load_state("networkidle", timeout=10000)
            except Exception as e:
                logger.error("Day %s: page load failed: %s. Skipping.", day_one_indexed, e)
                continue

            # 3) Ensure Daily filter is selected (Vue sets it when ?date= is present)
            try:
                page.get_by_role("button", name="Daily").click()
                page.wait_for_timeout(500)
            except Exception:
                pass

            # 4) Wait for ApexCharts / animations
            page.wait_for_timeout(int(CHART_WAIT_SEC * 1000))

            # 5) Full page screenshot
            try:
                page.screenshot(path=str(filepath), full_page=True)
                logger.info("Saved %s", filename)
            except Exception as e:
                logger.error("Day %s: screenshot failed: %s", day_one_indexed, e)

        context.close()
        browser.close()

    logger.info("Done. Screenshots in %s", OUTPUT_DIR)


if __name__ == "__main__":
    main()
