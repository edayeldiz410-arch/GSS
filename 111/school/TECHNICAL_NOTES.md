# 🔧 Notes Techniques - GénieSchool Mobile Platform

## Architecture & Technologies

### Frontend Stack
```
- HTML5 (Semantic markup)
- CSS3 (Flexbox, Grid, Media Queries)
- JavaScript Vanilla (No frameworks)
- Responsive Design (Mobile-first)
```

### Backend Integration
```
- Django 3.x+
- Python 3.6+
- SQLite/PostgreSQL
- Django ORM
```

### Design Philosophy
```
Flagship Apps (Apple)
├─ Minimalist UI
├─ Large touch targets (44x44px minimum)
├─ Gradient accents
├─ Smooth animations
├─ Accessibility first
└─ Performance optimized
```

---

## Code Structure

### Templates Anatomy

#### 1. Header Structure
```html
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Viewport crucial pour responsive -->
</head>
<body>
    <!-- Content -->
</body>
</html>
```

#### 2. CSS Organization
```css
/* Reset */
* { margin: 0; padding: 0; box-sizing: border-box; }

/* Variables */
--primary: #667eea;
--secondary: #764ba2;

/* Base Styles */
html, body { ... }

/* Components */
.header { ... }
.card { ... }

/* Responsive */
@media (max-width: 480px) { ... }
```

#### 3. JavaScript Patterns
```javascript
// Event Listeners
document.querySelectorAll('.btn').forEach(btn => {
    btn.addEventListener('click', function() { ... });
});

// DOM Manipulation
element.classList.add('active');
element.style.display = 'block';

// No external libraries!
```

---

## Key Implementation Details

### 1. Sticky Header
```css
.header {
    position: sticky;
    top: 0;
    z-index: 100;
}
```
⚠️ Mobile: Peut causer issues au clavier. Solution: détecter clavier ouvert

### 2. Bottom Navigation
```css
.bottom-nav {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    z-index: 999;
}

/* Padding pour content */
body { padding-bottom: 100px; }
```
✓ Reste fixe même pendant scroll

### 3. Responsive Grid
```css
.cards-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 16px;
}

@media (max-width: 768px) {
    .cards-grid {
        grid-template-columns: 1fr;
    }
}
```
✓ Adapte automatiquement nombre colonnes

### 4. Gradient Buttons
```css
.btn-primary {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    transition: all 0.3s ease;
}

.btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
}
```
✓ Smooth hover avec lift effect

### 5. Progress Bars
```css
.progress-bar {
    background: #e0e0e0;
    height: 6px;
    border-radius: 3px;
    overflow: hidden;
}

.progress-fill {
    background: linear-gradient(90deg, #667eea, #764ba2);
    height: 100%;
    transition: width 0.3s ease;
}
```
✓ Dynamic width avec {{ progress_percent }}%

---

## Django Integration Points

### 1. Views Connection

```python
# views.py - login_view()
def login_view(request):
    if request.method == 'POST':
        action = request.POST.get('action', 'login')
        
        if action == 'register':
            # Create Utilisateur
            user = Utilisateur.objects.create(
                nom=nom,
                prenom=prenom,
                email=email,
                mot_de_passe=password,
                role='etudiant',  # KEY
                statut='actif',
                date_creation=datetime.utcnow()
            )
            
            # Create Etudiant profile
            Etudiant.objects.create(
                nom=nom,
                prenom=prenom,
                email=email,
                date_inscription=date.today(),
                statut='inscrit'
            )
            
            return render(..., {'success': 'Compte créé'})
    
    return render(request, 'login.html', {...})
```

### 2. Dashboard Auto-Switch

```python
# views.py - dashboard()
def dashboard(request):
    user_id = request.session.get('user_id')
    if not user_id:
        return redirect('login')
    
    user = Utilisateur.objects.get(id=user_id)
    
    # KEY: Auto-switch pour étudiants
    if user.role == 'etudiant':
        return render(request, 'dashboard_etudiant.html', {'user': user})
    
    # Sinon dashboard admin
    nb_etudiants = Etudiant.objects.count()
    return render(request, 'dashboard.html', {...})
```

### 3. Template Context

```python
# Passer données au template
context = {
    'inscriptions': Inscription.objects.filter(etudiant=etudiant),
    'paiements': Paiement.objects.filter(etudiant=etudiant),
    'events': CalendarEvent.objects.filter(...),
    'user': user,
}
return render(request, 'dashboard_etudiant.html', context)
```

---

## Performance Optimizations

### 1. CSS
```css
/* Grouper media queries */
@media (max-width: 480px) {
    /* Tous styles mobiles ensemble */
}

/* Utiliser transform + opacity pour animations */
transform: translateY(-4px);  /* GPU accelerated */
opacity: 0.5;
```

### 2. Images
```html
<!-- Responsive images -->
<img src="..." alt="..." style="max-width: 100%; height: auto;">

<!-- Lazy loading -->
<img loading="lazy" src="..." alt="...">
```

### 3. JavaScript
```javascript
/* Éviter manipulation DOM répétée */
let cards = document.querySelectorAll('.card'); // Cache
cards.forEach(card => {
    card.addEventListener('click', handler);
});

/* Event delegation pour listes dynamiques */
document.addEventListener('click', (e) => {
    if (e.target.matches('.btn-action')) {
        handleAction(e.target);
    }
});
```

### 4. CSS Animations
```css
/* GPU-accelerated properties */
transform: translateY(-2px);  ✓ Fast
opacity: 0.5;                  ✓ Fast
filter: brightness(0.9);       ✓ Fast

/* Non-optimized */
left: 100px;                   ✗ Slow (layout)
width: 50%;                    ✗ Slow (layout)
```

---

## Accessibility

### 1. Semantic HTML
```html
<!-- Good -->
<header>...</header>
<nav>...</nav>
<main>...</main>
<button>Envoyer</button>

<!-- Bad -->
<div class="header">...</div>
<div class="btn">Envoyer</div>
```

### 2. Labels & Forms
```html
<!-- Good -->
<label for="email">Email</label>
<input id="email" type="email" required>

<!-- Bad -->
<input type="text" placeholder="Email">
```

### 3. Color Contrast
```
✓ Primary (#667eea) on White: 4.5:1 ratio
✓ Text (#333) on Gray (#f5f5f7): 10:1 ratio
✓ Status (Green) on White: 4.5:1 ratio
```

### 4. Touch Targets
```css
/* Minimum 44x44px */
.btn { padding: 12px 16px; } /* Plus grand sur mobile */
.nav-item { padding: 12px; }
```

---

## Security Considerations

### 🔴 Current Issues
```
1. Mots de passe non hachés
   → Solution: utiliser make_password(password)

2. Pas de CSRF protection
   → Solution: {% csrf_token %} dans forms

3. Données sensibles en session
   → Solution: session sécurisée + HTTPS

4. No input validation côté serveur
   → Solution: forms.py + validation Django
```

### ✅ Best Practices

```python
# 1. Hash passwords
from django.contrib.auth.hashers import make_password

user = Utilisateur.objects.create(
    email=email,
    mot_de_passe=make_password(password),  # ← Hashé
    role='etudiant'
)

# 2. CSRF Token
# Tous forms Django incluent {% csrf_token %}

# 3. HTTPS
# En production: DEBUG=False + HTTPS

# 4. Input Validation
from django import forms

class RegisterForm(forms.Form):
    email = forms.EmailField()
    password = forms.CharField(min_length=8)
    # Django valide automatiquement
```

---

## Browser Compatibility

```
✓ Chrome 90+
✓ Firefox 88+
✓ Safari 14+
✓ Edge 90+
✗ IE11 (pas CSS Grid support)

Mobile:
✓ iOS Safari 14+
✓ Chrome Mobile
✓ Samsung Internet
✓ Firefox Mobile
```

### Fallbacks Needed
```css
/* Grid fallback */
display: grid;
grid-template-columns: 1fr;

@supports (display: grid) {
    /* Grid-specific styles */
}
```

---

## Testing Checklist

### Unit Tests
```python
def test_student_creation(self):
    user = Utilisateur.objects.create(
        email='test@gmail.com',
        role='etudiant'
    )
    etudiant = Etudiant.objects.filter(email=user.email)
    self.assertTrue(etudiant.exists())
```

### Integration Tests
```python
def test_login_flow(self):
    # Create user
    # Login
    # Check session
    # Check dashboard
```

### UI Tests
```javascript
// Cypress/Selenium
describe('Login Page', () => {
    it('should create account', () => {
        cy.visit('/');
        cy.contains('Créer un compte').click();
        cy.get('#nom').type('Test');
        cy.get('button[type=submit]').click();
        cy.contains('Compte créé').should('be.visible');
    });
});
```

---

## Deployment Checklist

### Pre-Deploy
- [ ] Vérifier DEBUG = False
- [ ] Configurer ALLOWED_HOSTS
- [ ] Vérifier SECRET_KEY (aléatoire)
- [ ] HTTPS activé
- [ ] Database migré
- [ ] Static files collectés
- [ ] Tester sur vrais appareils

### Server Setup
```bash
# Production server
gunicorn school.wsgi:application --bind 0.0.0.0:8000

# Reverse proxy (Nginx)
# Static files serving
# SSL certificates
# Database backups
```

---

## Monitoring & Analytics

### Core Web Vitals
```
LCP (Largest Contentful Paint): < 2.5s
FID (First Input Delay): < 100ms
CLS (Cumulative Layout Shift): < 0.1
```

### Monitoring
```python
# Django middleware pour logs
class PerformanceMiddleware:
    def __call__(self, request):
        start = time.time()
        response = self.get_response(request)
        duration = time.time() - start
        logger.info(f"{request.path} took {duration}s")
        return response
```

---

## Common Issues & Solutions

### Problem: Sticky header conflicts with keyboard
**Solution**: 
```css
@media (max-height: 600px) {
    .header {
        position: relative;
    }
}
```

### Problem: Bottom nav covers content on small screens
**Solution**:
```css
body {
    padding-bottom: 80px; /* Ajuster avec taille nav */
}
```

### Problem: Images ne scale pas
**Solution**:
```css
img {
    max-width: 100%;
    height: auto;
}
```

### Problem: Form fields zoom on mobile
**Solution**:
```css
input {
    font-size: 16px; /* >= 16px evite zoom */
}
```

---

## Resources

### Documentation
- Django: https://docs.djangoproject.com/
- MDN Web Docs: https://developer.mozilla.org/
- CSS Tricks: https://css-tricks.com/

### Tools
- Chrome DevTools (Inspect, Performance, Lighthouse)
- BrowserStack (Device testing)
- Lighthouse (Performance audit)
- Axe DevTools (Accessibility)

### References
- Apple HIG: https://developer.apple.com/design/
- Material Design: https://material.io/
- Web.dev: https://web.dev/

---

## Version History

```
v1.0 - Initial Release
├─ Login/Register with student auto-creation
├─ Student dashboard
├─ Profile management
├─ Inscriptions tracking
├─ Payments management
├─ Planning/Calendar
├─ Mobile-first responsive design
└─ Documentation

Future:
- PWA capabilities
- Offline support
- Mobile app (React Native)
- Backend optimization
- Analytics dashboard
```

---

**Last Updated**: December 7, 2024
**Status**: Production Ready (Frontend)
**Maintainer**: Development Team
