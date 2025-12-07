from django.core.management.base import BaseCommand


class Command(BaseCommand):
    help = 'Send a test email using Schoolapp.views._safe_send'

    def add_arguments(self, parser):
        parser.add_argument('to_email', nargs='?', default='testrf2@example.com')

    def handle(self, *args, **options):
        to_email = options['to_email']
        # import here to ensure Django is ready
        from Schoolapp.views import _safe_send
        from django.conf import settings

        self.stdout.write(f'EMAIL_BACKEND= {settings.EMAIL_BACKEND}')
        try:
            _safe_send('Test SMTP', to_email, 'email/welcome_etudiant.html', {'prenom': 'Jean', 'nom': 'SMTPTest', 'formation': 'Informatique'})
            self.stdout.write(self.style.SUCCESS('Email send attempted'))
        except Exception as e:
            import traceback
            traceback.print_exc()
            self.stderr.write(self.style.ERROR('Exception while sending email'))
            raise
