#!/bin/bash

# Stop and remove the Django Docker container.

CONTAINER_NAME="django-devops-container"

echo "Cleaning up Docker container..."

if docker ps -a --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"
then
    docker rm -f "$CONTAINER_NAME"
    echo "Container removed: $CONTAINER_NAME"
else
    echo "Container does not exist."
fi

echo "Cleanup complete."
