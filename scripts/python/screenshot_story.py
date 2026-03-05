"""
Playwright script to capture screenshots of ALL Vue.js pages after simulation.
Captures every role's view, every page, and special states.

Run: python screenshot_story.py
Requires: playwright installed and browsers installed (playwright install)
"""
import asyncio
import os
import sys
import json
from datetime import datetime
from pathlib import Path

# Windows console: allow UTF-8 for emoji/symbols
if hasattr(sys.stdout, 'reconfigure'):
    try:
        sys.stdout.reconfigure(encoding='utf-8')
    except Exception:
        pass

try:
    from playwright.async_api import async_playwright
except ImportError:
    print("[X] Playwright not installed. Install with: pip install playwright")
    print("   Then run: playwright install chromium")
    exit(1)


# Configuration - Updated for Docker deployment
FRONTEND_URL = os.environ.get('FRONTEND_URL', 'http://localhost')
BACKEND_URL = os.environ.get('BACKEND_URL', 'http://localhost:8000')
# All screenshots saved under screenshots/ with subfolders per role/section
SCREENSHOT_DIR = Path(__file__).resolve().parent / 'screenshots'
DELAY_BETWEEN_PAGES = 2.0  # seconds

# Folder structure: owner, manager, sale_staff, inventory_manager, technician, public, special
SCREENSHOT_FOLDERS = [
    'owner', 'manager', 'sale_staff', 'inventory_manager', 'technician', 'public', 'special'
]


def ensure_screenshot_folders():
    """Create all screenshot folders and README."""
    SCREENSHOT_DIR.mkdir(parents=True, exist_ok=True)
    for folder in SCREENSHOT_FOLDERS:
        (SCREENSHOT_DIR / folder).mkdir(parents=True, exist_ok=True)
    # Write folder structure README
    readme = SCREENSHOT_DIR / 'README.txt'
    readme.write_text("""Solar POS - Screenshot Folders
============================

owner/           - Owner view: Dashboard, P&L, User Management, Settings, License
manager/         - Manager view: Dashboard, Sales History, Inventory, Installation, Reports
sale_staff/      - Sale Staff: POS, Product search, Bundle, Cart, Invoice
inventory_manager/ - Products list, Stock movement, Categories, Transfer, Low stock
technician/      - Installation Management, Detail, Service, Repair Calendar
public/          - Public pages: Repair Track, Warranty Check, License Activation
special/         - USD rate, Approval flow, Serial assignment, Warranty, Barcode, AI, Notifications, Mobile view

Files are named 01_, 02_, ... for ordering.
""", encoding='utf-8')


async def login(page, username, password):
    """Login to the system."""
    try:
        # Clear any existing auth state and go to login
        await page.goto(f'{FRONTEND_URL}/login', timeout=20000)
        await page.evaluate('localStorage.clear()')
        await page.goto(f'{FRONTEND_URL}/login', timeout=20000)
        await page.wait_for_load_state('domcontentloaded', timeout=15000)
        await asyncio.sleep(3)
        
        # Wait for login form to be visible (longer timeout after role switch)
        await page.wait_for_selector('input[type="text"]', timeout=15000)
        await page.wait_for_selector('input[type="password"]', timeout=15000)
        
        # Fill username and password
        username_input = await page.query_selector('input[type="text"]')
        password_input = await page.query_selector('input[type="password"]')
        submit_button = await page.query_selector('button[type="submit"]')
        
        if not username_input or not password_input:
            print(f"  [WARNING] Login form inputs not found")
            return False
        
        await username_input.fill(username)
        await password_input.fill(password)
        
        # Wait a bit before clicking submit
        await asyncio.sleep(0.5)
        
        # Monitor network requests to see API call
        api_response_received = False
        api_error = None
        
        async def handle_response(response):
            nonlocal api_response_received, api_error
            url = response.url
            if '/token/' in url or '/api/token/' in url:
                api_response_received = True
                if response.status >= 400:
                    try:
                        api_error = await response.json()
                    except:
                        api_error = {'status': response.status}
        
        page.on('response', handle_response)
        
        # Click submit button or press Enter
        if submit_button:
            await submit_button.click()
        else:
            await page.keyboard.press('Enter')
        
        # Wait for API response
        await asyncio.sleep(3)
        
        # Wait for navigation to complete (login success redirects to /)
        try:
            await page.wait_for_url(lambda url: '/login' not in url, timeout=15000)
        except:
            # If URL doesn't change, check localStorage for token
            pass
        
        # Wait for network to settle
        try:
            await page.wait_for_load_state('networkidle', timeout=10000)
        except:
            pass
        await asyncio.sleep(2)
        
        # Verify login success by checking localStorage for access_token
        token = await page.evaluate('localStorage.getItem("access_token")')
        if token:
            current_url = page.url
            if '/login' not in current_url or current_url.endswith('/'):
                print(f"  [OK] Login successful for {username}")
                return True
            # Token present but URL still login (redirect may be slow): go to home and continue
            print(f"  [OK] Login successful for {username} (navigating to home)")
            await page.goto(f'{FRONTEND_URL}/', timeout=15000)
            await asyncio.sleep(2)
            return True
        else:
            print(f"  [WARNING] Login failed - no token in localStorage")
            if api_error:
                print(f"  [DEBUG] API error: {api_error}")
            # Check for error message
            error_elem = await page.query_selector('.text-rose-600, .error, [class*="error"]')
            if error_elem:
                error_text = await error_elem.inner_text()
                print(f"  [ERROR] Login error message: {error_text}")
            return False
            
    except Exception as e:
        print(f"  [ERROR] Login error: {e}")
        import traceback
        traceback.print_exc()
        # Take a screenshot for debugging
        try:
            await page.screenshot(path=str(SCREENSHOT_DIR / 'login_error.png'), full_page=True)
        except:
            pass
        return False


def screenshot_path(*parts):
    """Build path under SCREENSHOT_DIR. e.g. screenshot_path('owner', '01_dashboard.png')"""
    return str(SCREENSHOT_DIR.joinpath(*parts))


async def take_screenshot(page, path, full_page=True):
    """Take a screenshot and save it under SCREENSHOT_DIR."""
    try:
        p = path.replace('screenshots/', '').replace('screenshots\\', '')
        full_path = SCREENSHOT_DIR / p
        full_path.parent.mkdir(parents=True, exist_ok=True)
        await page.screenshot(path=str(full_path), full_page=full_page)
        print(f"  [OK] Saved: {full_path}")
        return True
    except Exception as e:
        print(f"  [FAIL] {path}: {e}")
        return False


async def capture_owner_view(page):
    """Capture Owner's view of all pages."""
    print("\n[OWNER] OWNER VIEW")
    if not await login(page, 'owner_solar', 'demo123') and not await login(page, 'admin', 'demo123'):
        print("  [WARNING] Login failed, skipping owner view")
        return
    
    pages_to_capture = [
        ('/', 'screenshots/owner/01_dashboard.png', 'Dashboard - Revenue, Alerts, Notifications'),
        ('/accounting/pl', 'screenshots/owner/02_pl_report.png', 'P&L Report with Charts'),
        ('/users', 'screenshots/owner/03_user_management.png', 'User Management - All 11 Roles'),
        ('/settings', 'screenshots/owner/04_settings.png', 'Settings Page'),
        ('/license-activate', 'screenshots/owner/05_license_status.png', 'License Status'),
    ]
    
    for url_path, screenshot_path, description in pages_to_capture:
        try:
            await page.goto(f'{FRONTEND_URL}{url_path}', timeout=20000)
            await page.wait_for_load_state('networkidle', timeout=20000)
            await asyncio.sleep(3)
            await take_screenshot(page, screenshot_path)
        except Exception as e:
            print(f"  [ERROR] Failed to capture {url_path}: {e}")


async def capture_manager_view(page):
    """Capture Manager's view."""
    print("\n[MANAGER] MANAGER VIEW")
    if not await login(page, 'manager', 'demo123'):
        print("  [WARNING] Login failed, skipping manager view")
        return
    
    pages_to_capture = [
        ('/', 'screenshots/manager/01_dashboard.png', 'Manager Dashboard'),
        ('/sales/history', 'screenshots/manager/02_sales_history.png', 'Sales History - All Transactions'),
        ('/products', 'screenshots/manager/03_inventory_levels.png', 'Inventory Levels'),
        ('/installation/dashboard', 'screenshots/manager/04_installation_dashboard.png', 'Installation Dashboard'),
        ('/reports/sales', 'screenshots/manager/05_reports_overview.png', 'Reports Overview'),
    ]
    
    for url_path, screenshot_path, description in pages_to_capture:
        try:
            await page.goto(f'{FRONTEND_URL}{url_path}', timeout=20000)
            await page.wait_for_load_state('networkidle', timeout=20000)
            await asyncio.sleep(3)
            await take_screenshot(page, screenshot_path)
        except Exception as e:
            print(f"  [ERROR] Failed to capture {url_path}: {e}")


async def capture_sale_staff_view(page):
    """Capture Sale Staff's view."""
    print("\n[SALE] SALE STAFF VIEW")
    if not await login(page, 'sale_staff_1', 'demo123'):
        print("  [WARNING] Login failed, skipping sale staff view")
        return
    
    try:
        # POS/Sales Request page
        await page.goto(f'{FRONTEND_URL}/sales/pos', timeout=20000)
        await page.wait_for_load_state('networkidle', timeout=20000)
        await asyncio.sleep(3)
        await take_screenshot(page, 'screenshots/sale_staff/01_pos_sales_request.png')
        
        # Product search
        search_input = await page.query_selector('input[type="search"], input[placeholder*="search" i], input[placeholder*="ရှာ" i]')
        if search_input:
            await search_input.fill('Panel')
            await asyncio.sleep(2)
            await take_screenshot(page, 'screenshots/sale_staff/02_product_search.png')
        
        # Bundle selection
        bundle_button = await page.query_selector('button:has-text("Bundle"), button:has-text("3KW"), [class*="bundle"]')
        if bundle_button:
            await bundle_button.click()
            await asyncio.sleep(2)
            await take_screenshot(page, 'screenshots/sale_staff/03_bundle_selection.png')
        
        # Cart + payment (if visible)
        cart_element = await page.query_selector('[class*="cart"], [class*="Cart"]')
        if cart_element:
            await take_screenshot(page, 'screenshots/sale_staff/04_cart_payment.png')
        
        # Invoice print preview
        await page.goto(f'{FRONTEND_URL}/sales/history', timeout=20000)
        await page.wait_for_load_state('networkidle', timeout=20000)
        await asyncio.sleep(3)
        invoice_link = await page.query_selector('a:has-text("INV"), [href*="invoice"]')
        if invoice_link:
            await invoice_link.click()
            await asyncio.sleep(2)
            await take_screenshot(page, 'screenshots/sale_staff/05_invoice_preview.png')
        else:
            await take_screenshot(page, 'screenshots/sale_staff/05_invoice_preview.png')
            
    except Exception as e:
        print(f"  [ERROR] Failed to capture sale staff view: {e}")


async def capture_inventory_manager_view(page):
    """Capture Inventory Manager's view."""
    print("\n[INVENTORY] INVENTORY MANAGER VIEW")
    if not await login(page, 'inventory_manager', 'demo123'):
        print("  [WARNING] Login failed, skipping inventory manager view")
        return
    
    pages_to_capture = [
        ('/products', 'screenshots/inventory_manager/01_products_list.png', 'Products List with USD Prices'),
        ('/movements', 'screenshots/inventory_manager/02_stock_movement.png', 'Stock Movement Page'),
        ('/categories', 'screenshots/inventory_manager/03_categories.png', 'Categories'),
        ('/inventory/transfer', 'screenshots/inventory_manager/04_transfer_page.png', 'Transfer Page'),
    ]
    
    for url_path, screenshot_path, description in pages_to_capture:
        try:
            await page.goto(f'{FRONTEND_URL}{url_path}', timeout=20000)
            await page.wait_for_load_state('networkidle', timeout=20000)
            await asyncio.sleep(3)
            await take_screenshot(page, screenshot_path)
        except Exception as e:
            print(f"  [ERROR] Failed to capture {url_path}: {e}")
    
    # Low stock notifications
    try:
        await page.goto(f'{FRONTEND_URL}/products', timeout=20000)
        await page.wait_for_load_state('networkidle', timeout=20000)
        await asyncio.sleep(2)
        await take_screenshot(page, 'screenshots/inventory_manager/05_low_stock.png')
    except Exception as e:
        print(f"  [ERROR] Failed to capture low stock: {e}")


async def capture_technician_view(page):
    """Capture Technician's view."""
    print("\n[TECHNICIAN] TECHNICIAN VIEW")
    if not await login(page, 'technician_1', 'demo123'):
        print("  [WARNING] Login failed, skipping technician view")
        return
    
    pages_to_capture = [
        ('/installation', 'screenshots/technician/01_installation_management.png', 'Installation Management'),
        ('/service', 'screenshots/technician/02_service_management.png', 'Service Management'),
    ]
    
    for url_path, screenshot_path, description in pages_to_capture:
        try:
            await page.goto(f'{FRONTEND_URL}{url_path}', timeout=20000)
            await page.wait_for_load_state('networkidle', timeout=20000)
            await asyncio.sleep(3)
            await take_screenshot(page, screenshot_path)
        except Exception as e:
            print(f"  [ERROR] Failed to capture {url_path}: {e}")
    
    # Installation Detail with signature UI
    try:
        await page.goto(f'{FRONTEND_URL}/installation', timeout=20000)
        await page.wait_for_load_state('networkidle', timeout=20000)
        await asyncio.sleep(2)
        # Try to click first installation job
        install_link = await page.query_selector('a[href*="/installation/"], [href*="INST"]')
        if install_link:
            await install_link.click()
            await asyncio.sleep(3)
            await take_screenshot(page, 'screenshots/technician/03_installation_detail.png')
        else:
            await take_screenshot(page, 'screenshots/technician/03_installation_detail.png')
    except Exception as e:
        print(f"  [ERROR] Failed to capture installation detail: {e}")
    
    # Repair Calendar
    try:
        await page.goto(f'{FRONTEND_URL}/service', timeout=20000)
        await page.wait_for_load_state('networkidle', timeout=20000)
        await asyncio.sleep(2)
        calendar_tab = await page.query_selector('button:has-text("Calendar"), [class*="calendar"]')
        if calendar_tab:
            await calendar_tab.click()
            await asyncio.sleep(2)
        await take_screenshot(page, 'screenshots/technician/04_repair_calendar.png')
    except Exception as e:
        print(f"  [ERROR] Failed to capture repair calendar: {e}")


async def capture_public_pages(page):
    """Capture public pages (no login required)."""
    print("\n[PUBLIC] PUBLIC PAGES")
    
    pages_to_capture = [
        ('/repair-track', 'screenshots/public/01_repair_track.png', 'Repair Track Page'),
        ('/warranty-check', 'screenshots/public/02_warranty_check.png', 'Warranty Check Page'),
        ('/license-activate', 'screenshots/public/03_license_activation.png', 'License Activation Page'),
    ]
    
    for url_path, screenshot_path, description in pages_to_capture:
        try:
            await page.goto(f'{FRONTEND_URL}{url_path}', timeout=20000)
            await page.wait_for_load_state('networkidle', timeout=20000)
            await asyncio.sleep(3)
            await take_screenshot(page, screenshot_path)
        except Exception as e:
            print(f"  [ERROR] Failed to capture {url_path}: {e}")


async def capture_special_states(page):
    """Capture special states and transitions."""
    print("\n[SPECIAL] SPECIAL CAPTURES")
    
    if not await login(page, 'manager', 'demo123'):
        print("  [WARNING] Login failed, skipping special captures")
        return
    
    try:
        # USD Rate Change - Products page BEFORE
        await page.goto(f'{FRONTEND_URL}/products', timeout=20000)
        await page.wait_for_load_state('networkidle', timeout=20000)
        await asyncio.sleep(3)
        await take_screenshot(page, 'screenshots/special/01_usd_rate_before.png')
        
        # Approval flow - Pending sale
        await page.goto(f'{FRONTEND_URL}/sales/approve', timeout=20000)
        await page.wait_for_load_state('networkidle', timeout=20000)
        await asyncio.sleep(3)
        await take_screenshot(page, 'screenshots/special/02_approval_pending.png')
        
        # Approval flow - Approved (if visible)
        approve_button = await page.query_selector('button:has-text("Approve"), button:has-text("အတည်ပြု")')
        if approve_button:
            await approve_button.click()
            await asyncio.sleep(2)
            await take_screenshot(page, 'screenshots/special/03_approval_approved.png')
        
        # Serial number assignment in sale
        await page.goto(f'{FRONTEND_URL}/sales/history', timeout=20000)
        await page.wait_for_load_state('networkidle', timeout=20000)
        await asyncio.sleep(2)
        sale_detail = await page.query_selector('a[href*="/sales/"], [href*="INV"]')
        if sale_detail:
            await sale_detail.click()
            await asyncio.sleep(2)
            await take_screenshot(page, 'screenshots/special/04_serial_assignment.png')
        
        # Warranty auto-creation
        await page.goto(f'{FRONTEND_URL}/sales/history', timeout=20000)
        await page.wait_for_load_state('networkidle', timeout=20000)
        await asyncio.sleep(2)
        await take_screenshot(page, 'screenshots/special/05_warranty_records.png')
        
        # Barcode generator
        await page.goto(f'{FRONTEND_URL}/products', timeout=20000)
        await page.wait_for_load_state('networkidle', timeout=20000)
        await asyncio.sleep(2)
        product_row = await page.query_selector('tr, [class*="product"]')
        if product_row:
            barcode_button = await page.query_selector('button:has-text("Barcode"), [class*="barcode"]')
            if barcode_button:
                await barcode_button.click()
                await asyncio.sleep(2)
                await take_screenshot(page, 'screenshots/special/06_barcode_generator.png')
        
        # AI insights page
        await page.goto(f'{FRONTEND_URL}/', timeout=20000)
        await page.wait_for_load_state('networkidle', timeout=20000)
        await asyncio.sleep(2)
        ai_section = await page.query_selector('[class*="insight"], [class*="ai"]')
        if ai_section:
            await take_screenshot(page, 'screenshots/special/07_ai_insights.png')
        else:
            # Try AI insights endpoint view
            await page.goto(f'{FRONTEND_URL}/reports', timeout=20000)
            await page.wait_for_load_state('networkidle', timeout=20000)
            await asyncio.sleep(2)
            await take_screenshot(page, 'screenshots/special/07_ai_insights.png')
        
        # Notification bell with unread count
        notification_bell = await page.query_selector('[class*="notification"], [class*="bell"], button[aria-label*="notification" i]')
        if notification_bell:
            await notification_bell.click()
            await asyncio.sleep(1)
            await take_screenshot(page, 'screenshots/special/08_notification_bell.png')
        else:
            await take_screenshot(page, 'screenshots/special/08_notification_bell.png')
        
        # Mobile responsive view
        await page.set_viewport_size({'width': 390, 'height': 844})
        await page.goto(f'{FRONTEND_URL}/', timeout=20000)
        await page.wait_for_load_state('networkidle', timeout=20000)
        await asyncio.sleep(3)
        await take_screenshot(page, 'screenshots/special/09_mobile_view.png')
        
        # Reset viewport
        await page.set_viewport_size({'width': 1920, 'height': 1080})
        
    except Exception as e:
        print(f"  [ERROR] Failed to capture special states: {e}")


async def main():
    """Main execution function."""
    ensure_screenshot_folders()
    print("=" * 60)
    print("SCREENSHOT STORY CAPTURE")
    print("=" * 60)
    print(f"Frontend: {FRONTEND_URL}")
    print(f"Backend: {BACKEND_URL}")
    print(f"Screenshots will be saved to: {SCREENSHOT_DIR}")
    print("Folders: " + ", ".join(SCREENSHOT_FOLDERS))
    print("=" * 60)
    print("\n[WARNING] Make sure both backend and frontend servers are running!")
    print("   Backend: python WeldingProject\\manage.py runserver")
    print("   Frontend: cd yp_posf && npm run dev")
    print("\nStarting in 3 seconds...")
    await asyncio.sleep(3)
    
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=False)  # Set to True for headless
        context = await browser.new_context(
            viewport={'width': 1920, 'height': 1080},
            locale='my-MM'  # Myanmar locale
        )
        page = await context.new_page()
        
        try:
            # Capture all views
            await capture_owner_view(page)
            await capture_manager_view(page)
            await capture_sale_staff_view(page)
            await capture_inventory_manager_view(page)
            await capture_technician_view(page)
            await capture_public_pages(page)
            await capture_special_states(page)
            
            print("\n" + "=" * 60)
            print("[OK] ALL SCREENSHOTS CAPTURED!")
            print(f"Screenshots saved to: {SCREENSHOT_DIR}")
            print("=" * 60)
            
        except Exception as e:
            print(f"\n[ERROR] Error: {e}")
            import traceback
            traceback.print_exc()
        finally:
            await browser.close()


if __name__ == '__main__':
    asyncio.run(main())
