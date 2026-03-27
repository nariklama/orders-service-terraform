variable "aws_region" {
  description = "AWS region to deploy the S3 bucket"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment (e.g. prod, staging, dev)"
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["prod", "staging", "dev"], var.environment)
    error_message = "Environment must be one of: prod, staging, dev."
  }
}

variable "orders_service_role_arn" {
  description = "IAM role ARN for the orders service that needs read/write access to the analytics bucket"
  type        = string
}
