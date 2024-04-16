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
      python_version = "3.9"
    }
  }

  function_app_application_settings = {
    #     General variables
    FUNCTIONS_WORKER_RUNTIME       = "python"
    SCM_DO_BUILD_DURING_DEPLOYMENT = true
    AzureWebJobsFeatureFlags       = "EnableWorkerIndexing"
    cloud_option                   = "AZURE"
    #     azure ML variable
    azureml_workspace_name      = module.ml_workspace.name
    azureml_resource_group_name = module.rg.resource_group_name
    azureml_subscription_id     = data.azurerm_client_config.main.subscription_id
    azureml_endpoint_name       = format("@Microsoft.KeyVault(SecretUri=%s)", azurerm_key_vault_secret.azureml_endpoint_name.id)
    azureml_rest_endpoint_uri   = format("@Microsoft.KeyVault(SecretUri=%s)", azurerm_key_vault_secret.azureml_rest_endpoint.id)
    #     Storage Variable
    imageHandler__blobServiceUri  = format("@Microsoft.KeyVault(SecretUri=%s)", azurerm_key_vault_secret.image_storage_blob_uri.id)
    imageHandler__queueServiceUri = format("@Microsoft.KeyVault(SecretUri=%s)", azurerm_key_vault_secret.image_storage_queue_uri.id)
    blob_path = format("%s/%s",
      module.image_uploader_storage_account.storage_blob_containers[local.images_container_name].name,
      "{filename}"
    )

    #     Service bus variable
    imageHandler__fullyQualifiedNamespace = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.fqdn_namespace.id})"
    queue_connection_string               = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.queue_send_connection_string.id})"
    queue_url                             = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.queue_url.id})"
    queue_name                            = module.embeddings_queue.queues[var.embeddings_queue_name].name
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

# ML permissions
resource "azurerm_role_assignment" "image_handler_func_azureml_data_scientist_on_image_uploader_storage" {
  principal_id         = module.image_handler_func.function_app_identity.principal_id
  scope                = module.ml_workspace.id
  role_definition_name = "AzureML Data Scientist"
}

resource "azurerm_role_assignment" "image_handler_func_azureml_workspace_connection_secrets_reader_on_image_uploader_storage" {
  principal_id         = module.image_handler_func.function_app_identity.principal_id
  scope                = module.ml_workspace.id
  role_definition_name = "Azure Machine Learning Workspace Connection Secrets Reader"
}

# embeddings_queue_name permissions

resource "azurerm_role_assignment" "image_handler_func_sb_data_sender_on_embeddings_queue" {
  principal_id         = module.image_handler_func.function_app_identity.principal_id
  scope                = module.embeddings_queue.queues[var.embeddings_queue_name].id
  role_definition_name = "Azure Service Bus Data Sender"
}