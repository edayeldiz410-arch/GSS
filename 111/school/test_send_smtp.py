import os
import sys

# Boot Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'school.settings')
import django
django.setup()

from django.conf import settings
from Schoolapp.views import _safe_send

print('EMAIL_BACKEND=', settings.EMAIL_BACKEND)
print('EMAIL_HOST=', getattr(settings, 'EMAIL_HOST', None))
print('EMAIL_HOST_USER=', getattr(settings, 'EMAIL_HOST_USER', None))

try:
    _safe_send('Test SMTP', 'testrf2@example.com', 'email/welcome_etudiant.html', {'prenom': 'Jean', 'nom': 'SMTPTest', 'formation': 'Informatique'})
    print('call completed')
except Exception as e:
    import traceback
    traceback.print_exc()
    sys.exit(1)
