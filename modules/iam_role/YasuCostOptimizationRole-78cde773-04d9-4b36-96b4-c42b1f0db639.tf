# Terraform import command:
# terraform import aws_iam_role.yasu_cost_optimization_role YasuCostOptimizationRole-78cde773-04d9-4b36-96b4-c42b1f0db639

resource "aws_iam_role" "yasu_cost_optimization_role" {
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
          AWS = "arn:aws:iam::686255963790:user/yasuCortex"
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = "yasu-78cde773-04d9-4b36-96b4-c42b1f0db639"
          }
        }
      }
    ]
  })

  tags = {
    ManagedBy        = "Terraform"
    Purpose          = "CostOptimization"
    ThirdPartyAccess = "Yasu"
    ImportedFrom     = "ShadowIT"
  }
}

# Note: This role currently has no attached policies defined in the state.
# If there are managed or inline policies attached in AWS, they should be
# separately codified using aws_iam_role_policy_attachment or aws_iam_role_policy resources.