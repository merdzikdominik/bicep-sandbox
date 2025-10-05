targetScope = 'resourceGroup'

param envName string
param location string
param namingPrefix string
param vmSize string
param subnetCidrs array
param tags object

module vnet '../modules/network/vnet.bicep' = {
  name: 'vnet01'
  params: {
    name: '${namingPrefix}-vnet01'
    location: location
    addressSpace: ['10.10.0.0/16']
    subnetCidrs: subnetCidrs
    tags: tags
    attachNsgToAllSubnets: true
    nsgId: nsg.outputs.id
  }
}

module nsg '../modules/network/nsg.bicep' = {
  name: 'nsg01'
  params: {
    name: '${namingPrefix}-nsg01'
    location: location
    tags: tags
    allowSsh: true
    allowedSshSource: '*'
  }
}

module kv '../modules/network/keyvault.bicep' = {
  name: 'kv01'
  params: {
    name: '${namingPrefix}-kv01'
    location: location
    tags: tags
  }
}

module la '../modules/platform/log-analytics.bicep' = {
  name: 'la01'
  params: {
    name: '${namingPrefix}-la01'
    location: location
    tags: tags
  }
}

module vm '../modules/compute/vm.bicep' = {
  name: 'vm01'
  params: {
    name: '${namingPrefix}-vm01'
    location: location
    vmSize: vmSize
    subnetId: vnet.outputs.subnetIds[0]
    tags: tags
    adminUsername: 'azureuser'
    sshPublicKey: 'ssh-ed25519 AAAA... user@host'
    createPublicIp: true
  }
}
