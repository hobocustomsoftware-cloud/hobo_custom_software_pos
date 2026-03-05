#!/usr/bin/env python3
"""
HoBo POS - EXE Entry Point (On-Premise)
- Django setup before any model/DRF imports
- Daphne for WebSockets (Channels)
- resource_path() for assets (logo.ico, etc.)
"""
import os
import sys

# 1. Fix stdout/stderr for console=False (PyInstaller)
class _DevNull:
    def write(self, _): pass
    def flush(self): pass
    def isatty(self): return False
if sys.stdout is None:
    sys.stdout = _DevNull()
if sys.stderr is None:
    sys.stderr = _DevNull()

# 2. DJANGO_SETTINGS_MODULE - MUST be set before django.setup()
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'WeldingProject.settings')
os.environ.setdefault('DEPLOYMENT_MODE', 'on_premise')
os.environ.setdefault('DATABASE_URL', '')
os.environ.setdefault('REDIS_URL', '')

# 3. EXE: persistent db path (next to exe)
if getattr(sys, 'frozen', False):
    BASE_DIR = sys._MEIPASS
    _exe_dir = os.path.dirname(sys.executable)
    os.environ.setdefault('HOBOPOS_DB_DIR', _exe_dir)
    _config_path = os.path.join(_exe_dir, 'HoBoPOS.ini')
    if os.path.exists(_config_path):
        try:
            import configparser
            _cfg = configparser.ConfigParser()
            _cfg.read(_config_path, encoding='utf-8')
            if _cfg.has_section('hobopos'):
                for k, v in _cfg.items('hobopos'):
                    if k.upper() == 'LICENSE_SERVER_URL' and v:
                        os.environ['LICENSE_SERVER_URL'] = v.strip()
                    elif k.upper() == 'DEBUG':
                        os.environ['DJANGO_DEBUG'] = v.strip()
        except Exception:
            pass
else:
    BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# 4. Add project to path
PROJECT_ROOT = os.path.join(BASE_DIR, 'WeldingProject')
if not os.path.exists(PROJECT_ROOT):
    PROJECT_ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), '..', '..', 'WeldingProject'))
sys.path.insert(0, PROJECT_ROOT)
# Add project root for assets
if os.path.dirname(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, os.path.dirname(PROJECT_ROOT))
os.chdir(PROJECT_ROOT)

# 5. CRITICAL: Initialize Django BEFORE any model/DRF imports
import django
django.setup()

# 6. Force PyInstaller to bundle these (lazy-loaded) - AFTER django.setup()
import rest_framework.negotiation  # noqa: F401
import rest_framework.urls
import rest_framework_simplejwt.views
import rest_framework_simplejwt.tokens
import django_filters.rest_framework
import channels.generic.websocket  # noqa: F401 - for notification consumers


def resource_path(relative_path: str) -> str:
    """Get path to asset - works for dev and PyInstaller EXE."""
    if getattr(sys, 'frozen', False):
        base = sys._MEIPASS
    else:
        base = os.path.normpath(os.path.join(os.path.dirname(__file__), '..', '..'))
    return os.path.join(base, 'assets', relative_path)


if __name__ == '__main__':
    import webbrowser
    import threading

    def open_browser():
        import time
        time.sleep(2.5)
        webbrowser.open('http://127.0.0.1:8000/app/')

    threading.Thread(target=open_browser, daemon=True).start()

    # Use Daphne for WebSockets (Channels) - primary for EXE
    try:
        import subprocess
        subprocess.run([
            sys.executable, '-m', 'daphne',
            '-b', '127.0.0.1', '-p', '8000',
            'WeldingProject.asgi:application'
        ], check=True)
    except (ImportError, FileNotFoundError):
        # Fallback to uvicorn if daphne not available
        try:
            import uvicorn
            uvicorn.run(
                'WeldingProject.asgi:application',
                host='127.0.0.1', port=8000,
                log_level='warning'
            )
        except ImportError:
            raise RuntimeError("Install daphne or uvicorn: pip install daphne uvicorn")
