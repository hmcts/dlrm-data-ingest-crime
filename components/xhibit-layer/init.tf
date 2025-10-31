terraform {
  required_version = ">= 1.11.4, < 2.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.51.0"
      configuration_aliases = [azurerm.soc, azurerm.cnp, azurerm.dcr]
    }
    
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.95.0"
    }

  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias                           = "soc"
  resource_provider_registrations = "none"
  features {}
  subscription_id = local.soc_sub_id
}


provider "azurerm" {
  alias                           = "cnp"
  resource_provider_registrations = "none"
  features {}
  subscription_id = local.is_prod ? local.cnp_prod_sub_id : local.cnp_nonprod_sub_id
}

provider "azurerm" {
  alias = "dcr"
  features {}
  subscription_id = var.env == "prod" || var.env == "production" ? "8999dec3-0104-4a27-94ee-6588559729d1" : var.env == "sbox" || var.env == "sandbox" ? "bf308a5c-0624-4334-8ff8-8dca9fd43783" : "1c4f0704-a29e-403d-b719-b90c34ef14c9"
}
