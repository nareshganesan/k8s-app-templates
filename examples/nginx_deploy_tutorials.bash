#!/bin/bash

#### Run a Stateless Application Using a Deployment
# https://kubernetes.io/docs/tasks/run-application/run-stateless-application-deployment/

### exploring an nginx deployment

# 1. Creating the deployment

# Create a Deployment based on the YAML file
kubectl apply -f https://k8s.io/docs/tasks/run-application/deployment.yaml

# Display information about the Deployment
kubectl describe deployment nginx-deployment

# List the pods created by the deployment
kubectl get pods -l app=nginx

# Display information about a pod
kubectl describe pod <pod-name>

# 2. Updating the deployment

# Apply the new YAML file
kubectl apply -f https://k8s.io/docs/tasks/run-application/deployment-update.yaml

# Watch the deployment create pods with new names and delete the old pods
kubectl get pods -l app=nginx

# 3. Scaling the application by increasing the replica count

# Apply the new YAML file
kubectl apply -f https://k8s.io/docs/tasks/run-application/deployment-scale.yaml

# Verify that the Deployment has four pods:
kubectl get pods -l app=nginx

# 4. Deleting a deployment

# Delete the deployment by name
kubectl delete deployment nginx-deployment


