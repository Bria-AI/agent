module "ml_workspace" {
  source = "../modules/machine_learning"
  client_name = lower(random_string.identifier.result)
  environment = var.environment
  key_vault_id = module.akv.key_vault_id
  location = module.azure_region.location
  location_short = module.azure_region.location_short
  public_network_access_enabled = true
  resource_group_name = module.rg.resource_group_name
  stack = var.stack
  storage_account_id = module.ml_backend_storage_account.storage_account_id
}