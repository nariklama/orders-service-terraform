# -----------------------------------------------------------------------
# S3 bucket for orders-service analytics (dev)
# IAM-506: Storage for Analytics feature of Orders Service
# -----------------------------------------------------------------------

resource "aws_s3_bucket" "analytics" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Service     = "orders-service"
    ManagedBy   = "terraform"
    JiraTicket  = "IAM-506"
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "analytics" {
  bucket = aws_s3_bucket.analytics.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Server-side encryption using AWS-managed KMS key (aws/s3)
resource "aws_s3_bucket_server_side_encryption_configuration" "analytics" {
  bucket = aws_s3_bucket.analytics.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = "aws/s3"
    }
    bucket_key_enabled = true
  }
}

# Lifecycle policy: Glacier after 30 days, delete after 90 days
resource "aws_s3_bucket_lifecycle_configuration" "analytics" {
  bucket = aws_s3_bucket.analytics.id

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

# IAM policy — restrict access to orders-service role only
data "aws_iam_policy_document" "analytics_bucket_policy" {
  # Deny all access except from the orders-service IAM role
  statement {
    sid    = "DenyAllExceptOrdersService"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.analytics.arn,
      "${aws_s3_bucket.analytics.arn}/*",
    ]

    condition {
      test     = "StringNotLike"
      variable = "aws:PrincipalArn"
      values   = [var.orders_service_role_arn]
    }
  }

  # Enforce HTTPS only
  statement {
    sid    = "DenyNonHTTPS"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.analytics.arn,
      "${aws_s3_bucket.analytics.arn}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "analytics" {
  bucket = aws_s3_bucket.analytics.id
  policy = data.aws_iam_policy_document.analytics_bucket_policy.json

  depends_on = [aws_s3_bucket_public_access_block.analytics]
}
