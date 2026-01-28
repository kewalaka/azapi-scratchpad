# Storage Account Diagnostic Settings Test

Test case for AzAPI issue #995 - testing `list_unique_id_property` and `ignore_other_items_in_list` with Storage Account blob service diagnostic settings.

## Storage Diagnostic Categories

- `StorageRead` - Log read operations
- `StorageWrite` - Log write operations  
- `StorageDelete` - Log delete operations

## Usage

```bash
# Copy and adjust the terraformrc for local provider dev
cp .terraformrc.example .terraformrc

# Set TF_CLI_CONFIG_FILE to use local provider
export TF_CLI_CONFIG_FILE="$PWD/.terraformrc"

# Apply
terraform apply
```

## Testing Scenarios

1. **Add categories** - Uncomment `StorageDelete` in the logs list
2. **Remove categories** - Comment out `StorageRead` or `StorageWrite`
3. **Verify plan detection** - After apply, remove a category and run `terraform plan` to verify it detects the change
