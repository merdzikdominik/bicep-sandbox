targetScope = 'resourceGroup'

param name string
param location string
param tags object

resource la 'Microsoft.OperationalInsigthts/workspaces@2022-10-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    retentionInDays: 30
    sku: { name: 'PerGB2018' }
  }
}

output id string = la.id
