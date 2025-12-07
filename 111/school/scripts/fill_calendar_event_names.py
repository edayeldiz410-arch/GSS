"""
Script: fill_calendar_event_names.py
Scan CalendarEvent rows and propose filling missing textual name fields
(formation_name, formateur_name, salle_name) based on their id fields.

Usage:
    python school/scripts/fill_calendar_event_names.py [--commit]

By default the script runs in dry-run mode and only prints proposed updates.
When called with --commit it will update rows in-place.

This script expects to be run from the project root (Genieschool2) so that
`school` is on sys.path and Django settings can be loaded.
"""
import os
import sys
from datetime import datetime

# Ensure project package is on sys.path
PROJ_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
if PROJ_ROOT not in sys.path:
    sys.path.insert(0, PROJ_ROOT)

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'school.settings')

import django
django.setup()

from Schoolapp.models import CalendarEvent, Formation, Enseignant, Utilisateur, Salle
from django.db import transaction

import argparse
parser = argparse.ArgumentParser()
parser.add_argument('--commit', action='store_true', help='Apply changes to the DB')
parser.add_argument('--limit', type=int, default=0, help='Limit number of rows to process (0 = no limit)')
args = parser.parse_args()

commit = args.commit
limit = args.limit

now = datetime.utcnow().isoformat()[:19]
print(f"fill_calendar_event_names: started at {now} (commit={commit}, limit={limit})")

q = CalendarEvent.objects.all().order_by('id')
if limit > 0:
    q = q[:limit]

proposals = []
for ev in q:
    changed = {}
    # formation
    formation_id = getattr(ev, 'formation_id', None)
    formation_name = (getattr(ev, 'formation_name', None) or '')
    if (not formation_name) and formation_id:
        f = Formation.objects.filter(id=formation_id).first()
        if f:
            changed['formation_name'] = str(f)
    # formateur/organisateur
    organisateur_id = getattr(ev, 'organisateur_id', None)
    formateur_name = (getattr(ev, 'formateur_name', None) or '')
    if (not formateur_name) and organisateur_id:
        fo = Enseignant.objects.filter(id=organisateur_id).first()
        if fo:
            changed['formateur_name'] = str(fo)
        else:
            u = Utilisateur.objects.filter(id=organisateur_id).first()
            if u:
                changed['formateur_name'] = str(u)
    # salle
    salle_id = getattr(ev, 'salle_id', None)
    salle_name = (getattr(ev, 'salle_name', None) or '')
    if (not salle_name) and salle_id:
        s = Salle.objects.filter(id=salle_id).first()
        if s:
            changed['salle_name'] = str(s)
    if changed:
        proposals.append((ev.id, ev.titre, changed))

if not proposals:
    print('No proposals found. CalendarEvent rows seem to already have textual names or ids are empty.')
else:
    print(f'Found {len(proposals)} CalendarEvent rows with missing names. Sample:')
    for i, (eid, titre, changed) in enumerate(proposals[:50], start=1):
        print(i, eid, repr(titre), '=>', changed)

    if commit:
        print('\nApplying changes...')
        with transaction.atomic():
            for eid, titre, changed in proposals:
                ev = CalendarEvent.objects.select_for_update().filter(id=eid).first()
                if not ev:
                    continue
                # set fields
                for k, v in changed.items():
                    setattr(ev, k, v)
                ev.save()
        print('Applied changes to DB.')
    else:
        print('\nDry-run only. To apply changes run with --commit')

print('Done.')
