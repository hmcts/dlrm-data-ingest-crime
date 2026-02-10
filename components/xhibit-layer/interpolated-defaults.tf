
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

data "azurerm_storage_account" "langing_storage" {
  name                = "ingest${local.default_lz}landing${var.env}"
  resource_group_name = "ingest${local.default_lz}-main-${var.env}"
}

data "azurerm_storage_account" "curated_storage" {
  name                = "ingest${local.default_lz}curated${var.env}"
  resource_group_name = "ingest${local.default_lz}-main-${var.env}"
}

data "azurerm_databricks_access_connector" "unity_catalog" {
  name                = "unity-catalog-access-connector"
  resource_group_name = "ingest${local.default_lz}-product-databricks001-managed-rg"
}

data "azuread_group" "dlrm_crime_admin" {
  display_name = local.dlrm_crime_admin_group
}


# import {
#   to = databricks_storage_credential.external
#   id = "crime_dbrics_catalogue"
# }


module "ctags" {
  source = "github.com/hmcts/terraform-module-common-tags"

  builtFrom    = var.builtFrom
  environment  = var.env
  product      = var.product
  expiresAfter = "3000-01-01"
}

# Lookup existing Self-Hosted Integration Runtime per Landing Zone
# data "azurerm_data_factory_integration_runtime_self_hosted" "lz" {
#   for_each = var.landing_zones
#   name                = "ingest${each.key}-shir005-${var.env}"
#   data_factory_name   = "ingest${each.key}-runtimes-dataFactory001-${var.env}"
#   resource_group_name = "ingest${each.key}-main-${var.env}"
# }
