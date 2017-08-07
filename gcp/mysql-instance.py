# Copyright 2016 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Creates an instance to run mysql databases on."""


def GenerateConfig(context):
  resources = [{
      'name': context.env['name'],
      'type': 'sqladmin.v1beta4.instance',
      'properties': {
        'region': context.properties['region'],
        'databaseVersion': 'MYSQL_5_7',
        'settings': {
          'tier': context.properties['machine-type'],
          'activationPolicy': 'ALWAYS',
          'ipConfiguration': {
            #'authorizedNetworks': [
            #  { 'value': '192.168.99.0/24' }
            #],
            'ipv4Enabled': True,
            'requireSsl': False
          },
          'locationPreference': {
            'zone': context.properties['zone']
          },
          'backupConfiguration': {
            'binaryLogEnabled': False,
            'enabled': True,
            'startTime': '20:00'
          },
          'dataDiskSizeGb': 20,
          'dataDiskType': 'PD_SSD',
          'maintenanceWindow': {
            'day': 7,
            'hour': 12
          },
          'storageAutoResizeLimit': 100,
          'userLabels': {
            'key': 'airflow'
          }
        }
      }
  }
  ]
  return {'resources': resources}
