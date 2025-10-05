targetScope = 'subscription'

param rgA string
param loc string = 'westeurope'
param myVmSize string = 'Standard_B2s'
param myVmName string = 'vm01'
param myNicName string = 'nic01'

resource rga 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: rgA
  location: loc
}

module network './network.bicep' = {
  name: 'network-to-rgA'
  scope: rga
  params: {
    vnetName: 'vnet1'
    subnetName: 'subnet1'
    location: loc
  }
}

module virtualmachine './compute.bicep' = {
  name: 'vm-to-rgA'
  scope: rga
  params: {
    vmName: myVmName
    vmSize: myVmSize
    location: loc
    nicName: myNicName
    subnetId: network.outputs.subnetId
  }
}
