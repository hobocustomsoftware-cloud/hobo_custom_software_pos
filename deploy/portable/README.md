# HoBo POS - Portable Build (Embedded Python + Waitress)

Lightweight package for low-spec PCs (2GB RAM). No Docker, no full Python install.

- **Embedded Python** – Official embeddable zip (portable)
- **Waitress** – WSGI server (lighter than Daphne)
- **Vue dist** – Served by Django staticfiles
- **launch.bat** – Start app; optional launcher .exe via VBS/WinSW

> **Note:** This build uses WSGI only (no WebSockets). For full Channels/WebSocket support use `deploy/installer` (PyInstaller) or `deploy/server` (Docker).

---

## Folder structure (after setup)

```
deploy/portable/
├── README.md
├── setup_embedded.ps1    # One-time: download embeddable, pip, install deps
├── run_waitress.py      # WSGI entry point
├── launch.bat           # Start app
├── run_hidden.vbs       # Run without console window (optional)
├── HoBoPOS.WinSW.xml    # WinSW config for single .exe launcher
└── output/              # Created by setup – portable package
    ├── python/         # Embedded Python + Lib/site-packages
    ├── app/             # WeldingProject + static_frontend
    ├── HoBoPOS.exe      # WinSW launcher (run: HoBoPOS.exe run)
    ├── HoBoPOS.xml      # WinSW config
    ├── Start_HoBoPOS.bat
    ├── launch.bat
    ├── run_waitress.py
    └── db.sqlite3       # Created on first run
```

---

## Quick start

### 1. One-time setup (from project root)

```powershell
.\deploy\portable\setup_embedded.ps1
```

This will:
- Download Python 3.11 embeddable to `deploy/portable/output/python`
- Install pip into embedded Python
- Install requirements + Waitress into `python/Lib/site-packages`
- Copy WeldingProject + Vue static into `output/app`

### 2. Run

```powershell
cd deploy\portable\output
.\launch.bat
```

Then open: http://127.0.0.1:8000/app/

### 3. Launcher .exe (setup creates it)

- **HoBoPOS.exe** – WinSW launcher (created by setup). Run: `HoBoPOS.exe run` or double-click **Start_HoBoPOS.bat**.
- **No console:** Double-click `run_hidden.vbs` (runs `launch.bat` hidden).

---

## Requirements

- Windows 10+
- Internet (first run only, for setup)
- ~500 MB disk for embedded Python + packages
