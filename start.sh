#!/bin/sh

# Activate virtualenv
. /opt/venv/bin/activate

# Change to Django project dir
export PYTHONPATH="/app/111:$PYTHONPATH"
cd /app/111/school

echo "=== GenieSchool Startup ==="
echo "Python: $(python --version 2>&1)"
echo "Working dir: $(pwd)"

# Try migrations but don't fail
echo "Migrations..."
timeout 30 python manage.py migrate --noinput 2>&1 | head -3 || echo "(skipped)"

# Try static files but don't fail
echo "Static files..."
timeout 30 python manage.py collectstatic --noinput 2>&1 | head -2 || echo "(skipped)"

# Set port
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
