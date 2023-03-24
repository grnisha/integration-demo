param serviceBusName string
param location string = resourceGroup().location


resource serviceBus 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' existing = {  
  name: serviceBusName
}
resource serviceBusTopic 'Microsoft.ServiceBus/namespaces/topics@2022-10-01-preview' = {  
  parent: serviceBus
  name: 'orders'
  location: location
  properties: {  
    enableBatchedOperations: true
    enablePartitioning: false
    maxSizeInMegabytes: 1024
    requiresDuplicateDetection: false
    supportOrdering: true
  }
}

resource serviceBusSubscription 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2022-10-01-preview' = {  
  parent: serviceBusTopic
  name: 'highvalue'
  properties: {  
    enableBatchedOperations: true
    requiresSession: false
  }
}

resource serviceBusSubscriptionRule 'Microsoft.ServiceBus/namespaces/topics/subscriptions/rules@2022-10-01-preview' = {  
  parent: serviceBusSubscription
  name: 'total'
  properties: { 
    filterType: 'SqlFilter'
    sqlFilter: {  
      sqlExpression: 'orderTotal > 200'     
    } 
  }
}



resource serviceBusSubscription2 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2022-10-01-preview' = {  
  parent: serviceBusTopic
  name: 'normal'
  properties: {  
    enableBatchedOperations: true
    requiresSession: false
  }
}

resource serviceBusSubscriptionRule2 'Microsoft.ServiceBus/namespaces/topics/subscriptions/rules@2022-10-01-preview' = {  
  parent: serviceBusSubscription2
  name: 'total'
  properties: {  
    filterType: 'SqlFilter'
    sqlFilter: {  
      sqlExpression: 'orderTotal <= 200'     
    }
  }
}
