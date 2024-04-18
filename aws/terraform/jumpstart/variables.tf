#
# API
#
variable "bria_api_token" {
  type        = string
  description = "Token to access the Bria API."
  sensitive   = true
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

#
# S3
#
variable "s3_bria_bucket" {
  type        = string
  default     = "jumpstart-bria-agent-results"
  description = "S3 bucket where the results are stored."
}

variable "s3_embeddings_prefix" {
  type        = string
  default     = "embeddings/"
  description = "S3 prefix for the embeddings."
}

#
# Sagemaker
#
variable "sagemaker_inference_endpoint" {
  type        = string
  default     = "bria-jumpstart-sdxl-v2-0-ep-2023-11-23-10-15-25"
  description = "The sagemaker inference endpoint created by ?."
}

#
# Queue
#
variable "embeddings_queue_name" {
  type    = string
  default = "jumpstart-agent-embeddings"
}

#
# Lambda
#
variable "execution_role_name" {
  type    = string
  default = "bria-jumpstart-agent-role"
}
