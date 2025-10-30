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
