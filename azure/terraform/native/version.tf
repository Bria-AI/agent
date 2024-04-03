terraform {
  required_version = "~>1.4.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.95.0"
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

  }
}