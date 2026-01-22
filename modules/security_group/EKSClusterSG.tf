# Import this resource first:
# terraform import aws_security_group.eks_cluster_sg sg-0f7eaea54c51b0eef

resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = data.aws_vpc.main.id

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }

  tags = {
    Name = "EKSClusterSG"
  }

  lifecycle {
    # Prevent accidental deletion of security group
    prevent_destroy = false
    # Ignore changes to description if modified outside Terraform
    ignore_changes = []
  }
}

# Data source to reference the VPC dynamically
data "aws_vpc" "main" {
  id = var.vpc_id
}

# Output the security group ID for reference
output "eks_cluster_sg_id" {
  description = "ID of the EKS cluster security group"
  value       = aws_security_group.eks_cluster_sg.id
}