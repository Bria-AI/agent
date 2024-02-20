resource "aws_lambda_function" "image_creation_handler" {
  function_name = var.name

  role    = var.execution_role

  package_type = "Image"
  timeout      = 30

  image_uri = var.image_uri

  environment {
    variables = {
      queue_url           = var.embeddings_queue_url
      sagemaker_endpoint  = var.sagemaker_endpoint
    }
  }
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_creation_handler.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "images/"
    filter_suffix       = ""
  }
}

resource "aws_lambda_permission" "lambda_invoke_permission" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_creation_handler.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.bucket_name}"
}
