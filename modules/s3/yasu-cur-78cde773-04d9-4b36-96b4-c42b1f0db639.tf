# Import command:
# terraform import aws_s3_bucket.yasu_cur_78cde773 yasu-cur-78cde773-04d9-4b36-96b4-c42b1f0db639

resource "aws_s3_bucket" "yasu_cur_78cde773" {
  bucket = "yasu-cur-78cde773-04d9-4b36-96b4-c42b1f0db639"

  tags = merge(
    var.common_tags,
    {
      Name        = "yasu-cur-78cde773-04d9-4b36-96b4-c42b1f0db639"
      ManagedBy   = "Terraform"
      Environment = var.environment
      Purpose     = "CUR Data Storage"
      ShadowIT    = "Codified on ${timestamp()}"
    }
  )
}

# Security: Block all public access
resource "aws_s3_bucket_public_access_block" "yasu_cur_78cde773" {
  bucket = aws_s3_bucket.yasu_cur_78cde773.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Security: Enable versioning for data protection
resource "aws_s3_bucket_versioning" "yasu_cur_78cde773" {
  bucket = aws_s3_bucket.yasu_cur_78cde773.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Security: Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "yasu_cur_78cde773" {
  bucket = aws_s3_bucket.yasu_cur_78cde773.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Lifecycle policy for cost optimization
resource "aws_s3_bucket_lifecycle_configuration" "yasu_cur_78cde773" {
  bucket = aws_s3_bucket.yasu_cur_78cde773.id

  rule {
    id     = "transition-old-cur-data"
    status = "Enabled"

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 180
      storage_class = "GLACIER_IR"
    }

    expiration {
      days = 730
    }
  }
}