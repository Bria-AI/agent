variable "key_vault_id" {
  description = "(Required) The ID of key vault associated with this Machine Learning Workspace. Changing this forces a new resource to be created."
  type        = string
}

variable "storage_account_id" {
  description = "(Required) The ID of the Storage Account associated with this Machine Learning Workspace. Changing this forces a new resource to be created."
  type        = string
}

variable "identity_type" {
  description = "Specifies the type of Managed Service Identity that should be configured on this Storage Account. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned` (to enable both)."
  type        = string
  default     = "SystemAssigned"
}

variable "identity_ids" {
  description = "Specifies a list of User Assigned Managed Identity IDs to be assigned to this Storage Account."
  type        = list(string)
  default     = null
}

variable "kind" {
  description = "(Optional) The type of the Workspace. Possible values are Default, FeatureStore. Defaults to Default"
  type        = string
  default = "Default"
}

variable "container_registry_id" {
  description =<<EOF
  (Optional) The ID of the container registry associated with this Machine Learning Workspace. Changing this forces a new resource to be created.
  NOTE:
  The admin_enabled should be true in order to associate the Container Registry to this Machine Learning Workspace."
EOF
  type        = string
  default = null
}

variable "public_network_access_enabled" {
  description = "(Optional) Enable public access when this Machine Learning Workspace is behind VNet."
  type        = string
  default = false
}

variable "image_build_compute_name" {
  description = "(Optional) The compute name for image build of the Machine Learning Workspace."
  type        = string
  default = null
}

variable "description" {
  description = "(Optional) The description of this Machine Learning Workspace."
  type        = string
  default = null
}

variable "encryption" {
  description =<<EOF
(Optional) An encryption block as defined below. Changing this forces a new resource to be created.

    key_vault_id - (Required) The ID of the keyVault where the customer owned encryption key is present.

    key_id - (Required) The Key Vault URI to access the encryption key.

    user_assigned_identity_id - (Optional) The Key Vault URI to access the encryption key.

EOF
  type        = object({
    key_vault_id  = string
    key_id = string
    user_assigned_identity_id = optional(string)

  })
  default     = null
}

variable "managed_network" {
  description = <<EOF
 (Optional) A managed_network block as defined below.
  isolation_mode - (Optional) The isolation mode of the Machine Learning Workspace. Possible values are Disabled, AllowOnlyApprovedOutbound, and AllowInternetOutb
EOF
  type        = object({
    isolation_mode = optional(string)

  })
  default = null
}

variable "feature_store" {
  description = <<EOF
  (Optional) A feature_store block as defined below.


    computer_spark_runtime_version - (Optional) The version of Spark runtime.

    offline_connection_name - (Optional) The name of offline store connection.

    online_connection_name - (Optional) The name of online store connection.

    Note:

    feature_store must be set whenkind is FeatureStore
EOF
  type        = object({
    computer_spark_runtime_version = optional(string)
    offline_connection_name = optional(string)
    online_connection_name = optional(string)

  })
  default = null
}

variable "friendly_name" {
  description = "(Optional) Display name for this Machine Learning Workspace."
  type        = string
  default = null
}

variable "high_business_impact" {
  description = " (Optional) Flag to signal High Business Impact (HBI) data in the workspace and reduce diagnostic data collected by the service. Changing this forces a new resource to be created."
  type        = string
  default = null
}

variable "primary_user_assigned_identity" {
  description = "(Optional) The user assigned identity id that represents the workspace identity."
  type        = string
  default = null
}

variable "v1_legacy_mode_enabled" {
  description = "(Optional) Enable V1 API features, enabling v1_legacy_mode may prevent you from using features provided by the v2 API. Defaults to false"
  type        = bool
  default     = false
}

variable "sku_name" {
  description = "(Optional) SKU/edition of the Machine Learning Workspace, possible values are Free, Basic, Standard and Premium. Defaults to Basic"
  type        = string
  default     = "Basic"
}