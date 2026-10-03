# Docker

This section demonstrates Docker fundamentals through a containerized Django application and practical Docker administration tasks.

## What I Implemented

- Docker image creation using a Dockerfile
- Containerized a Django application
- Docker port mapping
- Container lifecycle management
- Container logs and interactive shell access
- Docker volumes for persistent data
- Docker custom networking
- Container-to-container communication
- Docker automation using Bash scripts
- Django health-check endpoint for container validation

## Project Structure

```text 
03-docker/
├── examples/
│   └── django-app/
│       ├── config/
│       ├── core/
│       ├── manage.py
│       ├── requirements.txt
│       ├── Dockerfile
│       └── .dockerignore
│
├── screenshots/
│   ├── django-docker-app.png
│   ├── docker-volume.png
│   └── docker-network.png
│
├── scripts/
│   ├── build-image.sh
│   ├── run-container.sh
│   └── cleanup.sh
│
└── README.md
