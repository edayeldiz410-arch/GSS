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
# Railway may use different ports (8080, 9000, etc.) depending on configuration
# Check for PORT, or fallback to common Railway ports
if [ -z "$PORT" ]; then
  echo "=========================================="
  echo "WARNING: PORT environment variable is not set!"
  echo "=========================================="
  echo ""
  echo "Railway should provide PORT automatically for web services."
  echo "Trying common Railway ports..."
  # Try to detect from Railway's internal configuration
  if [ -n "$RAILWAY_ENVIRONMENT" ]; then
    echo "Railway environment detected, using port 9000 (Railway Metal Edge default)"
    PORT=9000
  else
    echo "Using default port 8080"
    PORT=8080
  fi
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
