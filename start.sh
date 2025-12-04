#!/bin/sh

# Navigate to the Django project directory
cd 111/school

# Run database migrations
python manage.py migrate

# Collect static files
python manage.py collectstatic --noinput

# Start the application using Gunicorn
gunicorn school.wsgi --bind 0.0.0.0:$PORT
