output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.orders_analytics.bucket
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = aws_s3_bucket.orders_analytics.arn
}

output "bucket_region" {
  description = "Region of the created S3 bucket"
  value       = aws_s3_bucket.orders_analytics.region
}
