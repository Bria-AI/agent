locals {
  federate_identity = try({ for k, v in var.federate_identity_map : k => v }, {})
}