# azapi-scratchpad

Small, self-contained Terraform cases for reproducing and testing
[AzAPI provider](https://github.com/Azure/terraform-provider-azapi) behaviour.

Each folder under `cases/` is an independent root module.

| Case | Purpose |
| --- | --- |
| `891-backup-policy-preflight` | Backup policy creation with preflight enabled (issue 891) |
| `995-keyvault-diagnostics` | `list_unique_id_property` / `ignore_other_items_in_list` on Key Vault diagnostics (issue 995) |
| `995-storage-diagnostics` | Same, on Storage blob service diagnostics (issue 995) |

To add a case, create `cases/<name>/` with a `terraform.tf` and `main.tf`.

## Running locally with a development provider

```bash
cp .terraformrc.example .terraformrc   # edit the path to your provider build
export TF_CLI_CONFIG_FILE="$PWD/.terraformrc"
cd cases/<name>
terraform plan   # skip `terraform init` when using dev_overrides
```

`TF_CLI_CONFIG_FILE` keeps the override scoped to your shell instead of `~/.terraformrc`.
To go back to the released provider: `unset TF_CLI_CONFIG_FILE` and run `terraform init`.

## Running in CI

Run the **Run case** workflow (Actions > Run case > Run workflow):

- `case`: folder name under `cases/`.
- `provider_ref`: branch, tag or SHA to build the provider from.
  Leave empty to skip the build and use the released provider.
- `provider_repo`: defaults to `Azure/terraform-provider-azapi`; set to a fork when needed.
- `action`: `plan`, or `apply-destroy` (applies, checks for a clean follow-up plan, then always destroys).

The built binary is cached per provider commit SHA. Azure access uses OIDC and needs the
repository variables `ARM_CLIENT_ID`, `ARM_TENANT_ID` and `ARM_SUBSCRIPTION_ID`; `apply-destroy`
requires an `integration` environment (add required reviewers there).
