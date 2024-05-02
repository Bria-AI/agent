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
  default     = "2.2"

  validation {
    condition     = contains(["2.0", "2.2", "2.3"], var.bria_model_version)
    error_message = "The model_version must be either '2.0' or '2.2' or '2.3'."
  }
}

#
# S3
#
variable "s3_bria_bucket" {
  type        = string
  default     = "aws-bria-agent-results"
  description = "S3 bucket where the results are stored."
}

variable "s3_embeddings_prefix" {
  type        = string
  default     = "embeddings/"
  description = "S3 prefix for the embeddings."
}

#
# Queue
#
variable "embeddings_queue_name" {
  type    = string
  default = "agent-embeddings"
}

#
# Lambda
#
variable "execution_role_name" {
  type    = string
  default = "bria-agent-role"
}

