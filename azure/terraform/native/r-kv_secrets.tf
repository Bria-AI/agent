# spm
resource "azurerm_key_vault_secret" "spn_client_id" {
  key_vault_id = module.akv.key_vault_id
  name         = "spn-client-id"
  value        = var.bria_spn_client_id

  depends_on = [module.akv]
}

# longhorn credentials
resource "azurerm_key_vault_secret" "spn_client_secret" {
  key_vault_id = module.akv.key_vault_id
  name         = "spn-client-secret"
  value        = var.bria_spn_client_secret

  depends_on = [module.akv]
}

# queue

resource "azurerm_key_vault_secret" "queue_listen_authorization_rule" {
  key_vault_id = module.akv.key_vault_id
  name         = "${var.embeddings_queue_name}-listen-connection-string"
  value        = try(module.embeddings_queue.queues_listen_authorization_rule[var.embeddings_queue_name].primary_connection_string, "")

  depends_on = [module.akv]
}

resource "azurerm_key_vault_secret" "queue_send_authorization_rule" {
  key_vault_id = module.akv.key_vault_id
  name         = "${var.embeddings_queue_name}-send-connection-string"
  value        = try(module.embeddings_queue.queues_send_authorization_rule[var.embeddings_queue_name].primary_connection_string, "")

  depends_on = [module.akv]
}