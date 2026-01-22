# Security group for EKS cluster - marked for deletion
# This security group has no inbound rules and is likely unused or misconfigured
# Consider removing this resource after verifying no active attachments
#
# To delete this resource:
# 1. Verify no ENIs/instances are attached: aws ec2 describe-network-interfaces --filters "Name=group-id,Values=sg-xxxxx"
# 2. Comment out or remove this resource block
# 3. Run: terraform state rm aws_security_group.eks_cluster_sg
# 4. Run: terraform apply

resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = var.vpc_id

  # No ingress rules - this security group blocks all inbound traffic
  # This is a non-functional configuration for an EKS cluster
  # EKS clusters require ingress from worker nodes on ports 443 and 10250

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "EKSClusterSG"
  }

  lifecycle {
    create_before_destroy = false
    # Prevent accidental recreation if this is actually in use
    prevent_destroy = false
  }
}