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

  name_suffix              = "embeddings"
  service_plan_custom_name = "plan-embeddings-dispatcher-func"

#     storage_account_custom_name = "saembeddingsfunc${random_string.identifier.result}"

  os_type              = "Linux"
  function_app_version = 4
  function_app_site_config = {
    application_stack = {
      python_version = "3.9"
      #      docker = {
      #        registry_url      = var.registry_url
      #        image_name        = var.embeddings_image_name
      #        image_tag         = var.embeddings_image_tag
      #        registry_username = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.spn_client_id.id})"
      #        registry_password = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.spn_client_secret.id})"
      #      }
    }
  }

  function_app_application_settings = {
    #     General variables
    FUNCTIONS_WORKER_RUNTIME = "python"
    AzureWebJobsFeatureFlags = "EnableWorkerIndexing"
    cloud_option             = "AZURE"

    attribution_endpoint = ""
    api_token            = format("@Microsoft.KeyVault(SecretUri=%s)", azurerm_key_vault_secret.api_token.id)
    model_version        = var.bria_model_version

    #     Service bus variable
    queue_connection_string                      = format("@Microsoft.KeyVault(SecretUri=%s)", azurerm_key_vault_secret.queue_listen_connection_string.id)
    queue_url                                    = format("@Microsoft.KeyVault(SecretUri=%s)", azurerm_key_vault_secret.queue_url.id)
    embeddingsDispatcher__fullyQualifiedNamespace = format("@Microsoft.KeyVault(SecretUri=%s)", azurerm_key_vault_secret.fqdn_namespace.id)
  }
  identity_type                = "SystemAssigned"
  application_insights_enabled = true

  use_existing_storage_account = true
  storage_account_id           = module.logs.logs_storage_account_id

#   storage_account_network_rules_enabled = false
#   application_zip_package_path = abspath("/or/clients/Bria/projects/agent-functions/azure/functionCode/embedding_dispatcher.zip")

  logs_destinations_ids = [
    module.logs.log_analytics_workspace_id
  ]

  function_app_application_settings_drift_ignore = false

  extra_tags = merge(local.extra_tags, {})
}

# embeddings_queue_name permissions

resource "azurerm_role_assignment" "embeddings_dispatcher_func_sb_data_receiver_on_embeddings_queue" {
  principal_id         = module.embeddings_dispatcher_func.function_app_identity.principal_id
  scope                = module.embeddings_queue.queues[var.embeddings_queue_name].id
  role_definition_name = "Azure Service Bus Data Receiver"
}
