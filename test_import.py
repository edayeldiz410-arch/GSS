#!/usr/bin/env python
"""
Quick test to check if Django can be imported.
Run with: python test_import.py
"""
import sys
import os

# Add paths
sys.path.insert(0, '/app/111')
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'school.settings')

try:
    import django
    print(f"✓ Django {django.VERSION} imported")
    
    django.setup()
    print("✓ Django setup complete")
    
    from django.core.wsgi import get_wsgi_application
    print("✓ get_wsgi_application imported")
    
    app = get_wsgi_application()
    print("✓ WSGI application created")
    
    # Test health endpoint
    class FakeStartResponse:
        def __init__(self):
            self.status = None
            self.headers = None
        
        def __call__(self, status, headers):
            self.status = status
            self.headers = headers
    
    environ = {
        'REQUEST_METHOD': 'GET',
        'PATH_INFO': '/health/',
        'SERVER_NAME': 'test',
        'SERVER_PORT': '8000',
        'wsgi.url_scheme': 'http',
    }
    
    start_response = FakeStartResponse()
    result = app(environ, start_response)
    response_body = b''.join(result)
    
    print(f"✓ Health endpoint returned: {start_response.status}")
    print(f"✓ Response: {response_body.decode()}")
    
except Exception as e:
    print(f"✗ Error: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)
