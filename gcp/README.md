# Airflow on kubernetes

This is a templated way to deploy airflow onto kubernetes and 
initialize everything in the process.

It is heavily inspired by the examples on the GCP documentation site.

### Usage

The *.py files are imported into the yaml file. The yaml file is a high level
organization of the network and how airflow gets deployed and passes the relevant
properties down into the templates.

Change the top level constants in the airflow-on-k8s.py file to rename resources the
way you desire.

Then run: 

```
gcloud deployment-manager deployments create airflow-on-k8s --config airflow-on-k8s.yaml
```

To delete:

```
gcloud deployment-manager deployments delete airflow-on-k8s
```

### What's next

You probably want to customize the way how things are deployed... you can add new properties
and propagate them through the templates, make them configurable, etc. 
