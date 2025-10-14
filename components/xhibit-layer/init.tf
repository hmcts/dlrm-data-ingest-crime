terraform {
  required_version = ">= 1.11.4, < 2.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.27.0"
      configuration_aliases = [azurerm.soc, azurerm.cnp, azurerm.dcr]
    }

  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}