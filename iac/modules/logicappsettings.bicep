param logicAppName string
param logicAppStorageName string
param appInsightsName string
param serviceBusName string
param storageAccountConnectionString string
param location string = resourceGroup().location
param office365ConRuntimeUrl string

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appInsightsName
}

resource siteLogicApp 'Microsoft.Web/sites@2022-03-01' existing = {
  name: logicAppName
}

resource logicAppStorageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' existing = {  
  name: logicAppStorageName
}



resource serviceBus 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' existing = {  
  name: serviceBusName
}

resource functionAppAppsettings 'Microsoft.Web/sites/config@2022-03-01' = {
  parent: siteLogicApp
  name: 'appsettings'
  properties: {
    APP_KIND: 'workflowApp'
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsights.properties.InstrumentationKey
    APPLICATIONINSIGHTS_CONNECTION_STRING: appInsights.properties.ConnectionString
    AzureFunctionsJobHost__extensionBundle__id: 'Microsoft.Azure.Functions.ExtensionBundle.Workflows'
    AzureFunctionsJobHost__extensionBundle__version: '[1.*, 2.0.0)'
    AzureWebJobsStorage: 'DefaultEndpointsProtocol=https;AccountName=${logicAppStorageName};AccountKey=${logicAppStorageAccount.listKeys().keys[0].value};EndpointSuffix=core.windows.net'
    FUNCTIONS_EXTENSION_VERSION: '~4'
    FUNCTIONS_WORKER_RUNTIME: 'node'
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING: 'DefaultEndpointsProtocol=https;AccountName=${logicAppStorageName};AccountKey=${logicAppStorageAccount.listKeys().keys[0].value};EndpointSuffix=core.windows.net'
    WEBSITE_CONTENTSHARE: toLower(logicAppName)
    WEBSITE_NODE_DEFAULT_VERSION: '~14'
    FUNCTIONS_V2_COMPATIBILITY_MODE: 'true'
    WORKFLOWS_SUBSCRIPTION_ID: subscription().subscriptionId
    WORKFLOWS_LOCATION_NAME: location
    WEBSITE_RUN_FROM_PACKAGE: '1'
    serviceBus_connectionString: serviceBus.listKeys().primaryConnectionString
    AzureBlob_connectionString: storageAccountConnectionString
    office365_connectionRuntimeUrl: office365ConRuntimeUrl
  }
}


