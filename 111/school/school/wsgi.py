"""
WSGI config for school project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/5.2/howto/deployment/wsgi/
"""
import sys
from pathlib import Path
import os
import traceback
import json

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
	traceback.print_exc()

# Initialize WSGI application with error handling
_app = None
_app_error = None

try:
	print('DEBUG: Initializing WSGI application...', flush=True)
	_app = get_wsgi_application()
	print('DEBUG: WSGI application initialized successfully', flush=True)
except Exception as e:
	print(f'ERROR: Failed to initialize WSGI application: {e}', flush=True)
	traceback.print_exc()
	_app_error = str(e)


def application(environ, start_response):
	"""WSGI application that handles initialization errors gracefully."""
	if _app_error:
		# Return a 500 error with the error message
		status = '500 Internal Server Error'
		response_headers = [('Content-type', 'application/json')]
		start_response(status, response_headers)
		error_msg = json.dumps({
			'error': 'Application initialization failed',
			'message': _app_error,
		}).encode('utf-8')
		return [error_msg]
	
	if _app is None:
		# Should not happen, but just in case
		status = '500 Internal Server Error'
		response_headers = [('Content-type', 'application/json')]
		start_response(status, response_headers)
		return [b'{"error": "Application not initialized"}']
	
	# Call the actual Django application
	try:
		return _app(environ, start_response)
	except Exception as e:
		print(f'ERROR in request handler: {e}', flush=True)
		traceback.print_exc()
		status = '500 Internal Server Error'
		response_headers = [('Content-type', 'application/json')]
		start_response(status, response_headers)
		error_msg = json.dumps({
			'error': 'Request processing failed',
			'message': str(e),
		}).encode('utf-8')
		return [error_msg]

