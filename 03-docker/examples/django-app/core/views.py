from django.http import JsonResponse


def home(request):
    return JsonResponse({
        "application": "Django DevOps Demo",
        "status": "running",
        "message": "Hello from Khush's Docker project!"
    })


def health(request):
    return JsonResponse({
        "status": "healthy"
    })
