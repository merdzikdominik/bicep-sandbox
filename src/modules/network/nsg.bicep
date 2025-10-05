targetScope = 'resourceGroup'

param name string
param location string
param tags object
param allowSsh bool = true
param allowedSshSource string = '*'

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    securityRules: concat(
      allowSsh ? [
        {
          name: 'Allow-SSH'
          properties: {
            priority: 1000
            direction: 'Inbound'
            access: 'Allow'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '22'
            sourceAddressPrefix: allowedSshSource
          }
        }
      ] : [],
      [
        {
          name: 'Allow-HTTP'
          properties: {
            priority: 1001
            direction: 'Inbound'
            access: 'Allow'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '80'
            sourceAddressPrefix: '*'
            destinationAddressPrefix: '*'
          }
        }
      ]
    )
  }
}

output id string = nsg.id
