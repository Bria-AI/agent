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

  os_type              = "Linux"
  function_app_version = 4
  function_app_site_config = {
    application_stack = {
      python_version = "3.9"
    }
  }

  function_app_application_settings = {
    #     General variables
    FUNCTIONS_WORKER_RUNTIME       = "python"
    SCM_DO_BUILD_DURING_DEPLOYMENT = true
    AzureWebJobsFeatureFlags       = "EnableWorkerIndexing"
    cloud_option                   = "AZURE"

    attribution_endpoint = ""
    api_token            = format("@Microsoft.KeyVault(SecretUri=%s)", azurerm_key_vault_secret.api_token.id)
    model_version        = var.bria_model_version

    #     Service bus variable
    queue_connection_string                       = format("@Microsoft.KeyVault(SecretUri=%s)", azurerm_key_vault_secret.queue_listen_connection_string.id)
    queue_url                                     = format("@Microsoft.KeyVault(SecretUri=%s)", azurerm_key_vault_secret.queue_url.id)
    queue_name                                    = module.embeddings_queue.queues[var.embeddings_queue_name].name
    embeddingsDispatcher__fullyQualifiedNamespace = format("@Microsoft.KeyVault(SecretUri=%s)", azurerm_key_vault_secret.fqdn_namespace.id)
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

# embeddings_queue_name permissions

resource "azurerm_role_assignment" "embeddings_dispatcher_func_sb_data_receiver_on_embeddings_queue" {
  principal_id         = module.embeddings_dispatcher_func.function_app_identity.principal_id
  scope                = module.embeddings_queue.queues[var.embeddings_queue_name].id
  role_definition_name = "Azure Service Bus Data Receiver"
}
