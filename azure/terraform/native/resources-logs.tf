module "logs" {
  source  = "claranet/run/azurerm//modules/logs"
  version = "7.9.0"

  client_name                           = var.client_name
  environment                           = var.environment
  stack                                 = var.stack
  location                              = module.azure_region.location
  location_short                        = module.azure_region.location_short
  resource_group_name                   = module.rg.resource_group_name
  name_suffix                           = random_string.identifier.result
  log_analytics_workspace_custom_name   = var.custom_log_analytics
  logs_storage_account_custom_name      = "logs${random_string.identifier.result}"
  logs_storage_account_enable_archiving = true



  extra_tags = merge(local.extra_tags, {})
}