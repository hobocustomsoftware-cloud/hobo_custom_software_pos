#!/bin/sh
# Single-Tenancy Demo (Grocery, Hardware, Pharmacy). Run after backend is up.
# Usage: ./run_single_tenancy_demo.sh [--scenario 1|2|3] [--no-pause]
BACKEND="${COMPOSE_BACKEND:-compose-backend-1}"
docker exec -it "$BACKEND" python manage.py run_single_tenancy_demo "$@"
