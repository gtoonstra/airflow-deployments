#!/bin/bash

ID=$(docker build -q -f Dockerfile -t airflow-k8s .)
docker tag $ID airflow-k8s:1.8.1
docker tag $ID airflow-k8s:latest
docker tag $ID 192.168.99.1:5000/airflow-k8s:latest
docker tag $ID 192.168.99.1:5000/airflow-k8s:1.8.1

docker push 192.168.99.1:5000/airflow-k8s:latest
docker push 192.168.99.1:5000/airflow-k8s:1.8.1
