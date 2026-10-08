data "azapi_client_config" "current" {}

resource "azapi_resource" "resourceGroup" {
  type     = "Microsoft.Resources/resourceGroups@2023-07-01"
  name     = "acctestRG-rsv-891"
  location = "Australia East"
}

resource "azapi_resource" "vault" {
  type      = "Microsoft.RecoveryServices/vaults@2025-02-01"
  parent_id = azapi_resource.resourceGroup.id
  name      = "acctestrsv891"
  location  = azapi_resource.resourceGroup.location
  body = {
    sku        = { name = "RS0", tier = "Standard" }
    properties = { publicNetworkAccess = "Enabled" }
  }
}

resource "azapi_resource" "fileShareDaily" {
  type      = "Microsoft.RecoveryServices/vaults/backupPolicies@2025-02-28-preview"
  parent_id = azapi_resource.vault.id
  name      = "acctest-fs-daily"
  body = {
    properties = {
      backupManagementType = "AzureStorage"
      workLoadType         = "AzureFileShare"
      timeZone             = "New Zealand Standard Time"
      schedulePolicy = {
        schedulePolicyType = "SimpleSchedulePolicy"
        scheduleRunFrequency = "Daily"
        scheduleRunTimes     = ["2026-01-01T02:00:00Z"]
      }
      retentionPolicy = {
        retentionPolicyType = "LongTermRetentionPolicy"
        dailySchedule = {
          retentionTimes    = ["2026-01-01T02:00:00Z"]
          retentionDuration = { count = 30, durationType = "Days" }
        }
      }
    }
  }
  schema_validation_enabled = true
  response_export_values    = ["*"]
}

