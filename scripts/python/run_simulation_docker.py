"""
Docker-based simulation runner.
Starts Docker services, waits for readiness, runs simulation, and optionally captures screenshots.

Usage:
    python run_simulation_docker.py                    # Run simulation only
    python run_simulation_docker.py --screenshots      # Run simulation + screenshots
    python run_simulation_docker.py --all              # Run simulation + screenshots + slideshow
"""
import os
import sys
import time
import subprocess
import argparse
from pathlib import Path

# Fix Windows console encoding for emojis
if sys.platform == 'win32':
    try:
        sys.stdout.reconfigure(encoding='utf-8')
        sys.stderr.reconfigure(encoding='utf-8')
    except:
        pass


# Global variable to track docker compose command
DOCKER_COMPOSE_CMD = None

def get_docker_compose_cmd():
    """Detect docker compose command (v2 or v1)."""
    global DOCKER_COMPOSE_CMD
    if DOCKER_COMPOSE_CMD:
        return DOCKER_COMPOSE_CMD
    
    # Try docker compose (v2) first
    stdout, stderr, code = run_command(['docker', 'compose', 'version'], check=False)
    if code == 0:
        DOCKER_COMPOSE_CMD = ['docker', 'compose']
        return DOCKER_COMPOSE_CMD
    
    # Fall back to docker-compose (v1)
    stdout, stderr, code = run_command(['docker-compose', '--version'], check=False)
    if code == 0:
        DOCKER_COMPOSE_CMD = ['docker-compose']
        return DOCKER_COMPOSE_CMD
    
    return None

def run_command(cmd, check=True, shell=False):
    """Run a shell command and return output."""
    try:
        if shell:
            result = subprocess.run(cmd, shell=True, check=check, capture_output=True, text=True)
        else:
            result = subprocess.run(cmd, check=check, capture_output=True, text=True)
        return result.stdout.strip(), result.stderr.strip(), result.returncode
    except subprocess.CalledProcessError as e:
        return e.stdout.strip(), e.stderr.strip(), e.returncode


def check_docker():
    """Check if Docker is running."""
    print("🔍 Checking Docker...")
    
    stdout, stderr, code = run_command(['docker', '--version'], check=False)
    if code != 0:
        print("❌ Docker is not installed or not running!")
        print("   Please install Docker Desktop and start it.")
        return False
    print(f"✅ Docker found: {stdout}")
    
    # Check for docker compose (v2) or docker-compose (v1)
    stdout, stderr, code = run_command(['docker', 'compose', 'version'], check=False)
    if code == 0:
        print(f"✅ Docker Compose (v2) found: {stdout}")
        return True
    
    stdout, stderr, code = run_command(['docker-compose', '--version'], check=False)
    if code == 0:
        print(f"✅ Docker Compose (v1) found: {stdout}")
        return True
    
    print("❌ docker-compose is not installed!")
    return False


def start_docker_services():
    """Start Docker services (postgres, redis, backend, frontend)."""
    print("\n🐳 Starting Docker services...")
    
    compose_cmd = get_docker_compose_cmd()
    if not compose_cmd:
        print("❌ Docker Compose command not found!")
        return False
    
    # Start postgres and redis first
    print("  Starting PostgreSQL and Redis...")
    cmd = compose_cmd + ['up', '-d', 'postgres', 'redis']
    stdout, stderr, code = run_command(cmd)
    if code != 0:
        print(f"❌ Failed to start postgres/redis: {stderr}")
        return False
    
    # Wait for postgres to be healthy
    print("  Waiting for PostgreSQL to be ready...")
    max_wait = 30
    waited = 0
    while waited < max_wait:
        cmd = compose_cmd + ['exec', '-T', 'postgres', 'pg_isready', '-U', 'hobo']
        stdout, stderr, code = run_command(cmd, check=False)
        if code == 0:
            print("  ✅ PostgreSQL is ready")
            break
        time.sleep(1)
        waited += 1
        print(f"  Waiting... ({waited}/{max_wait})")
    
    if waited >= max_wait:
        print("❌ PostgreSQL did not become ready in time")
        return False
    
    # Start backend
    print("  Starting Backend...")
    cmd = compose_cmd + ['up', '-d', 'backend']
    stdout, stderr, code = run_command(cmd)
    if code != 0:
        print(f"❌ Failed to start backend: {stderr}")
        return False
    
    # Wait for backend to be ready
    print("  Waiting for Backend to be ready...")
    max_wait = 60
    waited = 0
    while waited < max_wait:
        try:
            import urllib.request
            urllib.request.urlopen('http://localhost:8000/health/', timeout=2)
            print("  ✅ Backend is ready")
            break
        except Exception:
            pass
        time.sleep(2)
        waited += 2
        print(f"  Waiting... ({waited}/{max_wait})")
    
    if waited >= max_wait:
        print("⚠️  Backend may not be fully ready, but continuing...")
    
    # Start frontend
    print("  Starting Frontend...")
    cmd = compose_cmd + ['up', '-d', 'frontend']
    stdout, stderr, code = run_command(cmd)
    if code != 0:
        print(f"❌ Failed to start frontend: {stderr}")
        return False
    
    # Wait for frontend
    print("  Waiting for Frontend to be ready...")
    time.sleep(5)
    try:
        import urllib.request
        urllib.request.urlopen('http://localhost:80/', timeout=5)
        print("  ✅ Frontend is ready")
    except Exception:
        print("⚠️  Frontend may not be fully ready, but continuing...")
    
    print("\n✅ All Docker services started!")
    return True


def run_simulation():
    """Run the simulation command in Docker backend container."""
    print("\n📊 Running Simulation...")
    print("=" * 60)
    
    compose_cmd = get_docker_compose_cmd()
    if not compose_cmd:
        print("❌ Docker Compose command not found!")
        return False
    
    # Run simulation in Docker container
    cmd = compose_cmd + ['exec', '-T', 'backend', 'python', 'manage.py', 'simulate_month', '--skip-delay']
    print(f"Command: {' '.join(cmd)}")
    
    # Run with real-time output
    process = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        universal_newlines=True,
        bufsize=1
    )
    
    for line in process.stdout:
        print(line.rstrip())
    
    process.wait()
    
    if process.returncode == 0:
        print("\n✅ Simulation completed successfully!")
        return True
    else:
        print(f"\n❌ Simulation failed with exit code {process.returncode}")
        return False


def run_screenshots():
    """Run screenshot capture script."""
    print("\n📸 Capturing Screenshots...")
    print("=" * 60)
    
    # Set environment variables for Docker
    env = os.environ.copy()
    env['FRONTEND_URL'] = 'http://localhost:80'
    env['BACKEND_URL'] = 'http://localhost:8000'
    
    # Run screenshot script
    script_path = Path('screenshot_story.py')
    if not script_path.exists():
        print(f"❌ Screenshot script not found: {script_path}")
        return False
    
    cmd = [sys.executable, str(script_path)]
    print(f"Command: {' '.join(cmd)}")
    print(f"Frontend URL: {env['FRONTEND_URL']}")
    print(f"Backend URL: {env['BACKEND_URL']}")
    
    process = subprocess.Popen(
        cmd,
        env=env,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        universal_newlines=True,
        bufsize=1
    )
    
    for line in process.stdout:
        print(line.rstrip())
    
    process.wait()
    
    if process.returncode == 0:
        print("\n✅ Screenshots captured successfully!")
        return True
    else:
        print(f"\n❌ Screenshot capture failed with exit code {process.returncode}")
        return False


def build_slideshow():
    """Build HTML slideshow."""
    print("\n🎨 Building Slideshow...")
    print("=" * 60)
    
    script_path = Path('build_slideshow.py')
    if not script_path.exists():
        print(f"❌ Slideshow script not found: {script_path}")
        return False
    
    cmd = [sys.executable, str(script_path)]
    print(f"Command: {' '.join(cmd)}")
    
    process = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        universal_newlines=True,
        bufsize=1
    )
    
    for line in process.stdout:
        print(line.rstrip())
    
    process.wait()
    
    if process.returncode == 0:
        print("\n✅ Slideshow built successfully!")
        return True
    else:
        print(f"\n❌ Slideshow build failed with exit code {process.returncode}")
        return False


def main():
    parser = argparse.ArgumentParser(description='Run simulation with Docker')
    parser.add_argument('--screenshots', action='store_true', help='Capture screenshots after simulation')
    parser.add_argument('--slideshow', action='store_true', help='Build slideshow after screenshots')
    parser.add_argument('--all', action='store_true', help='Run simulation + screenshots + slideshow')
    parser.add_argument('--no-start', action='store_true', help='Skip starting Docker services (assume already running)')
    parser.add_argument('--stop', action='store_true', help='Stop Docker services after completion')
    
    args = parser.parse_args()
    
    # Determine what to run
    run_screenshots_flag = args.screenshots or args.all
    run_slideshow_flag = args.slideshow or args.all
    
    print("=" * 60)
    print("SOLAR POS SYSTEM - DOCKER SIMULATION RUNNER")
    print("=" * 60)
    
    # Check Docker
    if not check_docker():
        sys.exit(1)
    
    # Start Docker services
    if not args.no_start:
        if not start_docker_services():
            print("\n❌ Failed to start Docker services")
            sys.exit(1)
    else:
        print("\n⏭️  Skipping Docker service start (--no-start flag)")
    
    # Run simulation
    if not run_simulation():
        print("\n❌ Simulation failed")
        sys.exit(1)
    
    # Run screenshots if requested
    if run_screenshots_flag:
        if not run_screenshots():
            print("\n⚠️  Screenshot capture failed, but continuing...")
    
    # Build slideshow if requested
    if run_slideshow_flag:
        if not build_slideshow():
            print("\n⚠️  Slideshow build failed, but continuing...")
    
    # Stop services if requested
    if args.stop:
        print("\n🛑 Stopping Docker services...")
        compose_cmd = get_docker_compose_cmd()
        if compose_cmd:
            run_command(compose_cmd + ['stop'])
            print("✅ Docker services stopped")
    
    print("\n" + "=" * 60)
    print("✅ ALL TASKS COMPLETED!")
    print("=" * 60)
    print("\nOutput files:")
    print("  - simulation_log.json")
    if run_screenshots_flag:
        print("  - screenshots/ directory")
    if run_slideshow_flag:
        print("  - solar_pos_demo_YYYY-MM-DD.html")
    print("\nServices are still running. Access:")
    print("  - Frontend: http://localhost:80")
    print("  - Backend: http://localhost:8000")
    print("\nTo stop services: docker-compose stop")
    print("=" * 60)


if __name__ == '__main__':
    main()
