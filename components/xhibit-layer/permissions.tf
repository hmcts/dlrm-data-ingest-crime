resource "azurerm_role_assignment" "blob_landing_data_contributor" {
  scope                = data.azurerm_storage_account.langing_storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azuread_group.dlrm_crime_admin.object_id

}

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

resource "azurerm_role_assignment" "blob_data_contributor" {
  scope                = data.azurerm_storage_account.curated_storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_databricks_access_connector.unity_catalog.identity[0].principal_id
}
