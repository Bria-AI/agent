locals {
  image_container_exist = contains(
    try(data.azurerm_storage_containers.image_storage_account_containers.0.containers.*.name, []),
    var.images_container_name
  )
  use_custom_resource_group  = var.image_storage_account_resource_group_name == null ? false : true
  use_custom_storage_account = var.images_storage_account_name == null ? false : true
}

data "azurerm_storage_account" "custom_storage_account" {
  count               = local.use_custom_storage_account && local.use_custom_resource_group ? 1 : 0
  name                = var.images_storage_account_name
  resource_group_name = var.image_storage_account_resource_group_name
}

data "azurerm_storage_containers" "image_storage_account_containers" {
  count              = local.use_custom_storage_account && local.use_custom_resource_group ? 1 : 0
  storage_account_id = data.azurerm_storage_account.custom_storage_account.0.id
}

resource "azurerm_storage_container" "custom_image_container" {
  count                 = !local.use_custom_storage_account || local.image_container_exist ? 0 : 1
  name                  = var.images_container_name
  storage_account_name  = data.azurerm_storage_account.custom_storage_account.0.name
  container_access_type = "private"
}