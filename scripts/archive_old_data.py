#!/usr/bin/env python3
"""
Data archiving script (Task E - A to K recommendation).
Optional: Move old SaleTransaction / InventoryMovement to archive tables or cold storage.
Run from project root: python scripts/archive_old_data.py
Or integrate with Django: django-admin runscript archive_old_data (if django-extensions installed).
"""
import os
import sys
from datetime import timedelta

# Add WeldingProject to path so we can use Django
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'WeldingProject'))
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'WeldingProject.settings')

def main():
    import django
    django.setup()
    from django.db import connection

    # Example: report only (no delete). Customize cutoff date as needed.
    from django.utils import timezone as tz
    cutoff = tz.now() - timedelta(days=365*2)
    print("Archiving recommendation: records older than 2 years")
    vendor = connection.vendor
    with connection.cursor() as c:
        if vendor == 'postgresql':
            c.execute("""
                SELECT COUNT(*) FROM inventory_saletransaction WHERE created_at < %s
            """, [cutoff])
            count = c.fetchone()[0]
            print(f"  SaleTransaction (older than 2 years): {count} rows")
        else:
            print("  (SQLite: run DB size monitoring via manage.py db_size or /api/core/sre/db-stats/)")
    print("To implement actual archiving: create archive tables and move rows in batches (optional).")

if __name__ == '__main__':
    main()
