resource "aws_lambda_function" "embeddings" {
  function_name = "embeddings_dispatcher"
  package_type  = "Image"

  role      = var.execution_role
  image_uri = var.jump_start_embeddings_dispatcher_image
  timeout   = var.timeout

  environment {
    variables = {
      attribution_endpoint = var.attribution_endpoint
      api_token            = var.api_token
      model_version        = var.model_version
      queue_url            = var.embeddings_queue_url
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_event" {
  enabled                 = true
  function_response_types = ["ReportBatchItemFailures"]

  event_source_arn = var.embeddings_queue_arn
  function_name    = aws_lambda_function.embeddings.arn
  batch_size       = var.batch_size
}

output "lambda_function_arn" {
  description = "ARN of the Lambda"
  value       = aws_lambda_function.embeddings.arn
}
