resource "azurerm_machine_learning_workspace" "workspace" {
  name                    = local.workspace_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  application_insights_id = try(azurerm_application_insights.app_insights.0.id, var.application_insights_id)
  key_vault_id            = var.key_vault_id
  storage_account_id      = var.storage_account_id

  identity {
    type         = var.identity_type
    identity_ids = var.identity_ids
  }
  kind                          = var.kind
  container_registry_id         = var.container_registry_id
  public_network_access_enabled = var.public_network_access_enabled

  image_build_compute_name = var.image_build_compute_name
  description              = var.description

  dynamic "encryption" {
    for_each = var.encryption == null ? [] : ["enabled"]
    content {
      key_id                    = var.encryption.key_id
      key_vault_id              = var.encryption.key_vault_id
      user_assigned_identity_id = try(var.encryption.user_assigned_identity_id, null)
    }
  }

  dynamic "managed_network" {
    for_each = var.managed_network == null ? [] : ["enabled"]
    content {
      isolation_mode = var.managed_network.isolation_mode
    }
  }

  dynamic "feature_store" {
    for_each = var.feature_store == null ? [] : ["enabled"]
    content {
      computer_spark_runtime_version = var.feature_store.computer_spark_runtime_version
      offline_connection_name        = var.feature_store.offline_connection_name
      online_connection_name         = var.feature_store.online_connection_name
    }
  }
  friendly_name                  = var.friendly_name
  high_business_impact           = var.high_business_impact
  primary_user_assigned_identity = var.primary_user_assigned_identity
  v1_legacy_mode_enabled         = var.v1_legacy_mode_enabled
  sku_name                       = var.sku_name

  tags = merge(
    local.default_tags,
    var.extra_tags
  )
}



