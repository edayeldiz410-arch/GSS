"""
Custom management command to safely run migrations without blocking on database errors.
"""
from django.core.management.commands.migrate import Command as MigrateCommand
from django.db import OperationalError


class Command(MigrateCommand):
    """Extended migrate command that gracefully handles database connection errors."""
    
    def handle(self, *args, **options):
        """Run migrations with error handling."""
        try:
            return super().handle(*args, **options)
        except OperationalError as e:
            self.stderr.write(
                self.style.WARNING(f'Database connection warning: {e}')
            )
            self.stderr.write(
                self.style.WARNING('Continuing without migrations. Database may not be ready yet.')
            )
            return None
        except Exception as e:
            self.stderr.write(
                self.style.ERROR(f'Unexpected error during migration: {e}')
            )
            # Don't re-raise - let the app start anyway
            return None
