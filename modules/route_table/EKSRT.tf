# Import this resource using:
# terraform import aws_route_table.eksrt rtb-08f694a66f7ab8ca9

data "aws_vpc" "eksrt_vpc" {
  id = var.eksrt_vpc_id
}

data "aws_internet_gateway" "eksrt_igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [var.eksrt_vpc_id]
  }
}

resource "aws_route_table" "eksrt" {
  vpc_id = data.aws_vpc.eksrt_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.eksrt_igw.id
  }

  tags = {
    Name = "EKSRT"
  }

  lifecycle {
    # Prevent destruction of manually created route table
    prevent_destroy = false
    # Ignore changes to routes that might be managed elsewhere
    ignore_changes = []
  }
}

# Output the route table ID for reference
output "eksrt_route_table_id" {
  description = "The ID of the EKSRT route table"
  value       = aws_route_table.eksrt.id
}