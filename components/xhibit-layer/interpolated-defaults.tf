
data "azurerm_resource_group" "lz" {
  for_each = { for rg in local.flattened_resource_groups : rg => rg }
  name     = each.value
}

data "azurerm_virtual_network" "lz" {
  for_each            = var.landing_zones
  name                = "ingest${each.key}-vnet-${var.env}"
  resource_group_name = data.azurerm_resource_group.lz["ingest${each.key}-network-${var.env}"].name
}

data "azurerm_subnet" "lz" {
  for_each             = { for subnet in local.flattened_subnets : subnet.name => subnet }
  virtual_network_name = data.azurerm_virtual_network.lz[each.value.lz_key].name
  resource_group_name  = data.azurerm_resource_group.lz["ingest${each.value.lz_key}-network-${var.env}"].name
  name                 = each.value.name
}

data "azurerm_key_vault" "lz_vault" {
  for_each = var.landing_zones

  name                = "ingest${each.key}-meta001-${var.env}"
  resource_group_name = "ingest${each.key}-main-${var.env}"
}

data "azurerm_key_vault" "default_lz_vault" {
  name                = "ingest${local.default_lz}-meta002-${var.env}"
  resource_group_name = "ingest${local.default_lz}-main-${var.env}"
}


data "azurerm_storage_account" "langing_storage" {
  name                = "ingest${local.default_lz}landing${var.env}"
  resource_group_name = "ingest${local.default_lz}-main-${var.env}"
}

data "azurerm_storage_account" "curated_storage" {
  name                = "ingest${local.default_lz}curated${var.env}"
  resource_group_name = "ingest${local.default_lz}-main-${var.env}"
}

data "azurerm_storage_account" "external_storage" {
  name                = "ingest${local.default_lz}external${var.env}"
  resource_group_name = "ingest${local.default_lz}-main-${var.env}"
}

data "azurerm_databricks_access_connector" "unity_catalog" {
  name                = "unity-catalog-access-connector"
  resource_group_name = "ingest${local.default_lz}-product-databricks001-managed-rg"
}

data "azuread_group" "dlrm_crime_admin" {
  display_name = local.dlrm_crime_admin_group
}

module "ctags" {
  source = "github.com/hmcts/terraform-module-common-tags"

  builtFrom    = var.builtFrom
  environment  = var.env
  product      = var.product
  expiresAfter = "3000-01-01"
}

data "azurerm_key_vault_secret" "arm_xhbit_dispose_cases_sas" {
  name         = "ARM-XHIBIT-DISPOSED-CASE-SAS-TOKEN"
  key_vault_id = data.azurerm_key_vault.default_lz_vault.id
}

data "azurerm_key_vault_secret" "arm_xhibit_warrant_sas" {
  name         = "ARM-XHIBIT-WARRANT-SAS-TOKEN"
  key_vault_id = data.azurerm_key_vault.default_lz_vault.id
}
