# HoBo POS - Deploy

## Structure

```
deploy/
├── server/              # Server hosting (Docker, run scripts)
├── installer/           # EXE build (PyInstaller + Inno Setup)
└── portable/            # Lightweight: Embedded Python + Waitress (2GB RAM PCs)
    ├── setup_embedded.ps1
    ├── run_waitress.py
    ├── launch.bat
    └── run_hidden.vbs   # Optional: run without console
```

---

## Server Hosting

```powershell
# From project root
cp deploy/server/.env.example deploy/server/.env
# Edit deploy/server/.env - DJANGO_SECRET_KEY, POSTGRES_PASSWORD, etc.
docker-compose -f deploy/server/docker-compose.yml up -d --build
```

---

## Installer (EXE)

```powershell
.\deploy\installer\clean_rebuild.bat
```

Or full build with Vue + Inno Setup:
```powershell
.\deploy\installer\build.ps1
```

Output: `deploy/installer/dist/setup.exe`

---

## Portable (Embedded Python + Waitress)

For low-spec PCs (2GB RAM). No Docker, no full Python install.

```powershell
.\deploy\portable\setup_embedded.ps1
cd deploy\portable\output
.\launch.bat
```

See [deploy/portable/README.md](portable/README.md).

---

## Assets

Assets are in `assets/` at project root. `make_icon.py` creates `logo.ico` for EXE and Inno Setup.
