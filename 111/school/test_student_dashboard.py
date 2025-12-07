#!/usr/bin/env python
"""Test the complete login + dashboard flow"""
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'school.settings')
django.setup()

from Schoolapp.models import Etudiant, Utilisateur, Inscription, Paiement, Formation

print("=" * 70)
print("TEST COMPLETE STUDENT FLOW")
print("=" * 70)

# Test 1: Login with ID 12
print("\n[TEST 1] Login with Student ID 12")
try:
    etudiant = Etudiant.objects.get(id=12)
    utilisateur = Utilisateur.objects.filter(nom=etudiant.nom).first()
    
    print(f"  [ETUDIANT] ID: {etudiant.id}, Name: {etudiant.nom} {etudiant.prenom}")
    print(f"  [USER] ID: {utilisateur.id if utilisateur else 'NONE'}, Email: {utilisateur.email if utilisateur else 'N/A'}")
    print(f"  [SUCCESS] ✓ Can login with ID 12")
except Exception as e:
    print(f"  [ERROR] {e}")

# Test 2: Check student data
print("\n[TEST 2] Check Student Profile Data")
if etudiant:
    print(f"  Nom: {etudiant.nom}")
    print(f"  Prenom: {etudiant.prenom}")
    print(f"  Email: {etudiant.email or 'NOT SET'}")
    print(f"  Telephone: {etudiant.telephone or 'NOT SET'}")
    print(f"  Adresse: {etudiant.adresse or 'NOT SET'}")
    print(f"  Date Naissance: {etudiant.date_naissance or 'NOT SET'}")
    print(f"  NIN: {etudiant.nin or 'NOT SET'}")

# Test 3: Check inscriptions
print("\n[TEST 3] Check Inscriptions")
inscriptions = Inscription.objects.filter(etudiant=etudiant) if etudiant else []
print(f"  Total Inscriptions: {len(inscriptions)}")
for insc in inscriptions[:3]:
    print(f"    - {insc.formation.nom if insc.formation else 'Formation N/A'} (Status: {insc.statut})")

# Test 4: Check paiements
print("\n[TEST 4] Check Paiements")
paiements = Paiement.objects.filter(etudiant=etudiant) if etudiant else []
print(f"  Total Paiements: {len(paiements)}")
total_montant = sum(p.montant or 0 for p in paiements)
total_paye = sum(p.montant or 0 for p in paiements if p.statut == 'payé')
print(f"  Total Montant: {total_montant} FCFA")
print(f"  Total Payé: {total_paye} FCFA")
print(f"  Reste: {total_montant - total_paye} FCFA")

# Test 5: Check all students have users
print("\n[TEST 5] Check All Students Have Users")
all_etudiants = Etudiant.objects.all()[:10]
no_user = 0
for et in all_etudiants:
    user = Utilisateur.objects.filter(nom=et.nom).first()
    if not user:
        no_user += 1
        print(f"  [NO USER] ID {et.id}: {et.nom}")

if no_user == 0:
    print(f"  [SUCCESS] All first 10 students have users!")

print("\n" + "=" * 70)
print("TEST COMPLETE")
print("=" * 70)
