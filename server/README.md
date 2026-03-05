# HoBo POS – Server (Docker)

Single **Dockerfile** and **Gunicorn** for both environments. All files live in `/server`.

---

## 1. Common base

- **Dockerfile** – One image for Standalone and Demo (Django + Gunicorn).
- **Gunicorn** – Web server for both (no Daphne in this setup).

Build from **project root** so `WeldingProject/` and `yp_posf/` are in context.

---

## 2. Standalone production (single shop)

- **File:** `server/docker-compose.yml`
- **Services:** Postgres (256MB), Redis (128MB), Backend (512MB), Nginx (64MB)
- **Networking:** One domain or IP (e.g. `https://pos.yourshop.com`). Nginx uses `default.conf` (catch‑all `server_name _`).

### Start Standalone

From **project root**:

```bash
# Copy env and set POSTGRES_PASSWORD, DJANGO_SECRET_KEY
cp server/.env.example .env
# Edit .env then:
docker compose -f server/docker-compose.yml up -d --build
```

If you see path errors (e.g. `server\server`) on Windows, use the root-level compose:

```bash
docker compose -f docker-compose.server.yml up -d --build
```

(Ensure `docker-compose.server.yml` exists in the project root with `context: .` and `dockerfile: server/Dockerfile`.)

- **App:** http://localhost (Nginx) or http://localhost:8000 (Backend)
- **Health:** http://localhost:8000/health/

---

## 3. Lightweight demo (20–30 shops, 2GB RAM)

- **File:** `server/docker-compose.demo.yml` (overrides base)
- **Logic:** Schema-based multi-tenancy: one backend, all data filtered by `outlet_id`. Subdomain → outlet via `Outlet.code` (e.g. `shop1.yourdemo.com` → code `shop1`).
- **Env:** `DEMO_MODE=True` set in the demo compose.
- **RAM (strict):** Backend 512MB, Postgres 384MB, Redis 64MB, Nginx 64MB (~1GB app, rest for OS).
- **Networking:** Wildcard subdomains `*.yourdemo.com` handled by Nginx (`demo-wildcard.conf`). Set your demo domain in that config and in `DJANGO_ALLOWED_HOSTS`.

### Start Demo

From **project root**:

```bash
cp server/.env.example .env
# Set POSTGRES_PASSWORD, DJANGO_SECRET_KEY; optional: TELEGRAM_*, GOOGLE_SHEETS_*
docker compose -f server/docker-compose.yml -f server/docker-compose.demo.yml up -d --build
```

- **App:** http://localhost or http://shop1.yourdemo.com (after DNS and Nginx config for `*.yourdemo.com`).

---

## 4. Env template

Use **`server/.env.example`**. Copy to `.env` in **project root** (or in `server/` if you run compose from there):

```bash
cp server/.env.example .env
```

Required:

- `POSTGRES_PASSWORD`
- `DJANGO_SECRET_KEY`

Optional:

- `POSTGRES_DB`, `POSTGRES_USER`
- `DJANGO_DEBUG`, `DJANGO_ALLOWED_HOSTS`
- `DEMO_MODE` (usually set by compose: Standalone = False, Demo = True)
- `TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID`
- `GOOGLE_SHEETS_JSON`, `GOOGLE_SHEETS_SPREADSHEET_ID`, `GOOGLE_SHEETS_SHEET_NAME`
- `MACHINE_ID`

---

## 5. Summary

| Environment   | Compose command                                                                 | Nginx config           | RAM (typical)      |
|---------------|----------------------------------------------------------------------------------|------------------------|--------------------|
| **Standalone**| `docker compose -f server/docker-compose.yml up -d --build`                      | `default.conf` (IP/domain) | Backend 512M, Postgres 256M |
| **Demo**      | `docker compose -f server/docker-compose.yml -f server/docker-compose.demo.yml up -d --build` | `demo-wildcard.conf` (*.yourdemo.com) | Backend 512M, Postgres 384M, ~2GB total |

Both use the same **Dockerfile** and **Gunicorn** in `/server`.
