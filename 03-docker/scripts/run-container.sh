#!/bin/bash

# Start the Django application as a Docker container.

set -e

IMAGE_NAME="django-devops-app"
CONTAINER_NAME="django-devops-container"
HOST_PORT=8000
CONTAINER_PORT=8000

echo "Starting container: $CONTAINER_NAME"

# Remove an old container with the same name if it exists.
if docker ps -a --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"
then
    echo "Removing existing container..."
    docker rm -f "$CONTAINER_NAME"
fi

docker run -d \
    -p "$HOST_PORT:$CONTAINER_PORT" \
    --name "$CONTAINER_NAME" \
    "$IMAGE_NAME"

echo "Container started successfully."
echo "Application: http://localhost:$HOST_PORT"
echo "Health check: http://localhost:$HOST_PORT/health/"
