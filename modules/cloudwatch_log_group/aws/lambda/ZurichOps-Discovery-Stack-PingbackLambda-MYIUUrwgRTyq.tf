# CloudWatch Log Group for Lambda function
# This resource was previously Shadow IT and is now being codified
# Import command: terraform import aws_cloudwatch_log_group.zurichops_pingback_lambda "/aws/lambda/ZurichOps-Discovery-Stack-PingbackLambda-MYIUUrwgRTyq"

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 7
}

variable "kms_key_id" {
  description = "KMS key ID for encrypting CloudWatch logs (optional but recommended)"
  type        = string
  default     = null
}

resource "aws_cloudwatch_log_group" "zurichops_pingback_lambda" {
  name              = "/aws/lambda/ZurichOps-Discovery-Stack-PingbackLambda-MYIUUrwgRTyq"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.kms_key_id

  tags = {
    ManagedBy   = "Terraform"
    Environment = "production"
    Service     = "ZurichOps-Discovery"
    Component   = "PingbackLambda"
  }
}

# Import block for Terraform 1.5+
import {
  to = aws_cloudwatch_log_group.zurichops_pingback_lambda
  id = "/aws/lambda/ZurichOps-Discovery-Stack-PingbackLambda-MYIUUrwgRTyq"
}

output "log_group_name" {
  description = "Name of the CloudWatch Log Group"
  value       = aws_cloudwatch_log_group.zurichops_pingback_lambda.name
}

output "log_group_arn" {
  description = "ARN of the CloudWatch Log Group"
  value       = aws_cloudwatch_log_group.zurichops_pingback_lambda.arn
}