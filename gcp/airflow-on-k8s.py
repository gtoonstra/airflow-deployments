NETWORK_NAME = 'airflow-k8s'
CIDR_RANGE = '10.0.0.0/16'
ZONE = 'europe-west1-b'
REGION = 'europe-west1'
# See: ttps://cloud.google.com/sql/docs/mysql/delete-instance
# ```You cannot reuse an instance name for up to a week after you have deleted an instance.```
# Keep that in mind when deleting this composition
DB_VM_INSTANCE_NAME = 'airflow-db-instance4'
DB_MACHINE_TYPE = 'db-f1-micro'
DB_NAME = 'airflow'
ROOT_PASSWORD = 'testing'
AIRFLOW_USER = 'airflow'
AIRFLOW_PASSWORD = 'airflow'


def GenerateConfig(context):
  """Creates the Compute Engine with network and firewall."""

  resources = [
  #{
  #    'name': 'cluster',
  #    'type': 'gke-template.py',
  #    'properties': {
  #        'zone': ZONE,
  #        'initialNodeCount': 2,
  #        'network': NETWORK_NAME
  #    }
  #}, 
  {
      'name': NETWORK_NAME,
      'type': 'network-template.py',
      'properties': {
          'cidr-range': CIDR_RANGE
      }
  }, {
      'name': NETWORK_NAME + '-firewall',
      'type': 'firewall-template.py',
      'properties': {
          'network': NETWORK_NAME
      }
  }, {
      'name': DB_VM_INSTANCE_NAME,
      'type': 'mysql-instance.py',
      'properties': {
          'region': REGION,
          'zone': ZONE,
          'cidr-range': CIDR_RANGE,
          'machine-type': DB_MACHINE_TYPE
      }
  }, {
      'name': DB_NAME,
      'type': 'mysql-database.py',
      'properties': {
          'instance-name': DB_VM_INSTANCE_NAME
      }
  }, {
      'name': 'root-user',
      'type': 'mysql-user.py',
      'instance': DB_NAME,
      'properties': {
          'name': 'root',
          'password': ROOT_PASSWORD,
          'instance': DB_VM_INSTANCE_NAME
      }
  }, {
      'name': 'regular-airflow-user',
      'type': 'mysql-user.py',
      'instance': DB_NAME,
      'properties': {
          'name': AIRFLOW_USER,
          'password': AIRFLOW_PASSWORD,
          'instance': DB_VM_INSTANCE_NAME
      }
  }]
  return {'resources': resources}
