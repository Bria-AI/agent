#
# API
#
variable "bria_api_token" {
  type        = string
  description = "Token to access the Bria API."
  sensitive   = true
  default     = ""
}

variable "bria_model_version" {
  type        = string
  description = "Bria model version"
  default     = "2.0"

  validation {
    condition     = contains(["1.4", "2.0"], var.bria_model_version)
    error_message = "The model_version must be either '1.4' or '2.0'."
  }
}


# SPN
variable "bria_spn_tenant_id" {
  type        = string
  description = "The Tenant ID of the spn"
  sensitive   = true
}

variable "bria_spn_client_id" {
  type        = string
  description = "The client ID of the multi-tenant bria spn"
  sensitive   = true
}

variable "bria_spn_client_secret" {
  type        = string
  description = "The client secret of the multi-tenant bria spn"
  sensitive   = true
}

variable "bria_model_source_storage_account_name" {
  type        = string
  description = "The name of bria storage account that contain the models"
  sensitive   = true
}

variable "bria_model_source_container_name" {
  type        = string
  description = "The name of bria container name that contain the models"
  sensitive   = true
}

#
# Queue
#
variable "embeddings_queue_name" {
  type        = string
  description = "The embeddings queue name"
  default     = "agent-embeddings"
}

#
# func
#
#variable "registry_url" {
#  type        = string
#  description = "The registry url of the func images"
#  default     = "change-me"
#}
#
#variable "embeddings_image_name" {
#  type        = string
#  description = "The The image name for the embedding func"
#  default     = "change-me"
#}
#
#variable "embeddings_image_tag" {
#  type        = string
#  description = "The The image tag for the embedding func"
#  default     = "latest"
#}
#
#variable "image_handler_image_name" {
#  type        = string
#  description = "The The image name for the image handler func"
#  default     = "change-me"
#}
#
#variable "image_handler_image_tag" {
#  type        = string
#  description = "The The image tag for the image handler func"
#  default     = "latest"
#}

# ML
variable "ml_vm_location" {
  type        = string
  description = "The location to create the VM for ML model deployment"
  default     = "italynorth"
}
variable "ml_vm_size" {
  type        = string
  description = "The size to create the VM for ML model deployment"
  default     = "Standard_D2as_v4"
}