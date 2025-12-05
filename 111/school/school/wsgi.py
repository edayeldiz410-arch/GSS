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

# Defensive: when running inside the Docker container the project root is
# copied to `/app/111/school`. Make sure that path is present in `sys.path`
# so top-level packages such as `Schoolapp` are importable regardless of
# how the process was started.
container_path = '/app/111/school'
if container_path not in sys.path:
	try:
		# Only insert if the directory exists in the container image
		if Path(container_path).exists():
			sys.path.insert(0, container_path)
	except Exception:
		# Fall back silently; the original BASE_DIR insertion is usually enough
		pass

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'school.settings')

# Debug: print whether `Schoolapp` is importable at process startup; this
# helps diagnose ModuleNotFoundError issues in container logs.
try:
	import Schoolapp  # type: ignore
	print('DEBUG: Schoolapp import OK', flush=True)
except Exception as e:
	print('DEBUG: Schoolapp import FAILED:', repr(e), flush=True)

application = get_wsgi_application()

