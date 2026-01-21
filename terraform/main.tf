# IAM Policy: ZurichOps-AssumeRole-Policy
# Status: Optimal - No action required
# Cost: $0.00
# Attachment Count: 1 (Active)

resource "aws_iam_policy" "zurich_ops_assume_role_policy" {
  name        = "ZurichOps-AssumeRole-Policy"
  path        = "/"
  description = "Policy for Zurich Operations assume role permissions"

  # Policy document should be defined based on your specific requirements
  # This is a placeholder - replace with actual policy content
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:AssumeRole"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {}

  lifecycle {
    # This policy is actively in use with 1 attachment
    # Prevent accidental deletion
    prevent_destroy = true
  }
}

# Data source to track the policy for monitoring purposes
data "aws_iam_policy" "zurich_ops_assume_role_policy" {
  arn = aws_iam_policy.zurich_ops_assume_role_policy.arn
}

# Output for reference
output "zurich_ops_policy_info" {
  description = "Information about the ZurichOps-AssumeRole-Policy"
  value = {
    arn              = aws_iam_policy.zurich_ops_assume_role_policy.arn
    name             = aws_iam_policy.zurich_ops_assume_role_policy.name
    policy_id        = aws_iam_policy.zurich_ops_assume_role_policy.policy_id
    attachment_count = data.aws_iam_policy.zurich_ops_assume_role_policy.attachment_count
  }
}