"""Test script to call send_welcome_email_async and observe server logs.
Run with the project's python executable from the project root.
"""
import os
import sys
# ensure project root is on path
proj_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, proj_root)

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'school.settings')
import django
django.setup()

from Schoolapp.views import send_welcome_email_async

if __name__ == '__main__':
    test_email = os.environ.get('TEST_TO_EMAIL', 'test@example.com')
    ctx = {'prenom': 'Test', 'nom': 'User', 'formation': 'Test Formation'}
    print(f"Scheduling welcome email to {test_email}")
    send_welcome_email_async(test_email, ctx)
    print("Done scheduling; check console logs for SMTP debug or console backend output.")
