module "akv" {
  source  = "claranet/keyvault/azurerm"
  version = "7.5.0"

  client_name         = lower(random_string.identifier.result)
  environment         = var.environment
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
  stack               = var.stack

  # Current user should be here to be able to create keys and secrets
  admin_objects_ids = [
    data.azurerm_client_config.main.object_id,
  ]

  public_network_access_enabled = true
  network_acls = {
    default_action = "Allow"
  }

  purge_protection_enabled = false

  extra_tags = local.extra_tags

  logs_destinations_ids = [module.logs.log_analytics_workspace_id]

}