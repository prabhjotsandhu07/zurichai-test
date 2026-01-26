# Import this resource using:
# terraform import aws_iam_role.zurichops_discovery_role ZurichOps-Discovery-Stack-ZurichOpsRole-FpcX6m57VIUr

resource "aws_iam_role" "zurichops_discovery_role" {
  name        = "ZurichOps-Discovery-Stack-ZurichOpsRole-FpcX6m57VIUr"
  path        = "/"
  description = "ZurichOps Discovery Stack Role for cross-account resource discovery"

  max_session_duration = 3600

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          AWS = var.zurichops_account_id
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.zurichops_external_id
          }
        }
      }
    ]
  })

  tags = merge(
    var.common_tags,
    {
      Name        = "ZurichOps-Discovery-Stack-ZurichOpsRole-FpcX6m57VIUr"
      ManagedBy   = "Terraform"
      Purpose     = "ZurichOps Cloud Discovery"
      Environment = var.environment
    }
  )
}

# Variables required (add to variables.tf):
# variable "zurichops_account_id" {
#   description = "ZurichOps platform AWS account ID for cross-account assume role"
#   type        = string
#   default     = "686316017617"
# }
#
# variable "zurichops_external_id" {
#   description = "External ID for ZurichOps role assumption security"
#   type        = string
#   sensitive   = true
#   default     = "686e8487-9b00-478c-87de-bd9f68d763e0"
# }
#
# variable "environment" {
#   description = "Environment name"
#   type        = string
# }
#
# variable "common_tags" {
#   description = "Common tags to apply to all resources"
#   type        = map(string)
#   default     = {}
# }

# Output for reference:
output "zurichops_discovery_role_arn" {
  description = "ARN of the ZurichOps Discovery Role"
  value       = aws_iam_role.zurichops_discovery_role.arn
}

output "zurichops_discovery_role_name" {
  description = "Name of the ZurichOps Discovery Role"
  value       = aws_iam_role.zurichops_discovery_role.name
}