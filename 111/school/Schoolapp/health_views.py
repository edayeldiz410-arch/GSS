"""
Health check and status views that don't require database access.
"""
from django.http import JsonResponse
from django.views.decorators.http import require_http_methods


@require_http_methods(["GET"])
def health_check(request):
    """Simple health check endpoint that doesn't require database."""
    return JsonResponse({
        'status': 'ok',
        'message': 'Application is running',
    })


@require_http_methods(["GET"])
def status_view(request):
    """Status view showing application info."""
    return JsonResponse({
        'status': 'running',
        'app': 'Genie School',
    })
