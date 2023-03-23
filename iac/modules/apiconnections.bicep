targetScope= 'resourceGroup'
param location string = resourceGroup().location
param connName string = 'office365'
param region string = 'uksouth'

var resourceType  = 'Microsoft.Web/locations/managedApis'

resource office365con 'Microsoft.Web/connections@2016-06-01' = {
  name: connName
  location: location
  properties: {
    api: {
      brandColor: 'string'
      description: 'Outlook connector.'
      displayName: 'Outlook 365'
      iconUri: 'https://connectoricons-prod.azureedge.net/releases/v1.0.1535/1.0.1535.2609/office365/icon.png'
      name: connName
      type: resourceType
      id: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Web/locations/${region}/managedApis/${connName}'
    }
  }
}

var validityTimeSpan ={
  validityTimeSpan:'30'
}

var key = office365con.listConnectionKeys('2018-07-01-preview',validityTimeSpan).connectionKey
output apiKey string = key

var url = office365con.properties.connectionRuntimeUrl
output connRuntimeUrl string = any(url)

