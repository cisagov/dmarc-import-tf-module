variable "aws_region" {
  description = "The AWS region to deploy into (e.g. us-east-1)."
  default = "us-east-1"
}

variable "permanent_bucket_name" {
  type = "string"
  description = "The name of the S3 bucket where the DMARC aggregate report emails are stored permanently"
}

variable "temporary_bucket_name" {
  type = "string"
  description = "The name of the S3 bucket where the DMARC aggregate report emails are stored temporarily (until processed)"
}

variable "emails" {
  type = "list"
  description = "A list of the email addresses at which DMARC aggregate reports are being received"
}
