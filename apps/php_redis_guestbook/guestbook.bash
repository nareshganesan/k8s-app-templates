#!/bin/bash



kubectl apply -f redis-master-deployment.yaml
kubectl apply -f redis-master-service.yaml
sleep 4
kubectl apply -f redis-slave-deployment.yaml
kubectl apply -f redis-slave-service.yaml
sleep 4
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml

