param location string = resourceGroup().location
param aksClusterName string = 'AppCluster'
param cosmosDbAccountName string = 'cosmosmlcloudacc'
param aksNodeCount int = 2
param aksNodeVmSize string = 'standard_d2s_v3'
param aksKubernetesVersion string = '1.30.6'
param cosmosDbDatabaseName string = 'mlazuredatabase'
param cosmosDbCollectionName string = 'mlazurecontainer'
param acrName string = 'mlacrcloudunibuc'

resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-01-01' = {
  name: aksClusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: '${aksClusterName}-dns'
    agentPoolProfiles: [
      {
        name: 'nodepool1'
        count: aksNodeCount
        vmSize: aksNodeVmSize
        osType: 'Linux'
        mode: 'System'
      }
    ]
    kubernetesVersion: aksKubernetesVersion
    enableRBAC: true
    networkProfile: {
      networkPlugin: 'azure'
      loadBalancerSku: 'standard'
    }
  }
}

resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2023-03-15' = {
  name: cosmosDbAccountName
  location: location
  kind: 'MongoDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
        failoverPriority: 0
      }
    ]
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
  }
}

resource cosmosDbDatabase 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2023-03-15' = {
  name: '${cosmosDbAccountName}/${cosmosDbDatabaseName}'
  dependsOn: [
    cosmosDbAccount
  ]
  properties: {
    resource: {
      id: cosmosDbDatabaseName
    }
  }
}

resource cosmosDbCollection 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections@2023-03-15' = {
  name: '${cosmosDbAccountName}/${cosmosDbDatabaseName}/${cosmosDbCollectionName}'
  dependsOn: [
    cosmosDbDatabase
  ]
  properties: {
    resource: {
      id: cosmosDbCollectionName
      shardKey: {
        partitionKey: 'Hash'
      }
      indexes: [
        {
          key: {
            keys: [
              'query'
            ]
          }
        }
        {
          key: {
            keys: [
              'timestamp'
            ]
          }
        }
      ]
    }
  }
}

resource acr 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: false
  }
}

output aksClusterName string = aksClusterName
output cosmosDbAccountName string = cosmosDbAccountName

// need link acr to aks, didn't have enough permissions on azure to automate this

