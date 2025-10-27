# --- Reference existing Databricks workspace ---
data "azurerm_databricks_workspace" "this" {
  name                = local.db_workspace_name
  resource_group_name = "ingest05-main-sbox"
}

# --- Configure Databricks provider using workspace info ---
provider "databricks" {
  host = data.azurerm_databricks_workspace.this.workspace_url
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}

resource "databricks_cluster" "shared_autoscaling" {
  cluster_name            = "Dlrm Crime Shared Autoscaling ${ var.env }"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = 20
  autoscale {
    min_workers = 1
    max_workers = 20
  }
  custom_tags = local.common_tags
}