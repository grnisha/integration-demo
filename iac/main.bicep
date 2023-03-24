param buildNumber string
param location string = resourceGroup().location

//Exixting resources -- from landing zone accelerator deployment
param logicAppName string
param logicAppStorageName string
param appInsightsName string
param serviceBusName string

// Storage account for Orders blob storage
@minLength(3)
@maxLength(24)
@description('The name of the storage account')
param sgName string
@allowed([
  'Standard_LRS'
  'Standard_GRS'
])
param sku string = 'Standard_LRS'


// Storage account for blob storage
module storageAccountModule 'modules/storage.bicep' = {
  name: 'storageAccount-${buildNumber}'
  params: {
    sgName:sgName
    location:location
    sku:sku
  }
}


// Logic app managed api connection
module apiConnection 'modules/apiconnections.bicep' = {
  name: 'apiconnections-${buildNumber}'
  params:{
    location:location
  }
}

module serviceBusTopic 'modules/servicebus.bicep' = {
  name: 'servicebus-${buildNumber}'
  params:{
    serviceBusName:serviceBusName
    location:location
  }
}
// Logic app settings
module logicAppSettingsModule 'modules/logicappsettings.bicep' = {
  name: 'functionAppSettings-${buildNumber}'
  params: {
    logicAppName: logicAppName
    logicAppStorageName: logicAppStorageName
    appInsightsName: appInsightsName
    serviceBusName: serviceBusName
    storageAccountConnectionString: storageAccountModule.outputs.storageAccountConnectionString
    location: location
    office365ConRuntimeUrl: apiConnection.outputs.connRuntimeUrl
  }  
  dependsOn:[
    storageAccountModule
    apiConnection
  ]
}
