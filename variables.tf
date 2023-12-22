# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "elasticsearch_domain_name" {
  type        = string
  description = "The domain name of the Elasticsearch instance."
}

variable "elasticsearch_index" {
  type        = string
  description = "The Elasticsearch index to which to write DMARC aggregate report data."
}

variable "elasticsearch_type" {
  type        = string
  description = "The Elasticsearch type corresponding to a DMARC aggregate report."
}

variable "emails" {
  type        = list(string)
  description = "A list of the email addresses at which DMARC aggregate reports are being received."
}

variable "lambda_function_name" {
  type        = string
  description = "The name to use for the Lambda function."
}

variable "lambda_function_zip_file" {
  type        = string
  description = "The location of the zip file for the Lambda function."
}

variable "permanent_bucket_name" {
  type        = string
  description = "The name of the S3 bucket where the DMARC aggregate report emails are stored permanently."
}

variable "queue_name" {
  type        = string
  description = "The name of the SQS queue where events will be sent as DMARC aggregate reports are received."
}

variable "rule_set_name" {
  type        = string
  description = "The name of the SES rule set that processes DMARC aggregate reports."
}

variable "temporary_bucket_name" {
  type        = string
  description = "The name of the S3 bucket where the DMARC aggregate report emails are stored temporarily (until processed)."
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
#
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------

variable "aws_region" {
  type        = string
  description = "The AWS region to deploy into (e.g. us-east-1)."
  default     = "us-east-1"
}
