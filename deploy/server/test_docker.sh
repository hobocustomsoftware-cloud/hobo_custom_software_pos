#!/bin/bash
# Docker Test Script - Backend + Frontend
# Run: bash deploy/server/test_docker.sh

set -e

cd "$(dirname "$0")/../.."

echo "=== Docker Test: Backend + Frontend ==="
echo

# Check .env exists
if [ ! -f "deploy/server/.env" ]; then
  echo "⚠️  deploy/server/.env not found. Copying from .env.example..."
  cp deploy/server/.env.example deploy/server/.env
  echo "⚠️  Please edit deploy/server/.env and set DJANGO_SECRET_KEY and POSTGRES_PASSWORD"
  exit 1
fi

echo "1) Building Backend..."
docker-compose -f deploy/server/docker-compose.yml build backend

echo
echo "2) Building Frontend..."
docker-compose -f deploy/server/docker-compose.yml build frontend

echo
echo "3) Starting all services..."
docker-compose -f deploy/server/docker-compose.yml up -d

echo
echo "4) Waiting for services..."
sleep 10

echo
echo "5) Checking Backend health..."
curl -f http://localhost:8000/health/ || echo "⚠️  Backend health check failed"

echo
echo "6) Checking Frontend..."
curl -f http://localhost/ || echo "⚠️  Frontend check failed"

echo
echo "=== Test Complete ==="
echo "Backend: http://localhost:8000"
echo "Frontend: http://localhost"
echo
echo "Logs: docker-compose -f deploy/server/docker-compose.yml logs -f"
