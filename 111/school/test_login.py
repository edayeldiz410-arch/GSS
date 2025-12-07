#!/usr/bin/env python
"""
Test script for login functionality
Tests all 4 login methods
"""
import requests
from http.cookies import SimpleCookie

BASE_URL = "http://localhost:8000"
SESSION = requests.Session()

def test_login(identifier, password=None, description=""):
    """Test a login attempt"""
    print(f"\n{'='*60}")
    print(f"TEST: {description}")
    print(f"{'='*60}")
    print(f"Identifier: {identifier}")
    print(f"Password: {password if password else '(NONE - empty)'}")
    
    # Get the login page first to get CSRF token
    response = SESSION.get(f"{BASE_URL}/")
    print(f"[Step 1] GET /: Status {response.status_code}")
    
    # Extract CSRF token
    import re
    csrf_match = re.search(r'name="csrfmiddlewaretoken" value="([^"]+)"', response.text)
    csrf_token = csrf_match.group(1) if csrf_match else None
    print(f"[Step 2] CSRF Token: {csrf_token[:20]}..." if csrf_token else "[Step 2] CSRF Token: NOT FOUND")
    
    if not csrf_token:
        print("ERROR: Could not find CSRF token!")
        return False
    
    # Prepare login data
    data = {
        'action': 'login',
        'identifier': identifier,
        'csrfmiddlewaretoken': csrf_token
    }
    
    if password is not None:
        data['password'] = password
    
    # Send login request
    response = SESSION.post(f"{BASE_URL}/", data=data, allow_redirects=False)
    print(f"[Step 3] POST /: Status {response.status_code}")
    
    # Check if redirected to dashboard
    if response.status_code == 302:
        location = response.headers.get('Location', '')
        print(f"[Step 4] Redirect to: {location}")
        if 'dashboard' in location:
            print("✅ SUCCESS - Login worked!")
            return True
        else:
            print("❌ FAILED - Redirect not to dashboard")
            return False
    else:
        # Check for error message
        if 'invalide' in response.text.lower() or 'error' in response.text.lower():
            print("❌ FAILED - Error message shown")
            # Try to extract error
            error_match = re.search(r'<div class="alert alert-error">([^<]+)</div>', response.text)
            if error_match:
                print(f"   Error: {error_match.group(1)}")
        else:
            print(f"❓ UNCLEAR - Status {response.status_code}, no redirect")
        return False

print("\n" + "="*60)
print("LOGIN FUNCTIONALITY TEST SUITE")
print("="*60)

# Test 1: Email + Password
test_login('test@test.com', 'test123', 'Email + Password')

# Test 2: Nom + Password
test_login('Dupont', 'test123', 'Nom (Surname) + Password')

# Test 3: ID Étudiant + Password
test_login('57', 'test123', 'ID Étudiant + Password')

# Test 4: ID Étudiant ONLY (no password)
test_login('57', None, 'ID Étudiant ONLY (no password)')

# Test 5: Invalid credentials
test_login('invalid@test.com', 'wrongpassword', 'Invalid Email + Invalid Password')

print("\n" + "="*60)
print("TEST SUITE COMPLETED")
print("="*60)
