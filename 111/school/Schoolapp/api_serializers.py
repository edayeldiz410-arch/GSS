from rest_framework import serializers
from .models import (
    Utilisateur, Enseignant, Formation, Module, Etudiant, Inscription,
    Paiement, ReglementEnseignants, CalendarEvent, Presence, Groupe,
    Fournisseur, Achat, Charge, Salle
)


class UtilisateurSerializer(serializers.ModelSerializer):
    """Serializer for user authentication and profile"""
    class Meta:
        model = Utilisateur
        fields = ['id', 'nom', 'prenom', 'email', 'statut', 'photo', 
                  'code_utilisateur', 'role', 'date_creation', 'derniere_connexion']
        read_only_fields = ['id', 'date_creation', 'derniere_connexion']


class SalleSerializer(serializers.ModelSerializer):
    """Serializer for classroom/room data"""
    class Meta:
        model = Salle
        fields = ['id', 'nom', 'capacite', 'equipements', 'statut']


class ModuleSerializer(serializers.ModelSerializer):
    """Serializer for course modules"""
    class Meta:
        model = Module
        fields = ['id', 'formation', 'titre', 'description', 'ordre', 
                  'duree', 'created_at', 'updated_at']
        read_only_fields = ['created_at', 'updated_at']


class FormationSerializer(serializers.ModelSerializer):
    """Serializer for formations/courses with nested modules"""
    modules = ModuleSerializer(many=True, read_only=True)
    total_etudiants = serializers.SerializerMethodField()
    
    class Meta:
        model = Formation
        fields = ['id', 'nom', 'contenu', 'photo', 'pdf', 'prix_etudiant', 
                  'prix_fonctionnaire', 'duree', 'branche', 'categorie', 
                  'niveau', 'date_creation', 'statut', 'modules', 'total_etudiants']
        read_only_fields = ['date_creation']
    
    def get_total_etudiants(self, obj):
        return obj.etudiants.count()


class GroupeSerializer(serializers.ModelSerializer):
    """Serializer for student groups"""
    formation_nom = serializers.CharField(source='formation.nom', read_only=True)
    total_etudiants = serializers.SerializerMethodField()
    
    class Meta:
        model = Groupe
        fields = ['id', 'nom', 'description', 'formation', 'formation_nom', 
                  'capacite', 'created_at', 'total_etudiants']
        read_only_fields = ['created_at']
    
    def get_total_etudiants(self, obj):
        return obj.etudiants.count()


class EnseignantSerializer(serializers.ModelSerializer):
    """Serializer for teachers"""
    formation_nom = serializers.CharField(source='formation.nom', read_only=True)
    
    class Meta:
        model = Enseignant
        fields = ['id', 'matricule', 'nom', 'prenom', 'email', 'telephone', 
                  'adresse', 'date_naissance', 'lieu_naissance', 'sexe', 'photo', 
                  'niveau', 'specialite', 'bio', 'date_embauche', 'salaire', 
                  'statut', 'formation', 'formation_nom', 'is_active', 
                  'created_at', 'updated_at']
        read_only_fields = ['created_at', 'updated_at', 'matricule']


class EtudiantListSerializer(serializers.ModelSerializer):
    """Lightweight serializer for student lists"""
    formation_nom = serializers.CharField(source='formation.nom', read_only=True)
    groupe_nom = serializers.CharField(source='groupe.nom', read_only=True)
    
    class Meta:
        model = Etudiant
        fields = ['id', 'nom', 'prenom', 'email', 'telephone', 'mobile', 
                  'photo', 'formation', 'formation_nom', 'groupe', 'groupe_nom', 
                  'statut', 'date_inscription']


class EtudiantDetailSerializer(serializers.ModelSerializer):
    """Detailed serializer for individual student view"""
    formation_nom = serializers.CharField(source='formation.nom', read_only=True)
    groupe_nom = serializers.CharField(source='groupe.nom', read_only=True)
    total_paiements = serializers.SerializerMethodField()
    solde_restant = serializers.SerializerMethodField()
    
    class Meta:
        model = Etudiant
        fields = '__all__'
    
    def get_total_paiements(self, obj):
        return obj.paiements.aggregate(total=serializers.models.Sum('montant'))['total'] or 0
    
    def get_solde_restant(self, obj):
        from .utils import calculate_balances
        result = calculate_balances(obj.id)
        return result.get('solde_restant', 0)


class InscriptionSerializer(serializers.ModelSerializer):
    """Serializer for student enrollments"""
    etudiant_nom = serializers.CharField(source='etudiant.__str__', read_only=True)
    formation_nom = serializers.CharField(source='formation.nom', read_only=True)
    groupe_nom = serializers.CharField(source='groupe.nom', read_only=True)
    
    class Meta:
        model = Inscription
        fields = ['id', 'etudiant', 'etudiant_nom', 'formation', 'formation_nom', 
                  'groupe', 'groupe_nom', 'date_inscription', 'statut', 
                  'progress_percent', 'prix_total', 'session', 'ecole', 'remarques']
        read_only_fields = ['date_inscription']


class PaiementSerializer(serializers.ModelSerializer):
    """Serializer for payments"""
    etudiant_nom = serializers.CharField(source='etudiant.__str__', read_only=True)
    formation_nom = serializers.CharField(source='formation.nom', read_only=True)
    
    class Meta:
        model = Paiement
        fields = ['id', 'etudiant', 'etudiant_nom', 'formation', 'formation_nom', 
                  'inscription', 'montant', 'date_paiement', 'ecole', 
                  'mode_paiement', 'numero_cheque', 'date_cheque', 
                  'compte_bancaire', 'statut', 'reference', 'balance_after', 
                  'remarques', 'created_at', 'updated_at']
        read_only_fields = ['reference', 'balance_after', 'created_at', 'updated_at']


class ReglementEnseignantsSerializer(serializers.ModelSerializer):
    """Serializer for teacher payments"""
    enseignant_nom = serializers.CharField(source='enseignant.__str__', read_only=True)
    
    class Meta:
        model = ReglementEnseignants
        fields = ['id', 'enseignant', 'enseignant_nom', 'montant', 'balance_after', 
                  'date_reglement', 'mode_reglement', 'statut', 'reference', 
                  'remarques', 'created_at', 'updated_at']
        read_only_fields = ['reference', 'balance_after', 'created_at', 'updated_at']


class CalendarEventSerializer(serializers.ModelSerializer):
    """Serializer for calendar events"""
    salle_nom = serializers.SerializerMethodField()
    total_presences = serializers.SerializerMethodField()
    
    class Meta:
        model = CalendarEvent
        fields = ['id', 'titre', 'description', 'start_datetime', 'end_datetime', 
                  'is_online', 'salle_id', 'salle_nom', 'formation_id', 
                  'formation_name', 'session_id', 'organisateur_id', 
                  'formateur_name', 'groupe', 'notifications_sent', 
                  'created_at', 'total_presences']
        read_only_fields = ['created_at']
    
    def get_salle_nom(self, obj):
        if obj.salle_id:
            try:
                salle = Salle.objects.get(id=obj.salle_id)
                return salle.nom
            except Salle.DoesNotExist:
                return None
        return None
    
    def get_total_presences(self, obj):
        return obj.presences.count()


class PresenceSerializer(serializers.ModelSerializer):
    """Serializer for attendance records"""
    etudiant_nom = serializers.CharField(source='etudiant.__str__', read_only=True)
    event_titre = serializers.CharField(source='calendar_event.titre', read_only=True)
    
    class Meta:
        model = Presence
        fields = ['id', 'etudiant', 'etudiant_nom', 'calendar_event', 
                  'event_titre', 'statut', 'remarques']


class ChargeSerializer(serializers.ModelSerializer):
    """Serializer for expenses/charges"""
    formation_nom = serializers.CharField(source='formation.nom', read_only=True)
    
    class Meta:
        model = Charge
        fields = ['id', 'type_charge', 'montant', 'date_paiement', 
                  'mode_paiement', 'reference', 'remarque', 'formation', 
                  'formation_nom', 'contact']
        read_only_fields = ['reference']


class FournisseurSerializer(serializers.ModelSerializer):
    """Serializer for suppliers"""
    total_achats = serializers.SerializerMethodField()
    solde_restant = serializers.SerializerMethodField()
    
    class Meta:
        model = Fournisseur
        fields = ['id', 'nom', 'contact', 'email', 'telephone', 'adresse', 
                  'remarques', 'created_at', 'total_achats', 'solde_restant']
        read_only_fields = ['created_at']
    
    def get_total_achats(self, obj):
        return obj.achats.aggregate(total=serializers.models.Sum('total'))['total'] or 0
    
    def get_solde_restant(self, obj):
        from django.db.models import Sum
        total_achats = obj.achats.aggregate(total=Sum('total'))['total'] or 0
        total_reglements = obj.reglements.aggregate(total=Sum('montant'))['total'] or 0
        return float(total_achats) - float(total_reglements)


class DashboardStatsSerializer(serializers.Serializer):
    """Serializer for dashboard statistics"""
    total_students = serializers.IntegerField()
    total_teachers = serializers.IntegerField()
    total_formations = serializers.IntegerField()
    total_revenue = serializers.DecimalField(max_digits=12, decimal_places=2)
    total_expenses = serializers.DecimalField(max_digits=12, decimal_places=2)
    pending_payments = serializers.DecimalField(max_digits=12, decimal_places=2)
    recent_payments = PaiementSerializer(many=True)
    upcoming_events = CalendarEventSerializer(many=True)
