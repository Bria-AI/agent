module "embedding_dispatcher_func_msi" {
  source              = "../modules/msi"
  client_name         = lower(random_string.identifier.result)
  environment         = var.environment
  location_short      = module.azure_region.location_short
  stack               = var.stack
  name_suffix         = "embd-func"
  location            = var.location
  resource_group_name = module.rg.resource_group_name

  extra_tags = local.extra_tags


}

module "image_creation_func_msi" {
  source              = "../modules/msi"
  client_name         = lower(random_string.identifier.result)
  environment         = var.environment
  location_short      = module.azure_region.location_short
  stack               = var.stack
  location            = var.location
  resource_group_name = module.rg.resource_group_name
  name_suffix         = "image-func"


  extra_tags = local.extra_tags
}