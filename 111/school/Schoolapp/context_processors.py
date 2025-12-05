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
    
    # Safely try to get user from session with timeout handling
    try:
        uid = request.session.get('user_id')
        if uid:
            try:
                user = Utilisateur.objects.filter(id=uid).first()
                ctx['current_user'] = user
            except Exception as db_err:
                logger.warning(f"[context_processors] Database error fetching user {uid}: {db_err}")
                ctx['current_user'] = None
    except Exception as e:
        logger.debug(f"[context_processors.current_user] Error accessing session: {e}")
        ctx['current_user'] = None

    # read persisted school info if present (non-blocking)
    try:
        info_path = os.path.join(settings.BASE_DIR, 'school_info.json')
        if os.path.exists(info_path):
            with open(info_path, 'r', encoding='utf-8') as f:
                info = json.load(f)
                ctx['school_name'] = info.get('name', '')
                ctx['school_logo'] = info.get('logo', '')
    except FileNotFoundError:
        # keep defaults - file doesn't exist yet
        pass
    except Exception as e:
        logger.warning(f"[context_processors.current_user] Could not load school_info.json: {e}")

    return ctx
