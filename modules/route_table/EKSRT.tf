# Import this resource using:
# terraform import aws_route_table.eksrt rtb-08f694a66f7ab8ca9

resource "aws_route_table" "eksrt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }

  tags = {
    Name = "EKSRT"
  }

  lifecycle {
    # Prevent destruction of manually created resource
    prevent_destroy = false
    # Ignore changes to routes managed outside Terraform initially
    ignore_changes = []
  }
}

# Import block (Terraform 1.5+)
import {
  to = aws_route_table.eksrt
  id = "rtb-08f694a66f7ab8ca9"
}