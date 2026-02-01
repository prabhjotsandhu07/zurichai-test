# CloudWatch Log Group for EC2 App Server System Logs
# This resource was created as Shadow IT and is being codified
# Import command: terraform import aws_cloudwatch_log_group.app_server_system "/aws/ec2/app-server/system"

resource "aws_cloudwatch_log_group" "app_server_system" {
  name              = "/aws/ec2/app-server/system"
  retention_in_days = 7

  # Security: Enable encryption at rest using KMS
  # Note: Current state shows no KMS key, but this is recommended for production
  # Uncomment and set kms_key_id variable if encryption is required
  # kms_key_id = var.cloudwatch_kms_key_id

  tags = merge(
    var.common_tags,
    {
      Name        = "app-server-system-logs"
      Purpose     = "EC2 application server system logs"
      ManagedBy   = "Terraform"
      Environment = var.environment
    }
  )
}

# Terraform import block (Terraform 1.5+)
import {
  to = aws_cloudwatch_log_group.app_server_system
  id = "/aws/ec2/app-server/system"
}