#!/bin/bash
# Linux/Mac shell script to run simulation with Docker
# Usage: ./run_simulation_docker.sh [--screenshots] [--all] [--stop]

echo "============================================================"
echo "SOLAR POS SYSTEM - DOCKER SIMULATION RUNNER (Linux/Mac)"
echo "============================================================"

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python3 is not installed or not in PATH"
    exit 1
fi

# Run Python script with all arguments passed through
python3 run_simulation_docker.py "$@"

if [ $? -ne 0 ]; then
    echo ""
    echo "ERROR: Script failed"
    exit 1
fi
