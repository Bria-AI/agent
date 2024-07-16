#
# API
#
variable "bria_api_token" {
  type        = string
  description = "Token to access the Bria API."
  sensitive   = false
}

variable "bria_model_version" {
  type        = string
  description = "Bria model version"
  default     = "2.3"

  validation {
    condition     = contains(["2.2", "2.3"], var.bria_model_version)
    error_message = "The model_version must be either '2.2' or '2.3'."
  }
}

variable "images_storage_account_name" {
  type     = string
  default  = null
  description = "the name of the storage account which hosts the images container"
}

variable image_storage_account_container_name {
  type        = string
  default     = null
  description = "the name of the container in the storage account that hosts the images"
}



# SPN
variable "bria_spn_tenant_id" {
  type        = string
  description = "Tenant ID (provided by Bria) for multi-tenant spn authentication"
  sensitive   = false
}

variable "bria_spn_client_id" {
  type        = string
  description = "Client ID (provided by Bria) for multi-tenant spn authentication"
  sensitive   = false
}

variable "bria_spn_client_secret" {
  type        = string
  description = "Client secret (provided by Bria) for multi-tenant spn authentication"
  sensitive   = false
}

variable "bria_model_source_storage_account_name" {
  type        = string
  description = "Bria storage account (provided by Bria)"
  sensitive   = false
}

variable "bria_model_source_container_name" {
  type        = string
  description = "Bria container name (provided by Bria)"
  sensitive   = false
}

variable "bria_function_app_git_url" {
  type        = string
  description = "The function app git url"
  sensitive   = true
  default     = "https://github.com/Bria-AI/agent-functions.git"
}

variable "bria_image_function_app_path" {
  type        = string
  description = "The  image function app path"
  sensitive   = true
  default     = "azure/functionCode/agent_image_embeddings_calculator"
}

variable "bria_embedder_function_app_path" {
  type        = string
  description = "The  image function app path"
  sensitive   = true
  default     = "azure/functionCode/embedding_dispatcher"
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
