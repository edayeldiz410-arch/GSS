from django.db import migrations, models
import django.db.models.deletion

class Migration(migrations.Migration):

    dependencies = [
        ('Schoolapp', '0004_enseignant'),
    ]

    operations = [
        migrations.CreateModel(
            name='Fournisseur',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nom', models.CharField(max_length=255)),
                ('contact', models.CharField(max_length=255, null=True, blank=True)),
                ('email', models.EmailField(max_length=255, null=True, blank=True)),
                ('telephone', models.CharField(max_length=50, null=True, blank=True)),
                ('adresse', models.TextField(null=True, blank=True)),
                ('remarques', models.TextField(null=True, blank=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
            ],
            options={'db_table': 'fournisseur'},
        ),
        migrations.CreateModel(
            name='Achat',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('date_achat', models.DateField(auto_now_add=False)),
                ('reference', models.CharField(max_length=100, null=True, blank=True, unique=True)),
                ('total', models.DecimalField(max_digits=12, decimal_places=2, default=0)),
                ('statut', models.CharField(max_length=50, default='en_attente')),
                ('remarques', models.TextField(null=True, blank=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('fournisseur', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='achats', db_column='fournisseur_id', to='Schoolapp.Fournisseur')),
            ],
            options={'db_table': 'achat'},
        ),
        migrations.CreateModel(
            name='AchatItem',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('description', models.CharField(max_length=512)),
                ('quantite', models.DecimalField(max_digits=10, decimal_places=2, default=1)),
                ('prix_unitaire', models.DecimalField(max_digits=12, decimal_places=2, default=0)),
                ('achat', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='items', db_column='achat_id', to='Schoolapp.Achat')),
            ],
            options={'db_table': 'achat_item'},
        ),
        migrations.CreateModel(
            name='ReglementFournisseur',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('montant', models.DecimalField(max_digits=12, decimal_places=2)),
                ('date_reglement', models.DateField(auto_now_add=False)),
                ('mode', models.CharField(max_length=50, null=True, blank=True)),
                ('reference', models.CharField(max_length=100, null=True, blank=True, unique=True)),
                ('balance_after', models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)),
                ('remarques', models.TextField(null=True, blank=True)),
                ('fournisseur', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='reglements', db_column='fournisseur_id', to='Schoolapp.Fournisseur')),
                ('achat', models.ForeignKey(on_delete=django.db.models.deletion.SET_NULL, related_name='reglements', db_column='achat_id', to='Schoolapp.Achat', null=True, blank=True)),
            ],
            options={'db_table': 'reglement_fournisseur'},
        ),
    ]
