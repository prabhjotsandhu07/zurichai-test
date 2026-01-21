# CloudWatch Log Group for EKS Cluster
# Shadow IT Resource - Created manually, now being codified
# Import command: terraform import aws_cloudwatch_log_group.zurichai_cluster_logs "/aws/eks/zurichai-cluster/cluster"

resource "aws_cloudwatch_log_group" "zurichai_cluster_logs" {
  name              = "/aws/eks/zurichai-cluster/cluster"
  retention_in_days = 7

  # Security best practice: Enable encryption at rest
  kms_key_id = var.cloudwatch_kms_key_id

  tags = merge(
    var.common_tags,
    {
      Name        = "zurichai-cluster-logs"
      ManagedBy   = "Terraform"
      Environment = var.environment
      Component   = "EKS"
      Cluster     = "zurichai-cluster"
    }
  )
}

# Import block (Terraform 1.5+)
import {
  to = aws_cloudwatch_log_group.zurichai_cluster_logs
  id = "/aws/eks/zurichai-cluster/cluster"
}