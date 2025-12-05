"""
WSGI config for school project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/5.2/howto/deployment/wsgi/
"""
import sys
from pathlib import Path
import os

# Ensure the project parent directory is on sys.path
BASE_DIR = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(BASE_DIR))

# Add container path if it exists
container_path = '/app/111/school'
if container_path not in sys.path:
	try:
		if Path(container_path).exists():
			sys.path.insert(0, container_path)
	except Exception:
		pass

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'school.settings')

# Simple health check WSGI app
def health_app(environ, start_response):
	"""Minimal WSGI app that returns 200 OK."""
	status = '200 OK'
	response_headers = [('Content-Type', 'application/json')]
	start_response(status, response_headers)
	return [b'{"status": "ok"}']

# Try to import Django - if it fails, use health check only
_django_app = None
_error_message = None

try:
	from django.core.wsgi import get_wsgi_application
	_django_app = get_wsgi_application()
	print('✓ Django WSGI application loaded successfully', flush=True)
except Exception as e:
	print(f'✗ Failed to load Django: {e}', flush=True)
	import traceback
	traceback.print_exc()
	_error_message = str(e)

# Main application wrapper
def application(environ, start_response):
	"""
	WSGI application that routes to Django if available,
	or returns a health check response.
	"""
	# Health check endpoint - always works
	if environ.get('PATH_INFO') == '/health/' or environ.get('PATH_INFO') == '/health':
		return health_app(environ, start_response)
	
	# If Django failed to load, return an error
	if _django_app is None:
		status = '503 Service Unavailable'
		response_headers = [('Content-Type', 'application/json')]
		start_response(status, response_headers)
		error_json = f'{{"error": "Django initialization failed", "message": "{_error_message}"}}'.encode('utf-8')
		return [error_json]
	
# Main application wrapper
def application(environ, start_response):
	"""
	WSGI application that routes to Django if available,
	or returns a health check response.
	"""
	# Health check endpoint - always works
	if environ.get('PATH_INFO') == '/health/' or environ.get('PATH_INFO') == '/health':
		return health_app(environ, start_response)
	
	# If Django failed to load, return an error
	if _django_app is None:
		status = '503 Service Unavailable'
		response_headers = [('Content-Type', 'application/json')]
		start_response(status, response_headers)
		error_json = f'{{"error": "Django initialization failed", "message": "{_error_message}"}}'.encode('utf-8')
		return [error_json]
	
	# Otherwise, use Django
	try:
		return _django_app(environ, start_response)
	except Exception as e:
		print(f'✗ Request error: {e}', flush=True)
		import traceback
		error_trace = traceback.format_exc()
		print(error_trace, flush=True)
		status = '500 Internal Server Error'
		response_headers = [('Content-Type', 'application/json')]
		start_response(status, response_headers)
		# Include traceback in response for debugging
		error_json = f'{{"error": "Request failed", "message": "{str(e)}", "trace": "{error_trace.replace(chr(34), chr(39))}"}}'.encode('utf-8')
		return [error_json]

