variable "api_token"            { type = string }
variable "bucket_name"          { type = string }
variable "execution_role"       { type = string }
variable "embeddings_queue_arn" { type = string }
variable "embeddings_queue_url" { type = string }
variable "model_version"        { type = string }
variable "s3_embeddings_path"   { type = string }

variable "attribution_endpoint" {
  type      = string
  default   = "https://lx5eculobj.execute-api.us-east-1.amazonaws.com/v1/bria-agent-attribution"
  sensitive = true
}

variable "jump_start_embeddings_dispatcher_image" {
  type    = string
  default = "542375318953.dkr.ecr.us-east-1.amazonaws.com/jumpstart_embedding_dispatcher:latest"
}

variable "timeout" {
  type    = number
  default = 30
}

variable "batch_size" {
  type    = number
  default = 10
}
