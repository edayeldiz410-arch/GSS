import os
import sys
# configure Django environment
proj = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, proj)
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'school.settings')
import django
django.setup()

from Schoolapp.models import Etudiant
from django.utils import timezone

today = timezone.now().date()
qs = Etudiant.objects.filter(date_inscription__isnull=True)
print('A mettre à jour (sans date_inscription) :', qs.count())
updated = qs.update(date_inscription=today)
print('Nombre mis à jour :', updated)
month_start = timezone.now().replace(day=1).date()
count_month = Etudiant.objects.filter(date_inscription__gte=month_start).count()
print('Nouveaux ce mois (count):', count_month)
print(list(Etudiant.objects.filter(date_inscription__gte=month_start).values('id','nom','prenom')[:200]))
