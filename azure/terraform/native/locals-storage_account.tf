locals {
  model_container_name  = "model"
  images_container_name = "images"

  image_containers = var.image_storage_account_container_name == null ? [
    {
      name = local.images_container_name
    }
  ] : []
  image_uploader_storage_account_count = var.images_storage_account_name == null ? 1 : 0
  storage_account_name = length(var.images_storage_account_name) > 0 ? true : false
}