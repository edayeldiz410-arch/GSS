#!/usr/bin/env python
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'school.settings')
django.setup()

from Schoolapp.models import Utilisateur, Etudiant
from datetime import date, datetime

# Supprimer si existe déjà
Utilisateur.objects.filter(email='test@test.com').delete()
Etudiant.objects.filter(email='test@test.com').delete()

# Créer un compte de test
user = Utilisateur.objects.create(
    nom='Dupont',
    prenom='Jean',
    email='test@test.com',
    mot_de_passe='test123',
    role='etudiant',
    statut='actif',
    etat_compte='actif',
    date_creation=datetime.now()
)

# Créer le profil étudiant
etudiant = Etudiant.objects.create(
    nom='Dupont',
    prenom='Jean',
    email='test@test.com',
    date_inscription=date.today(),
    statut='inscrit'
)

print(f'✓ Utilisateur créé: ID={user.id}, Email={user.email}, Nom={user.nom}')
print(f'✓ Étudiant créé: ID={etudiant.id}, Email={etudiant.email}, Nom={etudiant.nom}')
print(f'\nModes de login disponibles:')
print(f'  1. Email (test@test.com) + Password (test123)')
print(f'  2. Nom (Dupont) + Password (test123)')
print(f'  3. ID Étudiant ({etudiant.id}) + Password (test123)')
print(f'  4. ID Étudiant ({etudiant.id}) SANS mot de passe')
