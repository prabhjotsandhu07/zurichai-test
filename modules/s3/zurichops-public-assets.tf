# Shadow IT Resource: S3 Bucket zurichops-public-assets
# Discovered: 2026-01-05T06:40:43+00:00
# Original Creation: Manual via AWS Console

# Import this resource using:
# terraform import aws_s3_bucket.zurichops_public_assets zurichops-public-assets

import {
  to = aws_s3_bucket.zurichops_public_assets
  id = "zurichops-public-assets"
}

resource "aws_s3_bucket" "zurichops_public_assets" {
  bucket = "zurichops-public-assets"

  tags = merge(
    var.common_tags,
    {
      Name        = "zurichops-public-assets"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Discovery   = "ShadowIT-Codified"
      DiscoveryDate = "2026-01-05"
    }
  )
}

# Security: Block all public access by default
resource "aws_s3_bucket_public_access_block" "zurichops_public_assets" {
  bucket = aws_s3_bucket.zurichops_public_assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Security: Enable versioning for data protection
resource "aws_s3_bucket_versioning" "zurichops_public_assets" {
  bucket = aws_s3_bucket.zurichops_public_assets.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Security: Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "zurichops_public_assets" {
  bucket = aws_s3_bucket.zurichops_public_assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Security: Enable bucket logging (optional - configure destination bucket)
# resource "aws_s3_bucket_logging" "zurichops_public_assets" {
#   bucket = aws_s3_bucket.zurichops_public_assets.id
#
#   target_bucket = var.s3_logging_bucket
#   target_prefix = "s3-logs/zurichops-public-assets/"
# }

# Lifecycle policy for cost optimization
resource "aws_s3_bucket_lifecycle_configuration" "zurichops_public_assets" {
  bucket = aws_s3_bucket.zurichops_public_assets.id

  rule {
    id     = "transition-to-ia"
    status = "Enabled"

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 180
      storage_class = "GLACIER_IR"
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "GLACIER_IR"
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}

output "zurichops_public_assets_bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.zurichops_public_assets.id
}

output "zurichops_public_assets_bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.zurichops_public_assets.arn
}

output "zurichops_public_assets_bucket_domain_name" {
  description = "The bucket domain name"
  value       = aws_s3_bucket.zurichops_public_assets.bucket_domain_name
}