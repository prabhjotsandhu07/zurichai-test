# This Lambda function has been identified as a zombie resource with no activity
# Monthly cost: $0.00, zero invocations in last 14 days, future LastModified date
# Action: TERMINATE

# Option 1: Remove the resource by commenting it out (safe approach)
# resource "aws_lambda_function" "pingback_lambda" {
#   filename      = "lambda_function.zip"
#   function_name = "ZurichOps-Discovery-Stack-PingbackLambda-Od4wyOB8WRls"
#   role          = aws_iam_role.lambda_role.arn
#   handler       = "index.handler"
#   runtime       = "python3.12"
#   timeout       = 60
#   memory_size   = 128
#
#   source_code_hash = filebase64sha256("lambda_function.zip")
#
#   region = "us-east-1"
# }

# Option 2: Use Terraform to explicitly delete the resource
resource "aws_lambda_function" "pingback_lambda" {
  filename      = "lambda_function.zip"
  function_name = "ZurichOps-Discovery-Stack-PingbackLambda-Od4wyOB8WRls"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "python3.12"
  timeout       = 60
  memory_size   = 128

  source_code_hash = filebase64sha256("lambda_function.zip")

  tags = {
    ManagedBy           = "Terraform"
    OptimizationStatus  = "PendingTermination"
    RecommendationType  = "zombie"
    LastInvocation      = "none"
    ScheduledForRemoval = "true"
  }

  lifecycle {
    prevent_destroy = false
  }
}

# IAM Role for Lambda execution (minimal required permissions)
resource "aws_iam_role" "lambda_role" {
  name = "ZurichOps-Discovery-Stack-PingbackLambda-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    ManagedBy = "Terraform"
  }
}

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Data source to track the resource for deletion
locals {
  zombie_resource_info = {
    function_name    = "ZurichOps-Discovery-Stack-PingbackLambda-Od4wyOB8WRls"
    region           = "us-east-1"
    status           = "pending_termination"
    reasoning        = "Zero invocations, $0.00 monthly cost, no activity in 14 days, anomalous LastModified date"
    recommendation   = "DELETE"
  }
}

# Output for audit trail
output "zombie_resource_termination_plan" {
  value       = local.zombie_resource_info
  description = "Details of the zombie Lambda function scheduled for termination"
}