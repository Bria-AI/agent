variable "compute_cluster_map" {
  description = <<EOF
The following arguments are supported:

    name - (Required) The name which should be used for this Machine Learning Compute Cluster. Changing this forces a new Machine Learning Compute Cluster to be created.

    machine_learning_workspace_id - (Required) The ID of the Machine Learning Workspace. Changing this forces a new Machine Learning Compute Cluster to be created.

    location - (Required) The Azure Region where the Machine Learning Compute Cluster should exist. Changing this forces a new Machine Learning Compute Cluster to be created.

    vm_priority - (Required) The priority of the VM. Changing this forces a new Machine Learning Compute Cluster to be created. Accepted values are Dedicated and LowPriority.

    vm_size - (Required) The size of the VM. Changing this forces a new Machine Learning Compute Cluster to be created.

    scale_settings - (Required) A scale_settings block as defined below. Changing this forces a new Machine Learning Compute Cluster to be created.

    ssh - (Optional) Credentials for an administrator user account that will be created on each compute node. A ssh block as defined below. Changing this forces a new Machine Learning Compute Cluster to be created.

    description - (Optional) The description of the Machine Learning compute. Changing this forces a new Machine Learning Compute Cluster to be created.

    identity - (Optional) An identity block as defined below. Changing this forces a new Machine Learning Compute Cluster to be created.

    local_auth_enabled - (Optional) Whether local authentication methods is enabled. Defaults to true. Changing this forces a new Machine Learning Compute Cluster to be created.

    node_public_ip_enabled - (Optional) Whether the compute cluster will have a public ip. To set this to false a subnet_resource_id needs to be set. Defaults to true. Changing this forces a new Machine Learning Compute Cluster to be created.

    ssh_public_access_enabled - (Optional) A boolean value indicating whether enable the public SSH port. Changing this forces a new Machine Learning Compute Cluster to be created.

    subnet_resource_id - (Optional) The ID of the Subnet that the Compute Cluster should reside in. Changing this forces a new Machine Learning Compute Cluster to be created.

    tags - (Optional) A mapping of tags which should be assigned to the Machine Learning Compute Cluster. Changing this forces a new Machine Learning Compute Cluster to be created.

An identity block supports the following:

    type - (Required) Specifies the type of Managed Service Identity that should be configured on this Machine Learning Compute Cluster. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both). Changing this forces a new resource to be created.

    identity_ids - (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Machine Learning Compute Cluster. Changing this forces a new resource to be created.

NOTE:

This is required when type is set to UserAssigned or SystemAssigned, UserAssigned.

A ssh block supports the following:

    admin_username - (Required) Name of the administrator user account which can be used to SSH to nodes. Changing this forces a new Machine Learning Compute Cluster to be created.

    admin_password - (Optional) Password of the administrator user account. Changing this forces a new Machine Learning Compute Cluster to be created.

    key_value - (Optional) SSH public key of the administrator user account. Changing this forces a new Machine Learning Compute Cluster to be created.

NOTE:

At least one of admin_password and key_value shoud be specified.

A scale_settings block supports the following:

    max_node_count - (Required) Maximum node count. Changing this forces a new Machine Learning Compute Cluster to be created.

    min_node_count - (Required) Minimal node count. Changing this forces a new Machine Learning Compute Cluster to be created.

    scale_down_nodes_after_idle_duration - (Required) Node Idle Time Before Scale Down: defines the time until the compute is shutdown when it has gone into Idle state. Is defined according to W3C XML schema standard for duration. Changing this forces a new Machine Learning Compute Cluster to be created.

Attributes Reference

In addition to the Arguments listed above - the following Attributes are exported:

    id - The ID of the Machine Learning Compute Cluster.

    identity - An identity block as defined below, which contains the Managed Service Identity information for this Machine Learning Compute Cluster.

EOF
  type = map(object({
    name        = string
    custom_name = optional(string, "")
    location    = optional(string)
    vm_priority = string
    vm_size     = string
    scale_settings = object({
      max_node_count                       = number
      min_node_count                       = number
      scale_down_nodes_after_idle_duration = string
    })
    ssh = optional(object({
      admin_username = string
      admin_password = optional(string)
      key_value      = optional(string)
    }), null)

    description = optional(string)
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string), null)
    }), null)
    local_auth_enabled        = optional(bool)
    node_public_ip_enabled    = optional(bool)
    ssh_public_access_enabled = optional(bool)
    subnet_resource_id        = optional(string)
    tags                      = optional(map(string), {})
  }))

  default = {}
}