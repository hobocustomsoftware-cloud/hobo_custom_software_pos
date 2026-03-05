"""Minimal: open login page, save one screenshot. Run with venv python."""
import os
import sys
_script_dir = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.dirname(_script_dir)
out_dir = os.path.join(REPO_ROOT, "demo_results", "1_pharmacy")
os.makedirs(out_dir, exist_ok=True)
path = os.path.join(out_dir, "Login_Page.png")
print("Using Playwright...")
from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    browser = p.chromium.launch(headless=False)
    page = browser.new_page()
    page.goto("http://127.0.0.1:8000/app/login", wait_until="domcontentloaded", timeout=15000)
    page.screenshot(path=path)
    print("Saved:", path)
    browser.close()
print("Done.")
