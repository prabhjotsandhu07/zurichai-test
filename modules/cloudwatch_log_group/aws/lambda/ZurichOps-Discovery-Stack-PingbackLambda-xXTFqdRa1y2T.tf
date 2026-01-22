# CloudWatch Log Group for Lambda function - Shadow IT resource codification
# Import command: terraform import aws_cloudwatch_log_group.zurichops_discovery_pingback_lambda "/aws/lambda/ZurichOps-Discovery-Stack-PingbackLambda-xXTFqdRa1y2T"

resource "aws_cloudwatch_log_group" "zurichops_discovery_pingback_lambda" {
  name              = "/aws/lambda/ZurichOps-Discovery-Stack-PingbackLambda-xXTFqdRa1y2T"
  retention_in_days = var.lambda_log_retention_days
  kms_key_id        = var.cloudwatch_kms_key_arn

  tags = merge(
    var.common_tags,
    {
      Name        = "zurichops-discovery-pingback-lambda-logs"
      ManagedBy   = "Terraform"
      Component   = "Discovery"
      Function    = "PingbackLambda"
      Environment = var.environment
    }
  )
}

# If using Terraform 1.5+, you can use the import block instead:
# import {
#   to = aws_cloudwatch_log_group.zurichops_discovery_pingback_lambda
#   id = "/aws/lambda/ZurichOps-Discovery-Stack-PingbackLambda-xXTFqdRa1y2T"
# }