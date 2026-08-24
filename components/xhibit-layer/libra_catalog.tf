resource "databricks_catalog" "libra_catalog" {
  name    = "crime_libra_${var.env}"
  comment = "this catalog is managed by terraform"
  properties = {
    purpose = "Crime libra catalog for ${var.env}"
  }

  storage_root   = "abfss://${var.landing_container}@${data.azurerm_storage_account.langing_storage.name}.dfs.core.windows.net/crime_libra_${var.env}"
  isolation_mode = "ISOLATED"
}

resource "databricks_grants" "libra_catalog_crime_grants" {
  catalog = databricks_catalog.libra_catalog.name

  grant {
    principal  = data.databricks_group.crime_admins.display_name
    privileges = ["ALL_PRIVILEGES", "MANAGE"]
  }

  grant {
    principal  = data.databricks_group.crime_users.display_name
    privileges = ["USE_CATALOG", "USE_SCHEMA", "BROWSE", "SELECT", "EXTERNAL_USE_SCHEMA", "READ VOLUME", "EXECUTE"]
  }
}

resource "databricks_schema" "libra_raw_external_schema" {
  catalog_name = databricks_catalog.libra_catalog.id
  name    = "raw_external"
  comment = "Schema to host raw Oracle data"
}

resource "databricks_schema" "libra_stg_shared_schema" {
  catalog_name = databricks_catalog.libra_catalog.id
  name    = "stg_shared"
  comment = "Staging Shared Schema"
}

resource "databricks_schema" "libra_stg_arm_schema" {
  catalog_name = databricks_catalog.libra_catalog.id
  name    = "stg_arm"
  comment = "Staging ARM data"
}

resource "databricks_schema" "libra_stg_cp_schema" {
  catalog_name = databricks_catalog.libra_catalog.id
  name    = "stg_cp"
  comment = "Staging CP data"
}

resource "databricks_grants" "schema_libra_raw_external_grants" {
  schema = databricks_schema.libra_raw_external_schema.id

  grant {
    principal  = data.databricks_group.crime_admins.display_name
    privileges = ["ALL_PRIVILEGES", "MANAGE"]
  }
}