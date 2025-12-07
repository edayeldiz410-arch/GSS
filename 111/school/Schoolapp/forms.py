from django import forms
from .models import Presence, Etudiant, CalendarEvent


class PresenceForm(forms.ModelForm):
    etudiant_search = forms.CharField(required=False, label='Rechercher étudiant',
                                     widget=forms.TextInput(attrs={'placeholder': 'Nom, id, téléphone'}))

    class Meta:
        model = Presence
        fields = ['etudiant', 'calendar_event', 'statut', 'remarques']
        widgets = {
            'remarques': forms.Textarea(attrs={'rows': 3}),
        }

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # show a friendly label
        self.fields['etudiant'].queryset = Etudiant.objects.all().order_by('prenom', 'nom')
        # If creating a new Presence (no PK), limit sessions to those scheduled for today.
        try:
            if getattr(self.instance, 'pk', None):
                # editing existing presence: keep full history order
                self.fields['calendar_event'].queryset = CalendarEvent.objects.all().order_by('-start_datetime')
            else:
                # creation: only sessions/events happening today
                from django.utils import timezone
                today = timezone.localdate()
                qs = CalendarEvent.objects.filter(start_datetime__date=today).order_by('start_datetime')
                self.fields['calendar_event'].queryset = qs
        except Exception:
            # fallback to full list in case of errors
            self.fields['calendar_event'].queryset = CalendarEvent.objects.all().order_by('-start_datetime')
