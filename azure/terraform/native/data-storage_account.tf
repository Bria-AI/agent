data "azurerm_storage_account" "storage_account" {
  count               = local.use_custom_storage_account ? 1 : 0
  name                = var.images_storage_account_name
  resource_group_name = var.existing_resource_group_name
}

data "azurerm_storage_containers" "container" {
  count              = local.use_custom_container ? 1 : 0
  storage_account_id = data.azurerm_storage_account.storage_account[0].id
}