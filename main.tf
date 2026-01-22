# Security group with no inbound rules - candidate for removal
# This resource should be reviewed and potentially deleted if unused
# Current state: No ingress rules configured, only default egress

resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = var.vpc_id

  # No ingress rules configured - this SG cannot accept any incoming traffic
  # If this is intentional and the SG is unused, consider removing this resource entirely

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EKSClusterSG"
  }

  lifecycle {
    # Prevent accidental deletion if resources are attached
    prevent_destroy = false
  }
}

# COST OPTIMIZATION RECOMMENDATION:
# This security group has no inbound rules and appears to be non-functional.
# Consider one of the following actions:
# 1. DELETE this resource entirely if it's not attached to any resources
# 2. ADD proper ingress rules if it should be functional for an EKS cluster
# 3. VERIFY no resources are using this SG before removal
#
# To remove this resource, delete the entire block above and run:
# terraform state rm aws_security_group.eks_cluster_sg (if already in state)
# OR simply don't include this resource in your configuration