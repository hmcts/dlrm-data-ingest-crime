# Account-level provider (alias)
data "azurerm_key_vault_secret" "databricks_account_id" {
  name         = "databricks-account-id"
  key_vault_id = data.azurerm_key_vault.default_lz_vault.id
}

provider "databricks" {
  alias      = "account"
  host       = "https://accounts.azuredatabricks.net" # Azure Accounts API endpoint
  account_id = data.azurerm_key_vault_secret.databricks_account_id.value
}

data "databricks_metastore" "this" {
  count        = var.assign_account == "true" ? 1 : 0
  provider     = databricks.account
  metastore_id = var.metastore_id
}
