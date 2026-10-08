# Key Vault diagnostic settings (AzAPI issue 995)

Tests `list_unique_id_property` and `ignore_other_items_in_list` against Key Vault
diagnostic settings. Adjust the `logs` list in `main.tf` and re-run plan to see how
list matching and ignored items behave.
