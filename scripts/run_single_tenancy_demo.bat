@echo off
REM Single-Tenancy Demo (Grocery, Hardware, Pharmacy). Run after backend is up.
REM Usage: run_single_tenancy_demo.bat [--scenario 1|2|3] [--no-pause]
set BACKEND=compose-backend-1
docker exec -it %BACKEND% python manage.py run_single_tenancy_demo %*
