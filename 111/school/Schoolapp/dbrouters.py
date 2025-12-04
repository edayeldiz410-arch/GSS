import threading
from typing import Optional

# Thread-local storage for the active DB alias. Middleware sets this per-request.
_local = threading.local()


def set_active_db(name: Optional[str]):
    """Set the active DB alias for the current thread/request."""
    setattr(_local, 'active_db', name)


def get_active_db() -> Optional[str]:
    return getattr(_local, 'active_db', None)


class SessionDBRouter:
    """A simple DB router that routes reads/writes to the per-request active DB.

    If no active DB is set, it returns None so Django uses the default routing.

    Note: migrations should be run against the 'default' database by convention.
    """

    def db_for_read(self, model, **hints):
        return get_active_db()

    def db_for_write(self, model, **hints):
        return get_active_db()

    def allow_relation(self, obj1, obj2, **hints):
        # Defer to default behavior
        return None

    def allow_migrate(self, db, app_label, model_name=None, **hints):
        # Avoid running migrations on non-default DBs by default. Return True
        # only for the default DB so manage.py migrate acts normally.
        return db == 'default'
