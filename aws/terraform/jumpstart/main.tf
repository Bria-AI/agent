module "iam_roles" {
  source = "../modules/iam_roles"

  name = var.execution_role_name
}

module "bucket" {
  source = "../modules/s3_bria_bucket"

  name = var.s3_bria_bucket
}

module "embeddings_queue" {
  source = "../modules/embeddings_queue"

  name   = var.embeddings_queue_name
}

module "embeddings_dispatcher" {
  source = "../modules/embeddings_dispatcher"

  api_token          = var.bria_api_token
  bucket_name        = module.bucket.bucket_name
  execution_role     = module.iam_roles.execution_role_arn
  model_version      = var.bria_model_version
  s3_embeddings_path = var.s3_embeddings_prefix
  
  embeddings_queue_arn = module.embeddings_queue.arn
  embeddings_queue_url = module.embeddings_queue.url
}

module "api_endpoint" {
  source = "../modules/api_endpoint_lambda"

  execution_role = module.iam_roles.execution_role_arn
  
  embeddings_queue_url = module.embeddings_queue.url
}
