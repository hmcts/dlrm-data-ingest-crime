resource "azurerm_role_assignment" "blob_landing_data_contributor" {
  scope                = data.azurerm_storage_account.langing_storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azuread_group.dlrm_crime_admin.id

}