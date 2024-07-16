data "azurerm_storage_account" "storage_account" {
  count               = local.storage_account_name ? 1 : 0
  name                = var.images_storage_account_name
  resource_group_name = "rg-ai-bria-prod-ue"
}

data "azurerm_storage_containers" "container" {
  storage_account_id = data.azurerm_storage_account.storage_account[0].id
}