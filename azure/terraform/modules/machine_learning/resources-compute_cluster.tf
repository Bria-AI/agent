resource "azurerm_machine_learning_compute_cluster" "compute_cluster" {
  for_each                      = var.compute_cluster_map
  location                      = try(each.value.location, var.location)
  machine_learning_workspace_id = azurerm_machine_learning_workspace.workspace.id
  name                          = coalesce(each.value.custom_name, each.value.name)
  vm_priority                   = each.value.vm_priority
  vm_size                       = each.value.vm_size

  scale_settings {
    max_node_count                       = each.value.scale_settings.max_node_count
    min_node_count                       = each.value.scale_settings.min_node_count
    scale_down_nodes_after_idle_duration = each.value.scale_settings.scale_down_nodes_after_idle_duration
  }

  dynamic "ssh" {
    for_each = each.value.ssh == null ? [] : ["ssh"]
    content {
      admin_username = each.value.ssh.admin_username
      admin_password = try(each.value.ssh.admin_password, null)
      key_value      = try(each.value.ssh.key_value, null)
    }
  }
  dynamic "identity" {
    for_each = each.value.identity == null ? [] : ["enabled"]
    content {
      type         = each.value.identity.type
      identity_ids = each.value.identity.identity_ids
    }
  }

  local_auth_enabled        = try(each.value.local_auth_enabled, true)
  node_public_ip_enabled    = try(each.value.node_public_ip_enabled, true)
  ssh_public_access_enabled = try(each.value.ssh_public_access_enabled, null)
  subnet_resource_id        = try(each.value.subnet_resource_id, null)

  tags = merge(
    local.default_tags,
    var.extra_tags,
    each.value.tags
  )

}