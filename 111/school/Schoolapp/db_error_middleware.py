# Schoolapp/db_error_middleware.py
"""
Middleware to handle database connection errors gracefully.
"""
import json
import logging
import traceback
from django.http import JsonResponse
from django.db import OperationalError, DatabaseError, connection
from django.utils.deprecation import MiddlewareMixin

logger = logging.getLogger(__name__)

class DatabaseErrorMiddleware(MiddlewareMixin):
    """
    Catches database connection errors and returns a graceful error message
    instead of a 500 error.
    """
    
    def process_exception(self, request, exception):
        """Handle database-related exceptions."""
        if isinstance(exception, (OperationalError, DatabaseError)):
            error_trace = traceback.format_exc()
            logger.error(f"[DatabaseErrorMiddleware] DB Error: {exception}\n{error_trace}")
            
            # Try to close and reset the connection
            try:
                connection.close()
            except Exception as e:
                logger.warning(f"[DatabaseErrorMiddleware] Could not close connection: {e}")
            
            # Return appropriate response based on request type
            if request.path.startswith('/api/') or 'application/json' in request.META.get('HTTP_ACCEPT', ''):
                return JsonResponse({
                    'error': 'Database connection unavailable',
                    'message': 'The database is not currently available. Please try again in a few moments.',
                    'status': 503,
                }, status=503)
            else:
                # For HTML requests, still return JSON for AJAX/fetch requests
                return JsonResponse({
                    'error': 'Database connection unavailable',
                    'message': 'The application is starting up. Please refresh in a few moments.',
                    'status': 503,
                }, status=503)
        
        # Don't catch non-database exceptions
        return None
