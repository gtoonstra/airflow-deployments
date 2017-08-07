#!/usr/bin/env bash

docker run -d -p 5000:5000 --restart=always --name myregistry registry:2 
minikube start --insecure-registry="192.168.99.1:5000" --feature-gates=DynamicVolumeProvisioning=false

mkdir -p /work/airflow-minikube/dags

minikube mount /work/airflow-minikube/dags:/dags &
