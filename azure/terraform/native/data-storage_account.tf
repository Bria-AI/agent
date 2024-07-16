data "azurerm_storage_account" "custom_storage_account" {
  count               = local.use_custom_storage_account && local.use_custom_resource_group ? 1 : 0
  name                = var.images_storage_account_name
  resource_group_name = var.storage_account_resource_group_name
}

data "azurerm_storage_containers" "image_storage_account_containers" {
  count              = local.use_custom_storage_account && local.use_custom_resource_group ? 1 : 0
  storage_account_id = data.azurerm_storage_account.custom_storage_account.0.id
}