from django.test import TestCase
from Schoolapp.utils import calculate_balances
from Schoolapp.models import Etudiant, Formation, Inscription, Paiement
from decimal import Decimal
from datetime import date


class CalculateBalancesTests(TestCase):
    def setUp(self):
        self.f = Formation.objects.create(nom='Test Formation', prix_etudiant=1000)
        self.etu = Etudiant.objects.create(nom='Doe', prenom='John')
        # create an inscription with total price
        self.ins = Inscription.objects.create(etudiant=self.etu, formation=self.f, prix_total=Decimal('1000.00'))

    def test_no_payments(self):
        res = calculate_balances(self.etu.id, montant=0)
        self.assertEqual(res['total_due'], 1000.0)
        self.assertEqual(res['prev_paid'], 0.0)
        self.assertEqual(res['ancien_solde'], 1000.0)
        self.assertEqual(res['apres_solde'], 1000.0)

    def test_with_previous_payments(self):
        Paiement.objects.create(etudiant=self.etu, formation=self.f, montant=Decimal('300.00'), date_paiement=date.today())
        res = calculate_balances(self.etu.id, montant=0)
        self.assertEqual(res['prev_paid'], 300.0)
        self.assertEqual(res['ancien_solde'], 700.0)
        # simulate a new payment of 200
        res2 = calculate_balances(self.etu.id, montant=Decimal('200.00'))
        self.assertEqual(res2['apres_solde'], 500.0)

    def test_exclude_current_payment(self):
        p = Paiement.objects.create(etudiant=self.etu, formation=self.f, montant=Decimal('100.00'), date_paiement=date.today())
        # exclude this payment when recalculating
        res = calculate_balances(self.etu.id, montant=Decimal('50.00'), exclude_payment_pk=p.pk)
        # prev_paid should be 0 (excluded)
        self.assertEqual(res['prev_paid'], 0.0)
        self.assertEqual(res['ancien_solde'], 1000.0)
        self.assertEqual(res['apres_solde'], 950.0)
