#!/usr/bin/env python3
"""
Standalone License Key Generator - Django မလိုပါ
Usage:
  python generate_license.py --type on_premise_perpetual
  python generate_license.py --type hosted_annual --years 2
  python generate_license.py --type on_premise_perpetual --output licenses.json
"""
import argparse
import json
import secrets
from datetime import datetime, timedelta, timezone
from pathlib import Path


def generate_key(license_type: str, years: int = 1) -> dict:
    """License key နဲ့ metadata ထုတ်ခြင်း"""
    key = f"WLD-{secrets.token_hex(8).upper()}-{secrets.token_hex(4).upper()}"
    expires_at = None
    if license_type == "hosted_annual":
        expires_at = (datetime.now(timezone.utc) + timedelta(days=365 * years)).isoformat()

    return {
        "license_key": key,
        "license_type": license_type,
        "expires_at": expires_at,
        "years": years if license_type == "hosted_annual" else None,
        "created_at": datetime.now(timezone.utc).isoformat(),
    }


def main():
    parser = argparse.ArgumentParser(description="Welding POS License Key Generator")
    parser.add_argument(
        "--type",
        "-t",
        default="on_premise_perpetual",
        choices=["on_premise_perpetual", "hosted_annual"],
        help="License type",
    )
    parser.add_argument("--years", "-y", type=int, default=1, help="Years for hosted_annual")
    parser.add_argument("--count", "-n", type=int, default=1, help="Number of keys to generate")
    parser.add_argument("--output", "-o", help="Output file (JSON)")
    parser.add_argument("--sql", action="store_true", help="Output SQL INSERT for Django")
    args = parser.parse_args()

    results = []
    for _ in range(args.count):
        data = generate_key(args.type, args.years)
        results.append(data)
        print(f"Key: {data['license_key']}")
        print(f"  Type: {data['license_type']}")
        if data["expires_at"]:
            print(f"  Expires: {data['expires_at'][:10]}")

    if args.output:
        out_path = Path(args.output)
        out_path.parent.mkdir(parents=True, exist_ok=True)
        with open(out_path, "w", encoding="utf-8") as f:
            json.dump(results if args.count > 1 else results[0], f, indent=2)
        print(f"\nSaved to {out_path}")

    if args.sql:
        print("\n-- SQL (PostgreSQL - Docker/Server):")
        for r in results:
            exp = f"'{r['expires_at'].replace('Z', '+00')}'::timestamptz" if r["expires_at"] else "NULL"
            print(
                f"INSERT INTO license_app_license (license_key, license_type, machine_id, expires_at, is_active, created_at, updated_at) "
                f"VALUES ('{r['license_key']}', '{r['license_type']}', '', {exp}, true, NOW(), NOW());"
            )


if __name__ == "__main__":
    main()
