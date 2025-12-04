"""Synchronous test to call _safe_send directly so we see SMTP logs before process exits."""
import os
import sys
proj_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, proj_root)

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'school.settings')
import django
django.setup()

from Schoolapp.views import _safe_send

if __name__ == '__main__':
    to_email = os.environ.get('TEST_TO_EMAIL', 'test@example.com')
    ctx = {'prenom': 'SyncTest', 'nom': 'User', 'formation': 'Test Formation'}
    print(f"Calling _safe_send synchronously for {to_email}")
    _safe_send('Bienvenue à GénieSchool', to_email, 'email/welcome_etudiant.html', ctx)
    print('Done _safe_send')
