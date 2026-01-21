# Shadow IT Resource: ZurichOps-CF-Connector SNS Topic
# This resource was created manually and is being codified into Terraform
# Import command: terraform import aws_sns_topic.zurichops_cf_connector arn:aws:sns:us-east-1:686316017617:ZurichOps-CF-Connector

resource "aws_sns_topic" "zurichops_cf_connector" {
  name = "ZurichOps-CF-Connector"

  # Enable encryption at rest for security best practices
  kms_master_key_id = var.sns_kms_key_id != "" ? var.sns_kms_key_id : null

  # Delivery policy for message retry
  delivery_policy = jsonencode({
    http = {
      defaultHealthyRetryPolicy = {
        minDelayTarget     = 20
        maxDelayTarget     = 20
        numRetries         = 3
        numMaxDelayRetries = 0
        numNoDelayRetries  = 0
        numMinDelayRetries = 0
        backoffFunction    = "linear"
      }
      disableSubscriptionOverrides = false
    }
  })

  tags = merge(
    var.common_tags,
    {
      Name        = "ZurichOps-CF-Connector"
      ManagedBy   = "Terraform"
      Environment = var.environment
      Purpose     = "CloudFront connector for ZurichOps"
      ShadowIT    = "true"  # Mark as previously unmanaged
    }
  )
}

# Output the topic ARN for reference
output "zurichops_cf_connector_arn" {
  description = "ARN of the ZurichOps CloudFront Connector SNS topic"
  value       = aws_sns_topic.zurichops_cf_connector.arn
}

output "zurichops_cf_connector_id" {
  description = "ID of the ZurichOps CloudFront Connector SNS topic"
  value       = aws_sns_topic.zurichops_cf_connector.id
}

# Import block (Terraform 1.5+)
import {
  to = aws_sns_topic.zurichops_cf_connector
  id = "arn:aws:sns:us-east-1:686316017617:ZurichOps-CF-Connector"
}