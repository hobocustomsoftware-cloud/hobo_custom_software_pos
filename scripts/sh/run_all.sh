#!/bin/bash
# One-command script to run everything: Docker + Simulation + Screenshots + Slideshow
# Usage: ./run_all.sh

echo "============================================================"
echo "SOLAR POS SYSTEM - COMPLETE AUTOMATION"
echo "============================================================"
echo ""
echo "This will:"
echo "  1. Start Docker services (PostgreSQL, Redis, Backend, Frontend)"
echo "  2. Run complete simulation (Day 1-30)"
echo "  3. Capture all screenshots"
echo "  4. Build HTML slideshow"
echo ""
echo "Estimated time: 5-10 minutes"
echo ""

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python3 is not installed or not in PATH"
    exit 1
fi

# Check if run_simulation_docker.py exists
if [ ! -f "run_simulation_docker.py" ]; then
    echo "ERROR: run_simulation_docker.py not found!"
    echo "Please make sure you're in the project root directory."
    exit 1
fi

read -p "Press Enter to continue or Ctrl+C to cancel..."

# Run the Python script with --all flag
python3 run_simulation_docker.py --all

if [ $? -ne 0 ]; then
    echo ""
    echo "============================================================"
    echo "ERROR: Process failed!"
    echo "============================================================"
    exit 1
fi

echo ""
echo "============================================================"
echo "SUCCESS! All tasks completed!"
echo "============================================================"
echo ""
echo "Output files:"
echo "  - simulation_log.json"
echo "  - screenshots/ directory"
echo "  - solar_pos_demo_YYYY-MM-DD.html"
echo ""
echo "Services are running:"
echo "  - Frontend: http://localhost:80"
echo "  - Backend: http://localhost:8000"
echo ""
echo "To stop services: docker-compose stop"
echo ""
