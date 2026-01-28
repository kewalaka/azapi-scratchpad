# Diagnostic settings for Storage Account Blob Service
# Categories: StorageRead, StorageWrite, StorageDelete
resource "azapi_resource" "blobDiagnostics" {
  type      = "Microsoft.Insights/diagnosticSettings@2021-05-01-preview"
  parent_id = data.azapi_resource_id.blobService.id
  name      = "acctest-blob-diag-12321"
  body = {
    properties = {
      workspaceId = azapi_resource.workspace.id
      logs = [
        # {
        #   category = "StorageRead"
        #   enabled  = true
        # },
        {
          category = "StorageWrite"
          enabled  = true
        },
        # {
        #   category = "StorageDelete"
        #   enabled  = true
        # },
      ]
    }
  }

  # Use category as the unique identifier for log entries
  list_unique_id_property = {
    "properties.logs" = "category"
  }

  # Only manage the logs we specify, ignore any others Azure may add
  ignore_other_items_in_list = ["properties.logs"]

  ignore_missing_property   = true
  schema_validation_enabled = true

  response_export_values = ["properties.logs"]
}

locals {
  logs           = azapi_resource.blobDiagnostics.output.properties.logs
  storage_read   = try([for l in local.logs : l.enabled if l.category == "StorageRead"][0], null)
  storage_write  = try([for l in local.logs : l.enabled if l.category == "StorageWrite"][0], null)
  storage_delete = try([for l in local.logs : l.enabled if l.category == "StorageDelete"][0], null)
}

output "storage_read_enabled" {
  value = tostring(local.storage_read)
}

output "storage_write_enabled" {
  value = tostring(local.storage_write)
}

output "storage_delete_enabled" {
  value = tostring(local.storage_delete)
}
