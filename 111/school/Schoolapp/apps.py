from django.apps import AppConfig


class SchoolappConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'Schoolapp'

    def ready(self):
        """Called when Django starts up. Import signal handlers here."""
        try:
            # Import signals to register handlers
            from . import models  # noqa: F401
        except Exception as e:
            print(f"Warning: Error loading Schoolapp models: {e}")
            import traceback
            traceback.print_exc()

