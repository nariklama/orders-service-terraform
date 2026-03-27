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
  value       = aws_s3_bucket.analytics.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Regional domain name (use for low-latency writes)"
  value       = aws_s3_bucket.analytics.bucket_regional_domain_name
}

output "access_logs_bucket_name" {
  description = "Name of the access logs bucket"
  value       = aws_s3_bucket.access_logs.bucket
}

