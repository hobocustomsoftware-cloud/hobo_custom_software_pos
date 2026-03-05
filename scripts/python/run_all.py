"""
One-command script to run everything: Docker + Simulation + Screenshots + Slideshow
Usage: python run_all.py
"""
import sys
import subprocess
from pathlib import Path

def main():
    print("=" * 60)
    print("SOLAR POS SYSTEM - COMPLETE AUTOMATION")
    print("=" * 60)
    print()
    print("This will:")
    print("  1. Start Docker services (PostgreSQL, Redis, Backend, Frontend)")
    print("  2. Run complete simulation (Day 1-30)")
    print("  3. Capture all screenshots")
    print("  4. Build HTML slideshow")
    print()
    print("Estimated time: 5-10 minutes")
    print()
    
    # Check if run_simulation_docker.py exists
    script_path = Path('run_simulation_docker.py')
    if not script_path.exists():
        print(f"❌ Error: {script_path} not found!")
        print("   Please make sure you're in the project root directory.")
        sys.exit(1)
    
    # Run with --all flag
    print("Starting automation...")
    print("=" * 60)
    print()
    
    result = subprocess.run(
        [sys.executable, str(script_path), '--all'],
        cwd=Path.cwd()
    )
    
    if result.returncode != 0:
        print()
        print("=" * 60)
        print("ERROR: Process failed!")
        print("=" * 60)
        sys.exit(1)
    
    print()
    print("=" * 60)
    print("SUCCESS! All tasks completed!")
    print("=" * 60)
    print()
    print("Output files:")
    print("  - simulation_log.json")
    print("  - screenshots/ directory")
    print("  - solar_pos_demo_YYYY-MM-DD.html")
    print()
    print("Services are running:")
    print("  - Frontend: http://localhost:80")
    print("  - Backend: http://localhost:8000")
    print()
    print("To stop services: docker-compose stop")
    print("=" * 60)

if __name__ == '__main__':
    main()
