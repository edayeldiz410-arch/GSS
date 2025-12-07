from django.apps import apps
from django.db.models import Sum, Q


def  calculate_balances1(etudiant_id, montant=0):

    Inscription = apps.get_model('Schoolapp', 'Inscription')
    Paiement = apps.get_model('Schoolapp', 'Paiement')  



def calculate_balances(etudiant_id, payment_date=None, montant=0, exclude_payment_pk=None):
    """
    Calculate balances with ordering awareness.

    - total_due: sum of prix_total across all inscriptions for the student
    - prev_paid: sum of payments that occurred before the given payment_date (or all payments if payment_date is None).
      When payment_date is provided, payments with date < payment_date are included, and payments with the same date are
      included only if their id < exclude_payment_pk (to emulate ordering by id on equal dates). The payment with
      pk == exclude_payment_pk is excluded from the calculation.
    - ancien_solde: total_due - prev_paid (floored at 0)
    - apres_solde: ancien_solde - montant (floored at 0)
    """
    Inscription = apps.get_model('Schoolapp', 'Inscription')
    Paiement = apps.get_model('Schoolapp', 'Paiement')

    # total due across all inscriptions
    try:
        totals = Inscription.objects.filter(etudiant_id=etudiant_id).aggregate(total_due=Sum('prix_total'))
        total_due = float(totals.get('total_due') or 0.0)
        # If prix_total values are null (or zero), fall back to per-inscription formation price when available
        if total_due == 0.0:
            total_due = 0.0
            ins_qs_for_total = Inscription.objects.filter(etudiant_id=etudiant_id).select_related('formation')
            for ins in ins_qs_for_total:
                if ins.prix_total is not None:
                    total_due += float(ins.prix_total)
                else:
                    if getattr(ins, 'formation', None) and getattr(ins.formation, 'prix_etudiant', None) is not None:
                        total_due += float(ins.formation.prix_etudiant)
    except Exception:
        total_due = 0.0

    # Also include unpaid Invoice amounts (e.g. registration fees created separately)
    try:
        Invoice = apps.get_model('Schoolapp', 'Invoice')
        inv_qs = Invoice.objects.filter(inscription__etudiant_id=etudiant_id).exclude(statut__icontains='pay')
        inv_sum = float(inv_qs.aggregate(s=Sum('montant')).get('s') or 0.0)
        total_due = float(total_due) + float(inv_sum)
    except Exception:
        # ignore if Invoice model not present or query fails
        pass

    # compute previous paid according to ordering
    prev_paid = 0.0
    try:
        qs = Paiement.objects.filter(etudiant_id=etudiant_id)
        if exclude_payment_pk:
            qs = qs.exclude(pk=exclude_payment_pk)
        if payment_date is not None:
            # include payments strictly before the date
            before_q = Q(date_paiement__lt=payment_date)
            # include payments on same date but with smaller id
            if exclude_payment_pk:
                same_day_q = Q(date_paiement=payment_date) & Q(id__lt=exclude_payment_pk)
            else:
                same_day_q = Q(date_paiement=payment_date)
            qs = qs.filter(before_q | same_day_q)
        prev_paid = float(qs.aggregate(s=Sum('montant')).get('s') or 0.0)
    except Exception:
        prev_paid = 0.0

    # Allow negative balances (overpayments/credit) instead of clamping to zero
    ancien_solde = float(total_due) - float(prev_paid or 0.0)
    apres_solde = ancien_solde - float(montant or 0.0)

    return {
        'total_due': total_due,
        'prev_paid': prev_paid,
        'ancien_solde': ancien_solde,
        'apres_solde': apres_solde,
    }
