terraform {
  required_version = "~>1.4.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.95.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "1.12.1"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "=1.2.28"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.6.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "=2.3.3"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "=2.4.2"
    }

  }
}