module "model_storage_account" {
  source  = "claranet/storage-account/azurerm"
  version = "7.9.0"

  client_name    = lower(random_string.identifier.result)
  environment    = var.environment
  location_short = module.azure_region.location_short
  stack          = var.stack
  name_suffix    = "model"

  location                 = module.azure_region.location
  resource_group_name      = module.rg.resource_group_name
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_bypass = [
    "AzureServices"
  ]
  default_firewall_action = "Allow"


  extra_tags = merge(local.extra_tags, {
  })

  logs_destinations_ids = [module.logs.log_analytics_workspace_id]

  containers = [
    {
      name = local.model_container_name
    }
  ]
}

module "image_uploader_storage_account" {
  source         = "claranet/storage-account/azurerm"
  version        = "7.9.0"
  client_name    = lower(random_string.identifier.result)
  environment    = var.environment
  location_short = module.azure_region.location_short
  stack          = var.stack

  name_suffix         = "image"
  location            = module.azure_region.location
  resource_group_name = module.rg.resource_group_name

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_bypass = [
    "AzureServices"
  ]
  default_firewall_action = "Allow"

  containers = [
    {
      name = local.embeddings_container_name
    }
  ]

  extra_tags = merge(local.extra_tags, {
  })

  logs_destinations_ids = [module.logs.log_analytics_workspace_id]
}

module "ml_backend_storage_account" {
  source         = "claranet/storage-account/azurerm"
  version        = "7.9.0"
  client_name    = lower(random_string.identifier.result)
  environment    = var.environment
  location_short = module.azure_region.location_short
  stack          = var.stack

  name_suffix         = "ml-backend"
  location            = module.azure_region.location
  resource_group_name = module.rg.resource_group_name

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_bypass = [
    "AzureServices"
  ]
  default_firewall_action = "Allow"

  containers = [
    {
      name = local.embeddings_container_name
    }
  ]

  extra_tags = merge(local.extra_tags, {
  })

  logs_destinations_ids = [module.logs.log_analytics_workspace_id]
}