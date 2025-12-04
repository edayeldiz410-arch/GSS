from django.contrib import admin
from .models import Charge


@admin.register(Charge)
class ChargeAdmin(admin.ModelAdmin):
	list_display = ('id', 'type_charge', 'montant', 'date_paiement', 'formation', 'mode_paiement', 'reference')
	search_fields = ('type_charge', 'reference', 'remarque')
	list_filter = ('date_paiement', 'mode_paiement')

