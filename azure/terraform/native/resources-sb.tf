module "embeddings_queue" {
  source  = "claranet/service-bus/azurerm"
  version = "7.3.0"

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  client_name         = lower(random_string.identifier.result)
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name

  namespace_parameters = {
    sku = "Basic"
  }
  namespace_authorizations = {
    listen = false
    send   = false
    manage = false
  }

  servicebus_queues = [
    {
      name        = var.embeddings_queue_name
      custom_name = var.embeddings_queue_name
      max_delivery_count = 3
    }
  ]

  logs_destinations_ids = [module.logs.log_analytics_workspace_id]
  extra_tags            = local.extra_tags
}
