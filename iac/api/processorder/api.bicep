param apiManagementServiceName string 
param logicAppName string

resource apiMgmt 'Microsoft.ApiManagement/service@2022-08-01' existing = {
  name: apiManagementServiceName
}
resource logicApp 'Microsoft.Web/sites@2022-03-01' existing = {
  name: logicAppName
}
resource api 'Microsoft.ApiManagement/service/apis@2021-08-01' = {
  parent: apiMgmt
  name: 'OrderAPI'
  properties: {
    displayName: 'Order API'
    path: 'orders'
    protocols: [
      'https'
    ]
  }
}

resource apiManagementServiceOperation 'Microsoft.ApiManagement/service/apis/operations@2021-08-01' = {
  parent: api
  name: 'ReceiveOrders'
  properties: {
    displayName: 'ReceiveOrders'
    method: 'POST'
    urlTemplate: '/OrderReceiver'
    description: 'Order Receiver'

  }
}

module laUrl 'logicappurl.bicep' =  {
  name: 'url'
  params: {
    logicAppId: logicApp.id
    workflow: 'OrderReceiver'
  }
}

resource apimPolicy 'Microsoft.ApiManagement/service/apis/operations/policies@2022-08-01' = {
  parent: apiManagementServiceOperation
  name: 'policy'
  properties: {
    value: '<policies>\r\n  <inbound>\r\n    <base />\r\n    <set-backend-service base-url="${laUrl.outputs.url.basePath}" />\r\n    <rewrite-uri template="${laUrl.outputs.url.queries}" />\r\n  </inbound>\r\n  <backend>\r\n    <base />\r\n  </backend>\r\n  <outbound>\r\n    <base />\r\n  </outbound>\r\n  <on-error>\r\n    <base />\r\n  </on-error>\r\n</policies>'
    format: 'xml'
  }
}

