#!/bin/bash

# Stop if a command fails or an unset variable is used.
set -euo pipefail

# Namespace and Deployment to inspect.
NAMESPACE="${1:-devops-api}"
DEPLOYMENT="${2:-django-api}"

echo "=== Deployment status ==="
kubectl get deployment "$DEPLOYMENT" -n "$NAMESPACE"

echo
echo "=== Pods ==="
kubectl get pods -n "$NAMESPACE" -o wide

echo
echo "=== Services ==="
kubectl get services -n "$NAMESPACE"

echo
echo "=== Recent namespace events ==="
kubectl get events -n "$NAMESPACE" \
  --sort-by='.metadata.creationTimestamp' | tail -n 15

echo
echo "=== Deployment rollout history ==="
kubectl rollout history deployment/"$DEPLOYMENT" \
  -n "$NAMESPACE"

echo
echo "=== Current application logs ==="
kubectl logs deployment/"$DEPLOYMENT" \
  -n "$NAMESPACE" --tail=50

echo
echo "Troubleshooting snapshot complete."
