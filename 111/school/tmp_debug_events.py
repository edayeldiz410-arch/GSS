import urllib.request, json, datetime

iso = datetime.date.today().isoformat()
url = f'http://127.0.0.1:8000/api/planning/events/?week_start={iso}'
print('Requesting', url)
with urllib.request.urlopen(url, timeout=10) as r:
    data = json.load(r)

print(json.dumps(data, indent=2, ensure_ascii=False))
