# HoBo POS - Deployment

- **Server hosting:** `deploy/server/` – Docker, run scripts
- **Installer (EXE):** `deploy/installer/` – PyInstaller + Inno Setup

See [deploy/README.md](deploy/README.md) for details.

---

## Local Dev (root docker-compose)

```bash
docker-compose up -d --build
# Frontend: http://localhost | Backend: http://localhost/api/
```
