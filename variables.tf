variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "bucket_name" {
  description = "Name of the analytics S3 bucket"
  type        = string
  default     = "orders-service-analytics-s3"
}

variable "orders_service_role_arn" {
  description = "IAM role ARN for the orders-service (must have access to the bucket)"
  type        = string
}
