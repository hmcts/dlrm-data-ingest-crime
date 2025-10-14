module "shir" {
  for_each                 = { for lz_key, lz in var.landing_zones : lz_key => lz if try(lz.deploy_shir, false) }
  # for_each                 = var.landing_zones
  # name                     = "ingest${each.key}${var.env}example"
  source =  "git::https://github.com/hmcts/terraform-module-data-landing-zone.git//modules/self-hosted-integration-runtime?ref=main"

  providers = {
    azurerm     = azurerm
    azurerm.soc = azurerm.soc
    azurerm.cnp = azurerm.cnp
    azurerm.dcr = azurerm.dcr
  }

  env                          = var.env
  name                         = "ingest${each.key}-shir005-${var.env}"
  short_name                   = "shir005"
  resource_group               = data.azurerm_resource_group.lz["ingest${each.key}-${each.value.use_microsoft_ip_kit_structure ? "main" : "runtimes"}-${var.env}"].name
  subnet_id                    = data.azurerm_subnet.lz["ingest${each.key}-services-${var.env}"].id
  key_vault_id                 = data.azurerm_key_vault.lz_vault[each.key].id
  integration_runtime_auth_key = "xxxxx"
  common_tags                  = local.common_tags
}