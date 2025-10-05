using '../src/main.bicep'

param envName = 'stg'
param location = 'westeurope'
param namingPrefix = 'acme-stg'
param vmSize = 'Standard_D2s_v5'
param subnetCidrs = [
  '10.20.1.0/24'
]
param tags = {
  env: 'stg'
  owner: 'platform'
  costCenter: '2001'
}
