# Docker Fundamentals and Django Application

A hands-on Docker project demonstrating containerization, image creation, container lifecycle management, port mapping, networking, persistent storage concepts, and shell-script automation.

## Project Overview

Docker packages an application and its dependencies into a portable image that can run consistently across different environments.

In this project, a Django web application is containerized and run as a Docker container. Supporting Bash scripts automate image builds, container startup, and cleanup.

### Objectives

* Understand the difference between Docker images and containers.
* Build a custom Docker image using a Dockerfile.
* Run a Django application inside a container.
* Publish a container port to the Kali Linux host.
* Inspect container status, logs, configuration, and resource usage.
* Practice Docker networking and volume concepts.
* Automate common Docker operations with Bash scripts.

## Architecture

```text
Developer
   |
   | docker build
   v
Dockerfile + Django application
   |
   v
Docker Image: django-devops-app
   |
   | docker run
   v
Container: django-devops-container
   |
   | Port mapping
   v
Kali Linux host browser / curl
   |
   v
Django application
   |
   +---- /          Application endpoint
   |
   +---- /health/   Health-check endpoint
```

## Project Structure

```text
03-docker/
├── README.md
├── examples/
│   ├── Dockerfile
│   └── django-app/
│       ├── Dockerfile
│       ├── .dockerignore
│       ├── manage.py
│       ├── requirements.txt
│       └── ...
├── scripts/
│   ├── build-image.sh
│   ├── run-container.sh
│   └── cleanup.sh
└── screenshots/
    ├── django-docker-app.png
    ├── Docker-container-automation.png
    ├── docker-network.png
    └── docker-volume.png
```

*Note: The tree above describes the main project components; supporting application files may vary.*

## Prerequisites

* Linux environment (Kali Linux used during development)
* Docker Engine
* Git
* A terminal and web browser
* Basic familiarity with Linux commands

Check your environment:

```bash
docker --version
docker info
git --version
```

If `docker info` reports a permissions or daemon error, verify that Docker is running and that your user is authorized to access it.

## Step 1: Navigate to the Repository

```bash
cd ~/Downloads/Devops-engineering-portfolio
```

Inspect the Docker project:

```bash
find 03-docker -maxdepth 3 -type f | sort
```

## Step 2: Understand the Dockerfile

A Dockerfile defines the instructions used to build an image.

Inspect the application Dockerfile:

```bash
cat 03-docker/examples/django-app/Dockerfile
```

Key concepts:

* **FROM** selects the base image.
* **WORKDIR** sets the working directory inside the image.
* **COPY** copies application files into the image.
* **RUN** executes commands during the image build.
* **EXPOSE** documents the intended container port; it does not publish that port to the host.
* **CMD** specifies the default command when a container starts.

The exact instructions depend on the Dockerfile in this repository.

## Step 3: Build the Django Image

Build the image using the application directory as the build context:

```bash
docker build \
  -t django-devops-app \
  ./03-docker/examples/django-app
```

Verify that the image exists:

```bash
docker images django-devops-app
```

Inspect image metadata:

```bash
docker image inspect django-devops-app
```

### What happens during a build?

Docker reads the Dockerfile, processes its instructions, installs required dependencies, and creates reusable image layers. Docker may reuse cached layers to make subsequent builds faster.

## Step 4: Run the Container

First, check whether a container with the intended name already exists:

```bash
docker ps -a --filter name=django-devops-container
```

If no existing container uses that name, start the application:

```bash
docker run -d \
  --name django-devops-container \
  -p 8000:8000 \
  django-devops-app
```

This command assumes the image's application server listens on port `8000`. Confirm that port in the application's Dockerfile or startup command.

### Command explanation

* `docker run` creates and starts a container.
* `-d` runs it in the background.
* `--name` assigns a recognizable container name.
* `-p 8000:8000` maps host port `8000` to container port `8000`.
* `django-devops-app` is the image used to create the container.

If the name or host port is already in use, inspect the existing container or select a free host port rather than deleting resources blindly.

## Step 5: Verify the Application

Check running containers:

```bash
docker ps
```

Check application logs:

```bash
docker logs django-devops-container
```

Follow logs in real time:

```bash
docker logs -f django-devops-container
```

Press `Ctrl+C` to stop following the logs; this does not stop the container.

Test the application from the Kali terminal:

```bash
curl -i http://127.0.0.1:8000/
curl -i http://127.0.0.1:8000/health/
```

The root endpoint should return the application's response. The health endpoint should return a successful response when the application is healthy.

You can also open these URLs in your browser:

* `http://127.0.0.1:8000/`
* `http://127.0.0.1:8000/health/`

If the application uses a different port or URL configuration, adjust these checks to match the actual application.

## Step 6: Inspect the Container

View detailed container configuration:

```bash
docker inspect django-devops-container
```

View resource usage:

```bash
docker stats django-devops-container
```

View processes running inside the container:

```bash
docker top django-devops-container
```

Open a shell inside the container, if the image includes one:

```bash
docker exec -it django-devops-container sh
```

Exit the container shell with:

```bash
exit
```

## Step 7: Automate Docker Operations

The repository includes scripts for image building, container startup, and cleanup.

Inspect the scripts before executing them:

```bash
cat 03-docker/scripts/build-image.sh
cat 03-docker/scripts/run-container.sh
cat 03-docker/scripts/cleanup.sh
```

Validate their Bash syntax:

```bash
bash -n 03-docker/scripts/build-image.sh
bash -n 03-docker/scripts/run-container.sh
bash -n 03-docker/scripts/cleanup.sh
```

Run the scripts from the repository root if they expect paths relative to that directory:

```bash
bash 03-docker/scripts/build-image.sh
bash 03-docker/scripts/run-container.sh
```

Execute the cleanup script only after reviewing its commands and confirming which resources it removes:

```bash
bash 03-docker/scripts/cleanup.sh
```

Scripts may use different names, ports, or options from the manual examples. The script contents are the source of truth; keep the README synchronized with them.

## Step 8: Docker Networking

Docker networking allows containers to communicate with each other and with permitted external endpoints.

List networks:

```bash
docker network ls
```

Inspect a network:

```bash
docker network inspect bridge
```

Inspect the application container's network configuration:

```bash
docker inspect \
  --format '{{json .NetworkSettings.Networks}}' \
  django-devops-container
```

For multi-container applications, a user-defined bridge network is generally preferable to relying on container IP addresses. Containers on the same user-defined network can discover each other by container name.

Do not expose databases or internal services to the host unless access is required.

## Step 9: Docker Volumes and Persistent Data

Containers are intended to be replaceable. Data stored only in a container's writable layer may be lost when that container is removed.

List Docker volumes:

```bash
docker volume ls
```

Inspect a volume:

```bash
docker volume inspect VOLUME_NAME
```

Replace `VOLUME_NAME` with an actual volume listed by Docker.

A named volume can persist application data across container replacement when it is mounted at the correct path. Confirm the application's data directory before configuring a mount.

Important: this Django demonstration may use application-specific or SQLite storage. Do not assume that data is persistent unless the database path is backed by a correctly configured volume or another persistent storage mechanism.

## Step 10: Troubleshooting

### Container exits immediately

```bash
docker ps -a
docker logs django-devops-container
```

Check the application startup command, dependencies, configuration, and listening port.

### Application is unreachable

```bash
docker port django-devops-container
docker inspect django-devops-container
curl -i http://127.0.0.1:8000/health/
```

Verify that the application listens on `0.0.0.0` inside the container, not only on `127.0.0.1`.

### Port is already allocated

```bash
docker ps
```

Choose another free host port, for example `8001:8000`, if the container listens on port `8000`.

### Image build fails

```bash
docker image ls
docker build --no-cache \
  -t django-devops-app \
  ./03-docker/examples/django-app
```

Use `--no-cache` only when you need to diagnose caching-related issues; it forces Docker to rebuild without using cached layers.

### Container name already exists

```bash
docker ps -a --filter name=django-devops-container
```

Inspect the existing container before deciding whether to start, rename, or remove it.

### Docker daemon or permissions error

```bash
docker info
systemctl status docker
```

Use the service-management command appropriate to your environment if Docker is not running. Avoid changing socket permissions broadly as a shortcut.

## Step 11: Cleanup

Stop the application container:

```bash
docker stop django-devops-container
```

Remove the container:

```bash
docker rm django-devops-container
```

Remove the image only if you no longer need it:

```bash
docker image rm django-devops-app
```

These commands affect the named resources only. Do not run broad prune commands without checking whether other portfolio projects are using the same Docker resources.

## Screenshots

Screenshots documenting the project are stored in `screenshots/`:

* `django-docker-app.png` — Django application running in Docker.
* `Docker-container-automation.png` — Docker automation workflow.
* `docker-network.png` — Docker networking demonstration.
* `docker-volume.png` — Docker volume demonstration.

## Learning Outcomes

After completing this project, you should be able to:

* Explain the difference between an image and a container.
* Build and inspect custom Docker images.
* Run and troubleshoot a containerized Django application.
* Understand host-to-container port mapping.
* Inspect Docker logs, processes, networks, and volumes.
* Write and validate Bash scripts for Docker automation.
* Explain why persistent data and container lifecycle management matter in DevOps.

## Future Improvements

* Add a Docker Compose configuration for multi-container development.
* Add automated application tests to the image build workflow.
* Introduce container health checks and structured logging.
* Add image vulnerability scanning and non-root execution.
* Integrate the build into GitHub Actions.
* Deploy the container to Kubernetes and later to AWS.

## Repository

GitHub: `KHUSHJUNEJA/Devops-engineering-portfolio`

This project is part of a broader DevOps learning portfolio covering Linux, Git, Docker, Kubernetes, CI/CD, infrastructure as code, cloud infrastructure, and monitoring.
