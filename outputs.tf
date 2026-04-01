output "bucket_name" {
  description = "Name of the analytics S3 bucket"
  value       = aws_s3_bucket.analytics.bucket
}

output "bucket_arn" {
  description = "ARN of the analytics S3 bucket"
  value       = aws_s3_bucket.analytics.arn
}

output "bucket_id" {
  description = "ID of the analytics S3 bucket"
  value       = aws_s3_bucket.analytics.id
}

output "bucket_domain_name" {
  description = "Domain name of the analytics S3 bucket"
  value       = aws_s3_bucket.analytics.bucket_regional_domain_name
}
