from .models import Utilisateur
import json, os
from django.conf import settings
import logging
import traceback

logger = logging.getLogger(__name__)

def current_user(request):
    """Inject current_user plus global school info into all template contexts.

    Adds:
      - current_user: Utilisateur or None (existing behavior)
      - school_name: name string or '' (read from school_info.json)
      - school_logo: URL path to logo (e.g. /media/... ) or ''
    """
    ctx = {'current_user': None, 'school_name': '', 'school_logo': ''}
    try:
        uid = request.session.get('user_id')
        if uid:
            user = Utilisateur.objects.filter(id=uid).first()
            ctx['current_user'] = user
    except Exception as e:
        logger.exception(f"[context_processors.current_user] Error fetching user from session: {e}")
        ctx['current_user'] = None

    # read persisted school info if present (non-blocking)
    try:
        info_path = os.path.join(settings.BASE_DIR, 'school_info.json')
        if os.path.exists(info_path):
            with open(info_path, 'r', encoding='utf-8') as f:
                info = json.load(f)
                ctx['school_name'] = info.get('name', '')
                ctx['school_logo'] = info.get('logo', '')
    except Exception as e:
        # keep defaults
        logger.warning(f"[context_processors.current_user] Could not load school_info.json: {e}")

    return ctx
