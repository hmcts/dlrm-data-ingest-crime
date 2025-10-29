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