variable "name" {
  description = "The name of the queue (do not include .fifo suffix for FIFO queues - it will be added automatically)"
  type        = string
}

variable "enable_dlq" {
  description = "Whether to enable the DLQ"
  type        = bool
  default     = true
}

variable "timeout_in_seconds" {
  description = "The visibility timeout for the queue in seconds. Default: 60 (1 minute)"
  type        = number
  default     = 60

  validation {
    condition     = var.timeout_in_seconds >= 0 && var.timeout_in_seconds <= 43200
    error_message = "timeout_in_seconds must be between 0 and 43200 seconds (12 hours)."
  }
}

variable "kms_key_arn" {
  description = "The ARN of the KMS Key that you want to use"
  type        = string
  default     = null
}

variable "fifo_queue" {
  description = "Whether this is a FIFO queue. FIFO queues have exactly-once processing and maintain message ordering."
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enable content-based deduplication for FIFO queues. When enabled, SQS uses a SHA-256 hash of the message body to generate the deduplication ID."
  type        = bool
  default     = false
}

variable "high_throughput_fifo" {
  description = "Enable high throughput mode for FIFO queues. Sets deduplication scope and throughput limit to per message group ID."
  type        = bool
  default     = false
}