variable "aws_region" {
  description = "The AWS region to deploy into (e.g. us-east-1)."
  default     = "us-east-1"
}

variable "queue_name" {
  type        = string
  description = "The name of the SQS queue where events will be sent as DMARC aggregate reports are received"
}

variable "permanent_bucket_name" {
  type        = string
  description = "The name of the S3 bucket where the DMARC aggregate report emails are stored permanently"
}

variable "temporary_bucket_name" {
  type        = string
  description = "The name of the S3 bucket where the DMARC aggregate report emails are stored temporarily (until processed)"
}

variable "emails" {
  type        = list(string)
  description = "A list of the email addresses at which DMARC aggregate reports are being received"
}

variable "lambda_function_name" {
  type        = string
  description = "The name to use for the Lambda function"
}

variable "lambda_function_zip_file" {
  type        = string
  description = "The location of the zip file for the Lambda function"
}

variable "elasticsearch_index" {
  type        = string
  description = "The Elasticsearch index to which to write DMARC aggregate report data"
}

variable "elasticsearch_type" {
  type        = string
  description = "The Elasticsearch type corresponding to a DMARC aggregate report"
}

variable "elasticsearch_domain_name" {
  type        = string
  description = "The domain name of the Elasticsearch instance"
}

variable "cognito_identity_pool_id" {
  type        = string
  description = "The ID of the Cognito identity pool to use for Kibana access."
}

variable "cognito_user_pool_id" {
  type        = string
  description = "The ID of the Cognito user pool to use for Kibana access."
}

variable "cognito_role_arn" {
  type        = string
  description = "The ARN of the role that grants Cognito access for Elasticsearch.  If you are using the AWS-provided role for this purpose, then the ARN will look like arn:aws:iam::<account-id>:role/service-role/CognitoAccessForAmazonES."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to all AWS resources created"
}

