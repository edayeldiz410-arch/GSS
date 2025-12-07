#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import sys
import django

if sys.stdout.encoding != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'school.settings')
django.setup()

from Schoolapp.models import Etudiant, Utilisateur
from datetime import datetime

print("="*70)
print("CREATE UTILISATEUR FOR STUDENTS WITHOUT USER")
print("="*70)

# Find all students
all_etudiants = Etudiant.objects.all()
missing_users = []

# Check which students have no user
for e in all_etudiants:
    u = None
    if e.email:
        u = Utilisateur.objects.filter(email__iexact=e.email).first()
    if not u and e.nom:
        u = Utilisateur.objects.filter(nom__iexact=e.nom).first()
    
    if not u:
        missing_users.append(e)

print(f"\n[INFO] Found {len(missing_users)} students without user")
print(f"[INFO] Total students: {all_etudiants.count()}")

if missing_users:
    print("\n[INFO] Creating users for these students...")
    created_count = 0
    
    for e in missing_users:
        try:
            # Use email if available, else create a simple one
            email = e.email if e.email else f"{e.nom.lower().replace(' ', '')}{e.id}@geniedschool.local"
            password = "student123"  # Default password
            
            # Check if email already exists
            if Utilisateur.objects.filter(email__iexact=email).exists():
                print(f"  [SKIP] Email already exists: {email}")
                continue
            
            # Create user
            user = Utilisateur.objects.create(
                nom=e.nom if e.nom else "UNKNOWN",
                prenom=e.prenom if e.prenom else "STUDENT",
                email=email,
                mot_de_passe=password,
                role='etudiant',
                statut='actif',
                etat_compte='actif',
                date_creation=datetime.now()
            )
            created_count += 1
            print(f"  [CREATED] User {user.id}: {e.nom} {e.prenom} ({email})")
            
        except Exception as ex:
            print(f"  [ERROR] Failed to create user for {e.nom}: {str(ex)}")
    
    print(f"\n[SUCCESS] Created {created_count} users!")
else:
    print("\n[SUCCESS] All students have users!")

print("\n" + "="*70)
print("VERIFICATION")
print("="*70)

# Verify etudiant 12
etudiant_12 = Etudiant.objects.filter(id=12).first()
if etudiant_12:
    print(f"\n[CHECK] Student ID 12:")
    print(f"  Name: {etudiant_12.nom} {etudiant_12.prenom}")
    print(f"  Email: {etudiant_12.email}")
    
    # Check if user exists
    user = None
    if etudiant_12.email:
        user = Utilisateur.objects.filter(email__iexact=etudiant_12.email).first()
    if not user and etudiant_12.nom:
        user = Utilisateur.objects.filter(nom__iexact=etudiant_12.nom).first()
    
    if user:
        print(f"  User: YES (ID={user.id}, Email={user.email})")
        print(f"\n[SUCCESS] Student 12 can now login with ID!")
    else:
        print(f"  User: NO - Still has no user!")

print("\n" + "="*70)
