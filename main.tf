terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  bucket_name      = "orders-service-analytics-${var.environment}"
  logs_bucket_name = "orders-service-analytics-${var.environment}-access-logs"

  common_tags = {
    Environment = var.environment
    Service     = "orders-service"
    ManagedBy   = "terraform"
    Ticket      = "IAM-499"
  }
}

# ------------------------------------------------------------------
# Access Logs Bucket
# ------------------------------------------------------------------
resource "aws_s3_bucket" "access_logs" {
  bucket        = local.logs_bucket_name
  force_destroy = false
  tags          = merge(local.common_tags, { Purpose = "access-logs" })
}

resource "aws_s3_bucket_public_access_block" "access_logs" {
  bucket                  = aws_s3_bucket.access_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id
  rule {
    id     = "expire-logs"
    status = "Enabled"
    expiration {
      days = 90
    }
  }
}

# ------------------------------------------------------------------
# Analytics Bucket
# ------------------------------------------------------------------
resource "aws_s3_bucket" "analytics" {
  bucket        = local.bucket_name
  force_destroy = false
  tags          = merge(local.common_tags, { Purpose = "analytics-storage" })
}

resource "aws_s3_bucket_public_access_block" "analytics" {
  bucket                  = aws_s3_bucket.analytics.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "analytics" {
  bucket = aws_s3_bucket.analytics.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "analytics" {
  bucket = aws_s3_bucket.analytics.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "analytics" {
  bucket = aws_s3_bucket.analytics.id

  rule {
    id     = "expire-objects-90-days"
    status = "Enabled"
    expiration {
      days = 90
    }
    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

resource "aws_s3_bucket_logging" "analytics" {
  bucket        = aws_s3_bucket.analytics.id
  target_bucket = aws_s3_bucket.access_logs.id
  target_prefix = "s3-access-logs/"
}

resource "aws_s3_bucket_policy" "analytics" {
  bucket = aws_s3_bucket.analytics.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "DenyNonTLS"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.analytics.arn,
          "${aws_s3_bucket.analytics.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
      {
        Sid    = "AllowOrdersServiceAccess"
        Effect = "Allow"
        Principal = {
          AWS = var.orders_service_role_arn
        }
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.analytics.arn,
          "${aws_s3_bucket.analytics.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_s3_bucket_accelerate_configuration" "analytics" {
  bucket = aws_s3_bucket.analytics.id
  status = "Enabled"
}

