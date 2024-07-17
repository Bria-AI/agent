# Copy blob
resource "terraform_data" "copy_model" {
  triggers_replace = [
    timestamp()
  ]
  input = {
    scriptName                       = "${path.module}/scripts/azcopy.sh"
    SPN_CLIENT_ID                    = var.bria_spn_client_id
    SPN_PASSWORD                     = var.bria_spn_client_secret
    TENANT_ID                        = var.bria_spn_tenant_id
    SAS_TOKEN                        = data.azurerm_storage_account_blob_container_sas.ml_backend_storage_account_sas_token.sas
    SOURCE_STORAGE_ACCOUNT_NAME      = var.bria_model_source_storage_account_name
    DESTINATION_STORAGE_ACCOUNT_NAME = module.ml_backend_storage_account.storage_account_name
    SOURCE_CONTAINER_NAME            = var.bria_model_source_container_name
    DESTINATION_CONTAINER_NAME       = module.ml_backend_storage_account.storage_blob_containers[local.model_container_name].name
#     DESTINATION_CONTAINER_NAME       = local.ml_default_datastore_container_name
  }
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command = format(
      "%s  -c '%s' -p '%s' -t '%s' -a '%s' -n '%s' -d '%s' -x '%s' -y '%s'",
      self.input.scriptName,
      self.input.SPN_CLIENT_ID,
      self.input.SPN_PASSWORD,
      self.input.TENANT_ID,
      self.input.SAS_TOKEN,
      self.input.SOURCE_STORAGE_ACCOUNT_NAME,
      self.input.DESTINATION_STORAGE_ACCOUNT_NAME,
      self.input.SOURCE_CONTAINER_NAME,
      self.input.DESTINATION_CONTAINER_NAME
    )
  }
}