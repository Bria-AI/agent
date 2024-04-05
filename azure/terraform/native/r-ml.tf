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

  datastore_blob_storage_map = {
    model = {
      name                       = "model"
      custom_name                = "bria_model"
      storage_container_id       = module.model_storage_account.storage_blob_containers[local.model_container_name].resource_manager_id
      account_key                = module.model_storage_account.storage_account_properties.primary_access_key
      service_data_auth_identity = "WorkspaceSystemAssignedIdentity"
    }
  }

  extra_tags = merge(local.extra_tags, {})
}

# Storage permissions
resource "azurerm_role_assignment" "sa_model_data_contributor_ml" {
  principal_id         = module.ml_workspace.identity.principal_id
  scope                = module.model_storage_account.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
}