output "arn" {
  description = "The ARN of the SQS queue"
  value       = aws_sqs_queue.sqs.arn
}

output "url" {
  description = "The URL of the SQS queue"
  value       = aws_sqs_queue.sqs.url
}

output "name" {
  description = "The name of the SQS queue"
  value       = aws_sqs_queue.sqs.name
}

output "dlq_arn" {
  description = "The ARN of the dead-letter queue (if enabled)"
  value       = var.enable_dlq ? aws_sqs_queue.dlq[0].arn : null
}

output "dlq_url" {
  description = "The URL of the dead-letter queue (if enabled)"
  value       = var.enable_dlq ? aws_sqs_queue.dlq[0].url : null
}