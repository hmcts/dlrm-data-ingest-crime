resource "databricks_catalog" "xhibit_prp_catalog" {
  count   = var.env == "prod" ? 1 : 0
  name    = "crime_xhibit_prp"
  comment = "this catalog is managed by terraform"
  properties = {
    purpose = "Crime xhibit PRP catalog"
  }

  storage_root   = "abfss://${var.landing_container}@${data.azurerm_storage_account.langing_storage.name}.dfs.core.windows.net/crime_xhibit_prp"
  isolation_mode = "ISOLATED"
}

resource "databricks_grants" "xhibit_prp_catalog_crime_grants" {
  count   = var.env == "prod" ? 1 : 0
  catalog = databricks_catalog.xhibit_prp_catalog[0].name

  grant {
    principal  = data.databricks_group.crime_admins.display_name
    privileges = ["ALL_PRIVILEGES", "MANAGE"]
  }

  grant {
    principal  = data.databricks_group.crime_users.display_name
    privileges = ["USE_CATALOG", "USE_SCHEMA", "BROWSE", "SELECT", "EXTERNAL_USE_SCHEMA", "READ VOLUME", "EXECUTE"]
  }
}

resource "databricks_schema" "xhibit_prp_raw_external_schema" {
  count        = var.env == "prod" ? 1 : 0
  catalog_name = databricks_catalog.xhibit_prp_catalog[0].id
  name         = "raw_external"
  comment      = "Schema to host raw Oracle data"
}

resource "databricks_schema" "xhibit_prp_audit_schema" {
  count        = var.env == "prod" ? 1 : 0
  catalog_name = databricks_catalog.xhibit_prp_catalog[0].id
  name         = "audit"
  comment      = "Schema for auditing tables"
}

resource "databricks_schema" "xhibit_prp_staging_arm_schema" {
  count        = var.env == "prod" ? 1 : 0
  catalog_name = databricks_catalog.xhibit_prp_catalog[0].id
  name         = "staging_arm"
  comment      = "Staging ARM data"
}

resource "databricks_schema" "xhibit_prp_staging_cp_schema" {
  count        = var.env == "prod" ? 1 : 0
  catalog_name = databricks_catalog.xhibit_prp_catalog[0].id
  name         = "staging_cp"
  comment      = "Staging CP Data"
}

resource "databricks_schema" "xhibit_prp_stg_shared_schema" {
  count        = var.env == "prod" ? 1 : 0
  catalog_name = databricks_catalog.xhibit_prp_catalog[0].id
  name         = "stg_shared"
  comment      = "Staging Shared Schema"
}

resource "databricks_schema" "xhibit_prp_curated_schema" {
  count        = var.env == "prod" ? 1 : 0
  catalog_name = databricks_catalog.xhibit_prp_catalog[0].id
  name         = "curated"
  comment      = "Curated Schema"
}

resource "databricks_grants" "xhibit_prp_raw_external_schema_grants" {
  count  = var.env == "prod" ? 1 : 0
  schema = databricks_schema.xhibit_prp_raw_external_schema[0].id

  grant {
    principal  = data.databricks_group.crime_admins.display_name
    privileges = ["ALL_PRIVILEGES", "MANAGE"]
  }
}