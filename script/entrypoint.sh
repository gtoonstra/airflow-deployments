#!/usr/bin/env bash

AIRFLOW_HOME="/usr/local/airflow"
CMD="airflow"
TRY_LOOP="20"

: ${REDIS_HOST:="airflow-redis"}
: ${REDIS_PORT:="6379"}
: ${REDIS_PASSWORD:=""}

: ${SQL_HOST:="airflow-db"}
: ${SQL_PORT:="3306"}
: ${SQL_DATABASE:="airflow"}
: ${SQL_USER:="airflow"}
: ${SQL_PASSWORD:="airflow"}

: ${FERNET_KEY:=$(python -c "from cryptography.fernet import Fernet; FERNET_KEY = Fernet.generate_key().decode(); print(FERNET_KEY)")}

# Install custom python package if requirements.txt is present
if [ -e "/requirements.txt" ]; then
    $(which pip) install --user -r /requirements.txt
fi

# Update airflow config - Fernet key
sed -i "s|\$FERNET_KEY|$FERNET_KEY|" "$AIRFLOW_HOME"/airflow.cfg

if [ -n "$REDIS_PASSWORD" ]; then
    REDIS_PREFIX=:${REDIS_PASSWORD}@
else
    REDIS_PREFIX=
fi

# Wait for the database
if [ "$1" = "webserver" ] || [ "$1" = "worker" ] || [ "$1" = "scheduler" ] ; then
  i=0
  while ! nc -z $SQL_HOST $SQL_PORT >/dev/null 2>&1 < /dev/null; do
    i=$((i+1))
    if [ "$1" = "webserver" ]; then
      echo "$(date) - waiting for ${SQL_HOST}:${SQL_PORT}... $i/$TRY_LOOP"
      if [ $i -ge $TRY_LOOP ]; then
        echo "$(date) - ${SQL_HOST}:${SQL_PORT} still not reachable, giving up"
        exit 1
      fi
    fi
    sleep 10
  done
fi

# Wait for Redis
if [ "$1" = "webserver" ] || [ "$1" = "worker" ] || [ "$1" = "scheduler" ] || [ "$1" = "flower" ] ; then
  j=0
  while ! nc -z $REDIS_HOST $REDIS_PORT >/dev/null 2>&1 < /dev/null; do
    j=$((j+1))
    if [ $j -ge $TRY_LOOP ]; then
      echo "$(date) - $REDIS_HOST still not reachable, giving up"
      exit 1
    fi
    echo "$(date) - waiting for Redis... $j/$TRY_LOOP"
    sleep 5
  done
fi
sed -i "s#celery_result_backend = db+mysql://airflow:airflow@airflow-database/airflow#celery_result_backend = db+mysql://$SQL_USER:$SQL_PASSWORD@$SQL_HOST:$SQL_PORT/$SQL_DATABASE#" "$AIRFLOW_HOME"/airflow.cfg
sed -i "s#sql_alchemy_conn = mysql+mysqldb://airflow:airflow@airflow-database/airflow#sql_alchemy_conn = mysql+mysqldb://$SQL_USER:$SQL_PASSWORD@$SQL_HOST:$SQL_PORT/$SQL_DATABASE#" "$AIRFLOW_HOME"/airflow.cfg
sed -i "s#broker_url = redis://redis:6379/1#broker_url = redis://$REDIS_PREFIX$REDIS_HOST:$REDIS_PORT/1#" "$AIRFLOW_HOME"/airflow.cfg
if [ "$1" = "webserver" ]; then
  echo "Initialize database..."
  exec $CMD webserver
else
  sleep 10
  exec $CMD "$@"
fi
