# OpenTofu AWS SQS Module

OpenTofu module for creating AWS SQS queues with optional dead-letter queue support.

## Features

- Standard and FIFO queue support
- Optional dead-letter queue (DLQ) with redrive policy
- High-throughput FIFO mode
- KMS encryption support
- Content-based deduplication for FIFO queues

## Usage

### Basic Standard Queue

```hcl
module "my_queue" {
  source = "git::https://github.com/im5tu/opentofu-aws-sqs.git?ref=main"

  name = "my-application-queue"
}
```

### FIFO Queue with High Throughput

```hcl
module "fifo_queue" {
  source = "git::https://github.com/im5tu/opentofu-aws-sqs.git?ref=main"

  name                        = "my-ordered-queue"
  fifo_queue                  = true
  high_throughput_fifo        = true
  content_based_deduplication = true
}
```

### Queue with KMS Encryption

```hcl
module "encrypted_queue" {
  source = "git::https://github.com/im5tu/opentofu-aws-sqs.git?ref=main"

  name        = "secure-queue"
  kms_key_arn = aws_kms_key.sqs.arn
}
```

## Requirements

| Name | Version |
|------|---------|
| opentofu | >= 1.9 |
| aws | ~> 6 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the queue (do not include .fifo suffix for FIFO queues - it will be added automatically) | `string` | n/a | yes |
| enable_dlq | Whether to enable the DLQ | `bool` | `true` | no |
| timeout_in_seconds | The visibility timeout for the queue in seconds (0-43200) | `number` | `60` | no |
| kms_key_arn | The ARN of the KMS Key for encryption | `string` | `null` | no |
| fifo_queue | Whether this is a FIFO queue | `bool` | `false` | no |
| content_based_deduplication | Enable content-based deduplication for FIFO queues | `bool` | `false` | no |
| high_throughput_fifo | Enable high throughput mode for FIFO queues | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the SQS queue |
| url | The URL of the SQS queue |
| name | The name of the SQS queue |
| dlq_arn | The ARN of the dead-letter queue (if enabled) |
| dlq_url | The URL of the dead-letter queue (if enabled) |

## Development

### Validation

This module uses GitHub Actions for validation:

- **Format check**: `tofu fmt -check -recursive`
- **Validation**: `tofu validate`
- **Security scanning**: Checkov, Trivy

### Local Development

```bash
# Format code
tofu fmt -recursive

# Validate
tofu init -backend=false
tofu validate
```

## License

MIT License - see [LICENSE](LICENSE) for details.
