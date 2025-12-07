"""
Minimal test views for diagnosing deployment issues.
These views don't access the database and should always work.
"""
import logging
from django.http import JsonResponse
from django.views.decorators.http import require_http_methods

logger = logging.getLogger(__name__)

@require_http_methods(["GET"])
def test_simple(request):
    """Ultra-simple test endpoint that does nothing but return JSON."""
    logger.info("[test_simple] Processing request...")
    return JsonResponse({
        'status': 'ok',
        'message': 'Simple test endpoint works',
    })

@require_http_methods(["GET"])
def test_template(request):
    """Test that template rendering works."""
    logger.info("[test_template] Processing request...")
    from django.shortcuts import render
    return render(request, 'test.html', {
        'status': 'ok',
        'message': 'Template test endpoint works',
    })

@require_http_methods(["GET"])
def test_db(request):
    """Test that database connection works."""
    logger.info("[test_db] Attempting database query...")
    try:
        from Schoolapp.models import Utilisateur
        count = Utilisateur.objects.count()
        logger.info(f"[test_db] Database query succeeded. Users count: {count}")
        return JsonResponse({
            'status': 'ok',
            'message': 'Database connection works',
            'user_count': count,
        })
    except Exception as e:
        logger.exception(f"[test_db] Database error: {e}")
        return JsonResponse({
            'status': 'error',
            'message': f'Database error: {e}',
        }, status=500)
