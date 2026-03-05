#!/bin/bash
# Sync frontend build files to Django static_frontend directory
# This ensures localhost:8000/app/ uses the same design as localhost/

set -e

FRONTEND_DIST="./yp_posf/dist"
DJANGO_STATIC_FRONTEND="./WeldingProject/static_frontend"

echo "🔄 Syncing frontend build to Django static_frontend..."

# Check if frontend dist exists
if [ ! -d "$FRONTEND_DIST" ]; then
    echo "❌ Frontend dist directory not found: $FRONTEND_DIST"
    echo "   Please build frontend first: cd yp_posf && npm run build"
    exit 1
fi

# Create Django static_frontend directory if it doesn't exist
mkdir -p "$DJANGO_STATIC_FRONTEND"

# Remove old files
echo "🧹 Cleaning old files..."
rm -rf "$DJANGO_STATIC_FRONTEND"/*

# Copy new build files
echo "📦 Copying frontend build files..."
cp -r "$FRONTEND_DIST"/* "$DJANGO_STATIC_FRONTEND/"

echo "✅ Frontend build synced successfully!"
echo "   Django will serve from: $DJANGO_STATIC_FRONTEND"
echo "   Access at: http://localhost:8000/app/"
