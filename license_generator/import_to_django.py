#!/usr/bin/env python3
"""
Standalone JSON မှ Django DB သို့ license ထည့်ခြင်း
Usage: cd WeldingProject && python -c "
import sys; sys.path.insert(0, '..');
exec(open('../license_generator/import_to_django.py').read())
" licenses.json

သို့မဟုတ်: cd WeldingProject && python ../license_generator/import_to_django.py ../license_generator/keys.json
"""
import json
import os
import sys
from datetime import datetime
from pathlib import Path

# Add WeldingProject to path
PROJECT_ROOT = Path(__file__).resolve().parent.parent / "WeldingProject"
sys.path.insert(0, str(PROJECT_ROOT))
os.chdir(PROJECT_ROOT)
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "WeldingProject.settings")

import django
django.setup()

from license.models import AppLicense


def import_licenses(json_path: str):
    """JSON file မှ license များ DB သို့ ထည့်ခြင်း"""
    path = Path(json_path)
    if not path.exists():
        print(f"File not found: {path}")
        return

    with open(path, encoding="utf-8") as f:
        data = json.load(f)

    if isinstance(data, dict):
        data = [data]

    for item in data:
        key = item.get("license_key")
        if not key:
            continue
        if AppLicense.objects.filter(license_key=key).exists():
            print(f"Skip (exists): {key}")
            continue
        exp = item.get("expires_at")
        if exp and isinstance(exp, str):
            try:
                exp = datetime.fromisoformat(exp.replace("Z", "+00:00"))
            except Exception:
                exp = None
        lic = AppLicense.objects.create(
            license_key=key,
            license_type=item.get("license_type", "on_premise_perpetual"),
            expires_at=exp,
            is_active=True,
        )
        print(f"Added: {key} ({lic.license_type})")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python import_to_django.py <licenses.json>")
        sys.exit(1)
    import_licenses(sys.argv[1])
