module "ml_backend_storage_account" {
  source         = "claranet/storage-account/azurerm"
  version        = "7.9.0"
  client_name    = lower(random_string.identifier.result)
  environment    = var.environment
  location_short = module.azure_region.location_short
  stack          = var.stack

  name_suffix         = "ml"
  location            = module.azure_region.location
  resource_group_name = module.rg.resource_group_name

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_bypass = [
    "AzureServices"
  ]
  default_firewall_action      = "Allow"
  storage_blob_data_protection = {}

  storage_blob_cors_rule = {
    allowed_headers = ["*"]
    allowed_methods = [
      "GET",
      "HEAD",
      "PUT",
      "DELETE",
      "OPTIONS",
      "POST",
      "PATCH"
    ]
    allowed_origins = [
      "https://mlworkspace.azure.ai",
      "https://ml.azure.com",
      "https://*.ml.azure.com",
      "https://ai.azure.com",
      "https://*.ai.azure.com",
    ]
    exposed_headers    = ["*"]
    max_age_in_seconds = 1800
  }

  extra_tags = merge(local.extra_tags, {
  })

  containers = [
    {
      name = local.model_container_name
    }
  ]

  logs_destinations_ids = [module.logs.log_analytics_workspace_id]
}

module "image_uploader_storage_account" {
  count          = local.use_custom_storage_account ? 0 : 1
  source         = "claranet/storage-account/azurerm"
  version        = "7.9.0"
  client_name    = lower(random_string.identifier.result)
  environment    = var.environment
  location_short = module.azure_region.location_short
  stack          = var.stack

  name_suffix         = "images"
  location            = module.azure_region.location
  resource_group_name = module.rg.resource_group_name

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_bypass = [
    "AzureServices"
  ]
  default_firewall_action = "Allow"

  containers = local.image_containers

  extra_tags = merge(local.extra_tags, {
  })

  logs_destinations_ids = [module.logs.log_analytics_workspace_id]
}

moved {
  from = module.image_uploader_storage_account
  to   = module.image_uploader_storage_account[0]
}

resource "azurerm_storage_container" "custom_image_container" {
  count                 = local.use_custom_container ? 0 : 1
  name                  = var.images_container_name
  storage_account_name  = try(module.image_uploader_storage_account.0.storage_account_name, data.azurerm_storage_account.custom_storage_account.0.name)
  container_access_type = "Private"
}
