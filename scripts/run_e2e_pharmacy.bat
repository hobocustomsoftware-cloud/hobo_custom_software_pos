@echo off
REM E2E Pharmacy demo: install deps, chromium, run 1_pharmacy and save screenshots
cd /d "%~dp0\.."
pip install playwright pytest-playwright requests -q
playwright install chromium
python scripts/e2e_demo_screenshots.py --shop pharmacy
echo.
echo Screenshots in demo_results\1_pharmacy\
pause
