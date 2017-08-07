# airflow-deployments

Two different methods to deploy airflow:

- minikube (local development)
- google cloud platform (gcp)

(not yet) - Amazon Web Services (aws)

Each deployment prefers a managed service over a custom built image,
so you'll find managed services over docker/k8s/ecr run services.

This basically means it deploys CloudSQL, MySQL RDS, Redis Elasticache
over mysql/postgres/redis docker containers.

Minikube is considered for local development only. Another way to run
a local development environment is through docker compose, based off
the puckel/airflow repository.
