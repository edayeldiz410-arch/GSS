# 📚 Guide: Comment Tester la Plateforme Mobile

## 1️⃣ Démarrer le Serveur

```bash
cd C:\Users\derin\Pictures\GSS-master\GSS-master\111\school
python manage.py runserver 0.0.0.0:8000
```

✅ Le serveur tourne sur `http://localhost:8000/`

---

## 2️⃣ Créer un Compte Étudiant

### Via le formulaire d'enregistrement (Facile)

1. Accédez à `http://localhost:8000/`
2. Cliquez sur "Créer un compte"
3. Remplissez:
   - Nom: `Dupont`
   - Prénom: `Jean`
   - Email: `jean@gmail.com`
   - Mot de passe: `test123`
4. Cliquez "Créer un compte"

**Résultat:**
- ✅ Utilisateur créé avec role='etudiant'
- ✅ Profil Etudiant créé automatiquement
- ✅ Redirect vers dashboard étudiant

---

## 3️⃣ Remplir le Profil Étudiant

1. Cliquez sur le lien "Compléter mon profil" ou allez à `/student/profile/edit/`
2. Remplissez:
   - Téléphone: `+226 70 000 000`
   - Adresse: `Rue du Savoir, Ouagadougou`
   - Situation: `Employé`
   - Upload Carte ID: `(optionnel)`
   - Upload Extrait naissance: `(optionnel)`
3. Cliquez "Enregistrer"

**Résultat:**
- ✅ Profil sauvegardé dans la BDD
- ✅ Vous verrez le % de complétion augmenter

---

## 4️⃣ Ajouter des Formations (Admin)

Vous avez besoin d'un compte admin pour cette étape.

### Créer un Compte Admin

```bash
python manage.py createsuperuser
```

Répondez:
- Username: `admin`
- Email: `admin@genieschool.com`
- Password: `admin123`

Puis accédez à `/admin/` et connectez-vous.

### Ajouter des Formations

1. Dans l'admin Django (`/admin/`)
2. Allez à "Formations" 
3. Cliquez "Ajouter une formation"
4. Remplissez:
   - **Nom:** `Python Avancé`
   - **Description:** `Maîtriser Python pour le développement`
   - **Duree:** `30`
   - **Prix:** `500000` (FCFA)
   - **Groupe:** `GR1`

5. Répétez pour:
   - **Web Moderne** - 40h - 600000 FCFA - GR2
   - **Design UI/UX** - 25h - 450000 FCFA - GR1

**Résultat:**
- ✅ Formations créées dans la BDD

---

## 5️⃣ Inscrire l'Étudiant aux Formations (Admin)

1. Dans l'admin Django (`/admin/`)
2. Allez à "Inscriptions"
3. Cliquez "Ajouter une inscription"
4. Remplissez:
   - **Etudiant:** `Dupont Jean` (recherchez par email)
   - **Formation:** `Python Avancé`
   - **Date d'inscription:** `Aujourd'hui`
   - **Statut:** `Inscrit`
5. Cliquez "Enregistrer"

6. Répétez pour les 2 autres formations

**Résultat:**
- ✅ Accédez à `http://localhost:8000/student/inscriptions/`
- ✅ Vous verrez les 3 formations listées!

---

## 6️⃣ Ajouter des Paiements (Admin)

1. Dans l'admin Django (`/admin/`)
2. Allez à "Paiements"
3. Cliquez "Ajouter un paiement"
4. Remplissez:
   - **Etudiant:** `Dupont Jean`
   - **Formation:** `Python Avancé` (optionnel)
   - **Montant:** `500000`
   - **Date de paiement:** `Aujourd'hui`
   - **Statut:** `Payé`
5. Cliquez "Enregistrer"

6. Ajoutez un 2e paiement:
   - **Formation:** `Web Moderne`
   - **Montant:** `250000` (paiement partiel)
   - **Statut:** `En attente`

**Résultat:**
- ✅ Accédez à `http://localhost:8000/student/payments/`
- ✅ Vous verrez:
  - Total dû: 1,550,000 FCFA
  - Total payé: 500,000 FCFA
  - Total en attente: 250,000 FCFA
  - Les 2 paiements dans l'historique

---

## 7️⃣ Ajouter des Événements/Cours (Admin)

1. Dans l'admin Django (`/admin/`)
2. Allez à "Calendar Events"
3. Cliquez "Ajouter un événement"
4. Remplissez:
   - **Formation:** `Python Avancé`
   - **Date début:** `2025-12-10 09:00`
   - **Date fin:** `2025-12-10 11:00`
   - **Salle:** (si disponible)
   - **Formateur name:** `Monsieur Ahmed`
5. Cliquez "Enregistrer"

6. Ajoutez plusieurs événements pour différentes dates

**Résultat:**
- ✅ Accédez à `http://localhost:8000/student/planning/`
- ✅ Vous verrez tous les cours à venir!

---

## 8️⃣ Tester les Filtres

### Filtrer les Formations
- Allez à `/student/inscriptions/`
- Cliquez sur "En cours" pour filtrer
- URL change à `?status=en_cours`

### Filtrer les Paiements
- Allez à `/student/payments/`
- Cliquez sur "Payés" pour filtrer
- Vous verrez uniquement les paiements payés

---

## 9️⃣ Vérifier les Données en Base

```bash
# Ouvrir la console Python Django
python manage.py shell

# Importer les modèles
>>> from Schoolapp.models import Utilisateur, Etudiant, Inscription, Paiement

# Compter les enregistrements
>>> Utilisateur.objects.count()
1

>>> Etudiant.objects.count()
1

>>> Inscription.objects.count()
3

>>> Paiement.objects.count()
2

# Voir les détails d'un étudiant
>>> etudiant = Etudiant.objects.first()
>>> etudiant.nom
'Dupont'

>>> etudiant.formations
# Montre les formations

>>> etudiant.paiements
# Montre les paiements

# Quitter
>>> exit()
```

---

## 🔟 Teste les URLs Directement

```bash
# Vérifier la réponse JSON des APIs
curl http://localhost:8000/student/dashboard/

# Tester avec filtres
curl "http://localhost:8000/student/payments/?status=paye"

# Vérifier la santé du serveur
curl http://localhost:8000/health/
```

---

## 📊 Dashboard Étudiant - À Quoi S'attendre

Quand vous accédez à `/student/dashboard/`:

```
┌─────────────────────────────────────┐
│  GénieSchool          [Déconnexion] │
├─────────────────────────────────────┤
│  Bienvenue, Jean! 👋                │
│  Voici votre progression...         │
├─────────────────────────────────────┤
│  [3]  [€500k]  [€250k]  [€800k]    │ ← Vos stats
│  Form  Payé    Attente  Reste      │
├─────────────────────────────────────┤
│  Mes Formations:                    │
│  ┌─────────────────┐ ┌────────────┐│
│  │ Python Avancé   │ │ Web Moderne││
│  │ Inscrit • 75%   │ │ En attente ││
│  │ Voir détails →  │ │ 50% payé   ││
│  └─────────────────┘ └────────────┘│
├─────────────────────────────────────┤
│  État Financier:                    │
│  ┌──────────────┐ ┌───────────────┐│
│  │ Paiement 1   │ │ Paiement 2    ││
│  │ ✓ Payé       │ │ ⏳ En attente  ││
│  │ 500k FCFA    │ │ 250k FCFA     ││
│  └──────────────┘ └───────────────┘│
├─────────────────────────────────────┤
│ [🏠] [📚] [💳] [📅] [👤]            │ ← Navigation
│  Home Form  Pay  Sch  Profil       │
└─────────────────────────────────────┘
```

---

## ✅ Checklist Complète

- [ ] Serveur Django démarre
- [ ] Compte étudiant créé
- [ ] Profil complété
- [ ] Formations ajoutées (admin)
- [ ] Étudiant inscrit aux formations
- [ ] Paiements créés
- [ ] Événements créés
- [ ] Dashboard affiche les données
- [ ] Inscriptions affiche les formations
- [ ] Payments affiche l'état financier
- [ ] Planning affiche les événements
- [ ] Filtres fonctionnent
- [ ] Navigation marche

---

## 🆘 Problèmes Courants

### "Aucune formation"
**Cause:** L'étudiant n'est pas inscrit
**Solution:** Aller à l'admin et créer une inscription

### "Aucun paiement"
**Cause:** Pas de paiements créés
**Solution:** Aller à l'admin et créer un paiement

### "Les données ne s'actualisent pas"
**Cause:** Cache du navigateur
**Solution:** F5 ou Ctrl+Shift+R pour hard refresh

### "Erreur 500"
**Cause:** Problème de configuration
**Solution:** Regarder les logs du serveur (terminal)

---

## 📞 Support

Si vous avez des problèmes:

1. Vérifier les logs du serveur Django
2. Vérifier la connexion à MySQL
3. Lancer `python manage.py check`
4. Consulter les fichiers logs

---

**Bon test! 🚀**
