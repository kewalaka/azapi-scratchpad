data "azapi_client_config" "current" {
}

resource "azapi_resource" "resourceGroup" {
  type     = "Microsoft.Resources/resourceGroups@2023-07-01"
  name     = "acctestRG-storage-12321"
  location = "Australia East"
}

resource "azapi_resource" "storageAccount" {
  type      = "Microsoft.Storage/storageAccounts@2023-05-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestsa12321"
  location  = azapi_resource.resourceGroup.location
  body = {
    kind = "StorageV2"
    sku = {
      name = "Standard_LRS"
    }
    properties = {
      accessTier                   = "Hot"
      allowBlobPublicAccess        = false
      minimumTlsVersion            = "TLS1_2"
      supportsHttpsTrafficOnly     = true
      publicNetworkAccess          = "Enabled"
      allowSharedKeyAccess         = true
    }
  }
}

# The blob service is auto-created, we just need to reference it
data "azapi_resource_id" "blobService" {
  type      = "Microsoft.Storage/storageAccounts/blobServices@2023-05-01"
  parent_id = azapi_resource.storageAccount.id
  name      = "default"
}

resource "azapi_resource" "workspace" {
  type      = "Microsoft.OperationalInsights/workspaces@2025-07-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestlaw-storage-12321"
  location  = azapi_resource.resourceGroup.location
  body = {
    properties = {
      sku                             = { name = "PerGB2018" }
      retentionInDays                 = 30
      publicNetworkAccessForIngestion = "Enabled"
      publicNetworkAccessForQuery     = "Enabled"
    }
  }
}
