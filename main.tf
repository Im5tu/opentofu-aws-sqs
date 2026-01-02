resource "aws_sqs_queue" "sqs" {
  name                        = var.fifo_queue ? "${var.name}.fifo" : var.name
  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.fifo_queue ? var.content_based_deduplication : null
  deduplication_scope         = var.fifo_queue && var.high_throughput_fifo ? "messageGroup" : null
  fifo_throughput_limit       = var.fifo_queue && var.high_throughput_fifo ? "perMessageGroupId" : null
  visibility_timeout_seconds  = var.timeout_in_seconds
  receive_wait_time_seconds   = 20
  message_retention_seconds   = 1209600
  kms_master_key_id           = var.kms_key_arn
  redrive_policy = var.enable_dlq ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
    maxReceiveCount     = 10
  }) : null
}

resource "aws_sqs_queue" "dlq" {
  count                       = var.enable_dlq ? 1 : 0
  name                        = var.fifo_queue ? "${var.name}-dlq.fifo" : "${var.name}-dlq"
  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.fifo_queue ? var.content_based_deduplication : null
  visibility_timeout_seconds  = 60
  receive_wait_time_seconds   = 20
  message_retention_seconds   = 1209600
  kms_master_key_id           = var.kms_key_arn
}

resource "aws_sqs_queue_redrive_allow_policy" "dlq" {
  count     = var.enable_dlq ? 1 : 0
  queue_url = aws_sqs_queue.dlq[0].id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue"
    sourceQueueArns   = [aws_sqs_queue.sqs.arn]
  })
}