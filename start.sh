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

# Skip migrations in startup - they can cause blocking issues
# Users can run manually: python manage.py migrate
echo "Note: Skipping migrations on startup (may already be applied)"
echo "To run migrations manually: python manage.py migrate"

# Try static files but don't fail if timeout
echo "Collecting static files (30s timeout)..."
timeout 30 python manage.py collectstatic --noinput 2>&1 | tail -2 || echo "  (skipped)"

# Get port from environment - Railway MUST provide this for web services
# If PORT is not set, Railway won't be able to route traffic
if [ -z "$PORT" ]; then
  echo "=========================================="
  echo "ERROR: PORT environment variable is not set!"
  echo "=========================================="
  echo ""
  echo "This usually means Railway hasn't detected this as a web service."
  echo ""
  echo "SOLUTION: In Railway dashboard:"
  echo "1. Go to your service settings"
  echo "2. Enable 'Public Networking' or set service type to 'Web Service'"
  echo "3. Railway will then automatically provide the PORT variable"
  echo ""
  echo "For now, using default port 8080 (this may not work)"
  PORT=8080
else
  echo "✓ PORT environment variable found: ${PORT}"
fi

echo ""
echo "=== Starting Application ==="
echo "Binding to: 0.0.0.0:${PORT}"
echo "=============================="
echo ""

# Start gunicorn
# Bind to 0.0.0.0 to accept connections from Railway's proxy
exec gunicorn \
  school.wsgi:application \
  --bind 0.0.0.0:${PORT} \
  --workers ${WEB_CONCURRENCY:-2} \
  --worker-class sync \
  --timeout 120 \
  --access-logfile - \
  --error-logfile - \
  --log-level info \
  --forwarded-allow-ips="*"
