#!/usr/bin/env bash

SERVICE='airflow-external'

NODEPORT=$(kubectl get service $SERVICE -o jsonpath="{.spec.ports[0].nodePort}")
IP=$(minikube ip)

echo "Connecting on $IP:$NODEPORT"

mysql -u root -h $IP -P $NODEPORT -ptest -e "CREATE DATABASE IF NOT EXISTS airflow"
mysql -u root -h $IP -P $NODEPORT -ptest -e "CREATE USER 'airflow'@'%' IDENTIFIED BY 'airflow'"
mysql -u root -h $IP -P $NODEPORT -ptest -e "GRANT ALL PRIVILEGES ON airflow.* to 'airflow'@'%'"
mysql -u root -h $IP -P $NODEPORT -ptest -e "FLUSH PRIVILEGES"
