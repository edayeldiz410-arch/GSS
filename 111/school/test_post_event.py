import urllib.request, json

# Adjust these ids to match real ones in your DB if needed
payload = {
  'title': 'API_TEST_EVENT',
  'start': '2025-09-21T09:00:00',
  'end': '2025-09-21T10:00:00',
  # these are best-effort; if id 1 doesn't exist, view will store names only when provided
  'formation': 1,
  'formateur': 1,
  'salle': 1
}

add_url = 'http://127.0.0.1:8000/api/planning/events/add/'
list_url = 'http://127.0.0.1:8000/api/planning/events/?week_start=2025-09-21'

print('Posting to', add_url)
req = urllib.request.Request(add_url, data=json.dumps(payload).encode('utf-8'), headers={'Content-Type':'application/json'})
try:
    with urllib.request.urlopen(req, timeout=10) as r:
        res = json.load(r)
        print('Add resp:', json.dumps(res, indent=2, ensure_ascii=False))
except Exception as e:
    print('post error', e)

print('\nFetching list')
with urllib.request.urlopen(list_url, timeout=10) as r:
    data = json.load(r)
    print(json.dumps(data, indent=2, ensure_ascii=False))
