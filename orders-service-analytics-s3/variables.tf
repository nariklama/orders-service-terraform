variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "bucket_name" {
  description = "Name of the S3 bucket for orders service analytics"
  type        = string
  default     = "orders-service-analytics-s3"
}

variable "orders_service_role_arn" {
  description = "IAM role ARN for the orders-service (only principal allowed to access this bucket)"
  type        = string
  default     = "arn:aws:iam::805863115079:role/duploservices-dev-orders-service"
}
