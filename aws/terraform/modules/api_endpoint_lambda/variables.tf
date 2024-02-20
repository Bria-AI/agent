variable "execution_role" { type = string }
variable "embeddings_queue_url" { type = string }

variable "name" {
  type    = string
  default = "jumpstart_api_lambda_endpoint"
}

variable "inference_endpoint" {
  type    = string
  default = "triton-gaia-ep-2023-11-20-11-04-54"
}

variable "image_uri" {
  type    = string
  default = "542375318953.dkr.ecr.us-east-1.amazonaws.com/jumpstart_endpoint_lambda:latest"
}
