import os
import django
import datetime

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'school.settings')
django.setup()

from Schoolapp.models import CalendarEvent, Session, Formation, Enseignant, Utilisateur, Salle
from django.utils import timezone

# compute week start (previous Sunday)
today = timezone.localdate()
delta = (today.weekday() + 1) % 7
sunday = today - timezone.timedelta(days=delta)
end = sunday + timezone.timedelta(days=7)

print('Week start:', sunday.isoformat())

# CalendarEvent
print('\nCalendarEvent records:')
q = CalendarEvent.objects.filter(start_datetime__date__gte=sunday, start_datetime__date__lt=end).order_by('start_datetime')
for e in q:
    print('---')
    print('id:', e.id)
    print('titre:', e.titre)
    print('start:', getattr(e, 'start_datetime'))
    print('end:', getattr(e, 'end_datetime'))
    print('formation_id:', getattr(e, 'formation_id', None))
    print('formation_name (raw):', getattr(e, 'formation_name', None))
    print('salle_id:', getattr(e, 'salle_id', None))
    print('salle_name (raw):', getattr(e, 'salle_name', None))
    print('organisateur_id:', getattr(e, 'organisateur_id', None))
    print('formateur_name (raw):', getattr(e, 'formateur_name', None))
    # resolve
    f_name = getattr(e, 'formation_name', '') or ''
    if not f_name and getattr(e, 'formation_id', None):
        try:
            f = Formation.objects.filter(id=e.formation_id).values_list('nom', flat=True).first()
            if f:
                f_name = f
        except Exception:
            pass
    s_name = getattr(e, 'salle_name', '') or ''
    if not s_name and getattr(e, 'salle_id', None):
        try:
            s = Salle.objects.filter(id=e.salle_id).values_list('nom', flat=True).first()
            if s:
                s_name = s
        except Exception:
            pass
    fo_name = getattr(e, 'formateur_name', '') or ''
    if not fo_name and getattr(e, 'organisateur_id', None):
        try:
            fo = Enseignant.objects.filter(id=e.organisateur_id).first()
            if fo:
                fo_name = str(fo)
            else:
                u = Utilisateur.objects.filter(id=e.organisateur_id).first()
                if u:
                    fo_name = str(u)
        except Exception:
            pass
    print('formation_name (resolved):', f_name)
    print('salle_name (resolved):', s_name)
    print('formateur_name (resolved):', fo_name)

# Sessions
print('\nSession records:')
qs = Session.objects.filter(date_debut__gte=sunday, date_debut__lt=end).order_by('date_debut')
for s in qs:
    print('---')
    print('session id:', s.id)
    print('formation:', s.formation.id if s.formation else None, '->', str(s.formation) if s.formation else '')
    print('formateur:', s.formateur.id if s.formateur else None, '->', str(s.formateur) if s.formateur else '')
    print('salle:', s.salle.id if s.salle else None, '->', str(s.salle) if s.salle else '')
    print('date_debut:', s.date_debut, 'horaire_debut:', s.horaire_debut, 'horaire_fin:', s.horaire_fin)

print('\nDone')
