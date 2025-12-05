"""
WSGI config for school project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/5.2/howto/deployment/wsgi/
"""
import sys
from pathlib import Path
import os

from django.core.wsgi import get_wsgi_application



# Ensure the project parent directory is on sys.path so sibling apps like
# `Schoolapp` can be imported when running under gunicorn/container.
BASE_DIR = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(BASE_DIR))

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'school.settings')

application = get_wsgi_application()

