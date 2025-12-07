import os
os.environ.setdefault('DJANGO_SETTINGS_MODULE','school.settings')
import django
django.setup()
from django.test import RequestFactory
from django.contrib.auth.models import AnonymousUser
from Schoolapp import views
import json
rf = RequestFactory()
req = rf.post('/inscriptions/add/', data={'etudiant':'1','formation':'1','groupe':'A'})
req.user = AnonymousUser()
resp = views.add_inscription(req)
print('ADD status', getattr(resp, 'status_code', 'N/A'))
print(resp.content.decode())

# For edit, try calling with a missing id to see error handling
req2 = rf.post('/inscriptions/edit/', data={'id':'1','formation':'1'})
req2.user = AnonymousUser()
resp2 = views.edit_inscription(req2)
print('EDIT status', getattr(resp2, 'status_code', 'N/A'))
print(resp2.content.decode())
