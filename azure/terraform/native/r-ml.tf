module "ml_workspace" {
  source                        = "../modules/machine_learning"
  client_name                   = lower(random_string.identifier.result)
  environment                   = var.environment
  key_vault_id                  = module.akv.key_vault_id
  location                      = module.azure_region.location
  location_short                = module.azure_region.location_short
  public_network_access_enabled = true
  resource_group_name           = module.rg.resource_group_name
  stack                         = var.stack
  storage_account_id            = module.ml_backend_storage_account.storage_account_id

  logs_destinations_ids = [module.logs.log_analytics_workspace_id]

  compute_cluster_map = {
    main = {
      name        = "bria"
      vm_priority = "LowPriority"
      vm_size     = "Standard_DS11_v2"
      location    = "italynorth"

      scale_settings = {
        min_node_count                       = 0
        max_node_count                       = 1
        scale_down_nodes_after_idle_duration = "PT30S"
      }

      identity = {
        type = "SystemAssigned"
      }
    }
  }

  extra_tags = merge(local.extra_tags, {})
}