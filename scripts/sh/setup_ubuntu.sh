#!/usr/bin/env bash
# =============================================================================
# HoBo POS - Ubuntu/Linux setup script (migrate from Windows to Native Ubuntu)
# 1. Install Docker and Docker Compose if not present
# 2. Run docker-compose up -d
# 3. Run database migrations and seed 30-day simulation data
# 4. Start the Frontend dev server
#
# Usage:
#   chmod +x setup_ubuntu.sh
#   ./setup_ubuntu.sh
# =============================================================================

set -e
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

echo "============================================================"
echo "HoBo POS - Ubuntu Setup (Docker + Migrations + Simulation + Frontend)"
echo "============================================================"

# -----------------------------------------------------------------------------
# 1. Install Docker and Docker Compose if not present
# -----------------------------------------------------------------------------
install_docker() {
  if command -v docker &>/dev/null && docker info &>/dev/null 2>&1; then
    echo "[1/4] Docker is already installed and running."
    return 0
  fi

  echo "[1/4] Installing Docker..."
  if command -v docker &>/dev/null; then
    echo "  Docker binary found but daemon may not be running. Start it with: sudo systemctl start docker"
    echo "  Then re-run this script."
    exit 1
  fi

  # Ubuntu/Debian
  if [ -f /etc/debian_version ]; then
    sudo apt-get update -qq
    sudo apt-get install -y -qq ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${VERSION_CODENAME:-$UBUNTU_CODENAME}") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -qq
    sudo apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker "$USER" 2>/dev/null || true
    echo "  Docker installed. You may need to log out and back in (or run 'newgrp docker') so your user can run Docker."
    echo "  If Docker daemon is not running: sudo systemctl start docker && sudo systemctl enable docker"
  else
    echo "  Unsupported distro. Please install Docker and Docker Compose manually: https://docs.docker.com/engine/install/"
    exit 1
  fi
}

install_docker

# Use Docker Compose V2 (docker compose) if available, else docker-compose
if docker compose version &>/dev/null 2>&1; then
  COMPOSE_CMD="docker compose"
elif command -v docker-compose &>/dev/null; then
  COMPOSE_CMD="docker-compose"
else
  echo "  Docker Compose not found. Install it: https://docs.docker.com/compose/install/"
  exit 1
fi

if ! docker info &>/dev/null 2>&1; then
  echo "  Docker daemon is not running. Start it with: sudo systemctl start docker"
  echo "  Then re-run: ./setup_ubuntu.sh"
  exit 1
fi

# -----------------------------------------------------------------------------
# 2. Run docker-compose up -d
# -----------------------------------------------------------------------------
echo "[2/4] Starting containers (docker-compose up -d)..."
$COMPOSE_CMD up -d --build 2>/dev/null || $COMPOSE_CMD up -d

echo "  Waiting for backend to be healthy (up to 90s)..."
BACKEND_URL="${BACKEND_URL:-http://127.0.0.1:8000}"
for i in $(seq 1 90); do
  if curl -sf "${BACKEND_URL}/health/" >/dev/null 2>&1; then
    echo "  Backend is up."
    break
  fi
  if [ "$i" -eq 90 ]; then
    echo "  WARNING: Backend did not become healthy in time. Migrations and simulation may still run when backend is ready."
  fi
  sleep 1
done

# -----------------------------------------------------------------------------
# 3. Run database migrations and seed 30-day simulation data
# -----------------------------------------------------------------------------
echo "[3/4] Running migrations and 30-day simulation data..."
$COMPOSE_CMD exec -T backend python manage.py migrate --noinput 2>/dev/null || {
  echo "  (migrate via exec failed; backend may run migrations on startup. Continuing.)"
}
$COMPOSE_CMD exec -T backend python manage.py run_simulation_data --days 30 2>/dev/null || {
  echo "  (run_simulation_data failed or skipped. You can run it later: $COMPOSE_CMD exec backend python manage.py run_simulation_data --days 30)"
}

echo "  Migrations and simulation step done."

# -----------------------------------------------------------------------------
# 4. Start the Frontend dev server
# -----------------------------------------------------------------------------
echo "[4/4] Starting Frontend dev server..."
FRONTEND_DIR="$ROOT_DIR/yp_posf"
if [ ! -d "$FRONTEND_DIR" ]; then
  echo "  Frontend directory not found: $FRONTEND_DIR"
  exit 1
fi

if [ ! -d "$FRONTEND_DIR/node_modules" ]; then
  echo "  Running npm install in $FRONTEND_DIR..."
  (cd "$FRONTEND_DIR" && npm install)
fi

echo "  Starting Vite dev server (npm run dev). Backend: ${BACKEND_URL}; Frontend: http://localhost:5173"
echo "  Press Ctrl+C to stop the dev server."
(cd "$FRONTEND_DIR" && npm run dev)
