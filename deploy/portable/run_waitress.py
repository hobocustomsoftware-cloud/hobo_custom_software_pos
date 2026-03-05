#!/usr/bin/env python3
"""
HoBo POS - Portable WSGI entry (Waitress)
Run from deploy/portable/output/ or with app/ and python/ in same parent.
Lightweight for 2GB RAM PCs.
"""
import os
import sys

# Portable layout: output/app (WeldingProject) + output/python
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
APP_DIR = os.path.join(SCRIPT_DIR, "app")
if not os.path.isdir(APP_DIR):
    APP_DIR = os.path.join(SCRIPT_DIR, "..", "..", "WeldingProject")

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "WeldingProject.settings")
os.environ.setdefault("DEPLOYMENT_MODE", "on_premise")
if "DATABASE_URL" not in os.environ:
    os.environ.setdefault("HOBOPOS_DB_DIR", SCRIPT_DIR)  # db.sqlite3, media in portable folder

sys.path.insert(0, APP_DIR)
os.chdir(APP_DIR)

import django
django.setup()

from django.core.wsgi import get_wsgi_application
from waitress import serve

application = get_wsgi_application()
HOST = os.environ.get("HOBOPOS_HOST", "127.0.0.1")
PORT = int(os.environ.get("HOBOPOS_PORT", "8000"))

if __name__ == "__main__":
    print(f"HoBo POS (Waitress) – http://{HOST}:{PORT}/app/")
    serve(application, host=HOST, port=PORT, threads=4)
