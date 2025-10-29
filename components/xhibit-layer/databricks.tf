# --- Reference existing Databricks workspace ---
data "azurerm_databricks_workspace" "this" {
  for_each            = var.landing_zones
  name                = "ingest${ each.value }-product-databricks001-${ var.env }"
  resource_group_name = "ingest${ each.value }-main-${ var.env }"
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
  node_type_id            = "Standard_DS3_v2"
  autotermination_minutes = 20
  autoscale {
    min_workers = 1
    max_workers = 20
  }
  data_security_mode      = "USER_ISOLATION"
  custom_tags             = local.common_tags
}