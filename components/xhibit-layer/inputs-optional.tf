variable "landing_zones" {
  description = "Identifiers for the landing zones to apply the project specific configuration to."
  type = map(object({
    use_microsoft_ip_kit_structure = optional(bool, false)
    deploy_shir                    = optional(bool, false)
  }))
  default = {}
}

variable "deploy_shir" {
  description = "Install SHIR."
  type        = bool
  default     = false
}

variable "project" {
  type        = string
  description = "The name of the data migration project."
  default     = "Crime Legacy Migration"
}

## Databricks compute
variable "dbrics_node_type_id" {
  type        = string
  description = "Databricks node type"
  default     = "Standard_DS3_v2"
}

variable "dbrics_auto_termination_mins" {
  type        = number
  description = "Databricks auto termination in minutes"
  default     = 30
}

variable "dbrics_min_workers" {
  type        = number
  description = "Databricks minimun number of workers"
  default     = 1
}

variable "dbrics_max_workers" {
  type        = number
  description = "Databricks maximun number of workers"
  default     = 15
}

# Databricks sql warehouse config

variable "dbrics_sql_cluster_size" {
  type        = string
  description = "Databricks  sql cluster size"
  default     = "X-Small"
}

variable "dbrics_sql_auto_termination_mins" {
  type        = number
  description = "Databricks  sql auto termination in minutes"
  default     = 30
}

variable "dbrics_sql_min_workers" {
  type        = number
  description = "Databricks  sql minimun number of workers"
  default     = 1
}

variable "dbrics_sql_max_workers" {
  type        = number
  description = "Databricks sql maximun number of workers"
  default     = 5
}

variable "dbrics_sql_enable_photon" {
  type        = bool
  description = "Databricks sql enable photon"
  default     = true
}

variable "dbrics_sql_enable_serverless" {
  type        = bool
  description = "Databricks sql maximun number of workers"
  default     = false
}

variable "dbrics_sql_warehouse_type" {
  type        = string
  description = "Databricks sql warehouse type"
  default     = "CLASSIC"
}

variable "dbrics_sql_spot_instance_policy" {
  type        = string
  description = "Databricks sql spot instence policy"
  default     = "COST_OPTIMIZED"
}

variable "landing_container" {
  type        = string
  description = "Landing container"
  default     = "landing"
}