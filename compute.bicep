targetScope = 'resourceGroup'

param vmName string
param location string
param vmSize string
param nicName string
param subnetId string

resource vm 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: { vmSize: vmSize }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
          properties: { primary: true }
        }
      ]
    }
  }
}

resource myIpAddress 'Microsoft.Network/publicIpAddresses@2023-06-01' = {
  name: 'myIpAddress'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
//    publickIpAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: myIpAddress
          subnet: { id: subnetId }
        }
      }
    ]
  }
}
