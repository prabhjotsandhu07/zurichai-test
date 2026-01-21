# Main route table for VPC - automatically created and managed by AWS
# This resource represents the default route table and has no direct cost
# Codifying for infrastructure visibility and drift detection

resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  # Local route is automatically created by AWS for VPC CIDR
  # No explicit route block needed for the local route

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.vpc_name}-main-rtb"
      ManagedBy   = "Terraform"
      CostCenter  = var.cost_center
      Environment = var.environment
    }
  )
}

# Reference to the VPC - should already exist in your configuration
# If not, use a data source instead:
# data "aws_vpc" "main" {
#   id = "vpc-03cdbafac3f49a977"
# }