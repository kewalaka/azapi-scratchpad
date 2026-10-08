# Backup policy with preflight (AzAPI issue 891)

Repro for [Azure/terraform-provider-azapi#891](https://github.com/Azure/terraform-provider-azapi/issues/891):
creating a Recovery Services backup policy with `enable_preflight = true` reports an
unexpected (auto-generated looking) resource group name.

Compare the result of `terraform plan` with `enable_preflight` set to `true` and `false`.
