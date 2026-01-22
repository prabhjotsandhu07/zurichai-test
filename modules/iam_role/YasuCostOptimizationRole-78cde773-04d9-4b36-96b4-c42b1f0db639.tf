# Import this resource using:
# terraform import aws_iam_role.yasu_cost_optimization YasuCostOptimizationRole-78cde773-04d9-4b36-96b4-c42b1f0db639

resource "aws_iam_role" "yasu_cost_optimization" {
  name        = "YasuCostOptimizationRole-78cde773-04d9-4b36-96b4-c42b1f0db639"
  description = "Role for Yasu to access cost optimization data"
  path        = "/"

  max_session_duration = 3600

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          AWS = var.yasu_cortex_user_arn
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.yasu_external_id
          }
        }
      }
    ]
  })

  tags = merge(
    var.common_tags,
    {
      Name        = "YasuCostOptimizationRole-78cde773-04d9-4b36-96b4-c42b1f0db639"
      ManagedBy   = "Terraform"
      Purpose     = "CostOptimization"
      Integration = "Yasu"
    }
  )
}

# Output the role ARN for reference
output "yasu_cost_optimization_role_arn" {
  description = "ARN of the Yasu cost optimization role"
  value       = aws_iam_role.yasu_cost_optimization.arn
}

output "yasu_cost_optimization_role_id" {
  description = "Unique ID of the Yasu cost optimization role"
  value       = aws_iam_role.yasu_cost_optimization.id
}