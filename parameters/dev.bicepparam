using '../src/main.bicep'

param envName = 'dev'
param location = 'westeurope'
param namingPrefix = 'acme-dev'
param vmSize = 'Standard_B2s'
param subnetCidrs = [
  '10.10.1.0/24'
]
param tags = {
  env: 'dev'
  owner: 'platform'
  costCenter: '1001'
}
