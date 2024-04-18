resource "aws_sqs_queue" "embeddings_queue_with_dlq" {
  name = "${var.name}-queue"
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.embeddings_dead_letter_queue.arn
    maxReceiveCount     = var.max_receive_count
  })
}

resource "aws_sqs_queue" "embeddings_dead_letter_queue" {
  name = "${var.name}-dead-letter-queue"
}

