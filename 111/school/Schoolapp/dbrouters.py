import threading
from typing import Optional
import logging

logger = logging.getLogger(__name__)

# Thread-local storage for the active DB alias. Middleware sets this per-request.
_local = threading.local()


def set_active_db(name: Optional[str]):
    """Set the active DB alias for the current thread/request."""
    try:
        setattr(_local, 'active_db', name)
        if name:
            logger.debug(f"[dbrouters] Active DB set to: {name}")
    except Exception as e:
        logger.exception(f"[dbrouters] Error setting active_db: {e}")


def get_active_db() -> Optional[str]:
    try:
        return getattr(_local, 'active_db', None)
    except Exception as e:
        logger.exception(f"[dbrouters] Error getting active_db: {e}")
        return None


class SessionDBRouter:
    """A simple DB router that routes reads/writes to the per-request active DB.

    If no active DB is set, it returns None so Django uses the default routing.

    Note: migrations should be run against the 'default' database by convention.
    """

    def db_for_read(self, model, **hints):
        try:
            return get_active_db()
        except Exception as e:
            logger.exception(f"[SessionDBRouter] Error in db_for_read for {model}: {e}")
            return None

    def db_for_write(self, model, **hints):
        try:
            return get_active_db()
        except Exception as e:
            logger.exception(f"[SessionDBRouter] Error in db_for_write for {model}: {e}")
            return None

    def allow_relation(self, obj1, obj2, **hints):
        # Defer to default behavior
        return None

    def allow_migrate(self, db, app_label, model_name=None, **hints):
        # Avoid running migrations on non-default DBs by default. Return True
        # only for the default DB so manage.py migrate acts normally.
        return db == 'default'
