# OPTIMIZATION: Remove unused security group with no ingress rules
# This security group has no inbound rules and appears to be unused
# Removing it reduces management overhead and improves security posture
# If this security group is actually in use, this resource should be re-created
# with proper ingress rules for EKS cluster communication

# resource "aws_security_group" "eks_cluster_sg" {
#   name        = "eks-cluster-sg"
#   description = "Security group for EKS cluster"
#   vpc_id      = var.vpc_id
# 
#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = []
#   }
# 
#   tags = {
#     Name = "EKSClusterSG"
#   }
# }

# COMMENTED OUT FOR REMOVAL
# To implement this optimization:
# 1. Verify the security group is truly unused by checking AWS console
# 2. Remove this commented block entirely
# 3. Run 'terraform state rm aws_security_group.eks_cluster_sg' if it exists in state
# 4. Manually delete the security group from AWS console or via AWS CLI:
#    aws ec2 delete-security-group --group-id sg-<id> --region us-east-1