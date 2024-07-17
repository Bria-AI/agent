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

  datastore_blob_storage_map = {
    model = {
      name                       = local.model_datastore_name
      is_default = true
      custom_name                = local.model_datastore_name
      storage_container_id       = module.ml_backend_storage_account.storage_blob_containers[local.model_container_name].resource_manager_id
      account_key                = module.ml_backend_storage_account.storage_account_properties.primary_access_key
      service_data_auth_identity = "WorkspaceSystemAssignedIdentity"
    }
  }

  extra_tags = local.extra_tags
}

data "azurerm_storage_containers" "ml_default_data_store_container" {
  storage_account_id = module.ml_backend_storage_account.storage_account_id

  depends_on = [module.ml_workspace]
}