from django.utils.deprecation import MiddlewareMixin
from .dbrouters import set_active_db
import logging
import traceback

logger = logging.getLogger(__name__)

class ActiveDBMiddleware(MiddlewareMixin):
    """Middleware that reads the user's selected DB from session or cookie
    and stores it in thread-local storage for the DB router to use.
    """

    def process_request(self, request):
        name = None
        try:
            # Check if session is initialized before accessing
            if hasattr(request, 'session') and request.session:
                name = request.session.get('active_db')
        except Exception as ex:
            # Session might not exist or be readable
            logger.exception(f"[ActiveDBMiddleware] Error reading session: {ex}")
            pass
        
        # fallback to cookie if present
        if not name:
            try:
                name = request.COOKIES.get('active_db')
            except Exception as e:
                logger.exception(f"[ActiveDBMiddleware] Error reading cookie: {e}")
                name = None
        
        try:
            set_active_db(name)
        except Exception as e:
            logger.exception(f"[ActiveDBMiddleware] Error setting active_db: {e}")

    def process_response(self, request, response):
        try:
            # clear after response to be safe
            set_active_db(None)
        except Exception as e:
            logger.exception(f"[ActiveDBMiddleware] Error clearing active_db: {e}")
        return response
