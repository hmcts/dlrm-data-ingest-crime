# --- Reference existing Databricks workspace ---
data "azurerm_databricks_workspace" "this" {
  name                = "ingest${ local.default_lz }-product-databricks001-${ var.env }"
  resource_group_name = "ingest${ local.default_lz }-main-${ var.env }"
}

provider "databricks" {
  host = data.azurerm_databricks_workspace.this.workspace_url
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}

data "databricks_group" "users" {
    display_name = "users"
}


data "databricks_group" "crime_admins" {
  display_name = "crime_admin_${var.env}"
}


data "databricks_group" "crime_users" {
  display_name = "crime_${var.env}"
}

resource "databricks_catalog" "xhibit_catalog" {
  name    = "crime_xhibit_${ var.env }"
  comment = "this catalog is managed by terraform"
  properties = {
    purpose = "Crime xhibit catalog for ${ var.env }"
  }

  storage_root = "abfss://${ var.landing_container }@${ data.azurerm_storage_account.langing_storage.name }.dfs.core.windows.net/crime_xhibit_${ var.env }"
  isolation_mode = "ISOLATED"
}

resource "databricks_cluster" "shared_autoscaling" {
  cluster_name            = "Dlrm Crime Shared Autoscaling ${ var.env }"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = var.dbrics_node_type_id
  autotermination_minutes = var.dbrics_auto_termination_mins
  autoscale {
    min_workers = var.dbrics_min_workers
    max_workers = var.dbrics_max_workers
  }
  data_security_mode      = "USER_ISOLATION"
  custom_tags             = local.common_tags
}


resource "databricks_sql_endpoint" "sql_warehouse" {
  name                     = "Dlrm Crime SQl warehouse ${ var.env }"
  cluster_size             = var.dbrics_sql_cluster_size
  min_num_clusters         = var.dbrics_sql_min_workers
  max_num_clusters         = var.dbrics_sql_max_workers
  auto_stop_mins           = var.dbrics_sql_auto_termination_mins
  enable_photon            = var.dbrics_sql_enable_photon
  enable_serverless_compute = var.dbrics_sql_enable_serverless
  warehouse_type           = var.dbrics_sql_warehouse_type
  spot_instance_policy     = var.dbrics_sql_spot_instance_policy
}

resource "databricks_permissions" "sql_endpoint_user" {
    sql_endpoint_id = databricks_sql_endpoint.sql_warehouse.id

    access_control {
        group_name = data.databricks_group.users.display_name
        permission_level = "CAN_USE"
    }
}


resource "databricks_storage_credential" "external" {
  name = "crime_dbrics_catalogue_${var.env}"
  azure_managed_identity {
    access_connector_id = data.azurerm_databricks_access_connector.unity_catalog.id
  }
  isolation_mode = "${var.databricks_landing_isolation_mode}"
  comment = "Managed by TF"
}

resource "databricks_external_location" "landing_external" {
  name = "external_st_${var.env}"
  url = format("abfss://%s@%s.dfs.core.windows.net", var.landing_container, data.azurerm_storage_account.langing_storage.name)
  credential_name = databricks_storage_credential.external.id
  comment         = "Managed by TF "
  isolation_mode = "ISOLATION_MODE_ISOLATED"
}

## perms
resource "databricks_grants" "storage_cred_grants" {
  storage_credential = databricks_storage_credential.external.id

  grant {
    principal  = data.databricks_group.crime_admins.display_name
    privileges = ["ALL_PRIVILEGES", "MANAGE"]
  }

  grant {
    principal  = data.databricks_group.crime_users.display_name
    privileges = ["READ_FILES"]
  }
}

resource "databricks_grants" "external_location_admin_grants" {
  external_location = databricks_external_location.landing_external.id

  grant {
    principal  = data.databricks_group.crime_admins.display_name
    privileges = ["ALL_PRIVILEGES", "MANAGE"]
  }

  grant {
    principal  = data.databricks_group.crime_users.display_name
    privileges = ["BROWSE", "READ FILES"]
  }
}


resource "databricks_grants" "catalog_crime_grants" {
    catalog = databricks_catalog.xhibit_catalog.name

    grant {
      principal  = data.databricks_group.crime_admins.display_name
      privileges = ["ALL_PRIVILEGES"]
    }

    grant {
      principal  = data.databricks_group.crime_users.display_name
      privileges = ["USE_CATALOG", "USE_SCHEMA", "BROWSE", "SELECT", "EXTERNAL_USE_SCHEMA" , "READ VOLUME", "EXECUTE"]
    }
}

