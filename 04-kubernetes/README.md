# Kubernetes Django REST API

A containerized Django REST API deployed to Kubernetes using Minikube. This project demonstrates application deployment, service discovery, configuration management, health checks, persistent storage, database migrations, resource constraints, rollout management, and troubleshooting.

## Architecture

```text
Developer
   |
   v
Minikube NodePort :30080
   |
   v
Kubernetes Service
   |
   v
Django API Deployment
   |-- Liveness probe: /health/
   |-- Readiness probe: /ready/
   |-- ConfigMap: application configuration
   |-- Secret: environment configuration
   |-- Resource requests and limits
   |
   v
PersistentVolumeClaim
   |
   v
SQLite database: /data/db.sqlite3
```

The API is packaged in a Docker image and runs inside a Kubernetes Pod. The Service exposes the application through NodePort 30080. A PersistentVolumeClaim provides storage for the SQLite database.

## Project structure

```text
04-kubernetes/
├── app/
│   ├── api/
│   │   ├── models.py
│   │   ├── serializers.py
│   │   ├── views.py
│   │   └── tests.py
│   ├── config/
│   ├── Dockerfile
│   ├── requirements.txt
│   └── manage.py
├── manifests/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── pvc.yaml
│   ├── migration-job.yaml
│   ├── deployment.yaml
│   └── service.yaml
├── scripts/
│   └── troubleshoot.sh
└── README.md
```

## Prerequisites

* Docker
* kubectl
* Minikube
* Git
* Python for optional local development

Verify the tools:

```bash
docker --version
kubectl version --client
minikube version
```

## Build and deploy

### 1. Start Minikube

```bash
minikube start --driver=docker
kubectl get nodes
```

### 2. Build the application image

Check the image tag in `manifests/deployment.yaml` and build the same tag:

```bash
grep -n 'image:' 04-kubernetes/manifests/deployment.yaml
```

From the repository root, build the image using the tag configured in the manifest. For example, if the manifest specifies version `1.4`:

```bash
minikube image build -t kubernetes-django-api:1.4 04-kubernetes/app
```

If you choose a new version, update the image tag in the Deployment and migration Job manifests consistently before deploying.

### 3. Apply configuration and storage

```bash
kubectl apply -f 04-kubernetes/manifests/namespace.yaml
kubectl apply -f 04-kubernetes/manifests/configmap.yaml
kubectl apply -f 04-kubernetes/manifests/pvc.yaml
```

Create or apply the Secret using the locally configured values. Do not commit real credentials to Git.

### 4. Run database migrations

Apply `migration-job.yaml` after confirming its image tag matches the image you built:

```bash
kubectl apply -f 04-kubernetes/manifests/migration-job.yaml
kubectl wait --for=condition=complete job/django-api-migrate \
  -n devops-api --timeout=120s
```

For subsequent releases, use a uniquely named migration Job or replace the completed Job safely. Kubernetes does not allow arbitrary changes to an existing Job's Pod template.

### 5. Deploy the API and Service

```bash
kubectl apply -f 04-kubernetes/manifests/deployment.yaml
kubectl apply -f 04-kubernetes/manifests/service.yaml

kubectl rollout status deployment/django-api -n devops-api
kubectl get deployments,pods,services,pvc -n devops-api
```

## API endpoints

| Endpoint      | Purpose                                          |
| ------------- | ------------------------------------------------ |
| `/`           | API landing response                             |
| `/health/`    | Liveness and health check                        |
| `/ready/`     | Readiness check, including database connectivity |
| `/api/tasks/` | Task API and CRUD operations                     |

Task records support title, description, status, priority, and timestamps. Supported status and priority filters are implemented in the API.

Test the deployed endpoints:

```bash
curl -i http://$(minikube ip):30080/health/
curl -i http://$(minikube ip):30080/ready/
curl -i http://$(minikube ip):30080/api/tasks/
```

## Configuration and security

* ConfigMap: non-sensitive application settings.
* Secret: sensitive configuration supplied to the application.
* Resource requests: CPU and memory used for scheduling.
* Resource limits: constrain CPU and memory consumption.
* `.dockerignore` and `.gitignore`: exclude development artifacts and local data.

Never commit real passwords, tokens, private keys, or production credentials. Kubernetes Secrets are not automatically an encrypted secrets-management solution.

## Persistent storage

The Deployment mounts the `django-api-data` PersistentVolumeClaim at `/data`. The database path is `/data/db.sqlite3`.

Pod replacement does not automatically delete the PVC. However, deleting the PVC or losing the underlying Minikube storage can cause data loss.

SQLite is appropriate for this learning exercise. For a production deployment with multiple API replicas, use an appropriate external database such as PostgreSQL rather than sharing a SQLite database file.

## Operations and troubleshooting

Inspect resources:

```bash
kubectl get deployments,pods,services -n devops-api
kubectl describe deployment django-api -n devops-api
kubectl get events -n devops-api \
  --sort-by='.metadata.creationTimestamp'
```

View logs:

```bash
kubectl logs deployment/django-api -n devops-api --tail=100
```

Inspect rollout history and status:

```bash
kubectl rollout status deployment/django-api -n devops-api
kubectl rollout history deployment/django-api -n devops-api
```

Roll back to the previous revision:

```bash
kubectl rollout undo deployment/django-api -n devops-api
kubectl rollout status deployment/django-api -n devops-api
```

Run the diagnostic script from the repository root:

```bash
./04-kubernetes/scripts/troubleshoot.sh
```

Check resource metrics if Metrics Server is enabled:

```bash
kubectl top nodes
kubectl top pods -n devops-api
```

## Cleanup

Remove application resources only when you no longer need them:

```bash
kubectl delete -f 04-kubernetes/manifests/service.yaml
kubectl delete -f 04-kubernetes/manifests/deployment.yaml
```

Database migration Jobs and the PVC are deliberately not deleted by these commands. Review and manage them separately. Do not delete the PVC unless you have decided that its stored data is no longer needed.

## Learning outcomes

* Containerized a Django REST API.
* Deployed and exposed an application using Kubernetes.
* Configured health and readiness probes.
* Used ConfigMaps and Kubernetes Secrets.
* Applied CPU and memory requests and limits.
* Ran database migrations as a Kubernetes Job.
* Configured persistent storage with a PVC.
* Tested Pod replacement and database persistence.
* Practiced rollout history, rollback, and troubleshooting.
* Documented an application deployment for a DevOps portfolio.

## Future enhancements

Planned improvements include RBAC, NetworkPolicies, HPA, Ingress, Helm, Kustomize, Prometheus, Grafana, CI/CD integration, and deployment to a managed Kubernetes environment
