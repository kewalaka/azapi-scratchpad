data "azapi_client_config" "current" {
}

resource "azapi_resource" "resourceGroup" {
  type     = "Microsoft.Resources/resourceGroups@2023-07-01"
  name     = "acctestRG12321"
  location = "Australia East"
}

resource "azapi_resource" "vault" {
  type      = "Microsoft.KeyVault/vaults@2025-05-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestvault12321"
  location  = azapi_resource.resourceGroup.location
  body = {
    properties = {
      enableRbacAuthorization   = true
      enableSoftDelete          = true
      publicNetworkAccess       = "Enabled"
      softDeleteRetentionInDays = 7
      sku = {
        family = "A"
        name   = "standard"
      }      
      tenantId = data.azapi_client_config.current.tenant_id
    }
  }
}

resource "azapi_resource" "workspace" {
  type      = "Microsoft.OperationalInsights/workspaces@2025-07-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestlaw12321"
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
