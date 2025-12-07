#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import sys
import django

# Set encoding
if sys.stdout.encoding != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'school.settings')
django.setup()

from Schoolapp.models import Etudiant, Utilisateur

print("="*60)
print("DEBUG: Check etudiant with ID 12")
print("="*60)

# Find the student with ID 12
etudiant = Etudiant.objects.filter(id=12).first()
if etudiant:
    print(f"\n[FOUND] Student:")
    print(f"  ID: {etudiant.id}")
    print(f"  Nom: {etudiant.nom}")
    print(f"  Prenom: {etudiant.prenom}")
    print(f"  Email: {etudiant.email}")
    
    # Find associated user
    user = None
    
    if etudiant.email:
        user = Utilisateur.objects.filter(email__iexact=etudiant.email).first()
        if user:
            print(f"\n[FOUND] User by EMAIL:")
            print(f"  ID: {user.id}")
            print(f"  Email: {user.email}")
            print(f"  Nom: {user.nom}")
            print(f"  Role: {user.role}")
            print(f"  Password: {user.mot_de_passe}")
        else:
            print(f"\n[NOT FOUND] No user with email: {etudiant.email}")
    
    if not user and etudiant.nom:
        user = Utilisateur.objects.filter(nom__iexact=etudiant.nom).first()
        if user:
            print(f"\n[FOUND] User by NOM:")
            print(f"  ID: {user.id}")
            print(f"  Email: {user.email}")
            print(f"  Nom: {user.nom}")
            print(f"  Role: {user.role}")
            print(f"  Password: {user.mot_de_passe}")
        else:
            print(f"\n[NOT FOUND] No user with nom: {etudiant.nom}")
    
    if not user:
        print("\n[PROBLEM] No user associated with this student!")
else:
    print("[NOT FOUND] Student with ID 12 not found")

print("\n" + "="*60)
print("ANALYSIS: All students and their users")
print("="*60)

for e in Etudiant.objects.all()[:15]:
    u = None
    if e.email:
        u = Utilisateur.objects.filter(email__iexact=e.email).first()
    if not u and e.nom:
        u = Utilisateur.objects.filter(nom__iexact=e.nom).first()
    
    status = "[LINKED]" if u else "[NO USER]"
    nom_display = (e.nom if e.nom else "NULL")[:15]
    email_display = (e.email if e.email else "NULL")[:25]
    print(f"ID={e.id:2d} | Nom={nom_display:15s} | Email={email_display:25s} | {status}")

print("\n" + "="*60)
print("SOLUTION PROPOSED")
print("="*60)

# Check if some students don't have users
no_user_etudiants = []
for e in Etudiant.objects.all():
    u = None
    if e.email:
        u = Utilisateur.objects.filter(email__iexact=e.email).first()
    if not u and e.nom:
        u = Utilisateur.objects.filter(nom__iexact=e.nom).first()
    if not u:
        no_user_etudiants.append(e)

if no_user_etudiants:
    print(f"\n[WARNING] {len(no_user_etudiants)} students have no associated user!")
    print("\nFirst 5 students without user:")
    for e in no_user_etudiants[:5]:
        print(f"  - ID={e.id}, Nom={e.nom}, Email={e.email}")
else:
    print("\n[SUCCESS] All students have an associated user!")
