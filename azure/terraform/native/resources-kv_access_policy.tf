resource "azurerm_key_vault_access_policy" "embedding_dispatcher_func_msi" {
  key_vault_id = module.akv.key_vault_id
  object_id    = module.embeddings_dispatcher_func.function_app_identity.principal_id
  tenant_id    = data.azurerm_subscription.main.tenant_id

  secret_permissions = [
    "Get",
    "List",
  ]
}
resource "azurerm_key_vault_access_policy" "image_creation_func_msi" {
  key_vault_id = module.akv.key_vault_id
  object_id    = module.image_handler_func.function_app_identity.principal_id
  tenant_id    = data.azurerm_subscription.main.tenant_id

  secret_permissions = [
    "Get",
    "List",
  ]
}


