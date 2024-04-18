variable "datastore_blob_storage_map" {
  description = <<EOF
The following arguments are supported:

    name - (Required) The name of the Machine Learning DataStore. Changing this forces a new Machine Learning DataStore to be created.

    workspace_id - (Required) The ID of the Machine Learning Workspace. Changing this forces a new Machine Learning DataStore to be created.

    storage_container_id - (Required) The ID of the Storage Account Container. Changing this forces a new Machine Learning DataStore to be created.

    account_key - (Optional) The access key of the Storage Account. Conflicts with shared_access_signature.

    shared_access_signature - (Optional) The Shared Access Signature of the Storage Account. Conflicts with account_key.

Note:

One of account_key or shared_access_signature must be specified.

    description - (Optional) Text used to describe the asset. Changing this forces a new Machine Learning DataStore to be created.

    is_default - (Optional) Specifies whether this Machines Learning DataStore is the default for the Workspace. Defaults to false.

Note:

is_default can only be set to true on update.

    service_data_auth_identity - (Optional) Specifies which identity to use when retrieving data from the specified source. Defaults to None. Possible values are None, WorkspaceSystemAssignedIdentity and WorkspaceUserAssignedIdentity.

    tags - (Optional) A mapping of tags which should be assigned to the Machine Learning DataStore. Changing this forces a new Machine Learning DataStore to be created.

EOF
  type = map(object({
    name                       = string
    custom_name                = optional(string, "")
    storage_container_id       = string
    account_key                = optional(string)
    shared_access_signature    = optional(string)
    description                = optional(string)
    is_default                 = optional(bool)
    service_data_auth_identity = optional(string)
    tags                       = optional(map(string), {})
  }))

  default = {}
}