import urllib.request, json, datetime

iso = datetime.date.today().isoformat()
url = f'http://127.0.0.1:8000/api/planning/events/?week_start={iso}'
print('Requesting', url)
with urllib.request.urlopen(url, timeout=10) as r:
    data = json.load(r)

print('success:', data.get('success'))
evs = data.get('events', [])
print('server events count:', len(evs))

# mapping functions from JS

def personName(p):
    if not p:
        return ''
    if isinstance(p, str):
        return p
    if isinstance(p, (int, float)):
        return str(p)
    if isinstance(p, dict):
        if p.get('prenom') or p.get('nom'):
            return ((p.get('prenom','') + ' ' + p.get('nom','')).strip())
        if p.get('first_name') or p.get('last_name'):
            return ((p.get('first_name','') + ' ' + p.get('last_name','')).strip())
        if p.get('display_name'):
            return p.get('display_name')
        if p.get('name'):
            return p.get('name')
        if p.get('nom'):
            return p.get('nom')
    return ''


def formationName(f):
    if not f:
        return ''
    if isinstance(f, str):
        return f
    if isinstance(f, dict):
        return f.get('nom') or f.get('name') or f.get('title') or ''
    return ''

mapped = []
for s in evs:
    start = None
    try:
        start = datetime.datetime.fromisoformat(s['start'])
    except Exception:
        start = None
    end = None
    if s.get('end'):
        try:
            end = datetime.datetime.fromisoformat(s['end'])
        except Exception:
            end = None
    if start:
        startHM = f"{start.hour:02d}:{start.minute:02d}"
        endHM = f"{end.hour:02d}:{end.minute:02d}" if end else startHM
    else:
        startHM = endHM = ''
    week_start = data.get('week_start')
    day = None
    if start and week_start:
        day = (start.date() - datetime.date.fromisoformat(week_start)).days
    form = formationName(s.get('formation_name') or s.get('formation') or '')
    formateur = personName(s.get('formateur_name') or s.get('formateur_nom') or s.get('formateur') or s.get('organisateur') or '')
    mapped.append({'id': s.get('id'), 'title': s.get('title') or s.get('titre'), 'day': day, 'start': startHM, 'end': endHM, 'formation': form, 'formateur': formateur})

print('\nMapped events:')
for m in mapped:
    print(m)
