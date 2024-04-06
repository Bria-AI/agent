### Linux
module "image_handler_func" {
  source  = "claranet/function-app/azurerm"
  version = "7.8.0"

  client_name         = lower(random_string.identifier.result)
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

  name_suffix = "image-creation-handler"

  service_plan_custom_name = "plan-image-handler-func"
  os_type                  = "Linux"
  function_app_version     = 4

  function_app_site_config = {
    application_stack = {
      python_version = "3.8"
      #      docker = {
      #        registry_url      = var.registry_url
      #        image_name        = var.image_handler_image_name
      #        image_tag         = var.image_handler_image_tag
      #        registry_username = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.spn_client_id.id})"
      #        registry_password = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.spn_client_secret.id})"
      #      }
    }
  }

  function_app_application_settings = {
    FUNCTIONS_WORKER_RUNTIME      = "python"
    queue_connection_string       = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.queue_send_connection_string.id})"
    queue_url                     = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.queue_url.id})"
    sagemaker_endpoint            = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.ml_rest_endpoint.id})"
    imageHandler__blobServiceUri  = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.image_storage_blob_uri.id})"
    imageHandler__queueServiceUri = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.image_storage_queue_uri.id})"
  }

  identity_type                = "SystemAssigned"
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
resource "azurerm_role_assignment" "image_handler_func_blob_data_contributor_on_image_uploader_storage" {
  principal_id         = module.image_handler_func.function_app_identity.principal_id
  scope                = module.image_uploader_storage_account.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
}

resource "azurerm_role_assignment" "image_handler_func_queue_data_contributor_on_image_uploader_storage" {
  principal_id         = module.image_handler_func.function_app_identity.principal_id
  scope                = module.image_uploader_storage_account.storage_account_id
  role_definition_name = "Storage Queue Data Contributor"
}

# embeddings_queue_name permissions

resource "azurerm_role_assignment" "image_handler_func_sb_data_sender_on_embeddings_queue" {
  principal_id         = module.image_handler_func.function_app_identity.principal_id
  scope                = module.embeddings_queue.queues[var.embeddings_queue_name].id
  role_definition_name = "Azure Service Bus Data Sender"
}