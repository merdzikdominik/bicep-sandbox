targetScope = 'resourceGroup'

param name string
param location string
param addressSpace array
param subnetCidrs array
param tags object
@description('If true - attach given NSG to all subnets')
param attachNsgToAllSubnets bool = false
@description('NSG Id to attach when "attachNsgToAllSubnets" is equal to true')
param nsgId string = ''

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    addressSpace: { addressPrefixes: addressSpace }
    subnets: [for (cidr, i) in subnetCidrs: {
      name: 'subnet${i+1}'
      properties: {
        addressPrefix: cidr
        networkSecurityGroup: attachNsgToAllSubnets ? { id: nsgId } : null
      }
    }]
  }
}

output id string = vnet.id
output subnetIds array = map(vnet.properties.subnets, subnet => subnet.id)
