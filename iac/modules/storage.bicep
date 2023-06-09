param sgName string
param sgContainerName string = 'orders'
param location string = resourceGroup().location
param sku string
param kind string = 'StorageV2'
param tier string = 'Hot'

resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: sgName
  location: location
  kind: kind
  sku:{
    name:sku
  }
  properties:{
    accessTier: tier
  }
}

resource ordcont 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-02-01' = {
  name: '${stg.name}/default/${sgContainerName}'
  properties:{
    publicAccess: 'None'
  }
}



output storageAccountConnectionString string = 'DefaultEndpointsProtocol=https;AccountName=${sgName};AccountKey=${stg.listKeys().keys[0].value};EndpointSuffix=core.windows.net'
