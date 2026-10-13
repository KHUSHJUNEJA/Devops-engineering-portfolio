from django.db import connection
from django.http import JsonResponse
from rest_framework import viewsets
from rest_framework.response import Response
from rest_framework.decorators import api_view

from .models import Task
from .serializers import TaskSerializer


class TaskViewSet(viewsets.ModelViewSet):
    """
    CRUD API for managing DevOps tasks.
    """

    serializer_class = TaskSerializer

    def get_queryset(self):
        queryset = Task.objects.all().order_by("-created_at")

        status = self.request.query_params.get("status")
        priority = self.request.query_params.get("priority")

        if status:
            queryset = queryset.filter(status=status)

        if priority:
            queryset = queryset.filter(priority=priority)

        return queryset


@api_view(["GET"])
def home(request):
    return Response({
        "application": "Kubernetes Django REST API",
        "version": "1.0",
        "status": "running",
        "endpoints": {
            "tasks": "/api/tasks/",
            "health": "/health/",
            "ready": "/ready/",
        },
    })


@api_view(["GET"])
def health(request):
    return Response({
        "status": "healthy",
    })


@api_view(["GET"])
def ready(request):
    try:
        connection.ensure_connection()

        return Response({
            "status": "ready",
            "database": "connected",
        })

    except Exception:
        return Response(
            {
                "status": "not ready",
                "database": "unavailable",
            },
            status=503,
        )
