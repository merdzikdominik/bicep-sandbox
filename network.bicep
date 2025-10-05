targetScope = 'resourceGroup'

param vnetName string
param location string
param subnetName string 

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefixes: [
            '10.0.1.0/24'
          ]
        }
      }
    ]
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' existing = {
  name: vnet.properties.subnets[0].name
}

output subnetId string = subnet.id
