#!/bin/bash

# Build the Django Docker image from the application directory.

set -e

APP_DIR="../examples/django-app"
IMAGE_NAME="django-devops-app"

echo "Building Docker image: $IMAGE_NAME"

cd "$APP_DIR"

docker build -t "$IMAGE_NAME" .

echo "Docker image built successfully."
