#!/usr/bin/env bash
eval $(minikube docker-env)
docker build -t hello-nodejs .
kubectl create -f hello_nodejs_deployment.yml
kubectl create -f hello_nodejs_service.yml
curl $(minikube service hello-nodejs-service --url)
