### Linux
module "embeddings_dispatcher_func" {
  source  = "claranet/function-app/azurerm"
  version = "7.8.0"

  client_name         = lower(random_string.identifier.result)
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

  name_suffix = "embeddings-dispatcher"
  service_plan_custom_name = "plan-embeddings-dispatcher-func"

  os_type              = "Linux"
  function_app_version = 3
  function_app_site_config = {
    application_stack = {
      docker = {
        registry_url      = var.registry_url
        image_name        = var.embeddings_image_name
        image_tag         = var.embeddings_image_tag
        registry_username = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.spn_client_id.id})"
        registry_password = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.spn_client_secret.id})"
      }
    }
  }

  function_app_application_settings = {
    attribution_endpoint = ""
    api_token            = var.bria_api_token
    model_version        = var.bria_model_version
    queue_url            = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.queue_listen_authorization_rule.id})"
  }
  identity_type = "SystemAssigned"
  application_insights_enabled = true

  use_existing_storage_account = true
  storage_account_id           = module.logs.logs_storage_account_id


  logs_destinations_ids = [
    module.logs.log_analytics_workspace_id
  ]

  function_app_application_settings_drift_ignore = false

  extra_tags = merge(local.extra_tags, {})
}

# Storage permissions
resource "azurerm_role_assignment" "sa_data_contributor_embeddings_dispatcher_func" {
  principal_id         = module.embeddings_dispatcher_func.function_app_identity.principal_id
  scope                = module.image_uploader_storage_account.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
}

# embeddings_queue_name permissions

resource "azurerm_role_assignment" "sb_image_queue_contributor_embeddings_dispatcher_func" {
  principal_id         = module.image_handler_func.function_app_identity.principal_id
  scope                = module.embeddings_queue.queues[var.embeddings_queue_name].id
  role_definition_name = "Azure Service Bus Data Receiver"
}
