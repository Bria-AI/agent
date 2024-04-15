module "rg" {
  source  = "claranet/rg/azurerm"
  version = "6.1.0"

  location    = module.azure_region.location
  client_name = lower(random_string.identifier.result)
  name_suffix = module.azure_region.location_short
  environment = var.environment
  stack       = var.stack
  extra_tags  = local.extra_tags
}