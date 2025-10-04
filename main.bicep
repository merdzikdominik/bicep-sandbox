targetScope = 'resourceGroup'

@description('Nazwa VM')
param vmName string = 'vm01'

@description('Region')
param location string = resourceGroup().location

@description('Nazwa VNET')
param vnetName string = 'vnet1'

@description('Nazwa subnetu')
param subnetName string = 'subnet1'

@description('Nazwa NIC')
param nicName string = 'vm01-nic'

// var nicId = resourceId('Microsoft.Network/networkInterfaces', nicName)

@secure()
@description('Haslo admina')
param adminPassword string

@description('User admina')
param adminUsername string = 'azureuser'

param vmSize string = 'Standard_B2s'

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: { addressPrefixes: [ '10.0.0.0/16' ] }
    subnets: [
      {
        name: subnetName
        properties: { addressPrefix: '10.0.0.0/24' }
      }
    ]
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
    deleteOption: 'Delete'
    publickIpAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
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
          subnet: { id: vnet.properties.subnets[0].id }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: { vmSize: 'Standard_B2s' }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter'
        version: 'latest'
      }
      osDisk: { createOption: 'FromImage' }
    }
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
