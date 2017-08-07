"""Creates the airflow database."""


def GenerateConfig(context):
  resources = [{
      'name': context.env['name'],
      'type': 'sqladmin.v1beta4.database',
      'properties': {
        # 'instance': '$(ref.' + context.properties['instance-name'] + '.selfLink)'
        'instance': context.properties['instance-name']
      }
  }]
  return {'resources': resources}
