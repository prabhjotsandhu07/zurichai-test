# IAM Role for EC2 instances to interact with CloudWatch
# Cost: $0.00/month (IAM roles have no direct cost)
# Note: Consider reviewing if this role is actively used before maintaining in IaC
resource "aws_iam_role" "ec2_cloudwatch_role" {
  name        = "ec2_cloudwatch_role"
  path        = "/"
  description = "Role for EC2 instances to send metrics and logs to CloudWatch"

  max_session_duration = 3600

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.common_tags,
    {
      Name        = "ec2_cloudwatch_role"
      ManagedBy   = "Terraform"
      Purpose     = "EC2 CloudWatch integration"
      CostCenter  = "infrastructure"
    }
  )
}

# Note: This role requires policies to be useful. Common attachments:
# - arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy
# - arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
# Example (uncomment if needed):
# resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
#   role       = aws_iam_role.ec2_cloudwatch_role.name
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
# }