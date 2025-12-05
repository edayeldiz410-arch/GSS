from django.utils.deprecation import MiddlewareMixin
from .dbrouters import set_active_db


class ActiveDBMiddleware(MiddlewareMixin):
    """Middleware that reads the user's selected DB from session or cookie
    and stores it in thread-local storage for the DB router to use.
    """

    def process_request(self, request):
        name = None
        try:
            name = request.session.get('active_db')
        except Exception:
            name = None
        # fallback to cookie if present
        if not name:
            try:
                name = request.COOKIES.get('active_db')
            except Exception:
                name = None
        set_active_db(name)

    def process_response(self, request, response):
        # clear after response to be safe
        set_active_db(None)
        return response
