#!/bin/sh

# Activate virtualenv
. /opt/venv/bin/activate

# Change to Django project dir
export PYTHONPATH="/app/111:$PYTHONPATH"
cd /app/111/school

echo "=== Starting Django Application Setup ==="
echo "Python version:"
python --version

echo ""
echo "Testing Django import..."
python -c "import django; print(f'Django {django.VERSION} imported OK')" || { echo "ERROR: Django import failed"; exit 1; }

echo ""
echo "Running migrations (if any)..."
python manage.py migrate --noinput 2>&1 || echo "Warning: Migration failed, but continuing..."

echo ""
echo "Collecting static files..."
python manage.py collectstatic --noinput 2>&1 || echo "Warning: Collectstatic failed, but continuing..."

echo ""
echo "Testing WSGI application import..."
python -c "from school.wsgi import application; print('WSGI application imported OK')" || { echo "ERROR: WSGI import failed"; exit 1; }

# Default port fallback
if [ -z "$PORT" ]; then
  PORT=8080
fi

echo ""
echo "=== Starting gunicorn on 0.0.0.0:${PORT} ==="
exec gunicorn school.wsgi:application --chdir . --bind 0.0.0.0:${PORT} \
    --workers ${WEB_CONCURRENCY:-2} --access-logfile - --error-logfile - --log-level debug --timeout 120
