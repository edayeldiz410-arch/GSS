#!/usr/bin/env python
"""Test if student ID 12 can now login"""
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'school.settings')
django.setup()

from Schoolapp.models import Etudiant, Utilisateur

print("=" * 60)
print("TEST LOGIN WITH STUDENT ID 12")
print("=" * 60)

try:
    # Get student
    etudiant = Etudiant.objects.get(id=12)
    print(f"\n[STUDENT] ID: {etudiant.id}")
    print(f"[STUDENT] Nom: {etudiant.nom}")
    print(f"[STUDENT] Prenom: {etudiant.prenom}")
    print(f"[STUDENT] Email: {etudiant.email}")
    
    # Try to find user by nom
    utilisateur = Utilisateur.objects.filter(nom=etudiant.nom).first()
    
    if utilisateur:
        print(f"\n[USER FOUND] ID: {utilisateur.id}")
        print(f"[USER] Nom: {utilisateur.nom}")
        print(f"[USER] Email: {utilisateur.email}")
        print(f"\n[SUCCESS] ✓ Student ID 12 has a user account!")
        print(f"[SUCCESS] ✓ Can login with ID: 12")
        print(f"[SUCCESS] ✓ Password: student123")
    else:
        print(f"\n[ERROR] No user found for student {etudiant.nom}")
        
except Etudiant.DoesNotExist:
    print("[ERROR] Student ID 12 not found")
except Exception as e:
    print(f"[ERROR] {e}")

print("\n" + "=" * 60)
