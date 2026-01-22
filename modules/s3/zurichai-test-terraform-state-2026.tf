# Shadow IT Resource: S3 Bucket for Terraform State
# Discovered: 2026-01-08
# Origin: Manually created in AWS Console

# Import this resource using:
# terraform import aws_s3_bucket.zurichai_test_terraform_state_2026 zurichai-test-terraform-state-2026

import {
  to = aws_s3_bucket.zurichai_test_terraform_state_2026
  id = "zurichai-test-terraform-state-2026"
}

resource "aws_s3_bucket" "zurichai_test_terraform_state_2026" {
  bucket = "zurichai-test-terraform-state-2026"

  tags = {
    Name        = "zurichai-test-terraform-state-2026"
    Environment = var.environment
    ManagedBy   = "terraform"
    Purpose     = "terraform-state"
    Discovered  = "shadow-it"
    CodifiedOn  = "2026-01-08"
  }
}

# Security: Enable versioning for state file protection
resource "aws_s3_bucket_versioning" "zurichai_test_terraform_state_2026" {
  bucket = aws_s3_bucket.zurichai_test_terraform_state_2026.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Security: Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "zurichai_test_terraform_state_2026" {
  bucket = aws_s3_bucket.zurichai_test_terraform_state_2026.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Security: Block all public access
resource "aws_s3_bucket_public_access_block" "zurichai_test_terraform_state_2026" {
  bucket = aws_s3_bucket.zurichai_test_terraform_state_2026.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Security: Enable bucket logging (optional - configure destination)
# resource "aws_s3_bucket_logging" "zurichai_test_terraform_state_2026" {
#   bucket = aws_s3_bucket.zurichai_test_terraform_state_2026.id
#
#   target_bucket = var.s3_logging_bucket
#   target_prefix = "s3-access-logs/zurichai-test-terraform-state-2026/"
# }

# Lifecycle: Protect against accidental deletion
resource "aws_s3_bucket_lifecycle_configuration" "zurichai_test_terraform_state_2026" {
  bucket = aws_s3_bucket.zurichai_test_terraform_state_2026.id

  rule {
    id     = "archive-old-versions"
    status = "Enabled"

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = 90
      storage_class   = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = 365
    }
  }
}

# Prevent accidental deletion of state bucket
lifecycle {
  prevent_destroy = true
}