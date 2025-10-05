using '../src/main.bicep'

param envName = 'prod'
param location = 'westeurope'
param namingPrefix = 'acme-prd'
param vmSize = 'Standard_D4s_v5'
param subnetCidrs = [
  '10.30.1.0/24'
]
param tags = {
  env: 'prod'
  owner: 'platform'
  costCenter: '3001'
  criticality: 'high'
}
