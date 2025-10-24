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