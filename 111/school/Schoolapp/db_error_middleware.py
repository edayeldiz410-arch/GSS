"""
Middleware to handle database connection errors gracefully.
"""
import json
from django.http import JsonResponse
from django.db import OperationalError, DatabaseError
from django.utils.deprecation import MiddlewareMixin


class DatabaseErrorMiddleware(MiddlewareMixin):
    """
    Catches database connection errors and returns a graceful error message
    instead of a 500 error.
    """
    
    def process_exception(self, request, exception):
        """Handle database-related exceptions."""
        if isinstance(exception, (OperationalError, DatabaseError)):
            # Check if this is an API request
            if request.path.startswith('/api/') or 'application/json' in request.META.get('HTTP_ACCEPT', ''):
                return JsonResponse({
                    'error': 'Database connection unavailable',
                    'message': 'The database is not currently available. Please try again in a few moments.',
                    'status': 503,
                }, status=503)
            else:
                # For HTML requests, return a simple HTML error page
                return JsonResponse({
                    'error': 'Database connection unavailable',
                    'message': 'The application is starting up. Please refresh in a few moments.',
                }, status=503)
        
        return None
