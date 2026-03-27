output "bucket_name" {
  description = "Name of the orders-service analytics S3 bucket"
  value       = aws_s3_bucket.analytics.bucket
}

output "bucket_arn" {
  description = "ARN of the orders-service analytics S3 bucket"
  value       = aws_s3_bucket.analytics.arn
}

output "bucket_id" {
  description = "ID of the orders-service analytics S3 bucket"
  value       = aws_s3_bucket.analytics.id
}

output "bucket_domain_name" {
  description = "Bucket domain name"
  value       = aws_s3_bucket.analytics.bucket_domain_name
}

output "access_logs_bucket_name" {
  description = "Name of the S3 access logs bucket"
  value       = aws_s3_bucket.access_logs.bucket
}
