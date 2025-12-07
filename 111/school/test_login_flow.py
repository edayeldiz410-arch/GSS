#!/usr/bin/env python
"""Test complete login flow"""
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'school.settings')
django.setup()

from Schoolapp.models import Utilisateur, Etudiant, Inscription, Paiement

print("=" * 70)
print("FULL LOGIN & DASHBOARD TEST")
print("=" * 70)

# 1. Find user and student 
user_id = 12
try:
    utilisateur = Utilisateur.objects.get(id=user_id)
    print(f"\n[LOGIN] Found User: {utilisateur.nom} {utilisateur.prenom}")
    print(f"  Email: {utilisateur.email}")
    print(f"  Role: {utilisateur.role}")
    print(f"  Status: {utilisateur.statut}")
except:
    print(f"\n[ERROR] User {user_id} not found")
    exit(1)

# 2. Get student data
etudiant = None
try:
    # Try multiple ways to find the student
    etudiant = Etudiant.objects.get(utilisateur_id=user_id)
except:
    try:
        etudiant = Etudiant.objects.get(email=utilisateur.email)
    except:
        try:
            etudiant = Etudiant.objects.filter(nom=utilisateur.nom).first()
        except:
            pass

if etudiant:
    print(f"\n[STUDENT PROFILE] ID: {etudiant.id}")
    print(f"  Nom: {etudiant.nom} {etudiant.prenom}")
    print(f"  Email (Etudiant): {etudiant.email or 'NOT SET'}")
    print(f"  Telephone: {etudiant.telephone or 'NOT SET'}")
    print(f"  Adresse: {etudiant.adresse or 'NOT SET'}")
    print(f"  Date Naissance: {etudiant.date_naissance or 'NOT SET'}")
    print(f"  NIN: {etudiant.nin or 'NOT SET'}")
else:
    print(f"\n[WARNING] No student profile found for {utilisateur.nom}")

# 3. Get inscriptions
if etudiant:
    inscriptions = Inscription.objects.filter(etudiant=etudiant).select_related('formation')
    print(f"\n[INSCRIPTIONS] Total: {len(inscriptions)}")
    for insc in inscriptions:
        formation_name = insc.formation.nom if insc.formation else "N/A"
        print(f"  - {formation_name}")
        print(f"    Status: {insc.statut}")
        print(f"    Date: {insc.date_inscription}")
else:
    print("\n[INSCRIPTIONS] No student data")

# 4. Get paiements
if etudiant:
    paiements = Paiement.objects.filter(etudiant=etudiant).order_by('-date_paiement')
    total = sum(p.montant or 0 for p in paiements)
    paid = sum(p.montant or 0 for p in paiements if p.statut == 'payé')
    
    print(f"\n[PAIEMENTS] Total: {len(paiements)}")
    print(f"  Total Montant: {total} FCFA")
    print(f"  Total Payé: {paid} FCFA")
    print(f"  Reste: {total - paid} FCFA")
    
    print(f"\n[PAIEMENTS DETAILS]")
    for pai in paiements[:5]:
        print(f"  - {pai.montant} FCFA ({pai.statut})")
        print(f"    Date: {pai.date_paiement}")
        print(f"    Reference: {pai.reference or 'N/A'}")
else:
    print("\n[PAIEMENTS] No student data")

print("\n" + "=" * 70)
print("DASHBOARD CONTEXT IS READY")
print("=" * 70)
