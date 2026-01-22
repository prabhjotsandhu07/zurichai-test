# Import command (run this before applying):
# terraform import aws_iam_policy.zurichops_assume_role_policy arn:aws:iam::ACCOUNT_ID:policy/ZurichOps-AssumeRole-Policy

# Or use import block (Terraform 1.5+):
import {
  to = aws_iam_policy.zurichops_assume_role_policy
  id = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/ZurichOps-AssumeRole-Policy"
}

data "aws_caller_identity" "current" {}

# Fetch the current policy document from AWS to avoid drift
data "aws_iam_policy" "zurichops_assume_role_policy_existing" {
  name = "ZurichOps-AssumeRole-Policy"
}

resource "aws_iam_policy" "zurichops_assume_role_policy" {
  name        = "ZurichOps-AssumeRole-Policy"
  path        = "/"
  description = "ZurichOps AssumeRole policy for cross-account access - codified from Shadow IT"

  # Use the existing policy document to maintain state consistency
  policy = data.aws_iam_policy.zurichops_assume_role_policy_existing.policy

  tags = merge(
    var.common_tags,
    {
      "Name"               = "ZurichOps-AssumeRole-Policy"
      "ManagedBy"          = "Terraform"
      "CodifiedFrom"       = "ShadowIT"
      "CodificationDate"   = "2025-12-19"
      "OriginalCreateDate" = "2025-12-18"
    }
  )
}

# Output the policy ARN for reference
output "zurichops_assume_role_policy_arn" {
  description = "ARN of the ZurichOps AssumeRole policy"
  value       = aws_iam_policy.zurichops_assume_role_policy.arn
}

output "zurichops_assume_role_policy_id" {
  description = "ID of the ZurichOps AssumeRole policy"
  value       = aws_iam_policy.zurichops_assume_role_policy.id
}