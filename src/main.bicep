targetScope = 'subscription'

@allowed(['dev', 'stg', 'prod'])
param envName string
param location string
param namingPrefix string
param vmSize string
param subnetCidrs array
param tags object

var rgName = '${namingPrefix}-rg'

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: rgName
  location: location
  tags: tags
}

module env './stacks/env-stack.bicep' = {
  name: 'stack-${envName}'
  scope: rg
  params: {
    envName: envName
    location: location
    namingPrefix: namingPrefix
    vmSize: vmSize
    subnetCidrs: subnetCidrs
    tags: tags
  }
}
