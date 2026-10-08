resource "azapi_resource" "test" {
  type      = "Microsoft.Insights/diagnosticSettings@2021-05-01-preview"
  parent_id = azapi_resource.vault.id
  name      = "acctest12321"
  body = {
    properties = {
      workspaceId = azapi_resource.workspace.id
      logs = [
        {
          category = "AzurePolicyEvaluationDetails"
          enabled  = true
        },
        # {
        #   category = "AuditEvent"
        #   enabled  = false
        # },        
      ]
    }
  }

  # Use composite key to match log entries by both category and categoryGroup
  list_unique_id_property = {
    "properties.logs" = "category, categoryGroup"
  }

#   # Only manage the logs we specify, ignore any others Azure may add
  ignore_other_items_in_list = ["properties.logs"]

  ignore_missing_property = true
  schema_validation_enabled = true

  response_export_values = ["properties.logs"]
}

locals {
  logs = azapi_resource.test.output.properties.logs
  audit_event_enabled = try([for l in local.logs : l.enabled if l.category == "AuditEvent"][0], null)
  azure_policy_evaluation_details_enabled = try([for l in local.logs : l.enabled if l.category == "AzurePolicyEvaluationDetails"][0], null)
}

output "audit_event_enabled" {
  value = tostring(local.audit_event_enabled)
}

output "azure_policy_evaluation_details_enabled" {
  value = tostring(local.azure_policy_evaluation_details_enabled)
}