#!/bin/sh

# Activate virtualenv if it exists (for Docker)
if [ -f /opt/venv/bin/activate ]; then
  . /opt/venv/bin/activate
  echo "Virtual environment activated"
fi

# Set Python path
export PYTHONPATH="/app/111:$PYTHONPATH"
export PYTHONUNBUFFERED=1

# Change to Django project directory
cd /app/111/school || exit 1

echo "=== GenieSchool Application Startup ==="
echo "Python: $(python --version 2>&1)"
echo "Working directory: $(pwd)"
echo ""

# Try migrations but don't fail if timeout
echo "Running migrations (30s timeout)..."
timeout 30 python manage.py migrate --noinput 2>&1 | head -5 || echo "  (skipped - may not be ready)"

# Try static files but don't fail if timeout
echo "Collecting static files (30s timeout)..."
timeout 30 python manage.py collectstatic --noinput 2>&1 | head -3 || echo "  (skipped)"

# Get port from environment or default to 8080
PORT=${PORT:-8080}

echo ""
echo "Starting gunicorn on 0.0.0.0:${PORT}"
echo ""

# Start gunicorn
exec gunicorn \
  school.wsgi:application \
  --bind 0.0.0.0:${PORT} \
  --workers ${WEB_CONCURRENCY:-2} \
  --worker-class sync \
  --timeout 120 \
  --access-logfile - \
  --error-logfile - \
  --log-level info
