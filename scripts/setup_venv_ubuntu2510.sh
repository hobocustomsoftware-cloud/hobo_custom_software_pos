#!/usr/bin/env bash
# =============================================================================
# HoBo POS - Ubuntu 25.10 compatible venv (Python 3.12+)
# Creates venv, installs backend + dev deps. Run from repo root.
#
# Usage:
#   chmod +x scripts/setup_venv_ubuntu2510.sh
#   ./scripts/setup_venv_ubuntu2510.sh
# =============================================================================

set -e
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

VENV_DIR="${VENV_DIR:-$REPO_ROOT/venv}"
BACKEND_DIR="$REPO_ROOT/WeldingProject"
REQUIREMENTS="$REPO_ROOT/WeldingProject/requirements.txt"

echo "============================================================"
echo "HoBo POS - Ubuntu 25.10 venv setup"
echo "============================================================"
echo "Repo root: $REPO_ROOT"
echo "Venv path: $VENV_DIR"
echo ""

# Prefer python3.12 for Ubuntu 25.10 (ships 3.12/3.13)
PYTHON=""
for p in python3.13 python3.12 python3; do
  if command -v "$p" &>/dev/null; then
    PYTHON="$p"
    break
  fi
done
if [ -z "$PYTHON" ]; then
  echo "Python 3 not found. Install: sudo apt install python3 python3-venv python3-pip"
  exit 1
fi
echo "[1/4] Using: $PYTHON ($($PYTHON --version 2>&1))"

# Create venv
echo "[2/4] Creating venv at $VENV_DIR ..."
"$PYTHON" -m venv "$VENV_DIR"
# shellcheck source=/dev/null
source "$VENV_DIR/bin/activate"
pip install --upgrade pip setuptools wheel -q

# Install backend requirements
echo "[3/4] Installing backend requirements (WeldingProject/requirements.txt) ..."
pip install -r "$REQUIREMENTS"

# Optional: dev/e2e helpers (no backend dependency)
if [ -f "$REPO_ROOT/scripts/requirements-e2e.txt" ]; then
  echo "[4/4] Installing optional e2e script deps (scripts/requirements-e2e.txt) ..."
  pip install -r "$REPO_ROOT/scripts/requirements-e2e.txt" 2>/dev/null || true
else
  echo "[4/4] Skipping optional e2e deps (file not found)."
fi

echo ""
echo "Done. Activate venv and run backend:"
echo "  source $VENV_DIR/bin/activate"
echo "  cd $REPO_ROOT && python WeldingProject/manage.py runserver 0.0.0.0:8000"
echo ""
echo "Frontend (separate terminal):"
echo "  cd $REPO_ROOT/yp_posf && npm install && npm run dev"
echo ""
echo "Full simulation (Register → Setup → features → screenshots):"
echo "  ./scripts/run_full_simulation_ubuntu.sh"
echo ""
