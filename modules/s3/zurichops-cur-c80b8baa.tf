# Shadow IT Resource: S3 Bucket for Cost and Usage Reports
# Discovered: 2026-01-16T08:59:13+00:00
# Import Command: terraform import aws_s3_bucket.zurichops_cur_c80b8baa zurichops-cur-c80b8baa

resource "aws_s3_bucket" "zurichops_cur_c80b8baa" {
  bucket = "zurichops-cur-c80b8baa"

  tags = {
    ManagedBy         = "Terraform"
    Environment       = var.environment
    CostCenter        = var.cost_center
    Discovery         = "ShadowIT-Codified"
    DiscoveryDate     = "2026-01-16"
    OriginalCreation  = "2026-01-16T08:59:13Z"
  }
}

# Public access block - Security best practice
resource "aws_s3_bucket_public_access_block" "zurichops_cur_c80b8baa" {
  bucket = aws_s3_bucket.zurichops_cur_c80b8baa.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Server-side encryption - Security best practice
resource "aws_s3_bucket_server_side_encryption_configuration" "zurichops_cur_c80b8baa" {
  bucket = aws_s3_bucket.zurichops_cur_c80b8baa.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Versioning - Best practice for CUR buckets
resource "aws_s3_bucket_versioning" "zurichops_cur_c80b8baa" {
  bucket = aws_s3_bucket.zurichops_cur_c80b8baa.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Lifecycle policy - Cost optimization for old reports
resource "aws_s3_bucket_lifecycle_configuration" "zurichops_cur_c80b8baa" {
  bucket = aws_s3_bucket.zurichops_cur_c80b8baa.id

  rule {
    id     = "archive-old-reports"
    status = "Enabled"

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }
}

# Bucket policy for AWS Cost and Usage Report delivery
resource "aws_s3_bucket_policy" "zurichops_cur_c80b8baa" {
  bucket = aws_s3_bucket.zurichops_cur_c80b8baa.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSBillingDeliveryCURPolicy"
        Effect = "Allow"
        Principal = {
          Service = "billingreports.amazonaws.com"
        }
        Action = [
          "s3:GetBucketAcl",
          "s3:GetBucketPolicy"
        ]
        Resource = aws_s3_bucket.zurichops_cur_c80b8baa.arn
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = var.aws_account_id
            "aws:SourceArn"     = "arn:aws:cur:us-east-1:${var.aws_account_id}:definition/*"
          }
        }
      },
      {
        Sid    = "AWSBillingDeliveryCURObjectPolicy"
        Effect = "Allow"
        Principal = {
          Service = "billingreports.amazonaws.com"
        }
        Action = "s3:PutObject"
        Resource = "${aws_s3_bucket.zurichops_cur_c80b8baa.arn}/*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = var.aws_account_id
            "aws:SourceArn"     = "arn:aws:cur:us-east-1:${var.aws_account_id}:definition/*"
          }
        }
      }
    ]
  })
}