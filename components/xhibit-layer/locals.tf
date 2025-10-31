locals {
  resource_group_names        = ["network", "logic", "management", "logging", "runtimes", "storage", "external-storage", "metadata", "shared-integration", "shared-product", "di001", "di002", "dp001", "dp002"]
  ip_kit_resource_group_names = ["network", "logic", "main"]
    
  flattened_resource_groups = flatten([
    for lz_key, lz in var.landing_zones : [
      for rg in lz.use_microsoft_ip_kit_structure ? local.ip_kit_resource_group_names : local.resource_group_names : "ingest${lz_key}-${rg}-${var.env}"
    ]
  ])

  subnets = ["data-bricks-private", "data-bricks-product-private", "data-bricks-product-public", "data-bricks-public", "data-integration-001", "data-integration-002", "data-product-001", "data-product-002", "services-mysql", "services"]
  flattened_subnets = flatten([
    for lz_key, lz in var.landing_zones : [
      for subnet in local.subnets : {
        name   = "ingest${lz_key}-${subnet}-${var.env}"
        lz_key = lz_key
      }
    ]
  ])

  abbr_environments_map = {
    sbox  = "sandbox"
    stg      = "staging"
    production = "prod"
  }

  is_prod            = length(regexall(".*(prod).*", var.env)) > 0
  is_sbox            = length(regexall(".*(s?box).*", var.env)) > 0

  cnp_prod_sub_id            = "8999dec3-0104-4a27-94ee-6588559729d1"
  cnp_nonprod_sub_id         = "1c4f0704-a29e-403d-b719-b90c34ef14c9"
  soc_sub_id                 = "8ae5b3b6-0b12-4888-b894-4cec33c92292"
  common_tags                = merge(module.ctags.common_tags, { "Data-Ingest-Project" = var.project })

  dlrm_crime_admin_group     = "DTS DLRM Data Ingestion Admin (env:${ lookup(local.abbr_environments_map, var.env, var.env) })"

  # Setting up a default landing zone. The project will use single LZ.
  default_lz = "05"
}
