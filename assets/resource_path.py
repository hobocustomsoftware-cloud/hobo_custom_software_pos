"""
Central resource path utility for HoBo POS.
Use resource_path() to find assets (logo.ico, logo.png) in both:
- Development: project root / assets/
- PyInstaller EXE: _MEIPASS / assets/ (bundled)
"""
import os
import sys


def resource_path(relative_path: str) -> str:
    """
    Get absolute path to resource, works for dev and PyInstaller.
    Usage: resource_path('logo.ico'), resource_path('logo.png')
    """
    if getattr(sys, 'frozen', False):
        base = sys._MEIPASS
    else:
        # This file is in assets/ - parent is project root
        base = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    return os.path.join(base, 'assets', relative_path)


def get_asset_path(name: str) -> str:
    """Alias for resource_path - returns path to asset in assets/ folder."""
    return resource_path(name)
