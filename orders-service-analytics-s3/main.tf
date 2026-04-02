terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "orders_analytics" {
  bucket = var.bucket_name

  tags = {
    Environment = var.environment
    Service     = "orders-service"
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket_public_access_block" "orders_analytics" {
  bucket = aws_s3_bucket.orders_analytics.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "orders_analytics" {
  bucket = aws_s3_bucket.orders_analytics.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
      kms_master_key_id = "aws/s3"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "orders_analytics" {
  bucket = aws_s3_bucket.orders_analytics.id

  rule {
    id     = "archive-and-expire"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }
  }
}

resource "aws_s3_bucket_policy" "orders_analytics" {
  bucket = aws_s3_bucket.orders_analytics.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowOrdersServiceRole"
        Effect = "Allow"
        Principal = {
          AWS = var.orders_service_role_arn
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = [
          aws_s3_bucket.orders_analytics.arn,
          "${aws_s3_bucket.orders_analytics.arn}/*"
        ]
      },
      {
        Sid    = "DenyAllOtherPrincipals"
        Effect = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.orders_analytics.arn,
          "${aws_s3_bucket.orders_analytics.arn}/*"
        ]
        Condition = {
          ArnNotEquals = {
            "aws:PrincipalArn" = var.orders_service_role_arn
          }
          Bool = {
            "aws:PrincipalIsAWSService" = "false"
          }
        }
      }
    ]
  })
}
