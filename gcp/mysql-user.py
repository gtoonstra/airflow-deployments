"""Creates the airflow database."""


def GenerateConfig(context):
  resources = [{
      'name': context.env['name'],
      'type': 'sqladmin.v1beta4.user',
      'properties': {
        'name': context.properties['name'],
        'password': context.properties['password'],
        # 'instance': '$(ref.' + context.properties['instance'] + '.selfLink)'
        'instance': context.properties['instance']
      }
  }]
  return {'resources': resources}
