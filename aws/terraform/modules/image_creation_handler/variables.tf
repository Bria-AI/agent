variable "execution_role" { type = string }
variable "bucket_name" { type = string }
variable "sagemaker_endpoint" { type = string }
variable "embeddings_queue_url" { type = string }

variable "name" {
  type    = string
  default = "image_creation_handler"
}

variable "image_uri" {
  type    = string
  default = "542375318953.dkr.ecr.us-east-1.amazonaws.com/agent_image_embeddings_calculator:latest"
}

