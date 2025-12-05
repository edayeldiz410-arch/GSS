#!/bin/sh
set -e

# Activate virtualenv
. /opt/venv/bin/activate

# Change to Django project dir
cd /app/111/school

echo "Running migrations (if any)..."
# run migrations if DB is reachable; don't fail build if not
python manage.py migrate --noinput || true

echo "Collecting static files..."
python manage.py collectstatic --noinput || true

# Default port fallback
if [ -z "$PORT" ]; then
  PORT=8080
fi

echo "Starting gunicorn on 0.0.0.0:${PORT}"
exec gunicorn school.wsgi:application --chdir . --bind 0.0.0.0:${PORT} \
    --workers ${WEB_CONCURRENCY:-2} --access-logfile - --error-logfile - --log-level info
