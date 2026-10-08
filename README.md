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

## Choosing the provider build per case

Each case has a `provider.ref` file:

```text
# branch on the upstream repo
my-feature-branch
```

- `my-branch` builds `Azure/terraform-provider-azapi` at that branch or tag.
- `owner/repo@my-branch` builds from a fork.
- Empty (or comments only) uses the released provider.

Branches are resolved to their current commit on every CI run, so you don't update SHAs when
the branch moves. The built binary is cached per commit.

## Running in CI

Run the **Run case** workflow (Actions > Run case > Run workflow), pick a case from the
dropdown and an action: `plan`, or `apply-destroy` (apply, check for a clean follow-up plan,
then always destroy).

The dropdown is a static list in `.github/workflows/case.yml`. When you add or remove a case
folder, update it; the **Check cases** workflow fails if the two differ.

### One-off setup

- Repository variables `ARM_CLIENT_ID`, `ARM_TENANT_ID`, `ARM_SUBSCRIPTION_ID`.
- Environments `plan` (no rules) and `integration` (required reviewers).
- Entra app federated credentials for subjects
  `repo:kewalaka/azapi-scratchpad:environment:plan` and
  `repo:kewalaka/azapi-scratchpad:environment:integration`.
