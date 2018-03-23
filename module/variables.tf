variable "aws_region" {
  description = "The AWS region to deploy into (e.g. us-east-1)."
  default = "us-east-1"
}

variable "bucket_prefix" {
  type = "string"
  description = "A prefix to use for the names of the S3 buckets where the DMARC aggregate report emails are stored"
}

variable "emails" {
  type = "list"
  description = "A list of the email addresses at which DMARC aggregate reports are being received"
}
