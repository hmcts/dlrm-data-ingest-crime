// Resources in this file are purely for example purposes, remove these and replace with your own resources.

# resource "azurerm_storage_account" "this" {
#   for_each                 = var.landing_zones
#   name                     = "ingest${each.key}${var.env}example"
#   resource_group_name      = data.azurerm_resource_group.lz["ingest${each.key}-main-${var.env}"].name
#   location                 = data.azurerm_resource_group.lz["ingest${each.key}-main-${var.env}"].location
#   account_tier             = "Standard"
#   account_kind             = "StorageV2"
#   account_replication_type = "LRS"
#   tags                     = local.common_tags
# }


resource "azurerm_role_assignment" "blob_data_reader" {
  scope                = data.azurerm_storage_account.langing_storage.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = data.azurerm_databricks_access_connector.unity_catalog.identity[0].principal_id
}

resource "azurerm_role_assignment" "blob_data_contributor" {
  scope                = data.azurerm_storage_account.langing_storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_databricks_access_connector.unity_catalog.identity[0].principal_id

}