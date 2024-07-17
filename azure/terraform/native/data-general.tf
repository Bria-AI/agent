data "azurerm_subscription" "main" {}


data "azurerm_client_config" "main" {}

data "azurerm_storage_account_blob_container_sas" "ml_backend_storage_account_sas_token" {
  connection_string = module.ml_backend_storage_account.storage_account_properties.primary_connection_string
  container_name    = module.ml_backend_storage_account.storage_blob_containers[local.model_container_name].name
#   container_name    = local.ml_default_datastore_container_name
  https_only        = true


  start  = timestamp()
  expiry = timeadd(timestamp(), "30m")

  permissions {
    read   = true
    add    = true
    create = true
    write  = true
    delete = false
    list   = true
  }

  cache_control       = "max-age=5"
  content_disposition = "inline"
  content_encoding    = "deflate"
  content_language    = "en-US"
  content_type        = "application/json"
}