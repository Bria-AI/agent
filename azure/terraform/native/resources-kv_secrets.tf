# spn
resource "azurerm_key_vault_secret" "spn_client_id" {
  key_vault_id = module.akv.key_vault_id
  name         = "spn-client-id"
  value        = var.bria_spn_client_id

  depends_on = [module.akv]
}


resource "azurerm_key_vault_secret" "spn_client_secret" {
  key_vault_id = module.akv.key_vault_id
  name         = "spn-client-secret"
  value        = var.bria_spn_client_secret

  depends_on = [module.akv]
}

# Bria
resource "azurerm_key_vault_secret" "api_token" {
  key_vault_id = module.akv.key_vault_id
  name         = "api-token"
  value        = var.bria_api_token

  depends_on = [module.akv]
}

# queue

resource "azurerm_key_vault_secret" "queue_listen_connection_string" {
  key_vault_id = module.akv.key_vault_id
  name         = "queue-listen-connection-string"
  value        = try(module.embeddings_queue.queues_listen_authorization_rule[var.embeddings_queue_name].primary_connection_string, "")

  depends_on = [module.akv]
}

resource "azurerm_key_vault_secret" "fqdn_namespace" {
  key_vault_id = module.akv.key_vault_id
  name         = "sb-namespace-fqdn"
  value        = trimsuffix(trimprefix(module.embeddings_queue.namespace.endpoint, "https://"), ":443/")
  depends_on   = [module.akv]
}

resource "azurerm_key_vault_secret" "queue_url" {
  key_vault_id = module.akv.key_vault_id
  name         = "queue-url"
  value = try(format("%s%s", module.embeddings_queue.namespace.endpoint,
  module.embeddings_queue.queues[var.embeddings_queue_name].name), "")

  depends_on = [module.akv]
}

resource "azurerm_key_vault_secret" "queue_send_connection_string" {
  key_vault_id = module.akv.key_vault_id
  name         = "queue-send-connection-string"
  value        = try(module.embeddings_queue.queues_send_authorization_rule[var.embeddings_queue_name].primary_connection_string, "")

  depends_on = [module.akv]
}

# ML
resource "azurerm_key_vault_secret" "azureml_rest_endpoint" {
  key_vault_id = module.akv.key_vault_id
  name         = "azureml-endpoint-rest-api"
  value        = jsondecode(azapi_resource.ml_online_endpoint.output).properties.scoringUri

  depends_on = [module.akv]
}

resource "azurerm_key_vault_secret" "azureml_endpoint_name" {
  key_vault_id = module.akv.key_vault_id
  name         = "azureml-endpoint-name"
  value        = azapi_resource.ml_online_endpoint.name

  depends_on = [module.akv]
}

# r-embeddings_dispatcher_func


# image_handler_func
resource "azurerm_key_vault_secret" "image_storage_blob_uri" {
  key_vault_id = module.akv.key_vault_id
  name         = "image-handler-blob-uri"
  value        = module.image_uploader_storage_account.storage_account_properties.primary_blob_endpoint
  depends_on   = [module.akv]
}

resource "azurerm_key_vault_secret" "image_storage_queue_uri" {
  key_vault_id = module.akv.key_vault_id
  name         = "image-handler-queue-uri"
  value        = module.image_uploader_storage_account.storage_account_properties.primary_queue_endpoint
  depends_on   = [module.akv]
}