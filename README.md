# orders-service-terraform

Terraform configuration to provision AWS infrastructure for the **orders-service analytics** pipeline.

## Resources

| Resource | Name | Description |
|---|---|---|
| `aws_s3_bucket` | `orders-service-analytics-prod` | Primary bucket for JSON analytics events |
| `aws_s3_bucket` | `orders-service-analytics-prod-access-logs` | S3 access logs for the analytics bucket |

## Features

- **AES-256 encryption** — server-side encryption enabled by default
- **Versioning** — protects against accidental deletion or overwrites
- **90-day lifecycle expiration** — objects automatically expired after 90 days; noncurrent versions after 30 days
- **Public access blocked** — all public access is fully disabled
- **HTTPS-only** — bucket policy denies any non-TLS requests
- **IAM access control** — only the orders-service IAM role can read/write objects
- **Access logging** — all S3 requests logged to a dedicated logs bucket

## Usage

### Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.3.0
- AWS credentials configured for the prod account

### Apply

1. Update `terraform.tfvars` with your actual values:

```hcl
aws_region              = "us-east-1"
environment             = "prod"
orders_service_role_arn = "arn:aws:iam::123456789012:role/orders-service-role"
```

2. Initialize and apply:

```bash
terraform init
terraform plan
terraform apply
```

## Inputs

| Name | Description | Type | Default |
|---|---|---|---|
| `aws_region` | AWS region to deploy into | `string` | `"us-east-1"` |
| `environment` | Deployment environment (`prod`, `staging`, `dev`) | `string` | `"prod"` |
| `orders_service_role_arn` | IAM role ARN for the orders service | `string` | — |

## Outputs

| Name | Description |
|---|---|
| `bucket_name` | Name of the analytics S3 bucket |
| `bucket_arn` | ARN of the analytics S3 bucket |
| `bucket_id` | ID of the analytics S3 bucket |
| `bucket_domain_name` | Domain name of the analytics S3 bucket |
| `access_logs_bucket_name` | Name of the access logs bucket |

## Related

- Jira: [IAM-497](https://duplocloud-ai-suite-integration.atlassian.net/browse/IAM-497)
