output "arn" {
  description = "ARN of the Embeddings SQS Queue"
  value       = aws_sqs_queue.embeddings_queue_with_dlq.arn
}

output "id" {
  description = "ID of the Embeddings SQS Queue"
  value       = aws_sqs_queue.embeddings_queue_with_dlq.id
}

output "url" {
  description = "URL of the Embeddings SQS Queue"
  value       = aws_sqs_queue.embeddings_queue_with_dlq.url
}
