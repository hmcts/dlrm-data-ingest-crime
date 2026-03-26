resource "azurerm_storage_account_network_rules" "external_storage_firewall" {
  storage_account_id = data.azurerm_storage_account.external_storage.id

  default_action = "Deny"
  bypass         = []
  ip_rules       = var.external_storage_ip_rules
}